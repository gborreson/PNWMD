/*

PNW Meditation Deathmatch note: This was (more or less) the sketch that ran the competitions at 
Bass Coast 2018, with some vesitigal bits removed.

Things that are still on the to do list:
- Better-visualized victory states
- Saving game data anywhere persistent
- Add a visual indicator of the headbands status other than the console

Requires:
- 2 Muse headbands (I haven't tried it with the 2019 latest model, just 2016)
- Muse Direct to forward data on OSC or some other means of getting these OSC feeds
  - For us, this mean it needed Wi-Fi and two smartphones running the Muse Direct app. They charge
    a subscription fee for this app which is kind of silly.
- A HeroicRobotics PixelPusher
  - An LED installation with compatible LEDs

What is does:
- Receives incoming data from two Muse headbands forwarded via OSC from Muse Direct
- Translates that data into a momentary chill score using our scoring calculation
  * The 2016 Muse headband removed the Mellow score. Shucks! Otherwise we probably would
    have just used that.
- Controls starting, scoring, timing and victory
- Translates momentary and relative-to-opponent chillness into visualizers
- Displays those visualizers on a mapped LED installation driven by HeroicRobotics' PixelPusher

Key commands:
- Space: from ready state, start the countdown to begin. Game will start in 10 seconds.
- Shift-S: remove 20 seconds from the remaining time. Useful for testing.
- Shift-Q: reset scores and return game to ready state.

Things you want to do before beginning:
- Make sure the you have two Muses streaming relative alpha/beta/gamma/theta/delta to OSC on 
  matching OSC prefix (We used HomeWarrior and AwayWarrior) IP & port (recvPort below)
- The relative feeds are *REALLY FINICKY* and seem to require a duration of sustained full contact 
  on all of the electrodes. On the Muse Direct app, we found this meant the horseshoe had to be 
  fully lit up for about 10 seconds before these feeds would register anything. In the stream of 
  data in the console, values will transition from NaN to floats when those streams are available. 
  Scoring doesn't work right without those streams.
  
Scoring:
- Each sample, the relative share of each frequency band (alpha, beta, gamma, theta, delta) will
  be compared against the other bands to determine how chill the contestant is. Alpha dominance is
  associated with wakeful relaxation, so alpha share is rewarded (*1). Theta dominance is associated
  with near sleep and deep meditation, so theta share is doubly rewarded (*2). Beta dominance is
  associated with problem solving and concentration, so beta share is penalized (*-1). Gamma
  dominance is associated with memory, information processing, focusing on senses and agitation, so
  gamma share is doubly penalized (*-2). Delta dominance happens during deep sleep, so we consider
  that sort of like cheating (but good for you for being able to fall asleep in this environment) so
  is just scored at 0.
  Eg: Alpha 0.2, Beta 0.15, Gamma 0.15, Delta 0.15, Theta 0.35 will be scored:
  0.2 - 0.15 - 0.3 + 0 + 0.7 = 0.45
- Negative chill scores are possible but do not subtract from the cumulative score. 0 or negative
  simply prevents score from increasing.
- A score multiplier increases throughout the game, starting at x1 for the first minute then
  increasing by x1 after each minute. This allows a late-game come-from-behind victory if someone is
  really chill later on and/or someone really loses their chill at the end. Makes it a bit more
  interesting than having the race to see who can relax harder first giving a commanding lead.
- It's unfortunate that the headband coming loose can screw with the score. Momentary lapses will
  result in repeating previous values for a bit. If it stays disrupted long enough, that player's
  score will no longer increase.
  
Visualizer:
- The share of total score (with a flat amount added to each side to prevent /0) determines how large 
  (how many "stems") each player's visualizer is. Bigger means winninger.
- The player's recent performance (the last 300 samples) determines how orderly and colourful their
  visualizer is. If their recent average chill dips, their colour will become washed out, the "stems"
  will become uncertain in position and will become more hollow. Un-chill enough, and it devolves
  into static. A player that has the lead but loses their chill will have a pod filled with static
  while one who's well behind and not chill will have a little nimbus of chaos over their head.
  Conversely, someone about to have a come from behind victory will have a little rainbow swirl above
  their head, one that grows into massive smoothly-rotating spiral galaxy with rainbows of colour
  pulsing through it.
- It is possible for an extremely winning player's visualizer to bleed over into the other player's
  pod. This happened a few times at Bass Coast.
- The visualizer is based on plant phyllotaxis, the logic of growing stems.

*/

