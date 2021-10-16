#include <iostream>
#include "mpi.h"
#include <stdio.h>
#include <cstdlib>
#include <chrono>
#include <time.h>
#include "Time.h"
#include <vector>
#include <omp.h>
#include <algorithm>

using namespace std;

void merge(int* a, int size, int *p) {
	int i = 0;
	int j = size /2 ;
	int k = 0;

	while (i < size / 2 && j < size) {
		if (a[i] <= a[j]) {
			p[k++] = a[i++];
		}
		else {
			p[k++] = a[j++];
		}
	}

	while (i < size / 2) {
		p[k++] = a[i++];
	}

	while (j < size) {
		p[k++] = a[j++];
	}

	for (int i = 0; i < size; i++) {
		a[i] = p[i];
	}
}

void mergeSort(int* a, int size, int *p) {
	if (size > 1) {
		mergeSort(a, size / 2, p);
		mergeSort(a + size / 2, size - size / 2, p);
		merge(a, size, p);
	}
}

int main(int argc, char** argv) {
	Time timer;

	int n = 10;
	int* a = new int[n];
	int* p = new int[n];
	vector <int> buff;

	srand(time(nullptr));
	for (int i = 0; i < n; i++) {
		a[i] = rand() % n;
		buff.push_back(a[i]);
	}

	timer.start();

	mergeSort(a, n, p);

	cout << "Time: " << timer.stop() << endl;

	sort(buff.begin(), buff.end());
	for (int i = 0; i < n; i++) {
		if (buff[i] != a[i]) {
			cout << a[i] << " " << buff[i] << " " << i << endl;
			break;
		}
	}

	delete[]p;
	delete[]a;

	return 0;
}
