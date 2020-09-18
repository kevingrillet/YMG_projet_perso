#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>

#ifndef STASSID
#define STASSID ""
#define STAPSK  ""
#endif

#define PORT      80 // default 80
#define DEBUG     0
// 0 Infos après boot
// 1 Call à la page root
// 2 Call aux fonctions d'écriture de GPIO
// 3 Call aux fonctions de lecture de GPIO
#define GPIO_4    4 // D2 RED
#define GPIO_5    5 // D1 GREEN
#define GPIO_14  14 // D5 YELLOW

// HTML Formatter: https://webformatter.com/html
const char MAIN_page[] PROGMEM = R"=====(
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>WiFi LED control panel</title>
    <style>
      @import url("https://fonts.googleapis.com/css?family=Roboto&display=swap");
      body {
        background: #777777;
        background-image: url("https://picsum.photos/1920/1080.jpg?grayscale&blur=2");
        font-family: Roboto, Helvetica, Arial, sans-serif;
        overflow: hidden;
      }
      table {
        width: 100%;
        font-family: sans-serif;
        border-spacing: 0;
        border: 1px solid #333333;
      }
      th {
        background-color: #555555;
        color: white;
        font-weight: normal;
        padding: 2.5%;
        text-align: center;
      }
      td {
        background-color: #dddddd;
        font-size: large;
        font-family: monospace;
        padding: 2%;
        text-align: center;
      }
      .buttons {
        display: flex;
        flex-flow: row wrap;
        border: none;
      }
      .button {
        border: none;
        cursor: pointer;
        padding: 10px 10px;
        margin: 0.25%;
        outline: none;
      }
      .button33 {
        width: 32.8%;
      }
      .button50 {
        width: 49.5%;
      }
      .button100 {
        width: 99.5%;
      }
      .container {
        width: 400px;
        margin: 0 auto;
        margin-top: 50vh;
        transform: translateY(-50%);
        padding: 25px;
        background: #eeeeee;
        color: #333333;
        box-shadow: 0 0 20px 0 rgba(0, 0, 0, 0.2), 0 5px 5px 0 rgba(0, 0, 0, 0.24);
        border-radius: 5px;
      }
      #buttonGreen {
        background: limegreen;
      }
      #buttonGreen:hover {
        background: green;
      }
      #buttonOff {
        background: lightgray;
      }
      #buttonOff:hover {
        background: silver;
      }
      #buttonRed {
        background: red;
      }
      #buttonRed:hover {
        background: crimson;
      }
      #buttonYellow {
        background: lemonchiffon;
      }
      #buttonYellow:hover {
        background: khaki;
      }
      #diode {
        display: block;
        margin-left: auto;
        margin-right: auto;
      }
      #ip {
        font-size: large;
        font-family: monospace;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>WiFi LED control panel:</h1>
      <h2><span id="deviceName"></span></h2>
      <hr />
      <p>Click to turn:</p>
      <div class="buttons">
        <button type="button" class="button button33" id="buttonGreen" onclick="sendGPIO(5)">GREEN</button>
        <button type="button" class="button button33" id="buttonRed" onclick="sendGPIO(4)">RED</button>
        <button type="button" class="button button33" id="buttonYellow" onclick="sendGPIO(14)">YELLOW</button>
        <button type="button" class="button button100" id="buttonOff" onclick="sendGPIO(0)">OFF</button>
      </div>
      <hr />
      <table>
        <thead>
          <tr>
            <th>LED State</th>
            <th>GPIO4<br/>[D2]</th>
            <th>GPIO5<br/>[D1]</th>
            <th>GPIO14<br/>[D5]</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><span id="led">OFF</span></td>
            <td><span id="gpio4">0</span></td>
            <td><span id="gpio5">0</span></td>
            <td><span id="gpio14">0</span></td>
          </tr>
        </tbody>
      </table>
      <hr />
      <svg
        id="diode"
        enable-background="new 0 0 65 250"
        height="251"
        i:pageBounds="0 65 250 0"
        i:rulerOrigin="0 0"
        overflow="visible"
        space="preserve"
        viewBox="0 0 65 250"
        width="65"
        xmlns="http://www.w3.org/2000/svg"
        xmlns:a="http://ns.adobe.com/AdobeSVGViewerExtensions/3.0/"
        xmlns:graph="http://ns.adobe.com/Graphs/1.0/"
        xmlns:i="http://ns.adobe.com/AdobeIllustrator/10.0/"
        xmlns:x="http://ns.adobe.com/Extensibility/1.0/"
        xmlns:xlink="http://www.w3.org/1999/xlink"
      >
        <g i:dimmedPercent="50" i:layer="yes" i:rgbTrio="#4F008000FFFF" id="Layer_1">
          <path clip-rule="evenodd" d="M17.244,101.556h5.904v115.596h-5.904V101.556z    " fill="#808080" fill-rule="evenodd" i:knockout="Off" />
          <path clip-rule="evenodd" d="M32.904,101.196h5.868v149.868h-5.868V101.196z    " fill="#808080" fill-rule="evenodd" i:knockout="Off" />
          <path
            id="svgC0"
            clip-rule="evenodd"
            d="M7.812,86.94V24.48c0-0.072,0-0.144,0-0.252    c0-12.42,10.08-22.5,22.5-22.5c12.384,0,22.392,9.864,22.536,22.248L52.812,86.94H7.812z"
            style="fill: #999999;"
            fill-rule="evenodd"
            i:knockout="Off"
          />
          <linearGradient gradientUnits="userSpaceOnUse" id="XMLID_1_" x1="10.5483" x2="50.0762" y1="46.2061" y2="46.2061">
            <stop offset="0" id="svgC1" style="stop-color: #aaaaaa;" />
            <stop offset="0.1899" id="svgC2" style="stop-color: #dddddd;" />
            <stop offset="0.5088" id="svgC3" style="stop-color: #eeeeee;" />
            <stop offset="1" id="svgC4" style="stop-color: #aaaaaa;" />
            <a:midPointStop offset="0" id="svgC5" style="stop-color: #aaaaaa;" />
            <a:midPointStop offset="0.4889" id="svgC6" style="stop-color: #aaaaaa;" />
            <a:midPointStop offset="0.5088" id="svgC7" style="stop-color: #eeeeee;" />
            <a:midPointStop offset="0.5" id="svgC7" style="stop-color: #eeeeee;" />
            <a:midPointStop offset="1" id="svgC9" style="stop-color: #aaaaaa;" />
          </linearGradient>
          <path clip-rule="evenodd" d="M10.548,83.592V28.8    c0-0.072,0-0.144,0-0.216c0-10.908,8.856-19.764,19.764-19.764c10.872,0,19.656,8.676,19.764,19.512v55.26H10.548z" fill="url(#XMLID_1_)" fill-rule="evenodd" i:knockout="Off" />
          <path id="svgC10" clip-rule="evenodd" d="M0,86.4h60.624v15.624H0V86.4z" style="fill: #999999;" fill-rule="evenodd" i:knockout="Off" />
          <path id="svgC11" clip-rule="evenodd" d="M42.084,83.7V53.064H17.28l11.484,15.012h9.36    V83.7H42.084z" style="fill: #888888;" fill-rule="evenodd" i:knockout="Off" />
          <path id="svgC12" clip-rule="evenodd" d="M16.884,83.7V57.456l9.36,11.448V83.7H16.884z" style="fill: #888888;" fill-rule="evenodd" i:knockout="Off" />
        </g>
      </svg>
      Sources: <a href="https://github.com/kevingrillet/YMG_projet_perso">https://github.com/kevingrillet/YMG_projet_perso</a>
    </div>
    <script>
      function readDeviceName() {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
          if (this.readyState == 4 && this.status == 200) {
            document.getElementById("deviceName").innerHTML = this.responseText;
          }
        };
        xhttp.open("GET", "readDeviceName", true);
        xhttp.send();
      }

      function readLED() {
        var xhttp = new XMLHttpRequest();
        var c1, c2, c3;
        xhttp.onreadystatechange = function () {
          if (this.readyState == 4 && this.status == 200) {
            document.getElementById("led").innerHTML = this.responseText;
            switch (this.responseText) {
              case "GREEN":
                c0 = "#007931";
                c1 = "#147A33";
                c2 = "#187F32";
                c3 = "#6CBB22";
                c4 = "#005C25";
                break;
              case "YELLOW":
                c0 = "#DBDB00";
                c1 = "#DBDB0C";
                c2 = "#E8E94C";
                c3 = "#F6F89F";
                c4 = "#B5D11B";
                break;
              case "RED":
                c0 = "#FB0F0C";
                c1 = "#F8130D";
                c2 = "#F74431";
                c3 = "#F79680";
                c4 = "#DB0000";
                break;
              default:
                c0 = "#999999";
                c1 = "#aaaaaa";
                c2 = "#cccccc";
                c3 = "#eeeeee";
                c4 = "#888888";
            }
            document.getElementById("svgC0").style.fill = c0;
            document.getElementById("svgC1").style.stopColor = c1;
            document.getElementById("svgC2").style.stopColor = c2;
            document.getElementById("svgC3").style.stopColor = c3;
            document.getElementById("svgC4").style.stopColor = c1;
            document.getElementById("svgC5").style.stopColor = c1;
            document.getElementById("svgC6").style.stopColor = c1;
            document.getElementById("svgC7").style.stopColor = c3;
            document.getElementById("svgC9").style.stopColor = c1;
            document.getElementById("svgC10").style.fill = c0;
            document.getElementById("svgC11").style.fill = c4;
            document.getElementById("svgC12").style.fill = c4;
          }
        };
        xhttp.open("GET", "readLED", true);
        xhttp.send();
      }

      function readGPIO(gpio) {
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
          if (this.readyState == 4 && this.status == 200) {
            if (gpio == 4) {
              document.getElementById("gpio4").innerHTML = this.responseText;
            } else if (gpio == 5) {
              document.getElementById("gpio5").innerHTML = this.responseText;
            } else if (gpio == 14) {
              document.getElementById("gpio14").innerHTML = this.responseText;
            }
          }
        };
        xhttp.open("GET", "readGPIO?gpio=" + gpio, true);
        xhttp.send();
      }

      function refresh() {
        readLED();
        readGPIO(4);
        readGPIO(5);
        readGPIO(14);
      }

      function sendGPIO(gpio) {
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "setGPIO?gpio=" + gpio, true);
        xhttp.send();
        refresh();
      }

      readDeviceName();
      refresh();
      setInterval(function () {
        refresh();
      }, 10 * 1000);
    </script>
  </body>