import netP5.*;
import oscP5.*;
  
  // OSC PARAMETERS & PORTS - receive forwarded EEG data
  int recvPort = 5000;
  OscP5 oscP5;
  
  int timeStart; //Time that a game began, used to calculate how much time is remaining
  
  float scoreMod = 100; //Added to each score in the visualizer to prevent /0 errors
  float HomeSum = 0, AwaySum = 0; //Running tallies of each player's scores
  
  //Alpha, Beta, Gamma and Delta are point-in-time RSP band scores from the EEGs (0-1)
  //Chill rewards Alpha, strongly rewards Theta, penalizes Beta and strongly penalized Gamma
  
  //Recent is the last 300 samples, Avg is the average of those samples (used to show how
  //well someone's doing right now. This is represented in the order vs chaos of the player's
  //visualization.
  
  //Score is an accumulation of Chill over time, which is represented by the size/intensity
  //of the player's visualization.
  float HomeAlpha, HomeBeta, HomeGamma, HomeDelta, HomeTheta, HomeChill, HomeSize, HomeAvg, HomeShare = 0;
  float[] HomeRecent = new float[300];
  
  int phaseStart = 0; //Time holder, holds millis() at time a phase starts
  String gameState = "Ready"; //Ready, Starting, Relaxing, Victory, Done
  String message = "";
  int scoreMultiplier = 1; //During Relaxing phase, increments once per minute
  
  float HomeHue = 0.5;
  
  float AwayAlpha, AwayBeta, AwayGamma, AwayDelta, AwayTheta, AwayChill, AwaySize, AwayAvg, AwayShare = 0;
  float[] AwayRecent = new float[300];
  
  float AwayHue = 0.8;
  PFont letters;
  PFont numbers;
  
void setup() {
  
  size(800, 440, P2D);  //Canvas should be a size that can be easily divided into two effect spaces
  frameRate(24);
  letters = loadFont("CopperplateGothic-Bold-48.vlw");
  numbers = loadFont("Impact-48.vlw");
  
  global_rotation = 0.1;
  
  //PixelPusher
  registry = new DeviceRegistry();
  observer = new TestObserver();
  registry.addObserver(observer);
  showLocations(false);  // For plotting the pixel coordinates. Note: enabling will interfere with light output 
  // if you do not black out the frame on every refresh, as in this sketch.
  brightness = 0.7; // Starting brightness adjustment

  //Phyllotaxis variables
  maxCircles = 400;
  slope = -1.0;
  expansion = 9;
  r_min = 0.0;
  r_max = 5.0;
  rotation_factor = 0.0;
  spiral_type = 29.0;
  shape_type = 0;
  
  /* start oscP5, listening for incoming messages at recvPort */
  oscP5 = new OscP5(this, recvPort);
  background(0);
  
  ellipseMode(RADIUS);
  rectMode(RADIUS);
  textAlign(CENTER);
  colorMode(HSB, 100, 100, 100, 100);
  
  //Populate some zeroes
  for (int i = 0; i < HomeRecent.length; i++) {
    HomeRecent[i] = 0;
  }
  noStroke();
  background(0);
}

