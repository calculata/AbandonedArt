
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
// Dedicated to Adam and Joe: 
// http://www.youtube.com/watch?v=S2y0WebFULM


float xstart, ystart, xnoise, ynoise;
PImage bg;

void setup() {
  size(500, 300, P3D);
  bg = loadImage("wall.jpg");
  noStroke();
  xstart = random(10);
  ystart = random(10);
}

void draw() {
  xstart += 0.05;
  ystart += 0.05;
  background(150);
  image(bg, 0, 0);
  float ynoise = ystart;
  translate(250, 180, 0);
  for (float y = -40; y <= 40; y+=2) {
    ynoise += 0.01;
    float xnoise = xstart;
    for (float x = -40; x <= 40; x+=2) {
      xnoise += 0.01;
      drawPoint(x, y, noise(xnoise, ynoise));
    }
  } 
}

void drawPoint(float x, float y, float noiseFactor) {
  pushMatrix();
  translate(x * noiseFactor * 4, y * noiseFactor * 4, 5);
  float edgeSize = noiseFactor * 20;
  fill(255, 120);
  if ((y > 0) && (y < 30)) {
    if ( ((x> 10) && (x<18)) || ((x< -10) && (x>-18)) || ((x> -4) && (x< 4)) || ((x> 24) && (x<32)) || ((x< -24) && (x>-32))  ) {
      fill(0, 0, 255, 120);
    }
  }
  ellipse(0, 0, edgeSize, edgeSize);
  popMatrix();
}

