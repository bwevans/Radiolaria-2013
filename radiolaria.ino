/***********************************
Source code for Radiolaria, 2010-13
www.brianwevans.com
CC-BY-SA 2013
***********************************/

const int trimmer = A0;
const int charge = 2;
const int DCin = 3;
const int motor1a = 5;
const int motor1b = 6;
const int ledGnd = 8;
const int led = 9;

//identity
const int speedMin(35);
const int speedMax(60);
const int runMin(400);
const int runMax(400);
const int delayMin(2500);
const int delayMax(2500);

const boolean light=false;

void setup() {
  pinMode(DCin, INPUT);
  randomSeed(analogRead(trimmer));
  delay(10000);
}

void loop() {
  while(digitalRead(DCin)) {
    delay(5000);
  }
  
  int direction = random(2);
  
  int speed = random(speedMin,speedMax);
  int runTime = random(runMax);
  int delayTime = random(delayMax);
  
  if (runTime < runMin) runTime = 0;
  if (delayTime < delayMin) delayTime = 0;
  if (delayTime > (delayMax-100)) delayTime = random(20000,30000);
  
  spin(direction,speed);
  delay(runTime);
  spin(direction,0);
  delay(delayTime);
  
  if(light) if (delayTime) heartBeat(delayTime);
}

void spin(boolean dir, int spd) {
  if(dir) {
    analogWrite(motor1a, spd);
    analogWrite(motor1b, 0);
  } else {
    analogWrite(motor1a, 0);
    analogWrite(motor1b, spd);
  }
}

void heartBeat(int time) {
  int i = 0;
  int brightness = 0;
  int fadeAmount = 1;
  while (i <= time) {
    analogWrite(led, brightness);
    brightness = brightness + fadeAmount;
    if (brightness == 0 || brightness == 90) fadeAmount = -fadeAmount ;
    delay(50);
    i+=50;
  }
  analogWrite(led, 0);
}
  
