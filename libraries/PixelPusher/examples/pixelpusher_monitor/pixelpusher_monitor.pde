// pixelpusher monitor sketch.
// doesn't do anything, just listens out.
// jas strong, 26th aug 2014

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

TestObserver testObserver;



void setup() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  background(0);
}




void draw() {
}

void stop()
{
  super.stop();
}

