/*
 *  Tool for testing the luminance curve of LEDs.  Press a key to step on to the next luminance level.
 *
 *  jasmine@heroicrobotics.com
 */
 

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

int stride = 110;

boolean ready_to_go = true;

TestObserver testObserver;
int step;
boolean pressed;


void setup() {
  size(240*3, 480, P3D);  // this has to go first or setup() gets called twice.
  frameRate(30);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(false);
  registry.setAutoThrottle(true);
  pressed = false;

  background(0);
  colorMode(HSB, 256);
  noStroke();
  rectMode(CORNERS);
  step = 0;
  fill(0);
}

void keyPressed() {
   pressed = true; 
}

void draw() {
  
  if (pressed) {
    fill(step++);
    pressed = false;
  }
  println("Step at =="+step);
  if (step > 255)
    step=0;
  rect(0,0, 50, 50);
  scrape();
}

