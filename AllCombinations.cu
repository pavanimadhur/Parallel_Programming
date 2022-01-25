#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<stdlib.h>
#include <string.h>
#include <time.h>
extern char*  AllCombi(int n, int *rc, int *cc)
{
	long long int i, mul1[10], mul2[10], mul3[20];
	long long int r[5], c[5],minimum;
	char *str;
	FILE *fptr;

	fptr = fopen("output.txt", "a");
	//printf("working:\n");
	for (i = 0; i < n; i++)
	{
		r[i] = rc[i];
		c[i] = cc[i];
	}
	if (n == 3)
	{
		fprintf(fptr, "A:%lldx%lld   B:%lldx%lld   C:%lldx%lld", r[0], c[0], r[1], c[1], r[2], c[2]);
		fprintf(fptr, "\n order       No.of multiplications    ");
		mul1[0] = (r[1] * c[1] * c[2]) + (r[0] * c[0] * c[2]);
		fprintf(fptr, "\n(A(BC))\t%lld", mul1[0]);
		fprintf(fptr, "\n");
		mul1[1] = (r[0] * c[0] * c[1]) + (r[0] * c[1] * c[2]);
		fprintf(fptr, "\n((AB)C)\t%lld", mul1[1]);
		fprintf(fptr, "\n");
		if (mul1[0]<mul1[1])
		{
			str="(A(BC))";
		}
		else
		{
			str="((AB)C)";
		}
		
	}
	else if (n == 4)
	{
		fprintf(fptr, "A:%lldx%lld   B:%lldx%lld   C:%lldx%lld   D:%lldx%lld", r[0], c[0], r[1], c[1], r[2], c[2], r[3], c[3]);
		long long int  count = 0;
		fprintf(fptr, "\n order       No.of multiplications    ");
		mul2[0] = (r[0] * c[0] * c[1]) + (r[0] * c[1] * c[2]) + (r[0] * c[2] * c[3]);
		fprintf(fptr, "\n(((AB)C)D)\t%lld", mul2[0]);
		count++;
		fprintf(fptr, "\n");
		mul2[1] = (r[1] * c[1] * c[2]) + (r[0] * c[0] * c[2]) + (r[0] * c[2] * c[3]);
		fprintf(fptr, "\n((A(BC))D)\t%lld", mul2[1]);
		count++;
		fprintf(fptr, "\n");
		mul2[2] = (r[0] * c[0] * c[1]) + (r[2] * c[2] * c[3]) + (r[0] * c[1] * c[3]);
		fprintf(fptr, "\n((AB)(CD))\t%lld", mul2[2]);
		count++;
		fprintf(fptr, "\n");
		mul2[3] = (r[1] * c[1] * c[2]) + (r[1] * c[2] * c[3]) + (r[0] * c[0] * c[3]);
		fprintf(fptr, "\n(A((BC)D))\t%lld", mul2[3]);
		count++;
		fprintf(fptr, "\n");
		mul2[4] = (r[2] * c[2] * c[3]) + (r[1] * c[1] * c[3]) + (r[0] * c[0] * c[3]);
		fprintf(fptr, "\n(A(B(CD)))\t%lld", mul2[4]);
		count++;
		fprintf(fptr, "\n");
		int  c;
		minimum = mul2[0];

		for (c = 1; c < count; c++)
		{
			if (mul2[c] < minimum)
			{
				minimum = mul2[c];
			}
		}

		if (minimum == mul2[0])
		{
			str="(((AB)C)D)";
		}
		else if (minimum == mul2[1])
		{
			str="((A(BC))D)";
		}
		else if (minimum == mul2[2])
		{
			str="((AB)(CD))";
		}
		else if (minimum = mul2[3])
		{
			str="(A((BC)D))";
		}
		else
		{
			str="(A(B(CD)))";
		}


	}
	else if (n == 5)
	{
		fprintf(fptr, "A:%lldx%lld   B:%lldx%lld   C:%lldx%lld   D:%lldx%lld   E:%lldx%lld", r[0], c[0], r[1], c[1], r[2], c[2], r[3], c[3], r[4], c[4]);
		int  count = 0;
		fprintf(fptr, "\n order       No.of multiplications    ");
		mul3[0] = (r[2] * c[2] * c[3]) + (r[2] * c[3] * c[4]) + (r[1] * c[1] * c[4]) + (r[0] * c[0] * c[4]);
		fprintf(fptr, "\n(A(B((CD)E)))\t%lld", mul3[0]);
		count++;
		mul3[1] = (r[3] * c[3] * c[4]) + (r[2] * c[2] * c[4]) + (r[1] * c[1] * c[4]) + (r[0] * c[0] * c[4]);
		fprintf(fptr, "\n(A(B(C(DE))))\t%lld", mul3[1]);
		count++;
		mul3[2] = (r[1] * c[1] * c[2]) + (r[3] * c[3] * c[4]) + (r[1] * c[2] * c[4]) + (r[0] * c[0] * c[4]);
		fprintf(fptr, "\n(A((BC)(DE)))\t%lld", mul3[2]);
		count++;
		mul3[3] = (r[2] * c[2] * c[3]) + (r[1] * c[1] * c[3]) + (r[1] * c[3] * c[4]) + (r[0] * c[0] * c[4]);
		fprintf(fptr, "\n(A((B(CD))E))\t%lld", mul3[3]);
		count++;
		mul3[4] = (r[1] * c[1] * c[2]) + (r[1] * c[2] * c[3]) + (r[1] * c[3] * c[4]) + (r[0] * c[0] * c[4]);
		fprintf(fptr, "\n(A(((BC)D)E))\t%lld", mul3[4]);
		count++;
		mul3[5] = (r[0] * c[0] * c[1]) + (r[2] * c[2] * c[3]) + (r[2] * c[3] * c[4]) + (r[0] * c[1] * c[4]);
		fprintf(fptr, "\n((AB)((CD)E))\t%lld", mul3[5]);
		count++;
		mul3[6] = (r[0] * c[0] * c[1]) + (r[3] * c[3] * c[4]) + (r[2] * c[2] * c[4]) + (r[0] * c[1] * c[4]);
		fprintf(fptr, "\n((AB)(C(DE)))\t%lld", mul3[6]);
		count++;
		mul3[7] = (r[1] * c[1] * c[2]) + (r[0] * c[0] * c[2]) + (r[3] * c[3] * c[4]) + (r[0] * c[2] * c[4]);
		fprintf(fptr, "\n((A(BC))(DE))\t%lld", mul3[7]);
		count++;
		mul3[8] = (r[0] * c[0] * c[1]) + (r[0] * c[1] * c[2]) + (r[3] * c[3] * c[4]) + (r[0] * c[2] * c[4]);
		fprintf(fptr, "\n(((AB)C)(DE))\t%lld", mul3[8]);
		count++;
		mul3[9] = (r[0] * c[0] * c[1]) + (r[2] * c[2] * c[3]) + (r[0] * c[1] * c[3]) + (r[0] * c[3] * c[4]);
		fprintf(fptr, "\n(((AB)(CD))E)\t%lld", mul3[9]);
		count++;
		mul3[10] = (r[0] * c[0] * c[1]) + (r[0] * c[1] * c[2]) + (r[0] * c[2] * c[3]) + (r[0] * c[3] * c[4]);
		fprintf(fptr, "\n((((AB)C)D)E)\t%lld", mul3[10]);
		count++;
		mul3[11] = (r[1] * c[1] * c[2]) + (r[0] * c[0] * c[2]) + (r[0] * c[2] * c[3]) + (r[0] * c[3] * c[4]);
		fprintf(fptr, "\n(((A(BC))D)E)\t%lld", mul3[11]);
		count++;
		mul3[12] = (r[1] * c[1] * c[2]) + (r[1] * c[2] * c[3]) + (r[0] * c[0] * c[3]) + (r[0] * c[3] * c[4]);
		fprintf(fptr, "\n((A((BC)D))E)\t%lld", mul3[12]);
		count++;
		mul3[13] = (r[2] * c[2] * c[3]) + (r[1] * c[1] * c[3]) + (r[0] * c[0] * c[3]) + (r[0] * c[3] * c[4]);
		fprintf(fptr,"\n((A(B(CD)))E)\t%lld\n", mul3[13]);
		count++;
		int  c;
		minimum = mul3[0];

		for (c = 1; c < count; c++)
		{
			if (mul3[c] < minimum)
			{
				minimum = mul3[c];
			}
		}
		if (minimum == mul3[0])
		{
			str="(A(B((CD)E)))";

		}
		else if (minimum == mul3[1])
		{
			str = "(A(B(C(DE))))";
		}
		else if (minimum == mul3[2])
		{
			str = "(A((BC)(DE)))";
		}
		else if (minimum == mul3[3])
		{
			str = "(A((B(CD))E))";
		}
		else if (minimum == mul3[4])
		{
			str = "(A(((BC)D)E))";
		}
		else if (minimum == mul3[5])
		{
			str = "((AB)((CD)E))";
		}
		else if (minimum == mul3[6])
		{
			str = "((AB)(C(DE)))";
		}
		else if (minimum == mul3[7])
		{
			str = "((A(BC))(DE))";
		}
		else if (minimum == mul3[8])
		{
			str = "(((AB)C)(DE))";
		}
		else if (minimum == mul3[9])
		{
			str = "(((AB)(CD))E)";
		}
		else if (minimum == mul3[10])
		{
			str = "((((AB)C)D)E)";
		}
		else if (minimum == mul3[11])
		{
			str = "(((A(BC))D)E)";
		}
		else if (minimum == mul3[12])
		{
			str = "((A((BC)D))E)";
		}
		else if (minimum == mul3[13])
		{
			str = "((A(B(CD)))E)";
		}
	}
	fprintf(fptr, "\noptimal order: %s\noptimal cost:%lld \n", str,minimum);
	//printf("working\n");
	return str;
	
}