void draw() {
  fill(0,70);
  rect(0,0,width,height);
  addNum(HomeChill, HomeRecent);
  
  HomeAvg = recentAvg(HomeRecent);
  if (gameState == "Relaxing" && !Float.isNaN(HomeChill)) HomeSum += max(scoreMultiplier * HomeChill,0);
  
  addNum(AwayChill, AwayRecent);
  
  AwayAvg = recentAvg(AwayRecent);
  if (gameState == "Relaxing" && !Float.isNaN(AwayChill)) AwaySum += max(scoreMultiplier * AwayChill,0);
  
  if (HomeSum >= 0) {
    if (AwaySum >= 0) {
      HomeShare = (HomeSum + scoreMod)  / (HomeSum + AwaySum + 2*scoreMod);
    } else {
      HomeShare = 1.0; 
    }
  } else {
    HomeShare = 0;
  }
  
  if (AwaySum >= 0) {
    if (HomeSum >= 0) {
      AwayShare = (AwaySum + scoreMod) / (HomeSum + AwaySum + 2*scoreMod);
    } else {
      AwayShare = 1.0;
    }
  } else {
    AwayShare = 0;
  }
  HomeSize = 200*HomeShare;
  AwaySize = 200*AwayShare;
  
  fill(0,0,0,20);
  rect(0,0,width,height);
  global_rotation = sin(millis()/32000.0 * TWO_PI)*4;
  
  pushMatrix();
  
  translate(width/4, height/4);
  r_min = -2 + 3*HomeShare;
  r_max = 5.0 + 6*HomeShare;
  expansion = 2 + 12*HomeShare- 3*AwayAvg;
  awesomeness = (HomeAvg + 0.5) * 100; //Zero shouldn't be total static, .5 is really good so full score
  slope = HomeAvg * -2;
  drawSunFlower(int(maxCircles * HomeShare));
  
  translate(width/2,0);
  r_min = -2 + 3*AwayShare;
  r_max = 5.0 + 6*AwayShare;
  expansion = 2 + 12*AwayShare - 3*AwayAvg;
  awesomeness = (AwayAvg + 0.5) * 100;
  slope = AwayAvg * -2;
  drawSunFlower(int(maxCircles * AwayShare));
  
  popMatrix();
  
  //fill(HomeHue, 1.0, 0.5 + 0.5 * HomeChill); // 50% opacity at zero score, +1 chill will be 100%, -1 chill will be 0.
  //ellipse(250,250,HomeSize,HomeSize);
  textSize(50);
  text("Home: "+int(HomeSum), 150,400);
  println("Home: Alpha " + HomeAlpha + "  Beta " + HomeBeta + "  Gamma " + HomeGamma + "  Delta " + HomeDelta + "  Theta " + HomeTheta + "  Share " + HomeShare);
  println("Home Score " + HomeSum +"  Chill " + HomeChill + "  Recent Average: " + HomeAvg);  
  
  
  //fill(AwayHue, 1.0, 0.5 + 0.5 * AwayChill);
  //ellipse(750,250,AwaySize,AwaySize);
  textSize(50);
  text("Away: "+int(AwaySum), 590,400);
  println("Away: Alpha " + AwayAlpha + "  Beta " + AwayBeta + "  Gamma " + AwayGamma + "  Delta " + AwayDelta + "  Theta " + AwayTheta + "  Share " + AwayShare);
  println("Away Score " + AwaySum +"  Chill " + AwayChill + "  Recent Average: " + AwayAvg); 
  
  scoreTimer();
  DeviceRegistry.setOverallBrightnessScale(brightness);
  scrape();
}

