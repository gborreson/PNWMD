/*
SimpleTwitterStreaming for PixelPusher
 Twitter code developed by: Michael Zick Doherty
 2011-10-18
 http://neufuture.com
 
 PixelPusher interface and other fun Processing stuff 
 developed by Jas Strong <jasmine@heroicrobotics.com>
 2014-1-26
 
 We hacked this together for the ORD Camp unconference;
 you may want to change the details.  I've endogenated it.
 
 Requires the font Speccy by Rebecca Bettencourt;  you
 can swap this for any suitably legible low-resolution font,
 or if you have a big display then you can increase the size.
 http://www.kreativekorp.com/software/fonts/index.shtml#retro
 
 */


///////////////////////////// Config your setup here! ////////////////////////////

// This is where you enter your Oauth info
static String OAuthConsumerKey = "*REDACTED*";
static String OAuthConsumerSecret = "*REDACTED*";
// This is where you enter your Access Token info
static String AccessToken = "*REDACTED*";
static String AccessTokenSecret = "*REDACTED*";

// if you enter keywords here it will filter, otherwise it will sample
String keywords[] = {"dogecoin"
};

///////////////////////////// End Variable Config ////////////////////////////

TwitterStream twitter = new TwitterStreamFactory().getInstance();

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;

int stride = 240;
boolean use_weighted_get = true;

boolean ready_to_go = true;

String nextText;

int canvasW = 480;
int canvasH = 16;
TestObserver testObserver;

// this is how many pieces of text will scroll at any one time.
int numTextScrolls = 1;

int radius = 5;
float theta = 3.0;

class TextScroll {
   public int x;
   public int y;
   public int z;
   public color c;
   public String contentText;
  
  public TextScroll() {
     x=580;
     y= height-2;//int(random(height));
     z=20+int(random(width-20));
     c = color(random(100), 100, 100);
     
     // If a tweet is found, it scrolls it up next,
     // otherwise it picks one of the five options below.
     
     if (nextText != null) {
        contentText=new String(nextText); 
        nextText=null;
     }
     else
     switch(int(random(5))) {
       case 0: contentText = "Pushing your tweets!  tweet #dogecoin!";
               break;
       case 1: contentText = "PUSHING PIXELS AND TAKING #dogecoin";
               break;
       case 2: contentText = "your tweet in lights #dogecoin";
               break;
       case 3: contentText = "OH HAI!  TWEET ON ME #dogecoin";
               break;
       case 4: contentText = "so led.  much pixel.  wow #dogecoin";
     }    
  }
};

TextScroll[] scrollCloud;
PFont myFont;

void setup() {
 size(canvasW, canvasH, P3D);
  connectTwitter();
  twitter.addListener(listener);
  if (keywords.length==0) { twitter.sample(); }
  else { twitter.filter(new FilterQuery().track(keywords)); }
  
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  registry.setAntiLog(true);
  myFont = createFont("Speccy", 16);
  textFont(myFont);
  textSize(16);
  
  //background(#000000);
  stroke(#ffffff);
  fill(#ffffff);
  colorMode(HSB,100,100,100,100);
  scrollCloud = new TextScroll[numTextScrolls];
  background(0);
  for (int i=0; i<numTextScrolls; i++)
    scrollCloud[i] = new TextScroll();
}




void draw() {
  //background(0);
  noStroke();
  fill(#000000,35);
  rectMode(CORNERS);
  rect(0,0,width, height);
  for (int i=0; i<numTextScrolls; i++) {
    fill(scrollCloud[i].c);
    text(scrollCloud[i].contentText, scrollCloud[i].x, scrollCloud[i].y);
    //ellipse(scrollCloud[i].x, scrollCloud[i].y, scrollCloud[i].z/60, scrollCloud[i].z/60);
    scrollCloud[i].x-=1+scrollCloud[i].z / 260;
    if (scrollCloud[i].x < -textWidth(scrollCloud[i].contentText))
      scrollCloud[i] = new TextScroll();
  }
  scrape();
}

void stop()
{
  super.stop();
}


// Initial connection
void connectTwitter() {
  twitter.setOAuthConsumer(OAuthConsumerKey, OAuthConsumerSecret);
  AccessToken accessToken = loadAccessToken();
  twitter.setOAuthAccessToken(accessToken);
}

// Loading up the access token
private static AccessToken loadAccessToken() {
  return new AccessToken(AccessToken, AccessTokenSecret);
}

// This listens for new tweet
StatusListener listener = new StatusListener() {
  public void onStatus(Status status) {

    nextText = new String("@" + status.getUser().getScreenName() + " - " + status.getText());

  }

  public void onDeletionNotice(StatusDeletionNotice statusDeletionNotice) {
    //System.out.println("Got a status deletion notice id:" + statusDeletionNotice.getStatusId());
  }
  public void onTrackLimitationNotice(int numberOfLimitedStatuses) {
    //  System.out.println("Got track limitation notice:" + numberOfLimitedStatuses);
  }
  public void onScrubGeo(long userId, long upToStatusId) {
    System.out.println("Got scrub_geo event userId:" + userId + " upToStatusId:" + upToStatusId);
  }

  public void onException(Exception ex) {
    ex.printStackTrace();
  }
};


