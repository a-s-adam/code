
/* Arduino Code which sends data to google spreadsheet */

#include<SPI.h>
#include<MFRC522.h>
#include <Ethernet.h>
#define SS_PIN 2 //FOR  ETHERNET SHIELD AND RC-522
#define RST_PIN 9
#define No_Of_Card 3
#define MFRC522_SPICLOCK SPI_CLOCK_DIV4
byte mac[] = { 0x00, 0xAA, 0xBB, 0xCC, 0xDE, 0x02 };
char server[] = "api.pushingbox.com";   //YOUR SERVER
IPAddress ip(10, 0, 0, 232);
EthernetClient client;     
MFRC522 rfid(SS_PIN,RST_PIN);
MFRC522::MIFARE_Key key; 
byte id[No_Of_Card][4]={
  {202,50,208,36},             //STUDENT NO-1
  {162,109,11,28},             //STUDENT NO-2
  {218,22,178,36}              //STUDENT NO-3
};
byte id_temp[3][3];
byte i;
int j=0;


// the setup function runs once when you press reset or power the board
void setup(){
    Serial.begin(9600);
    SPI.begin();
    rfid.PCD_Init();
    for(byte i=0;i<6;i++)
    {
      key.keyByte[i]=0xFF;
    }
    if (Ethernet.begin(mac) == 0) {
      Serial.println("Failed to configure Ethernet using DHCP");
      Ethernet.begin(mac, ip);
    }
    delay(1000);
    Serial.println("connecting...");
 }

// the loop function runs over and over again forever
void loop(){
    int m=0;
    if(!rfid.PICC_IsNewCardPresent())
    return;
    if(!rfid.PICC_ReadCardSerial())
    return;
    for(i=0;i<4;i++)
    {
     id_temp[0][i]=rfid.uid.uidByte[i]; 
               delay(50);
    }
    
     for(i=0;i<No_Of_Card;i++)
    {
            if(id[i][0]==id_temp[0][0])
            {
              if(id[i][1]==id_temp[0][1])
              {
                if(id[i][2]==id_temp[0][2])
                {
                  if(id[i][3]==id_temp[0][3])
                  {
                    Serial.print("your card no :");
                    for(int s=0;s<4;s++)
                    {
                      Serial.print(rfid.uid.uidByte[s]);
                      Serial.print(" ");
                     
                    }
                    Serial.println("\nValid Person");
                    send_To_spreadsheet();
                    j=0;
                              
                              rfid.PICC_HaltA(); rfid.PCD_StopCrypto1();   return; 
                  }
                }
              }
            }
     else
     {j++;
      if(j==No_Of_Card)
      {
        Serial.println("Not a valid Person");
        send_To_spreadsheet();
        j=0;
      }
     }
    }
    
       // Halt PICC
    rfid.PICC_HaltA();
  
    // Stop encryption on PCD
    rfid.PCD_StopCrypto1();
 }

 void send_To_spreadsheet()   
 {
   if (client.connect(server, 80)) {
    Serial.println("connected");
    // Make a HTTP request:
    client.print("GET /pushingbox?devid=v6683C9E7DE586A4&registered_students=");     //YOUR URL
    if(j!=No_Of_Card)
    {
      client.print('1');
//      Serial.print('1');
    }
    else
    {
      client.print('0');
    }
    
    client.print("&student_ID=");
    for(int s=0;s<4;s++)
                  {
                    client.print(rfid.uid.uidByte[s]);
                                  
                  }
    client.print(" ");      //SPACE BEFORE HTTP/1.1
    client.print("HTTP/1.1");
    client.println();
    client.println("Host: api.pushingbox.com");
    client.println("Connection: close");
    client.println();
  } else {
    // if you didn't get a connection to the server:
    Serial.println("connection failed");
  }
 }

 
