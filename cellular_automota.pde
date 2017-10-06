import codeanticode.syphon.*;

/**
 * modified from:
 * A Processing implementation of Game of Life
 * By Joan Soler-Adillon
 *
 * Most basic modification: it runs on a torus instead of a plane.
 * 
 * Controls:
 * SPACE - run the simulation without stopping
 * s  - pause or step the simulation
 * r  - randomly generate a layout
 * c  - generate random color scheme (and step the simulation)
 * 1,2,3 - special starting points.
 */
import oscP5.*;
import netP5.*;
OscP5 oscP5;

// Size of cells
int cellSize = 10;

int rps = 0;
int balance = 3; // any number
int numspecies = 2*balance+1;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 50;

// Variables for timer
int interval = 0;
int lastRecordedTime = 0;
int stepping = 0;

// Periodic boundary conditions?
int toroidal = 1;

float v_fader1 = 0.0f;
float v_fader2 = 0.0f;
float v_fader3 = 0.0f;
float v_fader4 = 0.0f;
float v_fader5 = 0.0f;
float v_toggle1 = 0.0f;
float v_toggle2 = 0.0f;
float v_toggle3 = 0.0f;
float v_toggle4 = 0.0f;

// Colors for active/inactive cells

//color alive = color(random(100),random(100) ,random(100));
//color dead = color(random(255),random(255),random(255));

color[] colarray = new color[numspecies];

SyphonServer server;

void gencolor() {
  for (int n=0; n<numspecies; n++) {
    colarray[n] = color(100-random(100), 100, 100);//random(75,100),random(80,100));//color(8,100,(n+9)*(100/(numspecies+10)));
  }
}

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = true;

void settings() {
  //size(1080, 720, P3D);
  fullScreen();
  PJOGL.profile=1;
}

void setup() {
  //size (640, 360);
  //fullScreen();
  //server = new SyphonServer(this, "GameOfLife");
  colorMode(HSB, 100);
  noLoop();
  oscP5 = new OscP5(this, 12347);
  int numCellsX = width/cellSize;
  int numCellsY = height/cellSize;
  // Instantiate arrays 
  cells = new int[numCellsX][numCellsY];
  cellsBuffer = new int[numCellsX][numCellsY];
  gencolor();
  // This stroke will draw the background grid
  stroke(0, 0);
  //strokeWeight(0);
  noSmooth();

  // Initialization of cells
  initialize(1);
  //for (int x=0; x<numCellsX; x++) {
  //  for (int y=0; y<numCellsY; y++) {
  //     //float state = random (100);
  //     int state = 0;
  //    if (x == floor(width/(2*cellSize))) {//state > probabilityOfAliveAtStart) { 
  //      state = 1;
  //    } else {
  //      state = 0;
  //    }
  //    cells[x][y] = state; // Save state of each cell
  //  }
  //}
  background(0); // Fill in black in case cells don't cover all the windows
}

void initialize(int n) {
  int numCellsX = width/cellSize;
  int numCellsY = height/cellSize;
  if (rps==1) {
    int [] spec = new int[numspecies];
    for (int i=0; i < numspecies; i++) {
      spec[i]=floor(random(0, numspecies));
    }
    switch(n) {
    case 1: //rps
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          cells[x][y] = floor((x/(numCellsX+.001))*numspecies);//spec[floor(numspecies*x/(numCellsX+0.001))];//floor((x/numCellsX-0.01)*numspecies);//state; // Save state of each cell
        }
      }
      break;
    case 2://rps
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          cells[x][y] = floor((y/(numCellsY+.001))*numspecies);//spec[floor(numspecies*y/(numCellsY+0.001))];//state; // Save state of each cell
        }
      }
      break;
    case 3://rps
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          cells[x][y] = floor((x*y/(numCellsX*numCellsY+0.0001))*numspecies);//state; // Save state of each cell
        }
      }
      break;
    }
  } else {
    switch(n) {
    case 1:
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          //float state = random (100);
          int state = 0;
          if (x == floor(width/(2*cellSize))+1) {//state > probabilityOfAliveAtStart) { 
            state = 1;
          } else {
            state = 0;
          }
          cells[x][y] = state; // Save state of each cell
        }
      }
      break;
    case 2:
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          //float state = random (100);
          int state = 0;
          if (y == floor(height/(2*cellSize))+1) {//state > probabilityOfAliveAtStart) { 
            state = 1;
          } else {
            state = 0;
          }
          cells[x][y] = state; // Save state of each cell
        }
      }
      break;
    case 3:
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
          //float state = random (100);
          int state = 0;
          if ((y == floor(height/(2*cellSize))+1) || (x==floor(width/(2*cellSize))+1) ) {//state > probabilityOfAliveAtStart) { 
            state = 1;
          } else {
            state = 0;
          }
          cells[x][y] = state; // Save state of each cell
        }
      }
      break;
    }
  }
}

