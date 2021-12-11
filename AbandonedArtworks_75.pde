// Apr 2010
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


float xstart, xnoise, ystart, ynoise;

void setup() {
  size(500, 300, P3D);
  background(0);
  
  xstart = random(10);
  ystart = random(10);
}

void draw () {
  background(0);	

  xstart += 0.01;  	 
  ystart += 0.01;	
  xnoise = xstart;
  ynoise = ystart;
  
  translate(250, 150, 0);
  rotateZ(frameCount * 0.004);
  
  for (int y = -100; y <= 100; y+=5) {
    ynoise += 0.1;
    xnoise = xstart;
    for (int x = -100; x <= 100; x+=5) {
      xnoise += 0.1;
      drawPoint(x, y, noise(xnoise, ynoise));
    }
  } 
}

void drawPoint(float x, float y, float noiseFactor) {
  pushMatrix();
  translate(x * noiseFactor * 4, y * noiseFactor * 4, -y);
  stroke(255, 50);
  float edgeSize = noiseFactor * 5;
  ellipse(0, 0, edgeSize, edgeSize);
  popMatrix();
}
