using namespace std;

class flight
{
	private:
		
		string flightNumber;
		string departureDateAndTime;
		string departureAirport;
		string arrivalAirport;
		char seats[60][6]; //to keep seat details
	
	public:
		
		flight(); //constructor
		
		//member functions
		void set_flightNumber(string str){flightNumber=str;}
		void set_departureDateAndTime(string str){departureDateAndTime=str;}
		void set_departureAirport(string str){departureAirport=str;}
		void set_arrivalAirport(string str){arrivalAirport=str;}
		void set_seats(int row,int column,char value)
		{
			seats[row][column]=value;
		}
		
		//friend functions
		friend int showAvailableFlights(); //option 1
		friend void viewFlight(); //option 2
		friend int seatAvailability(); //option 3
		friend int seatBooking(); //option 4
		friend void exit(); //option 5
};

vector<flight> database; //vector of objects, (to store flight objects) -- dynamically --

flight::flight() //initializing the whole seat array to '/' values
{
	for(int i=0;i<60;i++) 
	{
		for(int j=0;j<6;j++)
		{
			seats[i][j]='/';
		}
	}	
}

void initialize()
{ 
//function which runs in the begining
//opens the text file and store all the data to database 
	 
	flight object; //creating a temporary object 
	int line=0,i=0; //line variable is used to identify attributes one by one and i variable is used to seperate flight by flight
	int  row=0,column=0,count=0; //to handle seat 2D array's data storing process
	char seatClass;	//to store the class of a seat
	
	//file operations
	
	fstream flights; 
	flights.open("flights.txt", ios::in); //opening the file
	flight x;
	if(!flights)
	{
		cout<<"No such file"; //if the file is not available
	} 
	else
	{ 
  		ifstream file("flights.txt");
  		string str;
  		while (getline(file,str)) //read line by line
		{
			if(line==0) //store flight number
			{
				object.set_flightNumber(str); //adding flight number data to the object temporarily
			}
			else if(line==1) //store departure Date And Time
			{
				object.set_departureDateAndTime(str); //adding departure Date And Time data to the object temporarily
			}
			else if(line==2) //store departure Airport
			{
				object.set_departureAirport(str); //adding departure Airport data to the object temporarily
			}
			else if(line==3) //store arrival Airport
			{
				object.set_arrivalAirport(str); //adding arrival Airport data to the object temporarily
			}
			else //to store available seat data into the 2D array
			{
				count=0; //to get word by word
    			istringstream substring(str);  	// Used to split the string
				string word; 
   				do { 	//getting word by word from the large string
        			
        			substring>>word; 
					if(count==0) //to get row number
					{
						istringstream(word)>>row; //converting it to int and assigning to row
				
					} 
        			else if(count==1) //to get the class of the seat
					{
						seatClass=word[0];
					
					} 
					else if(count==2) // to get the seat columns
					{
						char seatColumn;
						for(int j=0;j<word.size();j++)
						{
							seatColumn=word[j]; //getting character by character from the word
		
							column=(int)seatColumn; //converting to integer
							column=column-65; //I store these in the 2D array like this--> 0 column for A, 1 for B ... 5 for E
							
    						object.set_seats(row-1,column,seatClass);
						}
					}
        			count++;
    				}while(substring); 
			}
			
			line++;
			if(str=="")
			{
    			line=0; 
    			database.push_back(object);  //after allocating all the data to object, appending the object to the back of the vector
    			
    			//to clean previous object's records about seats
				for(int j=0;j<60;j++)
				{
					for(int l=0;l<6;l++)
					{
						object.set_seats(j,l,'/');
					}	
				}
				
				i++;
			}
			
  		}
	}
    flights.close(); 

}


int showAvailableFlights()
{
	cout<<"--Available Flights Details--"<<endl<<endl;
	int bigFlag=0,smallFlag=0,economySeatCount=0,businessSeatCount=0;
	
	for(int i=0;i<database.size();i++) //the flight
	{
		smallFlag=0;
		economySeatCount=0;
		businessSeatCount=0;
		
		for(int j=0;j<60;j++) //the row
		{
			for(int l=0;l<6;l++) //the column
			{
				if(database[i].seats[j][l]!='/')
				{
					bigFlag=1; //to find are there any available flight
					smallFlag=1; //to identify available flights one by one
					if(database[i].seats[j][l]=='E')
					{
						economySeatCount++;
					}
					else if(database[i].seats[j][l]=='B')
					{
						businessSeatCount++;
					}
				}
			}
		}
		if(smallFlag)
		{
			cout<<"Flight Number: "<<database[i].flightNumber<<endl;
			cout<<"Flight Departure Date and Time: "<<database[i].departureDateAndTime<<endl;
			cout<<"Departure Airport: "<<database[i].departureAirport<<endl;
			cout<<"Arrival Airport: "<<database[i].arrivalAirport<<endl;
			cout<<"--Available Seats--"<<endl;
			cout<<"In Business Class: "<<businessSeatCount<<" | In Economy Class: "<<economySeatCount<<endl<<endl;
		}
		cout<<endl;
	}
	if(!bigFlag)
	{
		cout<<"there are no available filghts";
		return 0;
	}
	
}