void scoreTimer() {
  int millisPassed = millis() - phaseStart;
  int secondsPassed = millisPassed/1000;
  int countdownTime;
  switch(gameState) {
    case "Ready":
      fill((millis()/2000.0)%100, 80, 100); //Pulsing colour
      textFont(letters, 30+10*sin(millis()/1000.0*TWO_PI)); //Sin-pulsing font size
      text("Ready", 400, 300);
      break;
    case "Starting":
      countdownTime = 10-secondsPassed;
      if (countdownTime > 0) {
        fill(1.0-secondsPassed/10.0, 100, 100, 100-70*(millisPassed%1000)/1000);
        textFont(numbers, 90.0 - 40.0*(millisPassed%1000)/1000); //Shrinking second-count numbers
        text(countdownTime, 400, 400); //Countdown from 10
      } else {
        gameState = "Relaxing";
        phaseStart = millis();
      }
      break;
    case "Relaxing":
      scoreMultiplier = secondsPassed /60 + 1;
      countdownTime = 240-secondsPassed;
      if (secondsPassed < 5) { //Intro "RELAX!"
        fill((millis()/4000.0)%100, 80, 100); //Pulsing colour
        textFont(letters, 40+20*sin(millis()/500.0*TWO_PI)); //Sin-pulsing font size
        text("RELAX!", 400, 400);
      } else if (secondsPassed < 230) { //Main game
        fill((millis()/30000.0)%100, 80, 100);
        textFont(numbers, 50);
        text(scoreMultiplier+"x "+countdownTime/60+":"+countdownTime%60/10+countdownTime%60%10, 400, 400);
        
      } else if (secondsPassed < 240) { //Final countdown
        fill(secondsPassed%10.0, 100, 100, 100-70*(millisPassed%1000)/1000);
        textFont(numbers, 90.0 - 40.0*(millisPassed%1000)/1000); //Shrinking second-count numbers
        text(scoreMultiplier+"x "+countdownTime%10, 400, 400); //Countdown from 10
      } else { //Game over
        gameState = "Victory";
      }
      break;
    case "Victory":
      if (AwaySum == HomeSum) {
        message = "TIE GAME????";
        pushMatrix();
          fill((millis()/4000.0)%1.0, 0.8, 1);
          translate(width*0.25,height*0.5);
          rotate(sin(millis()/8000.0 * TWO_PI));
          
          star(0,0,40+10*sin(millis()/4000.0 * TWO_PI),100+80*sin(millis()/12000.0 * TWO_PI),15);
        popMatrix();
        pushMatrix();
          fill((millis()/4000.0+0.5)%1.0, 0.8, 1);
          translate(width*0.75,height*0.5);
          rotate(sin(millis()/8000.0 * TWO_PI));
          
          star(0,0,40+10*sin(millis()/4000.0 * TWO_PI),100+80*sin(millis()/12000.0 * TWO_PI),15);
        popMatrix();
      }
      else if (AwaySum > HomeSum) {
        message = "AWAY WINS";
      }
      else if (AwaySum < HomeSum) {
        message = "HOME WINS";
      }
      break;
  }
}

void keyPressed() {
  switch (key) {
    case 'Q': //Reset to Ready
      gameState = "Ready";
      phaseStart = 0;
      resetScores();
      break;
    case 'S': //Subtract 20 seconds
      phaseStart -= 20000;
      
    case ' ':
      if (gameState == "Ready") {
        gameState = "Starting";
        phaseStart = millis();
      }
      break;
  }
}

void resetScores() {
  HomeAlpha = HomeBeta = HomeGamma = HomeDelta = HomeTheta = HomeChill = HomeSize = HomeAvg = HomeShare = HomeSum = 0;
  HomeRecent = new float[300];
  AwayAlpha = AwayBeta = AwayGamma = AwayDelta = AwayTheta = AwayChill = AwaySize = AwayAvg = AwayShare = AwaySum = 0;
  AwayRecent = new float[300];
}

