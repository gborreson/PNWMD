import g4p_controls.*;

// pixelpusher photon configurator
// used to configure a PixelPusher Photon.
// jas strong, 23rd june 2014.


import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.*;


import processing.core.*;
import java.util.*;

DeviceRegistry registry;

int lastPosition;
int canvasW = 640;
int canvasH = 600;
TestObserver testObserver;


int selectedPusher = 0;
String wifiSsid="HeroicRobotics";
String wifi_key="PixelPusher";
String wifiMode="wpa2";

byte[] stripType = {0,0,0,0,0,0,0,0};
byte[] colourOrder = {0,0,0,0,0,0,0,0};
int numStrips = 2;
int stripLength = 240;
int group = 0;
int controller = 0;

void spamCommand(PixelPusher p, PusherCommand pc) {
   for (int i=0; i<10; i++) {
    p.sendCommand(pc);
    try {
    Thread.sleep(200);
    } catch (Exception e) {
      // who cares?  not me
    }
  }
}

void setup() {
  size(canvasW, canvasH, P2D);
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  createGUI();
}




void draw() {
  background(#F2F4FF);
  scrape();
}

void stop()
{
  super.stop();
}

