#include <iostream>
#include <map>
#include <fstream>
#include <vector>
#include <stdlib.h>
#include "Timer.h"
#include <stdio.h>

using namespace std;

#define us unsigned short

FILE *fp1 = NULL;
FILE *fp2 = NULL;
us addflag;

string toString(int num){
  string res = "";
  res+=(char)num;
  return res;
}

void convertStringToChar(char *p, string &text){
    for (int i=0;i<text.size();i++){
        p[i] = text[i];
    }

    p[text.size()] = '\0';
}

void compress(){
  	map <string, us> flag;

  	for (int i=0;i<256;i++){
    	flag[toString(i)] = i;
  	}

  	addflag = 256;

    string now = "";
    char c;

    while ( (c = fgetc(fp1)) != EOF ){
        if ( flag.find(now + c) != flag.end() && now.size() + 1 < 7 ){
            now += c;
        }else{
            fwrite(&flag[now], 2, 1, fp2);

            if ( addflag < 65535 && now.size() + 1 < 7 ){
                flag[now + c] = addflag++;
            }

            now = "";
            now += c;
        }
    }

    fwrite(&flag[now], 2, 1, fp2);
}

void decompress(){
    map <us, string> flag;

    for (int i=0;i<256;i++){
       flag[i] = toString(i);
    }

    addflag = 256;

    us value;
    fread(&value, 2, 1, fp1);
    us old = value;
    string now = flag[old];
    char c = now[0];

    {
        char ispis[now.size() + 1];
        convertStringToChar(ispis, now);
        fputs(ispis, fp2);
    }

    while ( fread(&value, 2, 1, fp1) ){
        if ( flag.find(value) == flag.end() && now.size() + 1 < 7 ){
            now = flag[old];
            now += c;
        }else{
            now = flag[value];
        }

        char ispis[now.size() + 1];
        convertStringToChar(ispis, now);
        fputs(ispis, fp2);
        c = now[0];

        if ( addflag < 65535 && flag[old].size() + 1 < 7 ){
            flag[addflag++] = flag[old] + c;
        }

        old = value;
    }
}

void menu(){
	cout<<"=========================="<<endl;
	cout<<"Compress...............[1]"<<endl;
	cout<<"Decompress.............[2]"<<endl;
	cout<<"End....................[3]"<<endl;
	cout<<"=========================="<<endl<<endl;
	cout<<"Input option: ";
}

int main(){
    int option = 0;
    Timer time;

    do{
      menu();

      cin>>option;

      string fileIn;
      string fileOut;

      if ( option == 1 ){
        cout<<endl;
        cout<<"Input .txt: ";
        cin>>fileIn;
        cout<<"Output .dat: ";
        cin>>fileOut;

        char arr1[fileIn.size() + 1];
        char arr2[fileOut.size() + 1];
        convertStringToChar(arr1, fileIn);
        convertStringToChar(arr2, fileOut);
        fp1 = fopen(arr1, "r");
        fp2 = fopen(arr2, "wb");
        if ( fp1 == NULL || fp2 == NULL ){
            cout<<"GRESKA!!!"<<endl;
            continue;
        }

        time.start();
        compress();
        fclose(fp1);
        fclose(fp2);
        cout<<endl<<"Time of compression: "<<time.stop()<<endl;
      }else if ( option == 2 ){
        cout<<endl;
        cout<<"Input .dat: ";
        cin>>fileIn;
        cout<<"Output .txt: ";
        cin>>fileOut;

        char arr1[fileIn.size() + 1];
        char arr2[fileOut.size() + 1];
        convertStringToChar(arr1, fileIn);
        convertStringToChar(arr2, fileOut);
        fp1 = fopen(arr1, "rb");
        fp2 = fopen(arr2, "w");
        if ( fp1 == NULL || fp2 == NULL ){
            cout<<"GRESKA!!!"<<endl;
            continue;
        }

        time.start();
        decompress();
        fclose(fp1);
        fclose(fp2);
        cout<<endl<<"Time of decompression: "<<time.stop()<<endl;
      }else if ( option == 3 ){
        cout<<endl<<"Goodbye :)"<<endl;
      }else{
        cout<<endl<<"Option not valid!!!"<<endl<<endl;
      }
    }while( option != 3 );
    return 0;
}
