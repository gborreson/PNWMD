/*
 *  Generate moving waves in 2d, based on beat detection.
 *
 *  By Joe (subversion on forum.heroicrobotics.com)
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.PixelPusher;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;

import ddf.minim.*;
import ddf.minim.effects.*;
import ddf.minim.analysis.*;

import processing.core.*;
import java.util.*;

DeviceRegistry registry;
TestObserver testObserver;
Minim minim;
AudioInput in; // audio stream from microphone/line in
// beat detection
BeatDetect beat;
BeatListener bl;

// FFT info 
FFT fft; 
BandPass bpf;

int stride = 240;

int SCREENWIDTH  = 480;
int SCREENHEIGHT = 32;
 
int GRADIENTLEN = 1500;
// use this factor to make things faster, esp. for high resolutions
int SPEEDUP = 1;
 
int c = 0;
// swing/wave function parameters
int SWINGLEN = GRADIENTLEN*3;
int SWINGMAX = GRADIENTLEN / 2 - 1;
 
// gradient & swing curve arrays
private int[] colorGrad;
private int[] swingCurve;
 
// create standard gradient & swing curve
void setup() {
    size(SCREENWIDTH, SCREENHEIGHT, P2D);
    // PP init
    registry = new DeviceRegistry();
    testObserver = new TestObserver();
    registry.addObserver(testObserver);

    // init minim and beat detection
    minim = new Minim(this);
    in = minim.getLineIn(minim.MONO); // could use stereo, but for this purpose mono is fine
    // see class below for more info
  
    beat = new BeatDetect();
    beat.detectMode(BeatDetect.FREQ_ENERGY); // want to do freq analysis, not energy 
    beat.setSensitivity(50); // ms to wait before next analysis, range 10 .. max int 
    bl = new BeatListener(beat, in);
    
    /*
      some more fft init
     bpf filter helps beatDetection algo when bass beat detection is only wanted  
     freq - the center frequency of the band to pass (in Hz)
     bandWidth - the width of the band to pass (in Hz)
     sampleRate - the sample rate of audio that will be filtered by this filter
     */
     //http://code.compartmental.net/tools/minim/manual-iirfilter/
    bpf = new BandPass(100, 100, in.sampleRate());
    in.addEffect(bpf);
    fft = new FFT(in.bufferSize(), in.sampleRate());
    // calculate averages based on a miminum octave width of 22 Hz
    // split each octave into n bands
    fft.logAverages(22, 3); // n = 1  
    
    makeGradient(GRADIENTLEN);
    makeSwingCurve(SWINGLEN, SWINGMAX);
}
 
// draw one frame of the sinus plasma
void draw() {
    if ( beat.isKick()) {
      SPEEDUP = (int) random(1, 5);
      GRADIENTLEN = 1000 + (int) random (1,500);
      makeGradient(GRADIENTLEN);
    }    
  
    loadPixels();
    int i = 0;
    int t = frameCount*SPEEDUP;
    int swingT = swing(t); // swingT/-Y/-YT variables are used for a little tuning ...
 
    for (int y = 0; y < SCREENHEIGHT; y++) {
        int swingY  = swing(y);
        int swingYT = swing(y + t);
        for (int x = 0; x < SCREENWIDTH; x++) {
            // this is where the magic happens: map x, y, t around
            // the swing curves and lookup a color from the gradient
            // the "formula" was found by a lot of experimentation
            pixels[i++] = gradient(
                    swing(swing(x + swingT) + swingYT) +
                    swing(swing(x + t     ) + swingY ));
        }
    }
    updatePixels();
    scrape();
}
 
// create a new random gradient when mouse is pressed
void mousePressed() {
    if (mouseButton == LEFT) {
        SPEEDUP = (int) random(1, 10);
        GRADIENTLEN = 1000 + (int) random (1,500);
        makeGradient(GRADIENTLEN); } 
    else if (mouseButton == RIGHT) {
        makeSwingCurve(SWINGLEN, SWINGMAX);
    }
}
   
// fill the given array with a nice swingin' curve
// three cos waves are layered together for that
// the wave "wraps" smoothly around, uh, if you know what i mean ;-)
void makeSwingCurve(int arrlen, int maxval) {
    // default values will be used upon first call
    int factor1=2;
    int factor2=3;
    int factor3=6;
 
    if (swingCurve == null) {
        swingCurve = new int[SWINGLEN];
    } else {
        factor1=(int) random(1, 7);
        factor2=(int) random(1, 7);
        factor3=(int) random(1, 7);
    }
 
    int halfmax = maxval/factor1;
 
    for( int i=0; i<arrlen; i++ ) {
        float ni = i*TWO_PI/arrlen; // ni goes [0..TWO_PI] -> one complete cos wave
        swingCurve[i]=(int)(
            cos( ni*factor1 ) *
            cos( ni*factor2 ) *
            cos( ni*factor3 ) *
            halfmax + halfmax );
    }
}
 
// create a smooth, colorful gradient by cosinus curves in the RGB channels
private void makeGradient(int arrlen) {
    // default values will be used upon first call
    int rf = 4;
    int gf = 2;
    int bf = 1;
    int rd = 0;
    int gd = arrlen / gf;
    int bd = arrlen / bf / 2;
 
    if (colorGrad == null) {
        // first call
        colorGrad = new int[GRADIENTLEN];
    } else {
        // we are called again: random gradient
        rf = (int) random(1, 5);
        gf = (int) random(1, 5);
        bf = (int) random(1, 5);
        rd = (int) random(0, arrlen);
        gd = (int) random(0, arrlen);
        bd = (int) random(0, arrlen);
        System.out.println("Gradient factors("+rf+","+gf+","+bf+"), displacement("+rd+","+gd+","+bd+")");
    }
 
    // fill gradient array
    for (int i = 0; i < arrlen; i++) {
        int r = cos256(arrlen / rf, i + rd);
        int g = cos256(arrlen / gf, i + gd);
        int b = cos256(arrlen / bf, i + bd);
        colorGrad[i] = color(r, g, b);
    }
}

// helper: get cosinus sample normalized to 0..255
private int cos256(final int amplitude, final int x) {
    return (int) (cos(x * TWO_PI / amplitude) * 127 + 127);
}
 
// helper: get a swing curve sample
private int swing(final int i) {
    return swingCurve[i % SWINGLEN];
}
 
// helper: get a gradient sample
private int gradient(final int i) {
    return colorGrad[i % GRADIENTLEN];
}

// always close Minim audio classes when you are finished with them
void stop() {
  in.close();
  minim.stop();
  // this closes the sketch
  super.stop();
}

