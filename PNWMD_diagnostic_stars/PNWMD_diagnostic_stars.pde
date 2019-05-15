/* 

PNW Meditation Deathmatch note: This sketch was used to provide a passive visualizer
on the installation when it was in between competitions, and to provide wiring diagnotics.

The scraper is customized to our installation's specific LED mapping.

showLocations(true|false) in setup controls whether to draw pixel locations are drawn, but 
currently requires a connected PixelPusher in order to work correctly. When drawn, the
pixels will also have a whitening overlay. The coloured circle that follows the mouse cursor
is useful for identifying which parts of the installation map are misbehaving.

*/

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import processing.core.*;
import java.util.*;

DeviceRegistry registry;

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
        //println("Registry changed!");
        if (updatedDevice != null) {
          //println("Device change: " + updatedDevice);
        }
        this.hasStrips = true;
    }
}
//PImage im;
  
double brightness = 1.0;
TestObserver observer;
int stride = 240;

void setup() {
 size(800, 220, P2D); 
  // Load a sample image
  //im = loadImage("1.jpg");
 colorMode(HSB, 360, 100, 100, 100);
  
 registry = new DeviceRegistry();
 //testObserver = new TestObserver();
 //registry.addObserver(testObserver);
 
  observer = new TestObserver();
  registry.addObserver(observer);
  showLocations(false);  // For plotting the pixel coordinates. Note: enabling will interfere with light output 
  // if you do not black out the frame on every refresh, as in this sketch.
  brightness = 0.7; // Starting brightness adjustment
 
}

void keyPressed() {
   if (key=='d')
    brightness *= 0.9;
   if (key=='u')
    brightness *= 1.1;
   
   println("Brightness now =="+brightness); 
}

void draw() {
  
  
  // Scale the image so that it matches the width of the window
  //int imHeight = im.height * width / im.width;

  // Scroll down slowly, and wrap around
  //float speed = 0.05;
  //float y = (millis() * -speed) % imHeight;
  
  // Use two copies of the image, so it seems to repeat infinitely  
  //image(im, 0, y, width, imHeight);
  //image(im, 0, y + imHeight, width, imHeight);
  
  pushMatrix();
    fill(300,100,100);
    translate(width*0.25,height*0.5);
    rotate(sin(millis()/8000.0 * TWO_PI));
    
    star(0,0,40+10*sin(millis()/4000.0 * TWO_PI),100+80*sin(millis()/12000.0 * TWO_PI),15);
  popMatrix();
  
  pushMatrix();
    fill(180,50,100,75);
    translate(width*0.25,height*0.5);
    rotate(sin(millis()/12000.0 * TWO_PI));
    translate(sin(millis()/6000.0 * TWO_PI)*50, sin(millis()/13000.0 * TWO_PI));
    star(0,0,20+10*sin(millis()/2000.0 * TWO_PI),40+60*sin(millis()/8000.0 * TWO_PI),15);
  popMatrix();
  
  pushMatrix();
    fill(60,50,100,100 * sin(millis()/24000.0 * TWO_PI));
    translate(width*0.25,height*0.5);
    rotate(sin(millis()/18000.0 * TWO_PI));
    translate(sin(millis()/6000.0 * TWO_PI)*70, sin(millis()/13000.0 * TWO_PI)*70);
    star(0,0,10+10*sin(millis()/12000.0 * TWO_PI),30+10*sin(millis()/500.0 * TWO_PI),15);
  popMatrix();
  
  pushMatrix();
    fill(0,100,100);
    translate(width*0.75,height*0.5);
    rotate(sin(millis()/8000.0 * TWO_PI));
    
    star(0,0,40+10*sin(millis()/4000.0 * TWO_PI),100+80*sin(millis()/12000.0 * TWO_PI),15);
  popMatrix();
  
  pushMatrix();
    fill(240,50,100,75);
    translate(width*0.75,height*0.5);
    rotate(sin(millis()/12000.0 * TWO_PI));
    translate(sin(millis()/6000.0 * TWO_PI)*50, sin(millis()/13000.0 * TWO_PI));
    star(0,0,20+10*sin(millis()/2000.0 * TWO_PI),40+60*sin(millis()/8000.0 * TWO_PI),15);
  popMatrix();
  
  pushMatrix();
    fill(180,50,100,100 * sin(millis()/24000.0 * TWO_PI));
    translate(width*0.75,height*0.5);
    rotate(sin(millis()/18000.0 * TWO_PI));
    translate(sin(millis()/6000.0 * TWO_PI)*70, sin(millis()/13000.0 * TWO_PI)*70);
    star(0,0,10+10*sin(millis()/12000.0 * TWO_PI),30+10*sin(millis()/500.0 * TWO_PI),15);
  popMatrix();
  

  fill(360.0*(millis()%4000.0)/4000.0,80,10+30 * sin(millis()/27000.0 * TWO_PI), 12);
  rect(0, 0, width, height);
  fill(float(mouseX)/float(width)*360, 100, 100);
  //if (mouseX < width / 3)
  //  fill(255,0,0);
  //if (mouseX > width / 3 && mouseX < (2*(width/3)))
  //  fill(0, 255, 0);
  //if (mouseX > (2*(width/3)))
  //  fill(0,0,255);
    
    DeviceRegistry.setOverallBrightnessScale(brightness);
    
  noStroke();
  ellipse(mouseX, mouseY, 60, 60);
    
  scrape();
    
}
