// bridging MAX and Processing

// needs oscP5 library by andreas schlegel at http://www.sojamo.de/oscP5


import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

float x, y;
float px, py;
float easing = 0.05;
float weight;


void setup() {
  size(600,600);
  stroke(255, 255, 0);
  frameRate(25);
  /* start oscP5, listening for incoming messages at port 7000 
   * This is a different port then the outgoing port. 
   * we are not listening here */
  oscP5 = new OscP5(this,7000); 
  /* myRemoteLocation is a NetAddress. 
   * a NetAddress takes 2 parameters, an ip address and a port number. 
   * look for your ip address in your network pref panel */
  myRemoteLocation = new NetAddress("127.0.0.1",12000); 
}


void draw() {
  background(50);
  float targetX = mouseX;
  x += (targetX - x) * easing;
  float targetY = mouseY;
  y += (targetY - y) * easing;
  weight = dist(x, y, px, py);
  strokeWeight(weight);
  line(x, y, px, py);
  sendLocation();  // send OscMessage function below
  sendWeight();    // send OSCMessage function below
  py = y;
  px = x;  
}


void sendLocation() {
  /* create an osc message with address pattern /location */
  OscMessage myMessage = new OscMessage("/location");
  myMessage.add(x); /* add an int to the osc message */
  myMessage.add(y); /* add a second int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

void sendWeight() {
  /* create an osc message with address pattern /weight */
  OscMessage myMessage = new OscMessage("/weight");
  myMessage.add(weight); /* add an int to the osc message */
  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}
