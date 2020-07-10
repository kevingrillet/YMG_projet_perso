# Guide

L'IP dans l'example est mon IP locale avec le port changé à 81 vu que le port 80 est déjà utilisé...

## Panel de contrôle

<http://192.168.0.25:81/>

## Ecriture > GPIO

<http://192.168.0.25:81/setGPIO?gpio=>

|gpio|OUTPUT|
|---|---|
|```0``` [OFF]|```OFF```|
|```4``` [RED]|```RED```|
|```5``` [GREEN]|```GREEN```|
|```14``` [YELLOW]|```YELLOW```|

## Lecture > Device Name

<http://192.168.0.25:81/readDeviceName>

|OUTPUT|
|---|
|Nom du device visible sur le réseau|

## Lecture > GPIO

<http://192.168.0.25:81/readGPIO?gpio=>

|gpio|OUTPUT|
|---|---|
|```4``` [RED]|```0``` [ON], ```1``` [OFF]|
|```5``` [GREEN]|```0``` [ON], ```1``` [OFF]|
|```14``` [YELLOW]|```0``` [ON], ```1``` [OFF]|

## Lecture > LED

<http://192.168.0.25:81/readLED>

|OUTPUT|
|---|
|```[OFF, GREEN, RED, YELLOW]```|

## Sources

### ESP8266 - Web Server + HTML

<https://circuits4you.com/2016/12/16/esp8266-web-server-html/>

```c
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

const char MAIN_page[] PROGMEM = R"=====(
<HTML>
  <BODY>
    <P>Hello World!</P>
  </BODY>
</HTML>
)=====";

const char* ssid = "";
const char* password = "";

ESP8266WebServer server(80);

void handleRoot() {
  server.send(200, "text/html", MAIN_page);
}

void setup(void){
  Serial.begin(115200);

  WiFi.begin(ssid, password);

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.begin();

  Serial.println("HTTP server started");
}

void loop(void){
  server.handleClient();
}
```

### ESP8266 - LED ON/OFF

<https://circuits4you.com/2018/02/05/esp8266-arduino-wifi-web-server-led-on-off-control/>

La led de cet example est celle du GPIO_2, soit la LED intégrée qui est la seule à fonctionner en inversé ```HIGH<->LOW```

```c
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

#define LED 2

const char MAIN_page[] PROGMEM = R"=====(
<!DOCTYPE html>
<html>
  <body>
    Clic to turn <a href="ledOn" target="myIframe">LED ON</a><br>
    Clic to turn <a href="ledOff" target="myIframe">LED OFF</a><br>
    LED State:<iframe name="myIframe" width="100" height="25" frameBorder="0"><br>
  </body>
</html>
)=====";

const char* ssid = "";
const char* password = "";

ESP8266WebServer server(80);

void handleRoot() {
  server.send(200, "text/html", MAIN_page);
}

void handleLEDon() {
 Serial.println("LED on page");
 digitalWrite(LED,LOW);
 server.send(200, "text/html", "ON");
}

void handleLEDoff() {
 Serial.println("LED off page");
 digitalWrite(LED,HIGH);
 server.send(200, "text/html", "OFF");
}

void setup(void){
  Serial.begin(115200);

  WiFi.begin(ssid, password);

  pinMode(LED,OUTPUT);
  digitalWrite(LED,HIGH);

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/ledOn", handleLEDon);
  server.on("/ledOff", handleLEDoff);
  server.begin();

  Serial.println("HTTP server started");
}

void loop(void){
  server.handleClient();
}
```

### ESP8266 - GPIO à utiliser

<https://randomnerdtutorials.com/esp8266-pinout-reference-gpios/>

|GPIO|Label|Couleur|Utilisé|Commentaire|
|---|---|---|---|---|
|```0```|D3||||
|```2```|D2|Bleu||LED intégrée, fonctionne en inversé ```HIGH<->LOW```|
|```4```|D2|Rouge|X||
|```5```|D1|Vert|X||
|```12```|D6||||
|```13```|D7||||
|```14```|D5|Jaune|X||

### ESP8266 - Ajax

<https://circuits4you.com/2018/02/04/esp8266-ajax-update-part-of-web-page-without-refreshing/>

```c
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>

#define LED 2

const char MAIN_page[] PROGMEM = R"=====(
<!DOCTYPE html>
<html>
  <body>
    <div id="demo">
      <h1>The ESP8266 NodeMCU Update web page without refresh</h1>
      <button type="button" onclick="sendData(1)">LED ON</button>
      <button type="button" onclick="sendData(0)">LED OFF</button><BR>
    </div>
    <div>
      ADC Value is : <span id="ADCValue">0</span><br>
      LED State is : <span id="LEDState">NA</span>
    </div>
    <script>
      function sendData(led) {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
            document.getElementById("LEDState").innerHTML =
            this.responseText;
          }
        };
        xhttp.open("GET", "setLED?LEDstate="+led, true);
        xhttp.send();
      }
      setInterval(function() {
        getData();
      }, 2000);
      function getData() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
          if (this.readyState == 4 && this.status == 200) {
            document.getElementById("ADCValue").innerHTML =
            this.responseText;
          }
        };
        xhttp.open("GET", "readADC", true);
        xhttp.send();
      }
    </script>
  </body>
</html>
)=====";

const char* ssid = "";
const char* password = "";

ESP8266WebServer server(80);

void handleRoot() {
  server.send(200, "text/html", MAIN_page);
}

void handleADC() {
  int a = analogRead(A0);
  String adcValue = String(a);

  server.send(200, "text/plane", adcValue);
}

void handleLED() {
  String ledState = "OFF";
  String t_state = server.arg("LEDstate");

  Serial.println(t_state);

  if(t_state == "1")
  {
    digitalWrite(LED,LOW);
    ledState = "ON";
  }
  else
  {
    digitalWrite(LED,HIGH);
    ledState = "OFF";
  }

  server.send(200, "text/plane", ledState);
}

void setup(void){
  Serial.begin(115200);
  WiFi.begin(ssid, password);

  pinMode(LED,OUTPUT);
  digitalWrite(LED,HIGH);

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/ledOn", handleLEDon);
  server.on("/ledOff", handleLEDoff);
  server.begin();

  Serial.println("HTTP server started");
}
void loop(void){
  server.handleClient();
}
```

### ESP8266 - Hostname + Static IP

<https://circuits4you.com/2018/03/09/esp8266-static-ip-address-arduino-example/>

```c
void setup(void){
  ...
  wifi_station_set_hostname(deviceName);
  WiFi.hostname(deviceName);
  WiFi.config(staticIP, subnet, gateway, dns);
  ...
}
```

### Calcul pour les résistances

<https://www.hobby-hour.com/electronics/ledcalc.php>

|LED|Résistance|
|---|---|
|Rouge|100|
|Jaune|100|
|Bleu|100|
