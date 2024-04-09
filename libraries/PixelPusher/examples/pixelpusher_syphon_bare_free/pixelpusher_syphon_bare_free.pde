// pixelpusher syphon sketch with quadrilateral mapping
// jas strong, 28th feb 2014.

import codeanticode.syphon.*;

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

SyphonClient client;
PGraphics canvas;

boolean ready_to_go = true;
int lastPosition;
int canvasW = 640;
int canvasH = 480;
TestObserver testObserver;

// Positions of the four corners of the sampled area are set in setup()
// It ends up looking something like this:
/*
 *       (ax,ay)------------------------(bx,by)
 *              -----------------------
 *              ----------------------
 *              ---------------------
 *       (dx,dy)--------------------(cx,cy)
 */
float ax, bx, cx, dx;
float ay, by, cy, dy;



class Line {
 public float startx, starty;
 public float endx, endy;    // this is the line
 public float length;        // this is how long it is
 public float intervals;     // number of samples along the line
 public float incx, incy;
 private float changex, changey;

 Line(float startx, float starty, float endx, float endy, float intervals) {
    this.startx = startx;
    this.starty = starty;
    this.endx = endx;
    this.endy = endy; 
    this.intervals = intervals;
    this.compute();
 }

 void compute() {
    // given start, intervals and end, compute length, gradient and increments
   changex = (endx-startx);
   changey = (endy-starty);  // the line is the hypotenuse of this RA triangle.
   length = (float)Math.sqrt((Math.pow(changex, 2)) + (Math.pow(changey, 2))); // by pythag.
   incx = changex / intervals;
   incy = changey / intervals; 
   
  // println("Change in x = "+changex+" length = "+length+" incx = "+incx);
  // println("Change in y = "+changey+" length = "+length+" incy = "+incx);
 }
}


void setup() {
  size(canvasW, canvasH, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  background(0);
  client = new SyphonClient(this, "Modul8", "Main View");
  
  // set up the corners of the area to sample.
  
  ax = 30;
  ay = 30;

  bx = 600;
  by = 40;

  cx = 500;
  cy = 400;

  dx = 60;
  dy = 300; 
  
}




void draw() {
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }  
  scrape();
}

void stop()
{
  super.stop();
}

