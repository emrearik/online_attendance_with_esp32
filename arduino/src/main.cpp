#include <Arduino.h>
#include <WiFi.h>
#include <HTTPClient.h>
#include <ESP32QRCodeReader.h>
#include <Firebase_ESP_Client.h>
#include <addons/TokenHelper.h>
#include "StringSplitter.h"
#include <addons/RTDBHelper.h>
#include <Wire.h>

//FIRESTORE -- FIRESTORE KEYS HERE --
#define WIFI_SSID "WIFI_SSID"
#define WIFI_PASSWORD "WIFI_PASSWORD"
#define API_KEY "API_KEY"
#define FIREBASE_PROJECT_ID "FIREBASE_PROJECT_ID"
#define USER_EMAIL "admin@admin.com"
#define USER_PASSWORD "123456"
//* 5.Define RTDB URL (for TIMESTAMP)
#define DATABASE_URL "DATABASE_URL"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;

ESP32QRCodeReader reader(CAMERA_MODEL_AI_THINKER);
struct QRCodeData qrCodeData;
bool isConnected = false;
char deviceName[24] = "";
const int buzzer = 12;
String value = "";

//I2C
#define I2C_SDA 14
#define I2C_SCL 15
TwoWire I2CSensors = TwoWire(0);
#include <LiquidCrystal_I2C.h>
LiquidCrystal_I2C lcd(0x27,16,2);

bool connectWifi(){
  if (WiFi.status() == WL_CONNECTED){
    return true;
  }
  lcd.clear();
  lcd.print("Wifi baglaniyor"); 

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  int maxRetries = 10;
  while (WiFi.status() != WL_CONNECTED){
    delay(500);
    Serial.print(".");
    maxRetries--;
    if (maxRetries <= 0){
      return false;
    }
  }
  Serial.println("WiFi connected");
  lcd.clear();
  lcd.print("Wifi baglandi."); 
  delay(500);

  return true;
}

void setup(){
  Serial.begin(115200);
  I2CSensors.begin(I2C_SDA, I2C_SCL);

  lcd.init();
  lcd.backlight();
  lcd.setBacklight(50);
  lcd.begin(0,0);
  Serial.println();
  lcd.print("Baslatiliyor..."); 
  pinMode(buzzer, OUTPUT);
 

  uint64_t chipId = ESP.getEfuseMac();
  uint32_t highBytesChipId = (uint32_t)(chipId >> 16); // High 4 bytes
  //uint16_t lowBytesChipId = (uint16_t)chipId; // Low 2 bytes
  snprintf(deviceName, sizeof(deviceName), "READER_%08X", highBytesChipId);

  reader.setup();
  Serial.println("Setup QRCode Reader");

  reader.begin();
  Serial.println("Begin QR Code reader");

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;
  config.token_status_callback = tokenStatusCallback; //see addons/TokenHelper.h

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);
  Firebase.setDoubleDigits(5);
  delay(1000);

}


void loop(){
  bool connected = connectWifi();
  if (isConnected != connected) {
    isConnected = connected;
  }

  lcd.clear();
  lcd.print("QR okutunuz..."); 

  if (reader.receiveQrCode(&qrCodeData, 1000)){
    Serial.println("Found QRCode");
    lcd.clear();
    lcd.print("QR bulundu."); 
    delay(100);

    //veriler geçerli mi
    if (qrCodeData.valid){
      FirebaseJson content;
      String array[5];
      
      Serial.print("Payload: ");
      Serial.println((const char *)qrCodeData.payload);
      
      String qrDataString = (const char *)qrCodeData.payload;

      //mükerrer kayıt önleme.
      if(qrDataString!= value){
        digitalWrite(buzzer, HIGH);
        delay(1000);
        digitalWrite(buzzer, LOW);
        
        
        //KAREKOD VERİLERİ 
          StringSplitter *splitter = new StringSplitter(qrDataString, '_', 2);  // new StringSplitter(string_to_split, delimiter, limit)
          int itemCount = splitter->getItemCount();

          for(int i = 0; i < itemCount; i++){
            String item = splitter->getItemAtIndex(i);
            array[i] = String(item);
            Serial.println("Item @ index " + String(i) + ": " + array[i]);
          }

        //KAYİT İSLEMİ
        lcd.clear();
        lcd.print("Zaman ok."); 
        delay(100);
        if(Firebase.RTDB.setTimestamp(&fbdo, "/test/timestamp")){
          lcd.clear();
          lcd.print("QR parcalaniyor.");
          delay(100);

            //parçalanan qr kod datası arraylara atanır.
            content.set("fields/studentID/stringValue/", array[0]);
            content.set("fields/sessionID/stringValue/", array[1]);
            content.set("fields/attendanceTime/doubleValue/",fbdo.to<int>());

            //path belirlenir.
            String documentPath = "attendance/" + String(array[0]) +"_"+ String(array[1]);
            if (Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw())){
                Serial.printf("Kullanici gonderiliyor...\n%s\n\n", fbdo.payload().c_str());
                value = qrDataString;
                digitalWrite(buzzer, HIGH);
                delay(300);
                digitalWrite(buzzer, LOW);
                lcd.clear();
                lcd.print("Islem basarili.");
                delay(4000);
            }else{
                Serial.println(fbdo.errorReason());
                digitalWrite(buzzer, HIGH);
                delay(500);
                digitalWrite(buzzer, LOW);
                delay(100);
                digitalWrite(buzzer, HIGH);
                delay(500);
                digitalWrite(buzzer, LOW);  
                lcd.clear();
                lcd.print("Kayit zaten var."); 
                delay(2000);
            }

          
        }else {
          Serial.printf(fbdo.errorReason().c_str());
          lcd.clear();
          lcd.print("Zaman hatasi.");
          delay(100);
        }
        
      }else {
        //mükerrer kayıt uyarı sinyali
        digitalWrite(buzzer, HIGH);
        delay(500);
        digitalWrite(buzzer, LOW);
        delay(100);
        digitalWrite(buzzer, HIGH);
        delay(500);
        digitalWrite(buzzer, LOW);  
        lcd.clear();
        lcd.print("Kayit zaten var."); 
        delay(2000);
      }
    }else{
      Serial.print("Invalid QR: ");
      Serial.println((const char *)qrCodeData.payload);
      lcd.clear();
      lcd.print("QR gecersiz."); 
      delay(100);
    }
  }
}

  