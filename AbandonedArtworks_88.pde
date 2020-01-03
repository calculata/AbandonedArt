
// Dec 2008 
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


//================================= colour sampling

int numcols = 600; // 30x20
color[] sampleColour(String filename) {
  color[] colArr = new color[numcols];
  PImage img;
  img = loadImage(filename);
  image(img,0,0);
  int count = 0;
  for (int x=0; x < img.width; x++){
    for (int y=0; y < img.height; y++) {
      if (count < numcols) {
        color c = get(x,y);
        colArr[count] = c;
      }
      count++;
    }
  }  
  return colArr;
}




//================================= global vars

color[] _col1Arr;
color[] _col2Arr;

float _factor1 = 40;    // 1 too 100, num particles
float _factor2 = 50;    // 1 too 100, trail length (odds)
float _factor3 = 1;     // 1 too 10, thickness (odds)
float _factor4 = 50;    // 1 too 100, trail length (evens)
float _factor5 = 1;     // 1 too 10, thickness (evens)
float _factor6 = 50;    // 1 too 100

float _noise1, _noise2, _noise3, _noise4, _noise5, _noise6; 
float _xnoise, _ynoise;

Particle[] _pArr = {};

float _midx, _midy, _maxrad;

  
//================================= init

void setup() {
  size(500, 300, P3D);
  smooth(); 
  
  _midx = (width / 2) - 40;
  _midy = height / 2;
  _maxrad = 800;
  
  _col1Arr = sampleColour("tricolpalette.jpg");
  _col2Arr = sampleColour("moody.jpg");
  
  _noise1 = random(10);
  _noise2 = random(10);
  _noise3 = random(10);
  _noise4 = random(10);
  _noise5 = random(10);
  _noise6 = random(10);
  _xnoise = random(10);
  _ynoise = random(10);
  
  // initControls();
  updateFromSliders();
  
  restart();
}

void restart() {
  clearBackground();
 
  for (int i=0;i<_factor1;i++) {
    float spin = random(30) + 5;
    float rad = random(_maxrad-40) + 40;
    addPoint(i, spin, rad);
  }
}

void addPoint(int id, float spin, float rad) {
    Particle hp = new Particle(id, spin, rad);
    _pArr = (Particle[])append(_pArr, hp);
}

void clearBackground() {
  background(0);
}

//================================= frame loop

void draw() {
  clearBackground();
  
  pushMatrix();
  translate(width / 2, height / 2, -width);
  
  _xnoise += 0.01;
  _ynoise += 0.01;
  float xpos = noise(_xnoise) * width;
  float ypos = noise(_ynoise) * height;
  
  rotateY(map(xpos, 0, width, -PI, PI));
  rotateX(map(ypos, 0, height, -PI, PI));
  
  for (int i=0;i<_pArr.length;i++) {
    _pArr[i].update();
  }
  
  
  popMatrix();
}

void updateFromSliders() {
  _noise2 += 0.01;
  _factor2 = noise(_noise2) * 100;
  _noise3 += 0.01;
  _factor3 = noise(_noise3) * 40;
  _noise4 += 0.01;
  _factor4 = noise(_noise4) * 100;
  _noise5 += 0.01;
  _factor5 = noise(_noise5) * 40;
  _noise6 += 0.01;
  _factor6 = noise(_noise6) * 100;
  
}



//================================= objects


class HPoint {
  float x, y;
  HPoint(float ex, float why) {
    x = ex; y = why;
  }
}


class Particle {
  int id;
  float angle;
  float spin, rad;
  color ribbonColour;
  
  HPoint[] trailArr = {}; 
  
  Particle (int num, float myspin, float myrad) {
    id = num;
    angle = random(360);
    if (id%2 == 0) {
      ribbonColour = _col1Arr[int(random(numcols))];
    } else {
      ribbonColour = _col2Arr[int(random(numcols))];
    }
    setParams(myspin, myrad);
  }
  
  void setParams(float myspin, float myrad) {
    spin = myspin;
    rad = myrad;
  }
  
  void update() {
    float nextangle = angle + spin;
    while (angle <= nextangle) {
      HPoint hp = rotateMe(angle);
      addPointToTrail(hp);
      angle++;
    }
    
    if (nextangle > 360) { nextangle -= 360; }
    angle = nextangle;
    
    drawMe();
  }
  
  void addPointToTrail(HPoint hp) { 
    
    trailArr = (HPoint[])append(trailArr, hp);
    float limitNum = _factor2;
    if (id%2 == 0) { limitNum = _factor4; }
    if (trailArr.length > limitNum) {
      trailArr = (HPoint[])subset(trailArr, 1); 
    }
    // do it twice in case length has been reduced by slider control
    if (trailArr.length > limitNum) {
      trailArr = (HPoint[])subset(trailArr, 1); 
    }
  }
  
  HPoint rotateMe(float a) {
    float anglerad = radians(a);
    float x = _midx + (rad * cos(anglerad));
    float y = _midy + (rad * sin(anglerad));
    return new HPoint(x, y);
  }
  
  void drawMe() {
    stroke(ribbonColour, 200);
    strokeWeight(_factor3);
    if (id%2 == 0) { strokeWeight(_factor5); }
    HPoint lp = null;
    for (int i=0;i<trailArr.length;i++) {
      HPoint p = trailArr[i];
      if (lp != null) {
        line(p.x, p.y, lp.x, lp.y);
      }
      lp = p;
    }
  }
  
}
