

// To Do:
// animation
// tempo control
// center dots
// on and dim action
// random play and fade
// 

import oscP5.*;
import netP5.*;
OscP5 oscP5;

//import codeanticode.syphon.*;

//import themidibus.*;

//MidiBus myBus; // The MidiBus
int rps = 1;
int balance = 25; // any number
int numspecies = 2*balance+1;
float probabilityOfAliveAtStart = 50;
int interval = 1;
int lastRecordedTime = 0;
int toroidal = 1;
// Colors for active/inactive cells

//color alive = color(random(100),random(100) ,random(100));
//color dead = color(random(100),random(100),random(100));

color[] colarray = new color[numspecies];
void gencolor() {
  for (int n=0; n<numspecies; n++) {
    println(hue/100);
    float clr =max(0, min((hue/100)*((n*(100/(numspecies-1)))+100*intrpfctr)+rndfctr*random(100),100));//+(1-intrpfctr)*random(100));
    colarray[n] = color(clr,sat+(1-sat/100)*random(100),brt+(1-brt/100)*random(100));//(n*(100/(numspecies-1)),sat,100);//round(100*hue)/(numspecies-1),n*round(100*sat)/(numspecies-1),n*round(100*brt)/(numspecies-1));//
  }
}

float v_fader1 = 0.0f;
float v_fader2 = 0.0f;
float v_fader3 = 0.0f;
float v_fader4 = 0.0f;
float v_fader5 = 0.0f;
float v_toggle1 = 0.0f;
float v_toggle2 = 0.0f;
float v_toggle3 = 0.0f;
float v_toggle4 = 0.0f;

int rndfctr = 0;
float clr = 100;
float hue = 100;
float sat = 100;
float brt = 100;
int spcng = 10;
float intrpfctr = 1;
float scl = 1;
int channel = 0;
int number = 0;
int value = 90;
int pitch = 64;
int velocity = 127;
int mode = 2;
int[][] cells;
int[][] cellsBuffer;

//Pause
boolean pause = true;

//SyphonServer server;
PGraphics canvas;

void settings() {
 //size(1080, 720, P3D);
 fullScreen();
 PJOGL.profile=1;

}

void setup() {
 //fullScreen();
 canvas = createGraphics(1080, 720, P2D);
 //server = new SyphonServer(this, "RPS_automata");
 colorMode(HSB,100);
 frameRate(50);
 //background(0);
 //scale(1);
 //drawCircles(30);
 oscP5 = new OscP5(this,12345);
 int numCellsX = width/spcng;
 int numCellsY = height/spcng;
 cells = new int[numCellsX][numCellsY];
 cellsBuffer = new int[numCellsX][numCellsY];
 initializeCA(2);
 gencolor();
 //Midi stuff:
 //MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
 //myBus = new MidiBus(this, 0, 1); // Create a new MidiBus object
 //myBus.sendTimestamps(false); // This is for mac, apparently...
}

void draw() {
 background(0);
 //Note note = new Note(channel, pitch, velocity);
 
 //myBus.sendNoteOn(note); // Send a Midi noteOn
 // delay(200);
 //myBus.sendNoteOff(note); // Send a Midi nodeOff
 
   cellular_automata();
   delay(0);
   //image(canvas, 0, 0);
   
  //server.sendImage(canvas);
 
}

void oscEvent(OscMessage theOscMessage) {
    String addr = theOscMessage.addrPattern();
    float  val  = theOscMessage.get(0).floatValue();   
    println(addr);
    if(addr.equals("/1/fader1"))        { hue = round(100*val); }
    else if(addr.equals("/1/fader2"))   { sat = round(100*val); }
    else if(addr.equals("/1/fader3"))   { brt = round(100*val); }
    else if(addr.equals("/1/fader4"))   { pause=!pause; }//spcng = round(100*val)+5; }
    else if(addr.equals("/1/fader5"))   { intrpfctr = val; }
    else if(addr.equals("/1/toggle1"))  { rndfctr = round(val); }
    else if(addr.equals("/1/toggle2"))  { initializeCA(1); }
    else if(addr.equals("/1/toggle3"))  { initializeCA(2); }
    else if(addr.equals("/1/toggle4"))  { int numCellsX = width/spcng;
  int numCellsY = height/spcng;for (int x=0;x<numCellsX;x++){for (int y=0; y<numCellsY; y++) { 
    int species=floor(random(0,numspecies));
    cells[x][y]=species;
    };} }
    else {}
    gencolor();
}

//void controllerChange(ControlChange change) {
// println();
// println("Controller Change:");
// println("--------");
// println("Channel:"+change.channel());
// println("Number:"+change.number());
// println("Value:"+change.value());
//  switch(change.number()) {
//    case 11:
//      hue = 100*change.value()/127;
//      break;
//    case 12:
//      sat = 100*change.value()/127;
//      break;
//    case 13:
//      brt = 100*change.value()/127;
//      break;
//    case 15:
//      //clear();
//      //noLoop();
//      //redraw();
//      //loop();
//      spcng = change.value()+1;
//      break;
//    case 14:
//      intrpfctr = change.value()/127.0;
//      break;
//    //case 16:
//    //  scl = 2*change.value()/127;
//    //  break;
    
//    }
//}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}