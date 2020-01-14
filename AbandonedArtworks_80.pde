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



int _numChildren = 4;     // how many children to each branch
int _maxLevels = 4;        // the maximum depth

Branch _trunk;   

// ======================= init

void setup() {
  size(500,300);
  background(255);
  noFill();
  smooth();
  newTree();
}

void newTree() {
  _trunk = new Branch(1, width/2, height/2);
  _trunk.drawMe();
}

// ======================= frame loop

void draw() {
  background(255);
  _trunk.updateMe(width/2, height/2);
  _trunk.drawMe();
}  

// ======================= Branch object

class Branch {
  float level;    // it's really an int, but make it a float for calculation
  float x, y;
  float endx, endy;
  float strokeW, alph, rad, radChange;
  // rotation
  float rot, rotChange;
  
  // array of children
  Branch [] children = new Branch[0];
  
  Branch(float lev, float ex, float why) {
   level = lev; 
   rad = (1/level) * random(500);
   rot = random(360);
   rotChange = random(10) - 5;
   radChange = random(10) - 5;
   updateMe(ex, why);
   
   strokeW = (1/level) * 100;
   alph = 255 / level;
   
   // make children
   if (level <= _maxLevels) {
     children = new Branch[_numChildren];
     for (int x=0; x<_numChildren; x++) {
       children[x] = new Branch(level+1, endx, endy);
     }
   }
  }
  
  void updateMe(float ex, float why) {
   x = ex;
   y = why;
   rot += rotChange;
   if (rot > 360) { rot = 0; }
   else if (rot < 0) { rot = 360; }
   
   rad -= radChange;
   if (rad < 0) { radChange *= -1; }
   else if (rad > 500) { radChange *= -1; }
   
   float radian = radians(rot);
   endx = x + (rad * cos(radian));
   endy = y + (rad * sin(radian));
   
   // trickle it down
     for (int i=0; i<children.length; i++) {
       children[i].updateMe(endx, endy);
     }
  }
  
  void drawMe() {
    
    // draw my children first
     for (int i=0; i<children.length; i++) {
       children[i].drawMe();
     }
     
    if (level > 1) {
      strokeWeight(strokeW);
      stroke(0, alph);
      line(x, y, endx, endy);
        fill(255);
        ellipse(endx, endy, rad/12, rad/12);
    }
  }
  
}

// ======================= interaction

void mouseReleased() {
  newTree();
}
