#include <MQTT.h>
#include <iostream> 
#include <sstream> 
#include <ESP8266WiFi.h>

#define PWMMAX 1023
#define LED D7
#define BROKER_IP    "m24.cloudmqtt.com"
#define DEV_NAME     "pbtckmqs"
#define MQTT_USER    "pbtckmqs"
#define MQTT_PW      "cGqE8aOKMT2S"

const char ssid[] = "default";
const char pass[] = "Iveta15111511";

WiFiClient net;
MQTTClient client;
unsigned long lastMillis = 0;

void connect() {
  Serial.print("checking wifi...");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(1000);
  }

  Serial.print("\nconnecting...");
  while (!client.connect(DEV_NAME, MQTT_USER, MQTT_PW)) {
    Serial.print(".");
    delay(1000);
  }
  Serial.println("\nconnected!");
  client.subscribe("fan"); //SUBSCRIBE TO TOPIC /hello
}

void messageReceived(String &topic, String &payload) {
  Serial.println("incoming: " + topic + " - " + payload);
    message(payload);
}

int fanSpeedValue = 0;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, pass);
  
  pinMode(13, OUTPUT);
  // Note: Local domain names (e.g. "Computer.local" on OSX) are not supported by Arduino.
  // You need to set the IP address directly.
  //
  // MQTT brokers usually use port 8883 for secure connections.
  client.begin(BROKER_IP, 15785, net);
  client.onMessage(messageReceived);
  connect();
}

void loop() {
  client.loop();
  if (!client.connected()) {
    connect();
  }

}
void message(String payload) {

  Serial.println(payload);
  analogWrite(13, payload.toInt());
  
}
