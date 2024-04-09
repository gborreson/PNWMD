// Syphon sketch with custom triple-wide scraper.
// requires pixelpushers to be configured in three groups-  left, middle and right.
// jas strong, 6th Dec 2013.

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
int canvasW = 240 * 3;
int canvasH = 40 * 4;
TestObserver testObserver;



void setup() {
  size(canvasW, canvasH, P3D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  background(0);
  client = new SyphonClient(this, "Modul8", "Main View");
}




void draw() {
  if (client.available()) {
    canvas = client.getGraphics(canvas);
    image(canvas, 0, 0, width, height);
  }

  // since we have each "sub-screen" in its own group, scrape for all three.  
  scrape(1);
  scrape(2);
  scrape(3);
}

void stop()
{
  super.stop();
}