void viewFlight()
{
	string fNum;
	int flag=0;
	cout<<"insert the flight number: ";
	cin>>fNum;
	for(int i=0;i<database.size();i++)
	{
		if(database[i].flightNumber==fNum) //check whether the flight num is available
		{
			flag=1;
			int economySeatCount=0;
			int businessSeatCount=0;
			for(int j=0;j<60;j++) //the row
			{
				for(int l=0;l<6;l++) //the column
				{
					if(database[i].seats[j][l]!='/') //available seats
					{
						printf("Seat Number: %d-%c | Seat Class: %c\n",j+1,l+65,database[i].seats[j][l]);	
						if(database[i].seats[j][l]=='E')
						{
							economySeatCount++;
						}
						else if(database[i].seats[j][l]=='B')
						{
							businessSeatCount++;
						}
					}
				}	
			}
			cout<<"Available Economy Class Seats in the flight:"<<economySeatCount<<endl;
			cout<<"Available Business Class Seats in the flight:"<<businessSeatCount<<endl;	
			cout<<"Departure Airport: "<<database[i].departureAirport<<endl;
			cout<<"Arrival Airport: "<<database[i].arrivalAirport<<endl;
			cout<<"Flight Departure Date and Time: "<<database[i].departureDateAndTime<<endl;
			break;
		}
	}
	if(!flag)
	{
		cout<<"invalid flight number or flight is not present";
	}
	
}

int seatAvailability()
{
	string fNum;
	int seatAmount=0,flag=0,seatCount=0; //seatAmount->seat amount user wants , seatCount->seat amount that particular flight has.
	cout<<"Insert the flight number: ";
	cin>>fNum;
	cout<<"Insert the number of seats required: ";
	cin>>seatAmount;
	
	//to count the availble seats
	for(int i=0;i<database.size();i++)
	{
		if(database[i].flightNumber==fNum)
		{
			flag=1;
			for(int j=0;j<60;j++) //the row
			{
				for(int l=0;l<6;l++) //the column
				{
					if(database[i].seats[j][l]!='/') //available seats
					{
						seatCount++;
					}
				}	
			}
			break;
		}
	}
	//when user inputs invalid flight number
	if(!flag)
	{
		cout<<"Flight name invalid or flight is not present";
		return 0;
	}
	//when there are no enough seats
	if(seatCount<seatAmount)
	{
		cout<<"Not enough seats";
	}
	//if there are enough seats
	else
	{
		cout<<"\n\n---Seat Numbers That Are Available---\n\n";
		for(int i=0;i<database.size();i++)
		{
			if(database[i].flightNumber==fNum)
			{
				for(int j=0;j<60;j++) //the row
				{
					for(int l=0;l<6;l++) //the column
					{
						if(database[i].seats[j][l]!='/') //available seats
						{
							printf("Seat Number: %d-%c\n",j+1,l+65);
						}
					}	
				}
				break;
			}
		}
	}
}

int seatBooking()
{
	string fNum;
	int row,intColumn,bigFlag=0,smallFlag=0;
	char column; 
	cout<<"Insert the flight number: ";
	cin>>fNum;
	cout<<"Insert the seat row: ";
	cin>>row;
	cout<<"Insert the seat column: ";
	cin>>column;
	
	for(int i=0;i<database.size();i++)
	{
		if(database[i].flightNumber==fNum)
		{
			bigFlag=1;	
			if(database[i].seats[row-1][column-65]!='/') //availability
			{
				smallFlag=1;
				database[i].seats[row-1][column-65]='/';
			}
		}	
	}
	//when user inputs invalid flight number
	if(!bigFlag)
	{
		cout<<"Flight name invalid or flight is not present";
		return 0;
	}
	if(!smallFlag)
	{
		cout<<"Seat name is invalid or seat is not available";
		return 0;
	}
	
}

void exit()
{
 	string str1,str2;
 	char fClass;
 	int flag=0;
    // open a file in write mode.
    ofstream toWrite;
    toWrite.open("flights.dat");
    
    // write data into the file.
    
	for(int i=0;i<database.size();i++) //particular flight
	{	
		toWrite<<database[i].flightNumber<<endl;
		toWrite<<database[i].departureDateAndTime<<endl;
		toWrite<<database[i].departureAirport<<endl;
		toWrite<<database[i].arrivalAirport<<endl;	
		
		//write seat data
		for(int j=0;j<60;j++) //the row
		{
			flag=0;
			str1="";
			for(int l=0;l<6;l++) //the column
			{
				if(database[i].seats[j][l]!='/') //only write free seats
				{
					fClass=database[i].seats[j][l]; //assigning class of the flight to a char variable
					flag=1; 
					str2=l+65; //column of the seat
					str1.append(str2); 			
				}
			}
			if(flag)
			{
				//writing seat details
				toWrite<<j+1<<" "<<fClass<<" "<<str1<<endl;
			}
		}
		toWrite<<endl; //blank line that seperates flights
	}
 	toWrite.close();
}


int main()
{
	//Driver Programme
	initialize(); 
	int optionNumber;
	cout<<"~~ Virgin Airline Flight Reservation System ~~"<<endl;
	while(1)
	{
		
		cout<<"\n\n`````` The Main Menu ``````"<<endl;
		cout<<"---------------------------"<<endl;
		cout<<"1.Display Available Flights \n2.View Flight \n3.Seat Availability \n4.Seat Booking \n5.Exit\n";
		cout<<"---------------------------"<<endl;
		cout<<"\nEnter The Option Number: ";	
		cin>>optionNumber;
		cout<<endl;
		
		if(optionNumber==1)
		{
			showAvailableFlights();
		}
		else if(optionNumber==2)
		{
			viewFlight();
		}
		else if(optionNumber==3)
		{
			seatAvailability(); 
		}
		else if(optionNumber==4)
		{
			seatBooking();
		}
		else if(optionNumber==5)
		{
			exit();
			break;
		}
		else
		{
			cout<<"Invalid Input.! Please Try Again."<<endl;
		}
	}
	return 0;
}
