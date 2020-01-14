
// Oct 2008
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

int xshift = 25;
int yshift = 15;
int num = 16;
Particle[] pArr = new Particle[num];
float spaceNoise;

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(2);
  
  clearBackground();
  spaceNoise = random(10);
  
  for (int i=0;i<num;i++) {
    pArr[i] = new Particle(i);
  }
}

void clearBackground() {
  background(255); 
}

//================================= frame loop

int i = 0;

void draw() {
  
  pixelShift(0, yshift, 0.9);
  
  fill(255,60);
  noStroke();
  rect(0,0,width, height);
  
  float xpos = -random(50) - 25;
  for (int i=0;i<num;i++) {
    spaceNoise += 0.01;
    xpos += (noise(spaceNoise) * 30) + 30;
    pArr[i].init(xpos);
  }
}

void pixelShift(int xshift, int yshift, float scal) {
  // copy screen into an array
  color transArr[] = new color[width * height];
  
  loadPixels();
  arraycopy(pixels, transArr);
  
   for (int y=1; y < height; y++) {
      for (int x=1; x < width; x++){
        
        if ((x+xshift < width) && (x+xshift > 0)) {
          if ((y+yshift < height) && (y+yshift > 0)) {
            pixels[x + (y*width)] = transArr[(x+xshift)+ ((y+yshift)*width)];
          }
        }
        
      }
    }
  updatePixels();
  
}


//================================= interaction

void mousePressed() { 
  clearBackground();
}


//================================= objects


class Particle {
  int id;
  
  int facewidth, faceheight;
  int eyerad, pupilrad;
  int eyey, mouthy;
  int greenness;
  
  Particle (int num) {
    id = num;
  }
  
  void init(float xpos) {
    facewidth = int(random(30)) + 20;
    faceheight = int(random(50)) + 20;
    eyerad = int(random(10)) + 5;
    pupilrad = int(random(eyerad-5)) + 3;
    eyey = int(random(faceheight/3)) + eyerad;
    mouthy = int(random((faceheight-eyerad)/2));
    greenness = int(random(150)) + 50;
    
    drawMe(xpos);
  }
  
  void drawMe(float xpos) {
    pushMatrix();
    translate(xpos, 230);
    strokeWeight(2);
    stroke(0);
    fill(0, greenness, 0);
    ellipse(0, 0, facewidth, faceheight);
    strokeWeight(1);
    fill(255);
    ellipse(-10, -eyey, eyerad, eyerad);
    ellipse(10, -eyey, eyerad, eyerad);
    float mouthrad = (facewidth/2) - (mouthy / ((faceheight/facewidth) + 1));
    line(-mouthrad, mouthy, mouthrad, mouthy);
    fill(0);
    ellipse(-10, -eyey, pupilrad, pupilrad);
    ellipse(10, -eyey, pupilrad, pupilrad);
    popMatrix();
  }
  
}
