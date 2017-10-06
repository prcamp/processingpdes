void initializeCA(int n) {
  int numCellsX = width/spcng;
  int numCellsY = height/spcng;
  
  if (rps==1) {
  switch(n) {
  case 1: //rps
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
        cells[x][y] = floor((x/(numCellsX+.001))*numspecies);//floor((x/numCellsX-0.01)*numspecies);//state; // Save state of each cell
      }}
      break;
  case 2://rps
    for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
        cells[x][y] = floor((y/(numCellsY+.001))*numspecies);//state; // Save state of each cell
      }}
      break;
  case 3://rps
    for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
        cells[x][y] = floor((x*y/(numCellsX*numCellsY+0.0001))*numspecies);//state; // Save state of each cell
      }}
      break;
  }  
  } else {
  switch(n) {
  case 1:
      for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
       //float state = random (100);
           int state = 0;
        if (x == floor(width/(2*spcng))+1) {//state > probabilityOfAliveAtStart) { 
          state = 1;
        } else {
          state = 0;
        }
        cells[x][y] = state; // Save state of each cell
      }}
      break;
  case 2:
    for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
       //float state = random (100);
           int state = 0;
        if (y == floor(height/(2*spcng))+1) {//state > probabilityOfAliveAtStart) { 
          state = 1;
        } else {
          state = 0;
        }
        cells[x][y] = state; // Save state of each cell
      }}
      break;
  case 3:
    for (int x=0; x<numCellsX; x++) {
        for (int y=0; y<numCellsY; y++) {
       //float state = random (100);
           int state = 0;
        if ((y == floor(height/(2*spcng))+1) || (x==floor(width/(2*spcng))+1) ) {//state > probabilityOfAliveAtStart) { 
          state = 1;
        } else {
          state = 0;
        }
        cells[x][y] = state; // Save state of each cell
      }}
      break;
  }
    }
}

void cellular_automata() {
  canvas.beginDraw();
  canvas.stroke(0,0);
   
   int numCellsX = width/spcng;
   int numCellsY = height/spcng;
    //Draw grid
  //if (rps == 1) {
    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
      canvas.fill(colarray[cells[x][y]]);
      canvas.rect(x*spcng,y*spcng,spcng,spcng);
      }}
  //} else {
  
  //for (int x=0; x<numCellsX; x++) {
  //  for (int y=0; y<numCellsY; y++) {
  //    if (cells[x][y]==1) {
  //      fill(alive); // If alive
  //    }
  //    else {
  //      fill(dead); // If dead
  //    }
      //rect (x*spcng, y*spcng, spcng, spcng);
//    }
 //}
  // Iterate if timer ticks
  //int now = millis();
  //if (now-lastRecordedTime>interval) {
   if (!pause) {
      iterationCA();
   //   lastRecordedTime = millis();
    }
  //}
   if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
   }
   delay(0);
   canvas.endDraw();
}

void iterationCA() { // When the clock ticks
  int numCellsX = width/spcng;
  int numCellsY = height/spcng;
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
        int rowind = floor(random(-1,2));
        int colind = floor(random(-1,2));
        int xx = x+rowind;
        int yy = y+colind;
        int xidx = 0;
        int yidx = 0;
        if ((xx==-1)&&(toroidal==1)) { xidx = numCellsX-1;
        } else if ((xx==numCellsX)&&(toroidal==1)) { xidx=1;
        } else { xidx=xx;
        }
        if ((yy==-1)&&(toroidal==1)) { yidx = numCellsY-1;
        } else if ((yy==numCellsY)&&(toroidal==1)) { yidx = 1;
        } else { yidx = yy;
        }
        int m = min(cellsBuffer[x][y],cellsBuffer[xidx][yidx]);
        int M = max(cellsBuffer[x][y],cellsBuffer[xidx][yidx]);
        if (M-m<=balance) {  cells[x][y]=M;
        } else { cells[x][y]=m;
        }
        
      } else {
      int neighbours = 0; // We'll count the neighbours
      // for (datatype nbr : nhood(x,y)) {int xx = } 
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
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
          } else if((yy==numCellsY) && (toroidal==1)){
            yidx = 1;
          } else {
            yidx = yy;
          }
          if (((xidx>=0)&&(xidx<numCellsX))&&((yidx>=0)&&(yidx<numCellsY))) { // Make sure you are not out of bounds
            if (!((xidx==x)&&(yidx==y))) { // Make sure to to check against self
              if (cellsBuffer[xidx][yidx]==1){
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
      } 
      else { // The cell is dead: make it live if necessary      
        if (neighbours == 3 ) {
          cells[x][y] = 1; // Only if it has 3 neighbours
        }
      } // End of if
      }
    } // End of y loop
  } // End of x loop
} // End of function

void keyPressed() {
  int numCellsX = width/spcng;
  int numCellsY = height/spcng;
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    if (rps==1) {for (int x=0;x<numCellsX;x++){for (int y=0; y<numCellsY; y++) { 
    int species=floor(random(0,numspecies));
    cells[x][y]=species;
    }}} else {
    
    for (int x=0; x<numCellsX; x++) {
      for (int y=0; y<numCellsY; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        }
        else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  }
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  if (key=='1') { // On/off of pause
    initializeCA(1);
  }
  if (key == '2') {
    initializeCA(2);
  }
  if (key == '3') {
    initializeCA(3);
  }
  if (key=='c' || key == 'C') { // Clear all
    gencolor();
    //for (int x=0; x<numCellsX; x++) {
    //  for (int y=0; y<numCellsY; y++) {
    //    cells[x][y] = 0; // Save all to zero
    //  }
    //}
  }
}