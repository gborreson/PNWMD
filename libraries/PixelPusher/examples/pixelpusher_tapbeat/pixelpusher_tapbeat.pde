
/*
 * generate a visual tempo with colour waves that scroll across the array.
 * tap the 't' key to mark time;  the sketch will follow.
 * other keys supported as an example of how to configure PixelPusher Photon,
 * and also as an example of the new PusherCommand mechanism.
 *
 * April 2014, Jas@HR
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import com.heroicrobot.dropbit.devices.pixelpusher.*;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

int stride = 288;
int beat_width=0;
boolean use_weighted_get = true;

boolean ready_to_go = true;
long period = 1000000000 / (120 / 60);
long lastbeat = 0;
color currentRow = #ffffff;

int canvasW = 288;
int canvasH =144;
float phase = 0;
TestObserver testObserver;


float SLOW_COLOR_ADJUST = 0.02;
float DISCON_CHANCE = 0.01;
//float DISCON_JUMP = 0.15;
int BEAT_WIDTH=5;

boolean launch_beat = false;

void setup() {
  size(288*2, 144, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  //background(#000000);
  // stroke(#ffffff);
  noStroke();
  rectMode(CORNER);
  background(0);
  frameRate(30);
  loadPixels();
  lastbeat = System.nanoTime();
}


void adjustPixels() {
  color adjustedRow = adjustPixel(currentRow);
  currentRow = adjustedRow;
  noStroke();
  PImage b = get();
  rectMode(CORNERS);
  imageMode(CORNERS);
  if (launch_beat) {
    fill(adjustedRow);
    rect(0,0, 10, height);
  } else {
     fill(0);
     rect(0,0, 10, height);
  }
  blend(b, 0, 0, b.width, b.height, 10, 0, width, height, BLEND);
}

color adjustPixel(color input) {   
    if (random(1) < DISCON_CHANCE)
      return color(random(255), random(255), random(255));
  
  return color(adjustColor(red(input)), adjustColor(green(input)), adjustColor(blue(input)));
}

int adjustColor(float floatInput) {
  int input = int(floatInput);
  int sign = 1 * random(1) > 0.5 ? -1 : 1;
  int adjust = int(255 * random(SLOW_COLOR_ADJUST));
  return input + (sign * adjust);
}

void draw() {
  adjustPixels();
  if (launch_beat) {
    beat_width--;
    if (beat_width == 0)
      launch_beat = false;
  }
  scrape();
  if (System.nanoTime() - lastbeat > period) {
    launch_beat=true;
    beat_width = BEAT_WIDTH;
    lastbeat = System.nanoTime();
  }
}

void stop()
{
  super.stop();
}

long lastTap = 0;

void keyPressed() {
  
      if (key == ' ') {
        launch_beat = true;
        beat_width = BEAT_WIDTH;
      }
      if (key == 'R') {
         
        List<PixelPusher> pps = registry.getPushers();
       
        PusherCommand reboot = new PusherCommand((byte) 1);
 
        for (PixelPusher pp : pps) {
           println("Rebooting "+pp.getControllerOrdinal());
           pp.sendCommand(reboot);
        }
      }
        if (key == 'C') {
         
        List<PixelPusher> pps = registry.getPushers();
       
        for (PixelPusher pp : pps) {
           println("Reconfiguring "+pp.getControllerOrdinal());
           pp.sendCommand(new PusherCommand((byte) 3, "Interweb", "whatever", "wpa2" ));
        }
      }    
      if (key == 'S') {
         
        List<PixelPusher> pps = registry.getPushers();
       
        for (PixelPusher pp : pps) {
           println("Reconfiguring "+pp.getControllerOrdinal());
           pp.sendCommand(new PusherCommand((byte) 4, 2, 288, new byte[]{3,3,2,2,2,2,2,2}, new byte[]{0,0,1,1,1,1,1,1}, (short)27, (short)2, (short)12, (short)29));
        }
      }
      if (key == 't') {  // tap a beat
        if (lastTap != 0) { // if we have a last tap time
               period = System.nanoTime() - lastTap; // calculate how long it's been and set the period
               println("Period is "+period);
        } else {
           println("First tap");  
        }
        lastTap = System.nanoTime();
      }
     
}
