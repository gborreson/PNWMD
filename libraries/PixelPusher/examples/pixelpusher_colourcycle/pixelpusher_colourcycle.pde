/*
 * Generate a colour cycle on a PixelPusher array.
 * Won't do anything until a PixelPusher is detected.
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import com.heroicrobot.dropbit.devices.pixelpusher.PixelPusher;
import com.heroicrobot.dropbit.devices.pixelpusher.PusherCommand;


import java.util.*;

private Random random = new Random();

DeviceRegistry registry;

int[][] colors = {
  {
    127, 0, 0
  }
  , 
  {
    0, 127, 0
  }
  , 
  {
    0, 0, 127
  }
};

void spamCommand(PixelPusher p, PusherCommand pc) {
   for (int i=0; i<3; i++) {
    p.sendCommand(pc);
  }
}

public Pixel generateRandomPixel() {
  //return new Pixel((byte)(random.nextInt(scaling)),(byte)(random.nextInt(scaling)),(byte)(random.nextInt(scaling)));
  //return new Pixel((byte)(15), (byte)0, (byte)0);
  int[] colour = colors[random.nextInt(colors.length)];
  return new Pixel((byte)colour[0], (byte)colour[1], (byte)colour[2]);
}

class TestObserver implements Observer {
  public boolean hasStrips = false;
  public void update(Observable registry, Object updatedDevice) {
    println("Registry changed!");
    if (updatedDevice != null) {
      println("Device change: " + updatedDevice);
    }
    this.hasStrips = true;
  }
}

TestObserver testObserver;
int c = 0;

void setup() {
  size(640, 640, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  colorMode(HSB, 100);
  frameRate(60);
  prepareExitHandler();
}

void mousePressed() {
  List<PixelPusher> pushers = registry.getPushers();
  println(mouseY);
    for (PixelPusher p: pushers) {
       PusherCommand pc = new PusherCommand(PusherCommand.GLOBALBRIGHTNESS_SET, (short)((65536.0 * mouseY) / height));
       spamCommand(p,  pc);
    }
 
}

void draw() {
  int x=0;
  int y=0;
  if (testObserver.hasStrips) {   
    registry.startPushing();
    registry.setExtraDelay(0);
    registry.setAutoThrottle(true);
    registry.setAntiLog(true);    
    int stripy = 0;
    List<Strip> strips = registry.getStrips();
    
    if (++c > 99)
      c = 0;
    int numStrips = strips.size();
    //println("Strips total = "+numStrips);
    if (numStrips == 0)
      return;
    for (int stripNo = 0; stripNo < numStrips; stripNo++) {
      fill(c+(stripNo*2), 100, 100);
      rect(0, stripNo * (height/numStrips), width/2, (stripNo+1) * (height/numStrips)); 
      fill(c+((numStrips - stripNo)*2), 100, 100);
      rect(width/2, stripNo * (height/numStrips), width, (stripNo+1) * (height/numStrips));
    }    


    int yscale = height / strips.size();
    for (Strip strip : strips) {
      int xscale = width / strip.getLength();
      for (int stripx = 0; stripx < strip.getLength(); stripx++) {
        x = stripx*xscale + 1;
        y = stripy*yscale + 1; 
        color c = get(x, y);

        strip.setPixel(c, stripx);
      }
      stripy++;
    }
  }
}
private void prepareExitHandler () {

  Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {

    public void run () {

      System.out.println("Shutdown hook running");

      List<Strip> strips = registry.getStrips();
      for (Strip strip : strips) {
        for (int i=0; i<strip.getLength(); i++)
          strip.setPixel(#000000, i);
      }
      for (int i=0; i<100000; i++)
        Thread.yield();
    }
  }
  ));
}

