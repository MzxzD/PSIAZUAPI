#include <DHT.h>
#include <MQTT.h>
#include <ESP8266WiFi.h>

#define DHTPIN 13    // what pin we're connected to
#define DHTTYPE DHT12   // DHT 11
#define BROKER_IP    "m24.cloudmqtt.com"
#define DEV_NAME     "pbtckmqs"
#define MQTT_USER    "arduinoUser"
#define MQTT_PW      "arduinoUser"

const char ssid[] = "default";
const char pass[] = "Iveta15111511";
DHT dht(DHTPIN, DHTTYPE);
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
  client.subscribe("test"); //SUBSCRIBE TO TOPIC /test
}

void messageReceived(String &topic, String &payload) {
  Serial.println("incoming: " + topic + " - " + payload);
}

int fanSpeedValue = 0;

void setup() {
  Serial.begin(9600);
  WiFi.begin(ssid, pass);
  dht.begin();

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

temperture();
}

void temperture() {
  
  
    delay(2000);

  // Reading temperature or humidity takes about 250 milliseconds!
  // Sensor readings may also be up to 2 seconds 'old' (its a very slow sensor)
  float h = dht.readHumidity();
  // Read temperature as Celsius (the default)
  float t = dht.readTemperature();
  // Read temperature as Fahrenheit (isFahrenheit = true)
  float f = dht.readTemperature(true);

  // Check if any reads failed and exit early (to try again).
  if (isnan(h) || isnan(t) || isnan(f)) {
    Serial.println("Impossible de lire la sonde DHT!");
    return;
  }

  // Compute heat index in Fahrenheit (the default)
  float hif = dht.computeHeatIndex(f, h);
  // Compute heat index in Celsius (isFahreheit = false)
  float hic = dht.computeHeatIndex(t, h, false);

String data = "{ \"DTI\": { \"humidity\":" + String(h) + ", \"temperatureC\": " + String(t) + ", \"temperatureF\": " + String(f) + " }  }";

    client.publish("dti", data ); //PUBLISH TO TOPIC /hello MSG world
  
  
}
