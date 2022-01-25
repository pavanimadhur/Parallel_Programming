#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <string.h>
#include <time.h>
#include <cuda.h>
#include <device_functions.h>
#include <cuda_runtime_api.h>
extern void init(int *r, int *c, long long int *a1, long long int *a2, long long int *a3, long long int *a4, long long int *a5);
extern void print2(long long int *mat, long long int r, long long int c, char* str)
{
	long long int i, j;
	FILE *fptr;

	fptr = fopen(str, "a");
	//printf("Storing in file:%s\n",str);
	fprintf(fptr, "ARRAY\n");
	if (fptr == NULL)
	{
		printf("Error!");
		exit(1);
	}
	for (i = 0; i<r; i++)
	{
		for (j = 0; j<c; j++)
		{
			fprintf(fptr, "%lld ", mat[i*c + j]);
		}fprintf(fptr, "\n");
	}fprintf(fptr, "\n");
	fclose(fptr);
}

typedef struct ll
{
	char c;
	long long int *mat;
	long long int rv;
	long long int cv;
	struct ll *next;
}node;

extern __global__ void MatrixMul(long long int* A, long long int * B, long long int * C,
	long long int numARows, long long int numAColumns, long long  int numBColumns)
{
	__shared__ long long  int sA[32][32];   // Tile size of 32x32 
	__shared__  long long int sB[32][32];

	long long int Row = blockDim.y*blockIdx.y + threadIdx.y;
	long long int Col = blockDim.x*blockIdx.x + threadIdx.x;
	long long int Cvalue = 0;
	sA[threadIdx.y][threadIdx.x] = 0;
	sB[threadIdx.y][threadIdx.x] = 0;

	for (int k = 0; k < (((numAColumns - 1) / 32) + 1); k++)
	{
		if ((Row < numARows) && (threadIdx.x + (k * 32)) < numAColumns)
		{
			sA[threadIdx.y][threadIdx.x] = A[(Row*numAColumns) + threadIdx.x + (k * 32)];
		}
		else
		{
			sA[threadIdx.y][threadIdx.x] = 0.0;
		}
		if (Col < numBColumns && (threadIdx.y + k * 32) < numAColumns)
		{
			sB[threadIdx.y][threadIdx.x] = B[(threadIdx.y + k * 32)*numBColumns + Col];
		}
		else
		{
			sB[threadIdx.y][threadIdx.x] = 0.0;
		}
		__syncthreads();

		for (int j = 0; j < 32; ++j)
		{
			Cvalue += sA[threadIdx.y][j] * sB[j][threadIdx.x];
		}
	}
	if (Row < numARows && Col < numBColumns)
	{
		C[Row*numBColumns + Col] = Cvalue;
	}
}