</html>
)=====";

//IPAddress staticIP(192, 168, 43, 90);
//IPAddress gateway(192, 168, 43, 1);
//IPAddress subnet(255, 255, 255, 0);
//IPAddress dns(8, 8, 8, 8);
const char* deviceName = "IOT GRC";
const char *ssid = STASSID;
const char *password = STAPSK;

String ledState = "OFF";
ESP8266WebServer server(PORT);

void handleRoot()
{
  if (DEBUG > 0) {Serial.println("You called root page");}
  server.send(200, "text/html", MAIN_page);
}

void handleDeviceNamer()
{
  server.send(200, "text/html", deviceName);
}

void handleGPIOr()
{
  String t_state = server.arg("gpio");
	if ( t_state == "4")
	{
    if (DEBUG > 2) {Serial.println("digitalRead(4): " + String(digitalRead(GPIO_4)));}
		server.send(200, "text/plane", String(digitalRead(GPIO_4)));
	}
	else if ( t_state == "5")
	{
    if (DEBUG > 2) {Serial.println("digitalRead(5): " + String(digitalRead(GPIO_5)));}
		server.send(200, "text/plane", String(digitalRead(GPIO_5)));
	}
	else if ( t_state == "14")
	{
    if (DEBUG > 2) {Serial.println("digitalRead(14): " + String(digitalRead(GPIO_14)));}
		server.send(200, "text/plane", String(digitalRead(GPIO_14)));
	}
}

