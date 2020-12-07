#include <iostream>
#include <vector>
#include <ctime>
#include <cstdlib>
#include <omp.h>
#include "Timer.h"
#include <utility>
#include <cmath>
#include <mpi.h>

using namespace std;

void generateArray(vector <int> &arr, int size){
	srand(time(NULL));

	for (int i=0;i<size;i++){
		arr.push_back(rand());
	}
}

void merge(vector <int> &arr, int begin, int end, int sredina){
	int dimL = sredina - begin + 1;
	int dimR = end - sredina;

	int pom1[dimL];
	int pom2[dimR];

	for (int i=0;i<dimL;i++){
		pom1[i] = arr[i + begin];
	}

	for (int i=0;i<dimR;i++){
		pom2[i] = arr[i + sredina + 1];
	}

	int i = 0;
	int j = 0;
	int k = begin;

	while ( i < dimL && j < dimR ){
		if ( pom1[i] <= pom2[j] ){
			arr[k++] = pom1[i++];
		}else{
			arr[k++] = pom2[j++];
		}
	}

	while ( i < dimL ){
		arr[k++] = pom1[i++];
	}

	while ( j < dimR ){
		arr[k++] = pom2[j++];
	}
}

void mergeSort(vector <int> &arr, int begin, int end){
	if ( begin < end ){
		int sredina = (begin + end) / 2;
		mergeSort(arr, begin, sredina);
		mergeSort(arr, sredina + 1, end);
		merge(arr, begin, end, sredina);
	}
}

void print(vector <int> &arr){
	cout<<"Ispis niza: "<<endl<<endl;
	for (int i=0;i<arr.size();i++){
		cout<<"RB. ["<<i+1<<"]:"<<arr[i]<<endl;
	}
}

void mergeSortopenMP(vector <int> &arr, int begin, int end, int num){
	if ( num == 1 ){
		mergeSort(arr, begin, end);
	}else if ( num > 1 ){
		#pragma omp parallel sections
		{
			#pragma omp section
			{
				mergeSortopenMP(arr, begin, (begin + end / 2), num / 2);
			}

			#pragma omp section
			{
				mergeSortopenMP(arr, (begin + end) / 2 + 1, end, num - num / 2);
			}
		}

		merge(arr, begin, end, (begin + end) / 2);
	}
}

void mergeSortopenMP_MPI(vector <int> &arr, int begin, int end, int level, int num, int my_rank, int max_rank, MPI_Comm com, int tag){
	int helper_rank = my_rank + pow(2, level);

	if ( helper_rank > max_rank ){
		mergeSortopenMP(arr, begin, end, num);
	}else{
		int sredina = (begin + end) / 2;

		MPI_Request req;
		MPI_Isend(&arr[sredina + 1], end - sredina, MPI_INT, helper_rank, tag, com, &req);

		mergeSortopenMP_MPI(arr, begin, sredina, level + 1, num, my_rank, max_rank, com, tag);

		MPI_Request_free(&req);

		MPI_Status sta;
		MPI_Recv(&arr[sredina + 1], end - sredina, MPI_INT, helper_rank, tag, com, &sta);

		merge(arr, begin, end, sredina);
	}
}

int main(int argc, char *argv[]){
	MPI_Init(&argc, &argv);

	int com_size;
	MPI_Comm_size(MPI_COMM_WORLD, &com_size);
	int my_rank;
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
	int max_rank = com_size - 1;
	int tag = 123;

	//generisanje vektora za testiranje
	vector <int> arr;
	generateArray(arr, 2000000);

	//Objekat Timer
	Timer timer;

	//pamcenje vremena koliko je algoritam potrosio na izvrsavanje
	vector <pair<string, double> > time;

	//meni
	int option = 5;

	do{
		cout<<"======================="<<endl;
		cout<<"Normal MergeSort--- [1]"<<endl;
		cout<<"openMP MergeSort--- [2]"<<endl;
		cout<<"Hybrid openMP/MPI-- [3]"<<endl;
		cout<<"Compare Algorithms- [4]"<<endl;
		cout<<"Izlaz-------------- [5]"<<endl;
		cout<<"======================="<<endl;
		cout<<"Unesite opciju: ";
		cin>>option;

		if ( option == 1 ){
			vector <int> pom = arr;

			timer.start();
			mergeSort(pom, 0, pom.size()-1);
			time.push_back({"Merge Sort", timer.stop()});
		}else if ( option == 2 ){
			//korisnik unosi broj thread-ova
			int num = 0;
			int procs = omp_get_num_procs();
			int thread = omp_get_max_threads();

			if ( thread == 0 || procs == 0 ){
				cout<<"GRESKA!!!"<<endl;
				continue;
			}

			do{
				cout<<"Broj jezgara procesora: "<<procs<<endl;
				cout<<"Broje dostupnih thread: "<<thread<<endl;
				cout<<"Broj thread-ova mora biti manje od prethodna dva broja!!!"<<endl;
				cout<<"Unesite broj thread-ova: ";
				cin>>num;

				if ( num > procs || num > thread || num < 1 ){
					cout<<"GRESKA!!!"<<endl;
				}
			}while( num > procs || num > thread || num < 1);

			omp_set_nested(1);
			vector <int> pom = arr;

			timer.start();
			mergeSortopenMP(pom, 0, pom.size()-1, num);
			time.push_back({"Merge Sort openMP, Broj thread-ova: " + to_string(num), timer.stop()});
		}else if ( option == 3 ){
			cout<<my_rank<<" "<<max_rank<<endl;
			omp_set_nested(1);
			vector <int> pom = arr;
			timer.start();
			mergeSortopenMP_MPI(pom, 0, pom.size() - 1, 0, 2, my_rank, max_rank, MPI_COMM_WORLD, tag);
			time.push_back({"Hybrid Merge Sort, Broj thread-ova: " + to_string(2), timer.stop()});
		}else if ( option == 4 ){
			cout<<"Vrijeme izvrsavanja: "<<endl;
			for (auto pom : time){
				cout<<"Algoritam: "<<pom.first<<", Vrijeme: "<<pom.second<<"[s]"<<endl;
			}
		}else if ( option == 5 ){
		}else{
			cout<<"GRESKA!!!"<<endl;
		}
	}while( option != 5 );

	//cisti sva MPI stanja
	//poslije ovoga nijedna MPI rutina nemoze da se pozove
	MPI_Finalize();
	return 0;
}
