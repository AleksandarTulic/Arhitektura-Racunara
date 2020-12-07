/*

arr - referenca vektora koji ce se koristiti za sortiranje
size - koliko elemenata treba da se dodijeli vektoru arr

*/

void generateArray(vector <int> &arr, int size){
	srand(time(NULL));

	for (int i=0;i<size;i++){
		arr.push_back(rand());
	}
}
