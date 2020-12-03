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
