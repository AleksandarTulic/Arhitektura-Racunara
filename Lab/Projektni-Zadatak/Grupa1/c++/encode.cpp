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
