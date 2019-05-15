


// 2016_01_11 PixelPusher scraper for individual strip arrangement
// by chris (http://heroicrobotics.boards.net/user/599)

boolean first_scrape = true;
int[] pixelLocations;
int pixel_index = 1;   
boolean enableShowLocations;

// Set the location of a single LED on Canvas (taken from Fadecandy)
void led(int index, int x, int y)  
{ 
  // For convenience, automatically grow the pixelLocations array. We do want this to be an array,
  // instead of a HashMap, to keep draw() as fast as it can be.
  if (pixelLocations == null) {
    pixelLocations = new int[index + 1];
  } else if (index >= pixelLocations.length) {
    pixelLocations = Arrays.copyOf(pixelLocations, index + 1);
  }
  pixelLocations[index] = x + width * y;
}

void showLocations(boolean enabled)
{
  enableShowLocations = enabled;
}

void set_pixels_pod2(int start_index, int end_index, int start_x,int start_y,int end_x,int end_y) {
  int addr_offset = 860;
  int x_offset = width/2;
  set_pixels(addr_offset + start_index, addr_offset + end_index, x_offset + start_x, start_y, x_offset + end_x, end_y);
}

void set_pixels(int start_index, int end_index, int start_x,int start_y,int end_x,int end_y){
   if (observer.hasStrips) {
        registry.startPushing();
        //registry.setAutoThrottle(true);
        //registry.setAntiLog(true);
        List<Strip> strips = registry.getStrips();
        
        if (strips.size() > 0){       
          for(Strip strip : strips) {
            for (int step_index = start_index; step_index < end_index+1; step_index++) {
              int write_to_strip_number = floor(step_index/strip.getLength());
              if(strip.getStripNumber() == write_to_strip_number){
             
                float step_percent = (float(step_index)-float(start_index))/(float(end_index)-float(start_index));
                int interpolated_x = round(lerp(start_x,end_x,step_percent));
                int interpolated_y = round(lerp(start_y,end_y,step_percent));              
                color c = get(interpolated_x,interpolated_y);
                //println("interpolated_coordinates ", interpolated_x, " ", interpolated_y);
                pixel_index = step_index;
                led(step_index, interpolated_x, interpolated_y);
                strip.setPixel(c, step_index-(write_to_strip_number*strip.getLength()));
                //println(strip.getStripNumber()," ",step_index-(write_to_strip_number*strip.getLength()));
              }
             }
          }
        }     
    }
}

