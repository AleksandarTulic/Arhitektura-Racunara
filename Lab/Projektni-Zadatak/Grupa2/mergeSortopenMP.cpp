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
