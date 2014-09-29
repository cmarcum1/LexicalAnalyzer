//Christopher Austin Marcum
//CS 410 
//Lex Project
//Project Overview: The program goes through an excel spreadsheet of census data to pull out information
//					The lexical analyzer is used to find all of the information with regular expressions.
//					Once the information is extracted from the spreadsheet, the program sorts through the 
//					data to answer the required questions. 

%{
#include <stdio.h>
#include <stdlib.h>

//Declaration of methods
void printArray(int);
void makeStruct();
void printStruct();
void peopleToFamily();
void printAll();
void ReportQuestion1();
void womenWhoWork();
void railRoaders();

//Person structure that contains all the information for one person of the census data
typedef struct{
                 char line[20], houseNum[20],dwelingNum[20],familyNum[20],age[20], imagrationYear[20], natuarilzationYear[20], farmSchedule[20];
                 char lastName[20], firstMidName[20], relationship[20], ownOrRent[20], freeOrRent[20], sex[20];
		 char colorOrRace[20], status[20], natOrAlien[20], inSchool[20], read[20], write[20], birthPlace[20];
		 char mTongue[20], fBirthPlace[20], fMTongue[20], mBirthPlace[20], mMTongue[20], english[20];
		 char profession[20], bus[20], employer[20];
              } Person;
 

 //Start Lex Rules
%}
Integer	([0-9]*)?|(([0-9]*)?"."([0-9]*)?)
UnderFive ([0-9]*)?"-"([0-9]*)?"/12"|([0-9]*)?"/12"
Letter	[aA-zZ]
WhiteSpace	[ ]+
Punctuation	[!?\\.]|
Ignore ["\\'\\"(?)"-\\]
NewLine	[\n]
String ({Letter}*)?({WhiteSpace}?)*({Letter}*)?
Comma [,|\t]
%{
	int counter=0, monthAge =0;
	int peopleCount = 0;
	char temp[4][20];
	char charReaper[4][20];
	Person person;
	Person Reaper;
	Person people[100];
%}
%%
{NewLine} {
	// Once a line has finished the data gets put into an array and the struct is reset to null
	counter = 0;
	peopleToFamily();
	people[peopleCount]=person;
	peopleCount++;
	person = Reaper; //Null it out
}
{Ignore}{1} 
{WhiteSpace}{1}
{String} {
	// Once Lex encounters a String, it checks which column that it needs to be and adds it to the struct
	if(counter==4){
		strcpy(temp[3], yytext);
		strcpy(person.lastName, yytext);
	}else if(counter==5){
		strcpy(person.firstMidName, yytext);
	}else if(counter==6){
		strcpy(person.relationship, yytext);
	}else if(counter==7){
		strcpy(person.ownOrRent, yytext);
	}else if(counter==8){
		strcpy(person.freeOrRent, yytext);
	}else if(counter==9){
		strcpy(person.sex, yytext);
	}else if(counter==10){
		strcpy(person.colorOrRace, yytext);
	}else if(counter==12){
		strcpy(person.status, yytext);
	}else if(counter==14){
		strcpy(person.natOrAlien, yytext);
	}else if(counter==16){
		strcpy(person.inSchool, yytext);
	}else if(counter==17){
		strcpy(person.read, yytext);
	}else if(counter==18){
		strcpy(person.write, yytext);
	}else if(counter==19){
		strcpy(person.birthPlace, yytext);
	}else if(counter==20){
		strcpy(person.mTongue, yytext);
	}else if(counter==21){
		strcpy(person.fBirthPlace, yytext);
	}else if(counter==22){
		strcpy(person.fMTongue, yytext);
	}else if(counter==23){
		strcpy(person.mBirthPlace, yytext);
	}else if(counter==24){
		strcpy(person.mMTongue, yytext);
	}else if(counter==25){
		strcpy(person.english, yytext);
	}else if(counter==26){
		strcpy(person.profession, yytext);
	}else if(counter==27){
		strcpy(person.bus, yytext);
	}else if(counter==28){
		strcpy(person.employer, yytext);
	}
}
{Comma} {
	//Incerments to the next column
	counter += 1;
}
{Integer} {
	// Once Lex encounters a Integer, it checks which column that it needs to be and adds it to the struct
	if(counter==0){
		strcpy(person.line, yytext);
	}else if(counter==1){
		if(strlen(temp[0]) == 0){
			memset(temp, 0, sizeof temp);
		}
		strcpy(temp[0], yytext);
		strcpy(person.houseNum, yytext);
	}else if(counter==2){
		strcpy(temp[1], yytext);
		strcpy(person.dwelingNum, yytext);
	}else if(counter==3){
		strcpy(temp[2], yytext);
		strcpy(person.familyNum, yytext);
	}else if(counter==11){
		strcpy(person.age, yytext);
	}else if(counter==13){
		strcpy(person.imagrationYear, yytext);
	}else if(counter==15){
		strcpy(person.natuarilzationYear, yytext);
	}else if(counter==29){
		strcpy(person.farmSchedule, yytext);
	}
}
{UnderFive} {
	// Once Lex encounters a Monthly age, it increments the counter (for the report) and checks which column that it needs to be and adds it to the struct
	monthAge+= 1;
	if(counter==11){
		strcpy(person.age, yytext);
	}
}
%%
int main(){
	//Opens the file and runs program
	FILE *csv = fopen("1.csv", "r");
	if(!csv){
		printf("Error in opening file\n");
		return -1;
	}
	yyin = csv;
	yylex();
	int choice = 0;
	int line = 0;
	do{
		printf("Welcome to Lex! You are at the main menu.\n");
		printf("1) Print Report\n");
		printf("2) Print all cenus data\n");
		printf("3) Print a certain line of the cenus data\n");
		printf("\tPlease insert option (0 to exit)\n");
		scanf("%d", &choice);
		switch(choice){
			case 1:
				printf("\ncmarcum1@mix.wvu.edu \t 701082252\n");
				printf("CS 410 \t Dr.Vanscoy \t Due 10-1-13\n\n");
				printf("Report: \n");
				printf("Question 1:");
				ReportQuestion1();
				printf("\nQuestion 2:");
				printf("\nThe monthly age: %d\n",monthAge);
				printf("\nQuestion 3: \n");
				railRoaders();
				printf("\nQuestion 4: \n");
				womenWhoWork();
				break;
			case 2:
				printAll();
				break;
			case 3:
				printf("Which line of the cenus do you wish to view\n");
				scanf("%d", &line);
				printStruct(line);
				break;
		}
	 } while (choice != 0);
	printf("Goodbye!\n");
}

void printStruct(int x){
	// Prints all information of a person, if no information is given then that section will not be printed
	printf("Person Number %d\n", x);
	if (strlen(people[x].line)!= 0){
		printf("Line: %s\n", people[x].line);
	}if (strlen(people[x].houseNum)!= 0){
		printf("House Number: %s\n", people[x].houseNum);
	}if (strlen(people[x].dwelingNum) != 0){
		printf("Dweling Number: %s\n", people[x].dwelingNum);
	}if (strlen(people[x].familyNum) != 0){
		printf("Family Number: %s\n", people[x].familyNum);
	}if (strlen(people[x].lastName) != 0){
		printf("Last Name: %s\n", people[x].lastName);
	}if (strlen(people[x].firstMidName) != 0){
		printf("First Middle Name: %s\n", people[x].firstMidName);
	}if (strlen(people[x].relationship) != 0){
		printf("Relationship: %s\n", people[x].relationship);
	}if (strlen(people[x].ownOrRent) != 0){
		printf("Own or Rent: %s\n", people[x].ownOrRent);
	}if (strlen(people[x].freeOrRent) != 0){
		printf("If Own, Free Or Rent: %s\n", people[x].freeOrRent);
	}if (strlen(people[x].sex) != 0){
		printf("Sex: %s\n", people[x].sex);
	}if (strlen(people[x].colorOrRace) != 0){
		printf("Color Or Race: %s\n", people[x].colorOrRace);
	}if (strlen(people[x].age) != 0){
		printf("Age: %s\n", people[x].age);
	}if (strlen(people[x].status) != 0){
		printf("Status: %s\n", people[x].status);
	}if (strlen(people[x].imagrationYear)!= 0){
		printf("Imagration Year: %s\n", people[x].imagrationYear);
	}if (strlen(people[x].natOrAlien) != 0){
		printf("Nat or Alien: %s\n", people[x].natOrAlien);
	}if (strlen(people[x].inSchool) != 0){
		printf("In School: %s\n", people[x].inSchool);
	}if (strlen(people[x].read) != 0){
		printf("Read: %s\n", people[x].read);
	}if (strlen(people[x].write) != 0){
		printf("Write: %s\n", people[x].write);
	}if (strlen(people[x].birthPlace) != 0){
		printf("Birth Place: %s\n", people[x].birthPlace);
	}if (strlen(people[x].mTongue) != 0){
		printf("Mother's Tongue: %s\n", people[x].mTongue);
	}if (strlen(people[x].fBirthPlace) != 0){
		printf("Father's Birth Place: %s\n", people[x].fBirthPlace);
	}if (strlen(people[x].fMTongue) != 0){
		printf("Fathers Mother's Tongue: %s\n", people[x].fMTongue);
	}if (strlen(people[x].mBirthPlace) != 0){
		printf("Mother's Birth Place: %s\n", people[x].mBirthPlace);
	}if (strlen(people[x].mMTongue) != 0){
		printf("Mothers Mother's Tongue: %s\n", people[x].mMTongue);
	}if (strlen(people[x].english) != 0){
		printf("English: %s\n", people[x].english);
	}if (strlen(people[x].profession) != 0){
		printf("Profession: %s\n", people[x].profession);
	}if (strlen(people[x].bus) != 0){
		printf("Business: %s\n", people[x].bus);
	}if (strlen(people[x].employer) != 0){
		printf("Employyers: %s\n", people[x].employer);
	}if (strlen(people[x].farmSchedule) != 0){
		printf("Farm Schedule: %s\n", people[x].farmSchedule);
	}printf("\n");
}
 void peopleToFamily(){
	//Brings down the house number (from the above line) and other variables that are missing in a certain row
	if (strlen(person.houseNum) == 0||strlen(person.dwelingNum) == 0||strlen(person.familyNum) == 0||strlen(person.lastName) == 0){
		strcpy(person.houseNum, temp[0]);
		strcpy(person.dwelingNum, temp[1]);
		strcpy(person.familyNum, temp[2]);
		strcpy(person.lastName, temp[3]);
	}
}
void printAll(int maxPeople){
	//Prints all of the information give in the csv file
	int i;
	if(maxPeople >75)
		maxPeople =75;
	for(i=0;i<maxPeople;i++){
		printStruct(i);
	}
}
void ReportQuestion1(){
	//Computes the total number of people born in each state or country
	char stateOrCountry[20][20]={};
	char birthPlace[20];
	int sCCounter[20];
	int i,j,q;
	for(i=0;i<peopleCount;i++){
		strcpy(birthPlace,people[i].birthPlace);
		if(strlen(birthPlace) !=0 && strcmp(birthPlace, " alien")!=0&& strcmp(birthPlace, " place")!=0){
			for(j =0;j<20;j++){
				if(strlen(stateOrCountry[j])==0){
					strcpy(stateOrCountry[j],birthPlace);
					sCCounter[j] = 1;
					break;
				}else{
					if(strcmp(stateOrCountry[j],birthPlace)==0){
						sCCounter[j]+=1;
						break;
					}
				}	
			}
		}
	}
	printf("\nThe total number of people born in each state or country:\n\n");
	printf("Country/State \t Number\n");
	for(q=0;q<20;q++){
		if(strlen(stateOrCountry[q])== 0)
			break;
		if(strcmp(stateOrCountry[q],"Ohio")!=0){
			printf("%s \t %d\n",stateOrCountry[q],sCCounter[q]);
		}else{
			printf("%s \t\t %d\n",stateOrCountry[q],sCCounter[q]);
		}
	}
}

void womenWhoWork(){
	//Computes the total number of women who work
	int womenThatWork = 0;
	int i;
	for(i=0;i<peopleCount;i++){
		if(strcmp(people[i].relationship,"wife")==0){
			if(strcmp(people[i].profession,"None")!=0 && strlen(people[i].profession)!=0){
				womenThatWork++;
			} 
		}
	}
	printf("The total number of women that work is: %d\n\n", womenThatWork);
}

void railRoaders(){
	//Computes the following:
	//3A) Head of Households that is a railroader and all neighbor heads of household are railroaders
	//3B) Head of Households that is a railroader and some neighbor heads of household are railroaders
	//3C) Head of Households that is a railroader and none neighbor heads of household are railroaders
	int i,q,s;
	int j =0,totalNeighbors=0, neighborIsRailroader=0,allNeighbors =0,noNeighbors=0,someNeighbors=0;
	int houseNums[20], Railroader[20];
	for(i=0;i<peopleCount;i++){
		if(strcmp(people[i].relationship,"head")==0){
			houseNums[j] = atoi (people[i].houseNum);
			if(strcmp(people[i].bus,"Railroad shop")==0 ||strcmp(people[i].bus,"Railroad yard")==0 ||strcmp(people[i].bus,"Steam Railroad")==0||strcmp(people[i].bus,"Steam Rairoad")==0){
				Railroader[j] = 1;	
			}else{
				Railroader[j] = 0;
			}
			j++;
		}	
	}	
	for(q=0;q<j;q++){
		int housenum = houseNums[q];
		if(Railroader[q]==1){
			for(s=0;s<j;s++){
				if(housenum+4>=houseNums[s]&&housenum-4<=houseNums[s]&&q!=s){
					totalNeighbors++;
					if(Railroader[s]==1){
						neighborIsRailroader++;
					}
				}
			}
			if(totalNeighbors==0){
				noNeighbors++;
			}else if(neighborIsRailroader==totalNeighbors && neighborIsRailroader!=0){
				allNeighbors++;
			}else if(neighborIsRailroader<totalNeighbors){
				someNeighbors++;
			}
			totalNeighbors =0;
			neighborIsRailroader=0;
		}
	}
	printf("Head of Households that is a railroader and all neighbor heads of household are railroaders: %d\n",allNeighbors);
	printf("Head of Households that is a railroader and some neighbor heads of household are railroaders: %d\n",someNeighbors);
	printf("Head of Households that is a railroader and none neighbor heads of household are railroaders: %d\n",noNeighbors);
}