void handleGPIOs()
{
  String t_state = server.arg("gpio");
	if (t_state == "4")
	{
    if (DEBUG > 1) {Serial.println("RED LED on page");}
		digitalWrite(GPIO_4, HIGH);
		digitalWrite(GPIO_5, LOW);
		digitalWrite(GPIO_14, LOW);
		ledState = "RED";
	}
	else if (t_state == "5")
	{
    if (DEBUG > 1) {Serial.println("GREEN LED on page");}
		digitalWrite(GPIO_4, LOW);
		digitalWrite(GPIO_5, HIGH);
		digitalWrite(GPIO_14, LOW);
		ledState = "GREEN";
	}
	else if (t_state == "14")
	{
    if (DEBUG > 1) {Serial.println("YELLOW LED on page");}
		digitalWrite(GPIO_4, LOW);
		digitalWrite(GPIO_5, LOW);
		digitalWrite(GPIO_14, HIGH);
		ledState = "YELLOW";
	}
	else
	{
    if (DEBUG > 1) {Serial.println("LED off page");}
		digitalWrite(GPIO_4, LOW);
		digitalWrite(GPIO_5, LOW);
		digitalWrite(GPIO_14, LOW);
		ledState = "OFF";
	}
  if (DEBUG > 1) {Serial.println("ledState: " + ledState);}
  server.send(200, "text/plane", ledState);
}

void handleLEDr()
{
  server.send(200, "text/plane", ledState);
}

void setup(void)
{
  Serial.begin(115200);

  wifi_station_set_hostname(deviceName);
  WiFi.hostname(deviceName);
//  WiFi.config(staticIP, subnet, gateway, dns);
  WiFi.begin(ssid, password);
  Serial.println("");

  pinMode(GPIO_4, OUTPUT);
  digitalWrite(GPIO_4, LOW);
  pinMode(GPIO_5, OUTPUT);
  digitalWrite(GPIO_5, LOW);
  pinMode(GPIO_14, OUTPUT);
  digitalWrite(GPIO_14, LOW);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }

  Serial.println("");
  Serial.print("Connected to ");
  Serial.println(ssid);
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP().toString() + ":" + PORT);

  server.on("/", handleRoot);
  server.on("/readDeviceName", handleDeviceNamer);
  server.on("/readGPIO", handleGPIOr);
  server.on("/readLED", handleLEDr);
  server.on("/setGPIO", handleGPIOs);

  server.begin();
  Serial.println("HTTP server started");
}

void loop(void)
{
  server.handleClient();
}
