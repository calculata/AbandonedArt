
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


//================================================

FractalRoot pentagon;
float _strutFactor = 0.8;
float _strutNoise;
int _maxlevels = 3;
int _numSides = 10;

Point[] _allPointArr;

void setup() {
  size(500, 300); 
  
  smooth();
  _strutNoise = random(10);
}


void draw() {
  fill(200, 20);
  noStroke();
  rect(0,0,width, height);
  
  _strutNoise += 0.01;
  _strutFactor = noise(_strutNoise) * 2;    // allow range of 0 to 2
  
  _allPointArr = new Point[0];
  pentagon = new FractalRoot(frameCount);
  
  // draw all points
  stroke(30, 20, 0, 30);
    
   for (int i = 0; i < _allPointArr.length; i++) {
    Point thisPoint = _allPointArr[i];
    for (int j = 0; j < _allPointArr.length; j++) {
      Point thatPoint = _allPointArr[j];
      if (thisPoint != thatPoint) {
        float dis = dist(thisPoint.x, thisPoint.y, thatPoint.x, thatPoint.y);
        if (dis > 5) {
          if (dis < 60) {
            strokeWeight((60/dis) * 0.1);
            line(thisPoint.x, thisPoint.y, thatPoint.x, thatPoint.y);
          }
        }
      }
    }
  } 
}  


//================================================ objects

class Point {
   float x, y;
   Point(float ex, float why) {
     x = ex; y = why;
   }
}


class FractalRoot {
  Point[] pointArr = {};
  Branch rootBranch;
  
  FractalRoot(float startAngle) {
      float centX = width/2;
      float centY = height/2;
      int count = 0;
      
      // try more points
      float angNoise = startAngle/500;
      float angle = 0;
      for (float i = 0; i<_numSides; i++) {
        angNoise += 0.01;
        angle += (noise(angNoise) * 360);
        float x = centX + (300 * cos(radians(startAngle + angle)));
        float y = centY + (300 * sin(radians(startAngle + angle)));
        pointArr = (Point[])append(pointArr, new Point(x, y));
      }
      rootBranch = new Branch(0, 0, pointArr);
  }
  
  void drawShape() {
    rootBranch.drawMe();
  }
}

class Branch {
  int level, num;
  Point[] outerPoints = {};
  Point[] midPoints = {};
  Point[] projPoints = {};
  Branch[] myBranches = {};
  
  Branch(int lev, int n, Point[] points) {
    level = lev;
    num = n;
    outerPoints = points;
    midPoints = calcMidPoints();
    projPoints = calcStrutPoints();
    
    _allPointArr = (Point[])concat(_allPointArr, outerPoints);

    
    // next generation
    if ((level+1) < _maxlevels) {
      // center pentagon
      Branch childBranch = new Branch(level+1, 0, projPoints);
      myBranches = (Branch[])append(myBranches, childBranch);
      // other pentagons
      for (int k = 0; k < outerPoints.length; k++) {
       int nextk = k-1;
       if (nextk < 0) { nextk += outerPoints.length; }
        Point[] newPoints = {  projPoints[k], midPoints[k], outerPoints[k], midPoints[nextk], projPoints[nextk] };
        childBranch = new Branch(level+1, k+1, newPoints);
        myBranches = (Branch[])append(myBranches, childBranch);
      }  
       
    }
    
  }
  
  Point[] calcMidPoints() {
    Point[] mpArray = new Point[outerPoints.length];
    for (int i = 0; i < outerPoints.length; i++) {
      int nexti = i+1;
      if (nexti == outerPoints.length) { nexti = 0; }
      Point thisMP = calcMidPoint(outerPoints[i], outerPoints[nexti]);
      mpArray[i] = thisMP;
    } 
    return mpArray;
  }
  
  Point[] calcStrutPoints() {
    Point[] strutArray = new Point[midPoints.length];
    for (int i = 0; i < midPoints.length; i++) {
      int nexti = i+3;
      if (nexti >= midPoints.length) { nexti -= midPoints.length; }
      Point thisSP = calcProjPoint(midPoints[i], outerPoints[nexti]);  
      // draw from midpoint to opposite point on outer shape
      strutArray[i] = thisSP;
    } 
    return strutArray;
  }
  
  Point calcMidPoint(Point end1, Point end2) {
    float mx, my;
    if (end1.x > end2.x) {
      mx = end2.x + ((end1.x - end2.x)/2);
    } else {
      mx = end1.x + ((end2.x - end1.x)/2);
    }
    if (end1.y > end2.y) {
      my = end2.y + ((end1.y - end2.y)/2);
    } else {
      my = end1.y + ((end2.y - end1.y)/2);
    }
    return new Point(mx, my);
  }
  
  
  Point calcProjPoint(Point mp, Point op) {
    float px, py;
    // trig triangle, get opposite and adjacent
    float adj, opp;    
    if (op.x > mp.x) { 
      opp = op.x - mp.x;
    } else {
      opp = mp.x - op.x; 
    }
    if (op.y > mp.y) {
      adj = op.y - mp.y;
    } else {
      adj = mp.y - op.y;
    }
    // project point
    if (op.x > mp.x) { 
      px = mp.x + (opp * _strutFactor);
    } else {
      px = mp.x - (opp * _strutFactor); 
    }
    if (op.y > mp.y) {
      py = mp.y + (adj * _strutFactor);
    } else {
      py = mp.y - (adj * _strutFactor);
    }  
    return new Point(px, py);  
  }

  
  void drawMe() {
    float myWeight = level * 0.3;
    strokeWeight(myWeight/2);      // stroke weight according to level
    stroke(level * 30, num * 20, 0, 50);
   // draw midpoints and their projection points
   strokeWeight(myWeight);
   fill(255, 150);   
   for (int j = 0; j < midPoints.length; j++) {
     strokeWeight(myWeight/2);
     line(midPoints[j].x, midPoints[j].y, projPoints[j].x, projPoints[j].y);
     strokeWeight(myWeight);
     ellipse(midPoints[j].x, midPoints[j].y, myWeight*15, myWeight*15);
     ellipse(projPoints[j].x, projPoints[j].y, myWeight*25, myWeight*25);
   } 
   
   // draw children
   for (int k = 0; k < myBranches.length; k++) {
     myBranches[k].drawMe();
   }
   
   
  }
  
}

