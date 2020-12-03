#include <iostream>
#include <map>
#include <fstream>
#include <vector>
#include <stdlib.h>
#include "Timer.h"

using namespace std;

void generateRandomBitSequence(){
	ofstream of;
	of.open("alo.txt");
	srand(time(NULL));

	for (int i=0;i<200000;i++){
		of<<rand()%2;
	}

	of.close();
}

ofstream ispis;
ifstream upis;
map <string, unsigned short> flag;
map <unsigned short, string> flag1;
string now = "";
string line = "";
string newLine = "\n";
unsigned short addflag;

string toString(int num){
	string res = "";
	res+=(char)num;
	return res;
}

void inputFlag(){
	for (int i=0;i<256;i++){
		flag[toString(i)] = i + 1;
		flag1[i+1] = toString(i);
	}

	flag[newLine] = 257;
	addflag = 258;
}

void encode(){
	inputFlag();

	vector <unsigned short> rem;
	while ( getline(upis, line) ){
		if ( line == "" ){
			rem.push_back(flag[newLine]);
			continue;
		}

		now = line[0];
		for (int i=1;i<line.length();i++){
			if ( flag[now + line[i]] ){
				now += line[i];
			}else{
				rem.push_back(flag[now]);
				
				if ( addflag <= 65535 ) {
					flag[now + line[i]] = addflag;
					flag1[addflag++] = now + line[i];
				}

				now = line[i];
			}
		}

		rem.push_back(flag[now]);
		rem.push_back(flag[newLine]);
	}

	for (int i=0;i<rem.size();i++){
		unsigned short buff = rem[i];
		ispis.write((char*)&buff, sizeof(unsigned short));
	}
}

void decode(){
	map <unsigned short, string> flag2;
	for (int i=0;i<256;i++){
		flag2[i + 1] = toString(i);
	}
	flag2[257] = newLine;
	addflag = 258;

	unsigned short buff;
	vector <unsigned short> rem;

	while ( upis.read((char*)&buff, sizeof(unsigned short)) ){
		rem.push_back(buff);
	}

	unsigned short nowShort = rem[0];
	string now = flag2[nowShort];
	string c = "";
	c+= now[0];
	ispis<<now;

	for (int i=1;i<rem.size();i++){
		//cout<<rem[i]<<" "<<flag2[rem[i]]<<endl;
		if ( flag2.find(rem[i]) == flag2.end() ){
			now = flag2[nowShort];
			now += c;
		}else{
			now = flag2[rem[i]];
		}

		ispis<<now;
		c="";
		c+=now[0];
		if ( addflag <= 65535 ){
			flag2[addflag++] = flag2[nowShort] + c;
		}
		nowShort = rem[i];
	}
}

int main(){
	Timer timer;
	//generateRandomBitSequence();
	timer.stop();

	timer.start();
	upis.open("alo.txt");
	ispis.open("alo1.dat", ios::binary | ios::out );
	encode();

	upis.close();
	ispis.close();
	timer.stop();

	upis.open("alo1.dat", ios::binary | ios::in );
	ispis.open("alo1.txt");
	decode();

	upis.close();
	ispis.close();
	return 0;
}