void draw() {
  int numCellsX = width/cellSize;
  int numCellsY = height/cellSize;
  //Draw grid
  if (rps == 1) {
    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        fill(colarray[cells[x][y]]);
        rect(x*cellSize, y*cellSize, cellSize, cellSize);
      }
    }
  } else {

    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        if (cells[x][y]==1) {
          fill(colarray[0]); // If alive
        } else {
          fill(colarray[1]); // If dead
        }
        rect (x*cellSize, y*cellSize, cellSize, cellSize);
      }
    }
  }
  //Iterate if timer ticks
  if (stepping==0) {
    int now = millis();
    if (now-lastRecordedTime>interval) {
      iteration();
      lastRecordedTime = millis();
    }
  } else {
    iteration();
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, numCellsX));
    xCellOver = constrain(xCellOver, 0, numCellsX-1);
    int yCellOver = int(map(mouseY, 0, height, 0, numCellsY));
    yCellOver = constrain(yCellOver, 0, numCellsY-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(colarray[0]); // Fill with kill color
    } else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(colarray[1]); // Fill alive color
    }
  } else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
  //server.sendScreen();
}



void iteration() { // When the clock ticks
  int numCellsX = width/cellSize;
  int numCellsY = height/cellSize;
  // Save cells to buffer (so we opeate with one array keeping the other intact)
  for (int x=0; x<numCellsX; x++) {
    for (int y=0; y<numCellsY; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }
  // array{Tuple} nbrs[int][int]  
  // Visit each cell:
  for (int x=0; x<numCellsX; x++) {
    for (int y=0; y<numCellsY; y++) {
      // And visit all the neighbours of each cell
      if (rps == 1) {
        int rowind = floor(random(-1, 2));
        int colind = floor(random(-1, 2));
        int xx = x+rowind;
        int yy = y+colind;
        int xidx = 0;
        int yidx = 0;
        if ((xx==-1)&&(toroidal==1)) { 
          xidx = numCellsX-1;
        } else if ((xx==numCellsX)&&(toroidal==1)) { 
          xidx=1;
        } else { 
          xidx=xx;
        }
        if ((yy==-1)&&(toroidal==1)) { 
          yidx = numCellsY-1;
        } else if ((yy==numCellsY)&&(toroidal==1)) { 
          yidx = 1;
        } else { 
          yidx = yy;
        }
        int m = min(cellsBuffer[x][y], cellsBuffer[xidx][yidx]);
        int M = max(cellsBuffer[x][y], cellsBuffer[xidx][yidx]);
        if (M-m<=balance) {  
          cells[x][y]=M;
        } else { 
          cells[x][y]=m;
        }
      } else {
        int neighbours = 0; // We'll count the neighbours
        // for (datatype nbr : nhood(x,y)) {int xx = } 
        for (int xx=x-1; xx<=x+1; xx++) {
          for (int yy=y-1; yy<=y+1; yy++) {  
            int xidx = 0;
            int yidx = 0;
            if ((xx==-1) && (toroidal==1)) {
              xidx = numCellsX-1;
            } else if ((xx==numCellsX) && (toroidal==1)) { // only xx == -1
              xidx = 1;
            } else {
              xidx = xx;
            }
            if ((yy==-1) && (toroidal==1)) {
              yidx = numCellsY-1;
            } else if ((yy==numCellsY) && (toroidal==1)) {
              yidx = 1;
            } else {
              yidx = yy;
            }
            if (((xidx>=0)&&(xidx<numCellsX))&&((yidx>=0)&&(yidx<numCellsY))) { // Make sure you are not out of bounds
              if (!((xidx==x)&&(yidx==y))) { // Make sure to to check against self
                if (cellsBuffer[xidx][yidx]==1) {
                  neighbours ++; // Check alive neighbours and count them
                }
              } // End of if
            } // End of if
          } // End of yy loop
        } //End of xx loop
        // We've checked the neigbours: apply rules!
        if (cellsBuffer[x][y]==1) { // The cell is alive: kill it if necessary
          if (neighbours < 2 || neighbours > 3) {
            cells[x][y] = 0; // Die unless it has 2 or 3 neighbours
          }
        } else { // The cell is dead: make it live if necessary      
          if (neighbours == 3 ) {
            cells[x][y] = 1; // Only if it has 3 neighbours
          }
        } // End of if
      }
    } // End of y loop
  } // End of x loop
} // End of function

// Need to seperate out the dynamics, and neighborhood structures.


//void oscEvent(OscMessage theOscMessage) {
//   String addr = theOscMessage.addrPattern();
//   float  val  = theOscMessage.get(0).floatValue();   
//   println(addr, " - ", val);
//   if (stepping == 1) {
//   redraw();
//   }

//   if(addr.equals("/2/push13"))        {if (val==1.0){ stepping = 1; noLoop();redraw();} } // step through
//   else if(addr.equals("/2/push14"))   {if (val==1.0){ stepping = 0; loop();}}  // On/off of pause
//   else if(addr.equals("/2/push1"))   { if (val==1.0) {initialize(1); if (stepping == 1) { redraw();}}} 
//   else if(addr.equals("/2/push2"))   { if (val==1.0) {initialize(2); if (stepping == 1) { redraw();}}}
//   else if(addr.equals("/2/push3"))   { if (val==1.0) {initialize(3); if (stepping == 1) { redraw();}}}
//   else if(addr.equals("/2/push4"))   { int numCellsX = width/cellSize;int numCellsY = height/cellSize;
//    if (val==1.0) {    for (int x=0; x<numCellsX; x++) {  for (int y=0; y<numCellsY; y++) {
//        float state = random (100);
//        if (state > probabilityOfAliveAtStart) {    state = 0;  } else {  state = 1;  }
//        cells[x][y] = int(state); // Save state of each cell
//      } }}}
//   else if(addr.equals("/2/toggle1")) { gencolor(); if (stepping == 1) {redraw(); } }
//   //else if(addr.equals("/1/toggle1"))  { v_fader1 = round(val); }
//   //else if(addr.equals("/1/toggle2"))  { v_fader1 = val; }
//   //else if(addr.equals("/1/toggle3"))  { v_fader1 = val; }
//   //else if(addr.equals("/1/toggle4"))  { }
//}

// change these to midi actions.
void keyPressed() {

  int numCellsX = width/cellSize;
  int numCellsY = height/cellSize;
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells

    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        } else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (stepping == 1) {
    redraw();
  }
  if (key==' ') { // On/off of pause
    stepping = 0;
    loop();
    //pause = !pause;
  }
  if (key=='1') { // On/off of pause
    initialize(1);
    if (stepping == 1) {
      redraw();
    }
  }
  if (key == '2') {
    initialize(2);
    if (stepping == 1) {
      redraw();
    }
  }
  if (key == '3') {
    initialize(3);
    if (stepping == 1) {
      redraw();
    }
  }
  if (key == 's') {
    stepping = 1;
    noLoop();
    redraw();
  }
  if (key == 'S') {
  }
  if (key=='c' || key == 'C') { 
    //for (int x=0; x<numCellsX; x++) {
    //  for (int y=0; y<numCellsY; y++) {
    //cells[x][y] = 0; // Save all to zero
    gencolor();
    if (stepping == 1) {
      redraw();
    }
    //}
    //}
  }
  if (key == 'G') {
    rps = 1; 
    if (stepping == 1) {
      redraw();
    }
  }
  if (key == 'g') {
    rps = 0; 
    if (stepping == 1) {
      redraw();
    }
  }
}