

// To Do:
// animation
// tempo control
// center dots
// on and dim action
// random play and fade
// 

// The background function is a statement that tells the computer
// which color (or gray value) to make the background of the display window 
//background(0);

//// Sets the screen to be 640 pixels wide and 360 pixels high
//size(640, 360);

//// Set the background to black and turn off the fill color
//background(0);
//noFill();

//// The two parameters of the point() method each specify coordinates.
//// The first parameter is the x-coordinate and the second is the Y 
//stroke(255);
//point(width * 0.5, height * 0.5);
//point(width * 0.5, height * 0.666666); 

//// Coordinates are used for drawing all shapes, not just points.
//// Parameters for different functions are used for different purposes.
//// For example, the first two parameters to line() specify 
//// the coordinates of the first endpoint and the second two parameters 
//// specify the second endpoint
//stroke(0, 153, 255);
//line(0, height*0.53, width, height*0.33);

//// By default, the first two parameters to rect() are the 
//// coordinates of the upper-left corner and the second pair
//// is the width and height
////stroke(255, 153, 0);
////rect(width*0.25, height*0.1, width * 0.5, height * 0.8);
import oscP5.*;
import netP5.*;
OscP5 oscP5;
import codeanticode.syphon.*;


float v_fader1 = 0.0f;
float v_fader2 = 0.0f;
float v_fader3 = 0.0f;
float v_fader4 = 0.0f;
float v_fader5 = 0.0f;
float v_toggle1 = 0.0f;
float v_toggle2 = 0.0f;
float v_toggle3 = 0.0f;
float v_toggle4 = 0.0f;

int magnitude = 1;
int speed = 1;
color red = 255;
color blue = 0;
color green = 0;
int scng = 50;
float intrpfctr = 0;
float scl = 1;
//float nextfctr = 0;

//float time = 1;
//float basefreq = 1;
//float dt = .1;

//void oscillator() {
//  inrpfctr = 
//}

//SyphonServer server;

void settings() {
 //size(1080, 720, P3D);
 fullScreen();
 PJOGL.profile=1;
}

void setup() {
 //server = new SyphonServer(this, "moontemple_circles");
 //fullScreen();
 //background(0);
 //scale(1);
 //drawCircles(30);
 frameRate(50);
  /* start oscP5, listening for incoming messages at port 8000 */
  oscP5 = new OscP5(this,12346);
  println();
 ////Midi stuff:
 //MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
 //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus object
 //myBus.sendTimestamps(false); // This is for mac, apparently...
}

void draw() {
 //int channel=0;
 //int pitch = 64;
 //int velocity = 127;
 background(0);

 //int number = 0;
 //int value = 90;
 //ControlChange change = new ControlChange(channel, number, value);
 scale(scl);
 loop();
 drawCircles(scng,red,blue,green,intrpfctr);
 delay(0);
 //server.sendScreen();
 
}

//void controllerChange(ControlChange change) {
//  // Receive a controllerChange
//  println();
//  println("Controller Change:");
//  println("--------");
//  println("Channel:"+change.channel());
//  println("Number:"+change.number());
//  println("Value:"+change.value());
//}

void oscEvent(OscMessage theOscMessage) {
    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();   
    println(addr);
    if(addr.equals("/1/fader1"))        { red = round( 255*val); }
    else if(addr.equals("/1/fader2"))   { green = round( 255*val); }
    else if(addr.equals("/1/fader3"))   { blue = round( 255*val); }
    else if(addr.equals("/1/fader4"))   { scng = round(100*val)+30; }
    else if(addr.equals("/1/fader5"))   { intrpfctr = val; }
    //else if(addr.equals("/1/toggle1"))  { v_toggle1 = val; }
    //else if(addr.equals("/1/toggle2"))  { v_toggle2 = val; }
    //else if(addr.equals("/1/toggle3"))  { v_toggle3 = val; }
    //else if(addr.equals("/1/toggle4"))  { v_toggle4 = val; }
    else {}
}

