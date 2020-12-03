void generateRandomBitSequence(){
	ofstream of;
	of.open("alo.txt");
	srand(time(NULL));

	for (int i=0;i<200000;i++){
		of<<rand()%2;
	}

	of.close();
} 
