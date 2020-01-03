
// Jan 2010 
// http://www.abandonedart.org
// http://www.zenbullets.com
//
// This work is licensed under a Creative Commons 3.0 License.
// (Attribution - NonCommerical - ShareAlike)
// http://creativecommons.org/licenses/by-nc-sa/3.0/
// 
// This basically means, you are free to use it as long as you:
// 1. give http://www.zenbullets.com a credit
// 2. don't use it for commercial gain
// 3. share anything you create with it in the same way I have
//
// These conditions can be waived if you want to do something groovy with it 
// though, so feel free to email me via http://www.zenbullets.com


Cell[][] _cellArray;     // two dimensional array of cells
int _cellSize = 3;      // size of each cell
int _numX, _numY;        // dimensions of grid

void setup() { 
  size(500, 300);
  smooth();
  _numX = floor(width/_cellSize);
  _numY = floor(height/_cellSize);
  restart();
} 

void restart() {
  // create a grid of cells
  _cellArray = new Cell[_numX][_numY];
  for (int x = 0; x<_numX; x++) {
    for (int y = 0; y<_numY; y++) {
      Cell newCell = new Cell(x, y);          // create a cell at this x,y
      _cellArray[x][y] = newCell;             // add it to the array
    }
  }
  // once all created do a second pass to tell each object it's neighbours
  for (int x = 0; x < _numX; x++) {
    for (int y = 0; y < _numY; y++) {
      // positions to the sides of this cell
      int above = y-1;
      int below = y+1;
      int left = x-1;
      int right = x+1;
      // wrap positions if on the edge
      if (above < 0) { above = _numY-1; }
      if (below == _numY) { below = 0; }
      if (left < 0) { left = _numX-1; }
      if (right == _numX) { right = 0; }
      // pass array references to cells is 8 surrounding positions
      // going anticlockwise
     _cellArray[x][y].addNeighbour(_cellArray[left][above]);
     _cellArray[x][y].addNeighbour(_cellArray[left][y]);
     _cellArray[x][y].addNeighbour(_cellArray[left][below]);
     _cellArray[x][y].addNeighbour(_cellArray[x][below]);
     _cellArray[x][y].addNeighbour(_cellArray[right][below]);
     _cellArray[x][y].addNeighbour(_cellArray[right][y]);
     _cellArray[x][y].addNeighbour(_cellArray[right][above]);
     _cellArray[x][y].addNeighbour(_cellArray[x][above]);
    }
  }
}

void draw() {
  noStroke();
  fill(255, 5);
  rect(0,0,width,height);
  
  // calculate the next state of each cell before we draw it
  for (int x = 0; x < _numX; x++) {
    for (int y = 0; y < _numY; y++) {
     _cellArray[x][y].calcNextState();
    }
  }
  // draw all the cells in the array
  translate(_cellSize/2, _cellSize/2);  // offset slightly
  for (int x = 0; x < _numX; x++) {
    for (int y = 0; y < _numY; y++) {
     _cellArray[x][y].drawMe();
    }
  }
}

void mousePressed() {
  restart();
}

//================================= object

class Cell {
  float x, y;
  boolean state;  // on or off
  boolean nextState;  
  Cell[] neighbours;
  int life;
  int liveNs;
  
  Cell(float ex, float why) {
    x = ex * _cellSize;
    y = why * _cellSize;
    // randomise initial state
    if (random(2) > 1) {
      nextState = true;
    } else {
      nextState = false; 
    }
    state = nextState;
    life = 1;
    liveNs = 0;
    neighbours = new Cell[0];
  }
  
  void addNeighbour(Cell cell) {
    neighbours = (Cell[])append(neighbours, cell); 
  }
  
  void calcNextState() {
     // count number of neighbours alive
     int liveCount = 0;
     for (int i=0; i < neighbours.length; i++) {
       if (neighbours[i].state == true) {
         liveCount++;
       }
     }
     liveNs = liveCount;
     // apply GOL rules
     if (state == true) {
        if ((liveCount == 2) || (liveCount == 3)) {
          life++;
          nextState = true;
        } else {
          nextState = false;
        }
     } else {
        if (liveCount == 3) {
          life = 1;
          nextState = true;
        } else {
          nextState = false;
        }
     }
  }
  
  void drawMe() {
    state = nextState;
    if (state == true) {
      strokeWeight(0.5);
      stroke(255, 100/life, liveNs*20, 30);
      fill(5*life, 150);
      pushMatrix();
      translate(x,y);
      rotate(radians(life) * 25);
      beginShape();
      vertex(0,0);
      vertex(0,_cellSize*life);
      vertex(liveNs*10, 0);
      vertex(0, 0);
      endShape();
      popMatrix();
    }
  }
  
}
