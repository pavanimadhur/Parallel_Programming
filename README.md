
# Parallel implementation of Matrix Chain Multiplication on NVIDIA platform(CUDA) in C

The dynamic programming paradigm involves various important optimization problems. The set of optimization problems include optimal binary search tree, longest common subsequence, binary knapsack, Matrix chain multiplication (MCM), and many more.
Modern GPUs (Graphics Processing Units) can be used for general purpose parallel computation. One platform for doing so is NVIDIA’s Compute Unified Device Architecture, or CUDA. The example of Matrix Chain Multiplication has been used to introduce the basics of GPU computing in the CUDA environment.
The Matrix Chain Product Problem is an optimization problem for finding parenthesis of the matrix chain that gives the minimum total number of multiplications necessary to compute the product of the matrix chain. Dynamic programming can be used to solve the problem of optimal matrix parenthesization. The results and their analysis reveal that there is considerable amount of time reduction compared with simple left to right multiplication, on applying the matrix parenthesization algorithm and parallel programming. Time reduction varies from 0% to 96%, proportional to the number of matrices and the sequence of dimensions.

