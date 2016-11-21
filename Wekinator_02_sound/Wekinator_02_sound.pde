import oscP5.*;
import netP5.*;
import ddf.minim.*;
import ddf.minim.ugens.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
boolean send;
float value;
float value2;
Minim minim;
AudioOutput out;
Oscil fm;

void setup() {
  size(500, 500);
  oscP5 = new OscP5(this,12000);
  myRemoteLocation = new NetAddress("127.0.0.1",6448);
  send = false;
  minim = new Minim( this );
  out   = minim.getLineOut();
  Oscil wave = new Oscil( 200, 0.8, Waves.TRIANGLE );
  fm   = new Oscil( 10, 2, Waves.SINE );
  fm.patch( wave.frequency );
  wave.patch( out );
}

void draw() {
  // erase the window to black
  background( 0 );
  // draw using a white stroke
  stroke( 255 );
  // draw the waveforms
  for( int i = 0; i < out.bufferSize() - 1; i++ )
  {
    // find the x position of each buffer value
    float x1  =  map( i, 0, out.bufferSize(), 0, width );
    float x2  =  map( i+1, 0, out.bufferSize(), 0, width );
    // draw a line from one buffer position to the next for both channels
    line( x1, 50 + out.left.get(i)*50, x2, 50 + out.left.get(i+1)*50);
    line( x1, 150 + out.right.get(i)*50, x2, 150 + out.right.get(i+1)*50);
  }  
  
  text( "Modulation frequency: " + fm.frequency.getLastValue(), 5, 15 );
  text( "Modulation amplitude: " + fm.amplitude.getLastValue(), 5, 30 );

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
    value2 = theOscMessage.get(1).floatValue();
    float modulateAmount = map(value, 0, 1, 220, 1 );
    float modulateFrequency = map(value2, 0, 1, 0.1, 100 );
  
    fm.setFrequency( modulateFrequency );
    fm.setAmplitude( modulateAmount );
    
  }
}