void oscEvent(OscMessage msg) {
  //System.out.println("### got a message " + msg);
  HomeChill = 0;
  if (msg.checkAddrPattern("HomeWarrior/elements/alpha_relative")==true) {  
    HomeAlpha = 0;
    for(int i = 0; i < 4; i++) {
      float alphaValue = msg.get(i).floatValue();
      //System.out.print("Home Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      HomeAlpha += alphaValue;
    }
    HomeAlpha /= 4;
  } 
  if (msg.checkAddrPattern("HomeWarrior/elements/theta_relative")==true) {  
    HomeTheta = 0;
    for(int i = 0; i < 4; i++) {
      float thetaValue = msg.get(i).floatValue();
      //System.out.print("Home Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      HomeTheta += thetaValue;
    }
    HomeTheta /= 4;
  } 
  if (msg.checkAddrPattern("HomeWarrior/elements/beta_relative")==true) {  
    HomeBeta = 0;
    for(int i = 0; i < 4; i++) {
      float betaValue = msg.get(i).floatValue();
      //System.out.print("Home Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      HomeBeta += betaValue;
    }
    HomeBeta /= 4;
  } 
  if (msg.checkAddrPattern("HomeWarrior/elements/gamma_relative")==true) {  
    HomeGamma = 0;
    for(int i = 0; i < 4; i++) {
      float gammaValue = msg.get(i).floatValue();
      //System.out.print("Home Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      HomeGamma += gammaValue;
    }
    HomeGamma /= 4;
  } 
  if (msg.checkAddrPattern("HomeWarrior/elements/delta_relative")==true) {  
    HomeDelta = 0;
    for(int i = 0; i < 4; i++) {
      float deltaValue = msg.get(i).floatValue();
      //System.out.print("Home Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      HomeDelta += deltaValue;
    }
    HomeDelta /= 4;
  } 
  HomeChill = HomeAlpha + 2*HomeTheta - HomeBeta - 2*HomeGamma;
  //println("Home: Alpha " + HomeAlpha + "  Beta " + HomeBeta + "  Gamma " + HomeGamma + "  Delta " + HomeDelta + "  Theta " + HomeTheta);
  //println("Home Chill " + HomeChill);  
  
  AwayChill = 0;
  if (msg.checkAddrPattern("AwayWarrior/elements/alpha_relative")==true) {  
    AwayAlpha = 0;
    for(int i = 0; i < 4; i++) {
      float alphaValue = msg.get(i).floatValue();
      //System.out.print("Away Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      AwayAlpha += alphaValue;
    }
    AwayAlpha /= 4;
  } 
  if (msg.checkAddrPattern("AwayWarrior/elements/theta_relative")==true) {  
    AwayTheta = 0;
    for(int i = 0; i < 4; i++) {
      float thetaValue = msg.get(i).floatValue();
      //System.out.print("Away Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      AwayTheta += thetaValue;
    }
    AwayTheta /= 4;
  } 
  if (msg.checkAddrPattern("AwayWarrior/elements/beta_relative")==true) {  
    AwayBeta = 0;
    for(int i = 0; i < 4; i++) {
      float betaValue = msg.get(i).floatValue();
      //System.out.print("Away Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      AwayBeta += betaValue;
    }
    AwayBeta /= 4;
  } 
  if (msg.checkAddrPattern("AwayWarrior/elements/gamma_relative")==true) {  
    AwayGamma = 0;
    for(int i = 0; i < 4; i++) {
      float gammaValue = msg.get(i).floatValue();
      //System.out.print("Away Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      AwayGamma += gammaValue;
    }
    AwayGamma /= 4;
  } 
  if (msg.checkAddrPattern("AwayWarrior/elements/delta_relative")==true) {  
    AwayDelta = 0;
    for(int i = 0; i < 4; i++) {
      float deltaValue = msg.get(i).floatValue();
      //System.out.print("Away Alpha Relative channel " + i + ": " + alphaValue + "\n"); 
      AwayDelta += deltaValue;
    }
    AwayDelta /= 4;
  } 
  AwayChill = AwayAlpha + 2* AwayTheta - AwayBeta - 2*AwayGamma;
}


void addNum(float newNum, float[] holder) {
  arrayCopy(holder, 0, holder, 1, holder.length-1);
  if (Float.isNaN(newNum)) {
    holder[0] = 0;
  } else {
    holder[0] = newNum;
  }
} 

float recentAvg(float[] recent) {
  float sum = 0;
  for (int i = 0; i < recent.length; i++) {
    sum += recent[i];
  }
  return sum/recent.length;
}
  
