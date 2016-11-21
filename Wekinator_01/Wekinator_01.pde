import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
boolean send;
float value;

void setup() {
  size(500, 500);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",6448);
  send = false;
}

void draw() {
  background(0);
  fill(255*value, 0, 255*(1.0-value));
  ellipse(mouseX, mouseY, 100, 100);
  if (send == true) {
    sendOsc();
    fill(255, 0, 0);
    ellipse(30, 30, 60, 60);
  }
}

void keyPressed() {
  if (key == ' ') {
    send = !send;
  }
}

void sendOsc() {
  OscMessage myMessage = new OscMessage("/wek/inputs");
  myMessage.add((float) mouseX);
  myMessage.add((float) mouseY);
  oscP5.send(myMessage, myRemoteLocation); 
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/wek/outputs")) {
    value = theOscMessage.get(0).floatValue();
  }
}