//void controllerChange(ControlChange change) {
//  switch(change.number()) {
//    case 11:
//      red = 255*change.value()/127;
//      break;
//    case 12:
//      blue = 255*change.value()/127;
//      break;
//    case 13:
//      green = 255*change.value()/127;
//      break;
//    case 15:
//      //clear();
//      //noLoop();
//      //redraw();
//      //loop();
//      scng = change.value()+30;
//      break;
//    case 14:
//      intrpfctr = change.value()/127.0;
//      break;
//    //case 16:
//    //  scl = 2*change.value()/127;
//    //  break;
    
//    }
//}

void drawCircles(float spacing,int r,int g,int b,float infctr) {
 // initialize a bunch of variables:
 int rownum = 0;
 float offset = 0;
 float p1 = 1/2;
 float p2 = sqrt(3)/2;

  float fctr = intrpfctr;

 for (float i = -spacing; i < height+spacing; i+= spacing*sqrt(3)/2) {
   rownum += 1;
   if ((rownum % 2)==0) {
     offset = spacing/2;
   } else {
     offset = 0;
   }
   for (float j = -spacing+offset; j < width+spacing; j += spacing) {
     //println(j, i);
     //fill(color(random(255),random(255),random(255)));
     //stroke(color(r,g,b));
     //nw
     Circle(j-2*fctr*spacing*p1,i-2*fctr*spacing*p2,spacing,r,g,b);
     //ne
     Circle(j+2*fctr*spacing*p1,i-2*fctr*spacing*p2,spacing,r,g,b);
     //e
     Circle(j+2*fctr*spacing*2*p1,i,spacing,r,g,b);
     //se
     Circle(j+2*fctr*spacing*p1,i+2*fctr*spacing*p2,spacing,r,g,b);
     //sw
     Circle(j-2*fctr*spacing*p1,i+2*fctr*spacing*p2,spacing,r,g,b);
     //w
     Circle(j-2*fctr*spacing*2*p1,i,spacing,r,g,b);
   }
 }
}

//void midiMessage(MidiMessage message) { // You can also use midiMessage(MidiMessage message, long timestamp, String bus_name)
//  // Receive a MidiMessage
//  // MidiMessage is an abstract class, the actual passed object will be either javax.sound.midi.MetaMessage, javax.sound.midi.ShortMessage, javax.sound.midi.SysexMessage.
//  // Check it out here http://java.sun.com/j2se/1.5.0/docs/api/javax/sound/midi/package-summary.html
//  println();
//  println("MidiMessage Data:");
//  println("--------");
//  println("Status Byte/MIDI Command:"+message.getStatus());
//  for (int i = 1;i < message.getMessage().length;i++) {
//    println("Param "+(i+1)+": "+(int)(message.getMessage()[i] & 0xFF));
//  }
//}

void Circle(float x, float y, float radius, int R, int G, int B) {
  //stroke(255);
  noFill();
  stroke(color(R,G,B));
  strokeWeight(radius/25);
  ellipse(x,y,radius*2,radius*2);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}

void drawCircle(int x, int radius, int level) {                    
  //float tt = 126 * level/4.0;
  fill(color(random(255),random(255),random(255)));
  ellipse(x, height/2, radius*2, radius*2);      
  if(level > 1) {
    level = level - 1;
    drawCircle(x - radius/2, radius/2, level);
    drawCircle(x + radius/2, radius/2, level);
  }
}

//void draw() {
//  drawTarget(width*0.25, height*0.4, 200, 4);
//  drawTarget(width*0.5, height*0.5, 300, 10);
//  drawTarget(width*0.75, height*0.3, 120, 6);
//}

//void drawTarget(float xloc, float yloc, int size, int num) {
//  float grayvalues = 255/num;
//  float steps = size/num;
//  for (int i = 0; i < num; i++) {
//    fill(i*grayvalues);
//    ellipse(xloc, yloc, size - i*steps, size - i*steps);
//  }
//}