extern void call(int *r, int *c,char *str)
{
	//const int w=10;
	long long int i, j, f = 0;
	long long int zero = 0;
	char stk[256];

	long long int *arr1 = (long long int *)malloc(r[0] * c[0] * sizeof(long long int));
	long long int *arr2 = (long long int *)malloc(r[1] * c[1] * sizeof(long long int));
	long long int *arr3 = (long long int *)malloc(r[2] * c[2] * sizeof(long long int));
	long long int *arr4 = (long long int *)malloc(r[3] * c[3] * sizeof(long long int));
	long long int *arr5 = (long long int *)malloc(r[4] * c[4] * sizeof(long long int));
	long long int *count1 = (long long int *)malloc(r[0] * c[0] * sizeof(long long int));
	for (i = 0; i<r[0]; i++)
	{
		for (j = 0; j<c[0]; j++)
		{
			count1[i*c[0] + j] = 0;
		}
	}
	FILE *fptr;

	fptr = fopen("output.txt", "a");
	init(r, c, arr1, arr2, arr3, arr4, arr5);
	/*
	print2(arr1, r[0], c[0], "inp_parallel.txt");
	print2(arr2, r[1], c[1], "inp_parallel.txt");
	print2(arr3, r[2], c[2], "inp_parallel.txt");
	print2(arr4, r[3], c[3], "inp_parallel.txt");
	print2(arr5, r[4], c[4], "inp_parallel.txt");*/
	node *head = NULL, *temp, *temp2 = NULL, *temp3 = NULL;
	head = (node *)malloc(sizeof(node));
	head->c = 'A';
	head->mat = arr1;
	head->rv = r[0];
	head->cv = c[0];
	temp = head;
	temp->next = (node *)malloc(sizeof(node));
	temp = temp->next;
	temp->c = 'B';
	temp->rv = r[1];
	temp->cv = c[1];
	temp->mat = arr2;
	temp->next = (node *)malloc(sizeof(node));
	temp = temp->next;
	temp->c = 'C';
	temp->rv = r[2];
	temp->cv = c[2];
	temp->mat = arr3;
	temp->next = (node *)malloc(sizeof(node));
	temp = temp->next;
	temp->c = 'D';
	temp->rv = r[3];
	temp->cv = c[3];
	temp->mat = arr4;
	temp->next = NULL;
	temp->next = (node *)malloc(sizeof(node));
	temp = temp->next;
	temp->c = 'E';
	temp->rv = r[4];
	temp->cv = c[4];
	temp->mat = arr5;
	temp->next = NULL;

	
	//fgets(str, sizeof(str), stdin);
	i = 0;
	j = 0;

	clock_t t;
	t = clock();
	while (i<strlen(str))
	{
		while (str[i] != ')' && i<strlen(str))
		{
			if (str[i] == '(')
			{
				i++;
			}
			else
			{
				stk[j] = str[i];
				j++;
				i++;
			}
		}
		if (str[i] == ')')
		{
			char x = stk[--j];
			char y = stk[--j];
			temp2 = head;
			temp = head;
			while (temp->next != NULL)
			{
				if (temp->c == y)
				{
					temp2 = temp;
					break;
				}
				temp = temp->next;
			}
			temp = head;
			while (temp->next != NULL)
			{
				if (temp->c == x)
				{
					temp3 = temp;
					break;
				}
				temp = temp->next;
			}

			long long int *mat1_d, *mat2_d, *result_d, *count_d, *rv_d, *cv_d, *cv2_d;
			cudaMalloc((void**)&mat1_d, temp2->rv * temp2->cv * sizeof(long long int));
			cudaMalloc((void**)&mat2_d, temp->rv * temp->cv * sizeof(long long int));
			cudaMalloc((void**)&result_d, temp2->rv * temp->cv * sizeof(long long int));
			cudaMalloc((void**)&count_d, temp2->rv * temp->cv * sizeof(long long int));

			cudaMalloc((void **)&rv_d, sizeof(long long int));
			cudaMalloc((void **)&cv_d, sizeof(long long int));
			cudaMalloc((void **)&cv2_d, sizeof(long long int));

			cudaMemcpy(mat1_d, temp2->mat, temp2->rv * temp2->cv * sizeof(long long int), cudaMemcpyHostToDevice);
			cudaMemcpy(mat2_d, temp->mat, temp->rv * temp->cv * sizeof(long long int), cudaMemcpyHostToDevice);

			cudaMemcpy(rv_d, &temp2->rv, sizeof(long long int), cudaMemcpyHostToDevice);
			cudaMemcpy(cv_d, &temp2->cv, sizeof(long long int), cudaMemcpyHostToDevice);
			cudaMemcpy(cv2_d, &temp->cv, sizeof(long long int), cudaMemcpyHostToDevice);

			dim3 dimBlock(32, 32, 1);
			dim3 dimGrid((temp->cv / 32) + 1, (temp2->rv / 32) + 1, 1);



			MatrixMul << <dimGrid, dimBlock >> >(mat1_d, mat2_d, result_d, temp2->rv, temp2->cv, temp->cv);
			printf("\n");
			temp2->mat = (long long int *)realloc(temp2->mat, temp2->rv * temp->cv * sizeof(long long int));
			count1 = (long long int *)realloc(count1, temp2->rv * temp->cv * sizeof(long long int));
			cudaMemcpy(temp2->mat, result_d, temp2->rv * temp->cv * sizeof(long long int), cudaMemcpyDeviceToHost);
			cudaMemcpy(count1, count_d, temp2->rv * temp->cv * sizeof(long long int), cudaMemcpyDeviceToHost);
			for (f = 0; f<temp2->rv * temp->cv; f++)
			{
				zero += count1[f];
			}
			//final+=zero;
			temp2->cv = temp->cv;
			stk[++j] = temp2->c;
			i++;
			//print2(temp2->mat, temp2->rv, temp2->cv, "prog_parallel.txt");
			cudaError_t err = cudaFree(mat1_d);
			//printf("Free error: %s\n", cudaGetErrorString(err));
			cudaFree(mat2_d);
			cudaFree(result_d);
			cudaFree(count_d);
			cudaFree(rv_d);
			cudaFree(cv_d);
			cudaFree(cv2_d);
		}
	}
	//print2(temp2->mat,temp2->rv, temp2->cv, "outp_parallel.txt");
	t = clock() - t;
	double time_taken = ((double)t) / CLOCKS_PER_SEC; // in seconds
	fprintf(fptr, "Parallel Multiplication:");
	printf("Parallel Multiplication:");
	fprintf(fptr,"fun() took %f seconds to execute \n", time_taken);
	printf("fun() took %f seconds to execute \n", time_taken);
	//fprintf(fptr, "-------------------------------\n");
	//printf("no. of multiplications reduced due to zeroes:%lld\n", zero);
	
	//system("pause");
}