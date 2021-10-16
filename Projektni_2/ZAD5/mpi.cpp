#include <iostream>
#include "mpi.h"
#include <stdio.h>
#include <cstdlib>
#include <chrono>
#include <time.h>
#include <vector>
#include <algorithm>
#include "Time.h"

using namespace std;

void merge(int *arr, int size, int *p) {
	int i = 0;
	int j = size / 2;
	int k = 0;

	while ( i < size / 2 && j < size ){
		if ( arr[i] < arr[j] ){
			p[k++] = arr[i++];
		}else{
			p[k++] = arr[j++];
		}
	}

	while ( i < size / 2 ){
		p[k++] =  arr[i++];
	}

	while ( j < size ){
		p[k++] = arr[j++];
	}


	for (int i=0;i<size;i++){
		arr[i] = p[i];
	}
}

void mergeSort(int *arr, int size, int *p){
	if ( size > 1 ){
    		mergeSort(arr, size / 2, p);
    		mergeSort(arr + size / 2, size - size / 2, p);
    		merge(arr, size, p);
    	}
}


int main(int argc, char** argv) {
	if (argc != 2) {
		std::cout << "=========" << std::endl;
		std::cout << "GRESKA!!!" << std::endl;
		std::cout << "=========" << std::endl;
	}

	Time timer;

	int n = atoi(argv[1]);

	int* inputArr = new int[n];
	int* p = new int[n];
	vector <int> buff;

	srand((int)time(0));

	for (int i = 0; i < n; i++) {
		inputArr[i] = rand() % n;
		buff.push_back(inputArr[i]);
	}

	int rank;
	int size;

	timer.start();

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &rank);
	MPI_Comm_size(MPI_COMM_WORLD, &size);

	int* processArr = new int[n / size];
	MPI_Scatter(inputArr, n / size, MPI_INT, processArr, n / size, MPI_INT, 0, MPI_COMM_WORLD);

	mergeSort(processArr, n / size, p);

	int* res = nullptr;

	if (rank == 0) {
		res = new int[n];
	}

	MPI_Gather(processArr, n / size, MPI_INT, res, n / size, MPI_INT, 0, MPI_COMM_WORLD);

	if (rank == 0) {
		if (n % size != 0) {
			for (int i = (n / size) * size; i < n; i++) {
				res[i] = inputArr[i];
			}
		}

		mergeSort(res, n, p);

		std::cout << "Time: " << timer.stop() << "[s]" << std::endl;

		sort(buff.begin(), buff.end());
		for (int i = 0; i < n; i++) {
			if (buff[i] != res[i]) {
				cout << buff[i] << " " << res[i] << " " << i << endl;
				break;
			}
		}

		delete[]res;
	}

	MPI_Barrier(MPI_COMM_WORLD);
	MPI_Finalize();

	delete[]processArr;
	delete[]inputArr;
	delete[]p;

	return 0;
}