
// August 2010
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
//
// After Jack Kirby


Particle[] pArr;
color bgCol, bgCol2;
PImage bg;

void setup() {
  size(500, 300);
  bg = loadImage("orion2.jpg");
  smooth();
  noStroke();
  pArr = new Particle[150];
  for (int x = 0; x< pArr.length; x++) {
    pArr[x] = new Particle();
  }
  bgCol = color(254, 242, 0);
  bgCol2 = color(219, 32, 49);
}

void draw() {
  image(bg, 0, 0);
  for (int x = 0; x< pArr.length; x++) {
    pArr[x].updateMe();
    pArr[x].drawMe1();
  }
  for (int x = 0; x< pArr.length; x++) {
    pArr[x].drawMe2();
  }
  for (int x = 0; x< pArr.length; x++) {
    pArr[x].drawMe3();
  }
}

class Particle {
  float x, y;
  float yspeed, startx;
  float innerW, midW, outerW;
  float xnoise;
  
  Particle() {
    float factor = (pow(random(1), 3) * 150) - 25;
    startx = factor;
    if (random(2) > 1) { startx = width-startx; }
    y = height + 50;
    yspeed = 1 + random(3);
    innerW = 5+ random((150-factor)/6);
    outerW = 30+ random((150-factor)/4);
    midW = innerW + random(outerW - innerW);
    xnoise = random(10);
  }
  
  void updateMe() {
    y -= yspeed;
    xnoise += 0.005;
    if (startx < width/2) {
     x = startx + (noise(xnoise) * 100);
    } else {
     x = startx - (noise(xnoise) * 100);
    }
    if (y < -50) { y = height + 50; }
  }
  
  void drawMe1() {
    fill(bgCol);
    ellipse(x, y, outerW, outerW);
  }
  
  void drawMe2() {
    fill(bgCol2);
    ellipse(x, y, midW, midW);
  }
  
  void drawMe3() {
    fill(0);
    ellipse(x, y, innerW, innerW);
  }
}