void scrape() {
  // scrape for the strips
  loadPixels();
     // reset pixel_index before defining strip arrangement
     pixel_index = 1; 
     // define strip arrangement by defining which LEDs (from start_index to end_index)
     //   are on a line defined by start point (start_x and start_y) and end point (end_x and end_y) on the canvas.
     //set_pixels(0,479,0,0,479,479);     // first strip with 480 LEDs
     //set_pixels(480,959,0,100,479,100); // second strip with 480 LEDs
     
     
     /* Alternative mapping example: arrange the first strip as a square.  */
     // Map the upper horizontal line of the square on the canvas to the first 120 LEDs on the first strip
     //set_pixels(0,92,100,100,400,400);
     
     //Define a segment: set_pixels(start, end, start_x, start_y, end_x, end_y)
     
     //Channel 0:  0 - 214
     //Triangle RE AKA #1
     set_pixels(0,21,93,133,55,68);
     set_pixels(22,38,55,68,17,110);
     set_pixels(39,67,17,110,103,151);
     set_pixels(68,73,103,151,93,133);
     
     //Triangle RJ AKA #2
     set_pixels(74,83,108,130,127,161);
     set_pixels(84,92,127,161,158,155);
     set_pixels(93,120,158,155,86,93);
     set_pixels(121,132,86,93,108,130);
     
     //Channel 1: 215 - 429
     //Triangle RD AKA #3
     set_pixels(215,241,161,117,148,27);
     set_pixels(242,267,148,27,70,58);
     set_pixels(268,305,70,58,164,140);
     set_pixels(306,312,164,140,161,117);

     //Triangle RH AKA #4
     set_pixels(313,328,177,121,169,66);
     set_pixels(329,356,169,66,208,151);
     set_pixels(357,364,208,151,181,152);
     set_pixels(365,373,181,152,177,121);
     
     //Channel 2: 430 - 644
     //Triangle RC AKA #5
     set_pixels(430,438,225,94,217,134);
     set_pixels(439,475,217,134,166,24);
     set_pixels(476,497,166,24,238,23);
     set_pixels(498,522,238,23,225,94);
     
     //Triangle RG AKA #6
     set_pixels(523,537,238,108,247,56);
     set_pixels(538,568,247,56,266,157);
     set_pixels(569,579,266,157,229,152);
     set_pixels(580,592,229,152,238,108);
     
     //Channel 3: 645 - 859
     //Triangle RB AKA #7
     set_pixels(645,651,274,118,278,141);
     set_pixels(652,680,278,141,317,57);
     set_pixels(681,700,317,57,258,28);
     set_pixels(701,728,258,28,274,118);
     
     //Triangle RF AKA #8
     set_pixels(729,749,327,155,322,83);
     set_pixels(750,775,322,83,286,161);
     set_pixels(776,788,286,161,328,176);
     set_pixels(789,794,328,176,327,155);
     
     //Triangle RA AKA #9
     set_pixels(795,816,341,146,337,75);
     set_pixels(817,833,337,75,376,119);
     set_pixels(834,851,376,119,343,166);
     set_pixels(852,857,343,166,341,146);
     
     
     //Pod 2
     //Channel 4:  860 - 1074
     //Triangle RE AKA #1
     set_pixels_pod2(0,21,93,133,55,68);
     set_pixels_pod2(22,38,55,68,17,110);
     set_pixels_pod2(39,67,17,110,103,151);
     set_pixels_pod2(68,73,103,151,93,133);
     
     //Triangle RJ AKA #2
     set_pixels_pod2(74,83,108,130,127,161);
     set_pixels_pod2(84,92,127,161,158,155);
     set_pixels_pod2(93,120,158,155,86,93);
     set_pixels_pod2(121,132,86,93,108,130);
     
     //Channel 5: 215 - 429
     //Triangle RD AKA #3
     set_pixels_pod2(215,241,161,117,148,27);
     set_pixels_pod2(242,267,148,27,70,58);
     set_pixels_pod2(268,305,70,58,164,140);
     set_pixels_pod2(306,312,164,140,161,117);

     //Triangle RH AKA #4
     set_pixels_pod2(313,328,177,121,169,66);
     set_pixels_pod2(329,356,169,66,208,151);
     set_pixels_pod2(357,364,208,151,181,152);
     set_pixels_pod2(365,373,181,152,177,121);
     
     //Channel 6: 430 - 644
     //Triangle RC AKA #5
     set_pixels_pod2(430,438,225,94,217,134);
     set_pixels_pod2(439,475,217,134,166,24);
     set_pixels_pod2(476,497,166,24,238,23);
     set_pixels_pod2(498,522,238,23,225,94);
     
     //Triangle RG AKA #6
     set_pixels_pod2(523,537,238,108,247,56);
     set_pixels_pod2(538,568,247,56,266,157);
     set_pixels_pod2(569,579,266,157,229,152);
     set_pixels_pod2(580,592,229,152,238,108);
     
     //Channel 7: 645 - 860
     //Triangle RB AKA #7
     set_pixels_pod2(645,651,274,118,278,141);
     set_pixels_pod2(652,680,278,141,317,57);
     set_pixels_pod2(681,700,317,57,258,28);
     set_pixels_pod2(701,728,258,28,274,118);
     
     //Triangle RF AKA #8
     set_pixels_pod2(729,749,327,155,322,83);
     set_pixels_pod2(750,775,322,83,286,161);
     set_pixels_pod2(776,788,286,161,328,176);
     set_pixels_pod2(789,794,328,176,327,155);
     
     //Triangle RA AKA #9
     set_pixels_pod2(795,816,341,146,337,75);
     set_pixels_pod2(817,833,337,75,376,119);
     set_pixels_pod2(834,851,376,119,343,166);
     set_pixels_pod2(852,857,343,166,341,146);
     
     
    
    // if no pixels are defined, they cannot be printed
    if (pixelLocations == null) {
      // No pixels defined yet
      return;
    }  
    // show LED locations on canvas
    for (int i = 0; i < pixel_index+1; i++) { 
     int pixelLocation = pixelLocations[i];
     int pixel = pixels[pixelLocation];
      if (enableShowLocations) {
        pixels[pixelLocation] = 0xFFFFFF ^ pixel;
      }
    }
    // if LED locations should be shown on canvas, updatePixels() is executed here
    if (enableShowLocations) {
      updatePixels();
    }
       
  }
