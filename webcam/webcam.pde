import processing.video.*;
import com.hamoid.*;
Capture cam;

import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;

int FPS = 5;

void setup() {
  size(640, 480);
  surface.setLocation(0, 0);
  frameRate(FPS);
  cam = new Capture(this, 640, 480, FPS);
  cam.start();
  oscP5 = new OscP5(this,7000); 
   /* myRemoteLocation is a NetAddress. 
   * a NetAddress takes 2 parameters, an ip address and a port number. 
   * look for your ip address in your network pref panel */
  myRemoteLocation = new NetAddress("127.0.0.1",12000); 
}
void draw() {

  if (cam.available()) {
    cam.read();
    image(cam, 0, 0);
    
    float redAvg = 0;
    float greenAvg = 0;
    float blueAvg = 0;
    float brightAvg = 0;
    loadPixels();
    for (int i = 0; i < pixels.length; i ++) {
    float red = red(pixels[i]);
    float green = green(pixels[i]);
    float blue = blue(pixels[i]);
    float brightness = brightness(pixels[i]);
    redAvg += red;
    greenAvg += green;
    blueAvg += blue;
    brightAvg += brightness;
    }
    redAvg /= pixels.length;
    greenAvg /= pixels.length;
    blueAvg /= pixels.length;
    brightAvg /= pixels.length;
    //println(redAvg + ", " + greenAvg + ", " + blueAvg + ", " + brightAvg);
    updatePixels();
    sendInfo(redAvg, greenAvg, blueAvg, brightAvg);
  }
}

void sendInfo(float r, float g, float b, float br) {
  OscMessage mess = new OscMessage("/color");
  mess.add(r);
  mess.add(g);
  mess.add(b);
  mess.add(br);
  oscP5.send(mess, myRemoteLocation);
}
