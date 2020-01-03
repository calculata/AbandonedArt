
// Feb 2009 
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


//================================= global vars

float _noiseseed;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(60);
  
  restart();
}

void restart() {
  background(0);
  _noiseseed = random(10);
  println(_noiseseed);
  
  
  strokeWeight(1);
  stroke(255, 10);
  
  float yinc = 0.1;
  
  float yrangenoiseseed = random(10);
  float yrangenoise = yrangenoiseseed;
  float yrange = 500 * (noise (yrangenoise));
  
  for (float ystart = -yrange; ystart < height; ystart += yinc) {
    float thisNoise = _noiseseed;
    float lastx = -1.0;
    float lasty = -1.0;
    
    for (int x = 0; x < width; x++) {
      thisNoise += 0.01;
      float y = ystart + (noise(thisNoise) * yrange);
      if (lastx != -1.0) {
        line(lastx, lasty, x, y);
      }
      lastx = x;
      lasty = y; 
    }
    
    yrangenoise += 0.0003;
    yrange = 500 * (noise (yrangenoise));
  }
  
  
  for (float ystart = -yrange; ystart < height; ystart += yinc) {
    float thisNoise = _noiseseed;
    float lastx = -1.0;
    float lasty = -1.0;
    
    for (int x = 0; x < width; x++) {
      thisNoise += 0.01;
      float y = ystart + (noise(thisNoise) * yrange);
      if (lastx != -1.0) {
        line(lasty, lastx, y, x);
      }
      lastx = x;
      lasty = y; 
    }
    
    yrangenoise += 0.0003;
    yrange = 500 * (noise (yrangenoise));
  }
  
}

void clearBackground() {
  background(255);
}

//================================= frame loop

void draw() {
}


//================================= interaction

void mousePressed() { 
  restart();
}
