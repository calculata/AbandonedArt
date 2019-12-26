// July 2009
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

int _num = 1500;        
int _numSpheres = 20;    
int _threshold; 
float _maxRad, _maxNoise;

HPoint[] _pointArr = {};
Sphere[] _sphereArr = {};

//================================= init

void setup() {
  size(500, 300, P3D);
  smooth(); 
  _maxNoise = random(1);
  
  restart();
}

void restart() {
   background(255);
   newSpheres();
   newPoints();
}

void clearBackground() {
  background(255);
}

void newSpheres() {
  _sphereArr = (Sphere[])expand(_sphereArr, 0); 
  for (int x = 0; x <= _numSpheres; x++) {
    Sphere thisSphere = new Sphere();
    _sphereArr = (Sphere[])append(_sphereArr, thisSphere);
  }
}

void newPoints() {
 _pointArr = (HPoint[])expand(_pointArr, 0); 
  for (int x = 0; x <= _num; x++) {
    HPoint thisPoint = new HPoint(random(360), random(360));
    _pointArr = (HPoint[])append(_pointArr, thisPoint);
  }
}

//================================= interaction

void mousePressed() { 
  restart();
}

//================================= frame loop

void draw() {
  clearBackground();
  
  // update
  _maxNoise += 0.01;
  _maxRad = noise(_maxNoise) * 200; 
  _threshold = int(_maxRad / 3);
  for (int s = 0; s < _sphereArr.length; s++) {
    Sphere thisS = _sphereArr[s];
    thisS.update();
  }
  for (int x = 0; x < _pointArr.length; x++) {
    HPoint thisHP = _pointArr[x];
    thisHP.update();
  }
  
  // draw
  pushMatrix();
  translate(width/2, height/2, 0);
  rotateY(frameCount * 0.01);
  for (int y = 0; y < _pointArr.length; y++) {
    HPoint fromHP = _pointArr[y];
    stroke(fromHP.col, 150);
    noFill();
    for (int z = 0; z < _pointArr.length; z++) {
      HPoint toHP = _pointArr[z];
      float diff = dist(fromHP.x, fromHP.y, fromHP.z, toHP.x, toHP.y, toHP.z);
      if (diff < _threshold) {
        line(fromHP.x, fromHP.y, fromHP.z, toHP.x, toHP.y, toHP.z);
      }
    }
  }
  popMatrix();
}

//================================= objects

class Sphere {
  float radius, radNoise;
  
  Sphere() {
     radNoise = random(10);  
  }
  
  void update() {
    radNoise += 0.01;
    radius = 100 + (noise(radNoise) * _maxRad); 
  }
  
}

class HPoint {
  float s, t;
  float x, y, z;
  int mySphere;
  color col;
  
  HPoint(float es, float tee) {
    s = es; t = tee;
    col = color(255 - (10*mySphere), 160, (10*mySphere), 100);
    mySphere = int(random(_numSpheres));
  }
  
  void update() {
    Sphere myS = _sphereArr[mySphere];
    x = myS.radius * cos(s) * sin(t);
    y = myS.radius * sin(s) * sin(t);
    z = myS.radius * cos(t);
  } 
}
