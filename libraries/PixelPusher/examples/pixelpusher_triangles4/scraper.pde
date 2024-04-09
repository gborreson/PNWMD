
boolean first_scrape = true;
void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();
    boolean phase = false;
     // for every strip:
       int currenty = 0;
       int stripy = 0;
       for(Strip strip : strips) {
         int strides_per_strip = strip.getLength() / stride;

        //  println("Strides per strip = "+strides_per_strip);

         int xscale = width / stride;
         int yscale = height / (int)(strides_per_strip * strips.size());
         
         // for every pixel in the physical strip
         for (int stripx = 0; stripx < strip.getLength(); stripx++) {
             int xpixel = stripx % stride;
             int stridenumber = stripx / stride; 
             int xpos,ypos; 
             
             if ((stridenumber & 1) == 0) { // we are going left to right
               xpos = xpixel * xscale; 
               ypos = (((int)(stripy*strides_per_strip)) + stridenumber) * yscale;
            } else { // we are going right to left
               xpos = ((stride - 1)-xpixel) * xscale;
               ypos = ((stripy*strides_per_strip) + stridenumber) * yscale;               
            }
            
            color c = get(xpos, ypos);
             strip.setPixel(c, stripx);
            
          }
         stripy++;
       }
  }
}
