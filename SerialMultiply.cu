
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <string.h>
#include <time.h>

extern void print2(long long int *mat, long long int r, long long int c, char* str);

typedef struct ll
{
	char c;
	long long int *mat;
	long long int rv;
	long long int cv;
	struct ll *next;
}node;

extern void init(int*r, int *c, long long int *a1, long long int *a2, long long int *a3, long long int *a4, long long int *a5)
{
	int i, j;
	for (i = 0; i<r[0]; i++)
	{
		for (j = 0; j<c[0]; j++)
		{
			a1[i*c[0] + j] = rand() % 2;
		}
	}
	for (i = 0; i<r[1]; i++)
	{
		for (j = 0; j<c[1]; j++)
		{
			a2[i*c[1] + j] = rand() % 3;
		}
	}
	for (i = 0; i<r[2]; i++)
	{
		for (j = 0; j<c[2]; j++)
		{
			a3[i*c[2] + j] = rand() % 4;
		}
	}
	for (i = 0; i<r[3]; i++)
	{
		for (j = 0; j<c[3]; j++)
		{
			a4[i*c[3] + j] = rand() % 5;
		}
	}
	for (i = 0; i<r[4]; i++)
	{
		for (j = 0; j<c[4]; j++)
		{
			a5[i*c[4] + j] = rand() % 6;
		}
	}
}

extern long long int* mul(long long int *mat, long long int *mat2, long long int r1, long long int c1, long long int c2, long long int *count)
{
	long long int i, j, k;
	long long int s = 0;
	long long int *res = (long long int *)malloc(r1 * c2 * sizeof(long long int));
	for (i = 0; i<r1*c2; i++)
		res[i] = 0;

	for (i = 0; i<r1; i++)
	{
		for (j = 0; j<c1; j++)
		{
			for (k = 0; k<c2; k++)
			{
				//if (mat[i*c1 + j] == 0 || mat2[j*c2 + k] == 0)
				//{
				//	s = 0;
				//	(*count)++;
				//}
				//else
				//{
					s = mat[i*c1 + j] * mat2[j*c2 + k];
				//}
				res[i*c2 + k] += s;
			}
		}
	}
	mat = (long long int *)realloc(mat, r1 * c2 * sizeof(long long int));
	for (i = 0; i<r1; i++)
	{
		for (j = 0; j<c2; j++)
		{
			mat[i*c2 + j] = res[i*c2 + j];
		}
	}
	//print2(mat, r1, c2, "program.txt");
	return mat;
}


extern void call2(int *r, int *c,char *str)
{
	//const int w=10;
	long long int i, j, final = 0, zero = 0;
	char stk[256];

	long long int *arr1 = (long long int *)malloc(r[0] * c[0] * sizeof(long long int));
	long long int *arr2 = (long long int *)malloc(r[1] * c[1] * sizeof(long long int));
	long long int *arr3 = (long long int *)malloc(r[2] * c[2] * sizeof(long long int));
	long long int *arr4 = (long long int *)malloc(r[3] * c[3] * sizeof(long long int));
	long long int *arr5 = (long long int *)malloc(r[4] * c[4] * sizeof(long long int));
	FILE *fptr;

	fptr = fopen("output.txt", "a");
	init(r, c, arr1, arr2, arr3, arr4, arr5);
	/*
	print2(arr1, r[0], c[0], "inp.txt");
	print2(arr2, r[1], c[1], "inp.txt");
	print2(arr3, r[2], c[2], "inp.txt");
	print2(arr4, r[3], c[3], "inp.txt");
	print2(arr5, r[4], c[4], "inp.txt");*/
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

	//printf("enter string:\n");
	//scanf("%s", str);
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
			temp2->mat = mul(temp2->mat, temp->mat, temp2->rv, temp2->cv, temp->cv, &zero);
			//final+=zero;
			temp2->cv = temp->cv;
			stk[++j] = temp2->c;
			i++;
		}
	}
	//print2(temp2->mat, temp2->rv, temp2->cv, "outp.txt");
	t = clock() - t;
	double time_taken = ((double)t) / CLOCKS_PER_SEC; // in seconds
	fprintf(fptr, "Serial Multiplication:");
	printf("Serial Multiplication:");
	fprintf(fptr,"fun() took %f seconds to execute \n", time_taken);
	printf("fun() took %f seconds to execute \n", time_taken);
	fprintf(fptr, "-------------------------------\n");
	printf("-------------------------------\n");
	//printf("number of zeroes:%lld\n", zero);
	//system("pause");
}
