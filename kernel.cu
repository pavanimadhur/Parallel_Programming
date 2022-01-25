#include "cuda_runtime.h"
#include "device_launch_parameters.h"

//#include "paranthesisation.cu"
#include <stdio.h>
#include<stdlib.h>
#include<limits.h>


extern __global__ void scalar_matrixmultiplication(int *l, long long int* Matr, int* Brack, int w,long long  int *p);
extern __global__ void MatrixMul(int *Md, int *Nd, int *Pd, int r1, int c1, int c2, int *cn);
extern int* mul(long long int *mat, long long int *mat2, long long int r1, long long int c1, long long int c2, long long int *count);
extern void call2(int *r, int *c, char *str);
extern void printParenthesis(int i, int j, int n, int bracket[50][50], char &name);
extern void print(long long int *Matrix, int len);
extern void print2(long long int *mat, long long int r, long long int c);
extern void call(int *r, int *c, char *str);
extern char* AllCombi(int n, int *r, int *c);

int compatible(int r[], int c[], int n) //to check whether the matrices can be multiplied or not
{
	int i;
	for (i = 0; i<n; i++)
	{
		if (r[i + 1] != c[i])
			return 0;
		return 1;
	}
}

int main()
{
	int n, i, count, N, r[5], c[5];
	long long int p[10], *d_p;
	int l;
	int *d_l, *d_bracket;
	int value = 2000,choice=1;
	char* str;
	long long int *d_Mat;
	cudaMalloc((void **)&d_l, sizeof(int));
	cudaMalloc((void **)&d_p, 10 * sizeof(long long int));

	printf("Enter no. of matrices:");
	scanf("%d", &n);

	for (i = 0; i<n; i++)
	{
		r[i]=100;
		c[i]=100;
	}
	while (value <= 35000)
	{
		if (n == 3)
		{
			if (choice == 1)
			{
				r[0] = c[1] = r[2] = value;

			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = value;
			}
		}
		else if (n == 4)
		{
			if (choice == 1)
			{
				r[0] = c[1] = r[2] = value;

			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = r[3] = value;
			}
			else if (choice == 3)
			{
				c[1] = r[2] = c[3] = value;
			}
		}
		else if (n == 5)
		{
			if (choice == 1)
			{
				r[0] = c[1] = r[2] = value;

			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = r[3] = value;
			}
			else if (choice == 3)
			{
				c[1] = r[2] = c[3] = r[4] = value;
			}
			else if (choice == 4)
			{
				c[2] = r[3] = c[4] = value;
			}
		}
		str = AllCombi(n, r, c);
		count = n + 1;
		int d = count*count;
		cudaError_t errMemAll = cudaMalloc((void **)&d_Mat, d * sizeof(long long int));
		cudaError_t errMemAll2 = cudaMalloc((void **)&d_bracket, d * sizeof(int));
		printf("Memory Allocation: %s\n", cudaGetErrorString(errMemAll));

		long long int *Mat = (long long int *)malloc(d * sizeof(long long int));
		for (i = 0; i < d; i++)
			Mat[i] = 0;
		int *bracket = (int *)malloc(d * sizeof(int));
		for (i = 0; i < d; i++)
			bracket[i] = 0;

		for (i = 0; i < n; i++)
		{
			printf("No. of rows matrix %d:%d\n", i + 1, r[i]);
			printf("No. of columns matrix %d:%d\n", i + 1, c[i]);
		}
		if (compatible(r, c, n))
		{
			for (i = 0; i < n; i++)
				p[i] = r[i];
			p[n] = c[n - 1];
			for (l = 2; l < count; l++)//length of subchain to be multiplied
			{
				N = count - l + 1;
				cudaMemcpy(d_l, &l, sizeof(int), cudaMemcpyHostToDevice);
				cudaMemcpy(d_p, &p, count * sizeof(long long int), cudaMemcpyHostToDevice);
				cudaError_t errMemDev = cudaMemcpy(d_Mat, Mat, d * sizeof(long long int), cudaMemcpyHostToDevice);
				cudaError_t errMemDev2 = cudaMemcpy(d_bracket, bracket, d * sizeof(int), cudaMemcpyHostToDevice);
				printf("Memory to Device: %s\n", cudaGetErrorString(errMemDev));

				scalar_matrixmultiplication << <N, 1 >> > (d_l, d_Mat, d_bracket, count, d_p);

				cudaError_t errDevMem = cudaMemcpy(Mat, d_Mat, d * sizeof(long long int), cudaMemcpyDeviceToHost);
				cudaError_t errDevMem2 = cudaMemcpy(bracket, d_bracket, d * sizeof(int), cudaMemcpyDeviceToHost);
				printf("Device to Memory: %s\n", cudaGetErrorString(errDevMem));
			}
			long long int min = Mat[1 * count + n];
			printf("Cost of Optimal order is %lld\n", min);
			int brack2[50][50];
			for (int x = 0; x < count; x++)
				for (int y = 0; y < count; y++)
					brack2[x][y] = bracket[x*count + y];
			char name = 'A';

			printf("Optimal Parenthesization is : ");
			printParenthesis(1, count - 1, count, brack2, name);
		}

		print(Mat, count);


		free(Mat);
		free(bracket);
		cudaFree(d_bracket);
		
		cudaFree(d_Mat);
		
		call(r, c, str);
		//printf("stored to outp_parallel.txt\n");
		
		call2(r, c, str);
		//printf("stored to outp.txt\n");

		if (n == 3)
		{
			if (choice == 1)
			{
				r[0] = c[1] = r[2] = 100;
				choice++;
			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = 100;
				choice=1;
			}
		}
		else if (n == 4)
		{
			if (choice == 1)
			{
				r[0] = c[1] = r[2] = 100;
				choice++;
			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = r[3] = 100;
				choice++;
			}
			else if (choice == 3)
			{
				c[1] = r[2] = c[3] = 100;
				choice=1;
			}
		}
		else if (n == 5)
		{

			if (choice == 1)
			{
				r[0] = c[1] = r[2] = 100;
				choice++;
			}
			else if (choice == 2)
			{
				c[0] = r[1] = c[2] = r[3] = 100;
				choice++;
			}
			else if (choice == 3)
			{
				c[1] = r[2] = c[3] = r[4] = 100;
				choice++;
			}
			else if (choice == 4)
			{
				c[2] = r[3] = c[4] = 100;
				choice = 1;
			}
		}
		value += 3000;
	}
	cudaFree(d_l);
	cudaFree(d_p);
	system("pause");
	return 0;
}