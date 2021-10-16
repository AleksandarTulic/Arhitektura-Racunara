#include <iostream>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <omp.h>
#include <utility>
#include <cmath>
#include <algorithm>
#include <map>

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

void mergeSortSerial(int *arr, int size, int *p){
    if ( size < 2 ) return;

    mergeSortSerial(arr, size / 2, p);
    mergeSortSerial(arr + size / 2, size - size / 2, p);
    merge(arr, size, p);
}

void mergeSortopenMP(int *arr, int size, int *p) {
	if (size < 2) {
		return;
	}else if ( size < 20 ){
		mergeSortSerial(arr, size, p);
	}else{
		#pragma omp task firstprivate(arr, size, p)
		{
			mergeSortopenMP(arr, size / 2, p);
		}

		#pragma omp task firstprivate(arr, size, p)
		{
			mergeSortopenMP(arr + size / 2, size - size / 2, p + size / 2);
		}

		#pragma omp taskwait
		merge(arr, size, p);
	}
}

void generateArray(int *a, int size) {
	srand(time(NULL));

	for (int i = 0; i < size; i++) {
		a[i] = rand() % size;
	}
}

int main(int argc, char* argv[]) {
	int size;
	do{
		cout<<"Unesite velicinu niza: ";
		cin>>size;

		if ( size < 1 ){
			cout << "=========" << endl;
			cout << "GRESKA!!!" << endl;
			cout << "=========" << endl;
		}
	}while(size < 1);

	int *arr = new int[size];
	int *buff = new int[size];

	generateArray(arr, size);
	for (int i=0;i<size;i++){
		buff[i] = arr[i];
	}

	int procs = omp_get_num_procs();
	int thread = omp_get_max_threads();

	if (procs == 0 || thread == 0) {
		cout << "=========" << endl;
		cout << "GRESKA!!!" << endl;
		cout << "=========" << endl;
	}

	int *p = new int[size];

	double start, end;
	start = omp_get_wtime();
	#pragma omp parallel
	#pragma omp single
	mergeSortopenMP(arr, size, p);
	end = omp_get_wtime();
	cout << end - start << endl;


	sort(buff, buff + size);
	for (int i = 0; i < size; i++) {
		if (buff[i] != arr[i]) {
			cout << buff[i] << " " << arr[i] << " " << i << endl;
			break;
		}
	}

	delete []p;
	delete []buff;
	delete []arr;
	return 0;
}

//kompjliranje: g++ -fopenmp openMP.cpp -o openMP