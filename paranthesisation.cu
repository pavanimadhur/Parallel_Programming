#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include<limits.h>

extern __global__ void scalar_matrixmultiplication(int *l, long long int* Matr, int* Brack, int w, long long int *p)//min no of scalar multiplications
{
	int i, k, j = *l;
	long long int cost;
	i = blockIdx.x + 1;
	j = i + j - 1;
	Matr[i*w + j] = LLONG_MAX;
	for (k = i; k<j; k++)//k specifies the paranthesization value
	{
		cost = Matr[i*w + k] + Matr[(k + 1)*w + j] + p[i - 1] * p[k] * p[j];
		if (cost<Matr[i*w + j])
		{
			Matr[i*w + j] = cost;
			Brack[i*w + j] = k;
		}
	}
}


extern void printParenthesis(int i, int j, int n,
	int bracket[50][50], char &name)
{
	// If only one matrix left in current segment
	if (i == j)
	{
		printf("%c", name++);
		return;
	}

	printf("(");

	// Recursively put brackets around subexpression
	// from i to bracket[i][j].
	// Note that "*((bracket+i*n)+j)" is similar to
	// bracket[i][j]
	printParenthesis(i, bracket[i][j], n,
		bracket, name);

	// Recursively put brackets around subexpression
	// from bracket[i][j] + 1 to j.
	printParenthesis(bracket[i][j] + 1, j,
		n, bracket, name);
	printf(")");
}

extern void print(long long int *Matrix, int len)
{
	printf("\n");
	for (int i = 0; i<len*len; i++)
	{
		printf("%lld\t", Matrix[i]);
		if ((i + 1) % len == 0)
			printf("\n");
	}
}