
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

int _num = 20;    
Circle[] pArr = new Circle[_num];

//================================= init

void setup() {
  size(500, 300);
  smooth(); 
  frameRate(30);
  
  clearBackground();
  
  for (int i=0;i<_num;i++) {
    pArr[i] = new Circle(i);
    pArr[i].init(width/2, height/2, random(height/2));
  }
}

void clearBackground() {
  background(255);
}

//================================= frame loop

void draw() {
  
  for (int i=0;i<_num;i++) {
    pArr[i].update();
  }
}



//================================= interaction

void mousePressed() { 
  clearBackground();
  for (int i=0;i<_num;i++) {
    pArr[i].init(mouseX, mouseY, random(height/2));
  }
}


//================================= objects


class Circle {
  int id;
  float angnoise, radiusnoise;
  float widnoise, heinoise;
  float angle = 180;
  float radius = 100;
  float centreX = width/2;
  float centreY = height/2;
  float strokeCol = 254;
  float lastX = 9999;
  float lastY;
  
  Circle (int num) {
    id = num;
  }
  
  void init(float ex, float why, float r) {
    centreX = ex;
    centreY = why;
    radius = r;
  
    angnoise = random(10);
    radiusnoise = random(10);
    widnoise = random(10);
    heinoise = random(10);
    strokeCol = 254;
  }
  
  void update() {
    radiusnoise += 0.005;
    radius = (noise(radiusnoise) * 250) + 1;
  
    angnoise += 0.005;
    float change = (noise(angnoise) * 6) - 3;
    angle += change;
    if (angle > 360) { angle -= 360; }
    if (angle < 0) { angle += 360; }
    
    widnoise += 0.05;
    heinoise += 0.05;
    float wid = (noise(widnoise) * 10) +5;
    float hei = (noise(heinoise) * 10) +5;
  
    float rad = radians(angle);
    
    float x1 = centreX + (radius * cos(rad));
    float y1 = centreY + (radius * sin(rad));
    
    if (strokeCol > 0) { strokeCol -=2; } // fade in
    
    float alph = 0;
    if (lastX != 9999) {
      float distChange = dist(x1, y1, lastX, lastY);
      alph = 60 - (20 * distChange);
      println(distChange);
      if (alph < 0) { alph = 0; }
    }
    stroke(strokeCol, alph);
    fill(255,alph);
    ellipse(x1, y1, wid, hei);
    
    lastX = x1;
    lastY = y1;
  }
  
}
