
void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();

    // First, scrape for the left hand half of the display

    List<Strip> strips = registry.getStrips(1);

    if (strips.size() > 0) {

      // yscale = how many pixels of y == one led strip.
      // xscale = how many pixels of x == one led pixel.
      float xscale = float(width/2) / float(strips.get(0).getLength());
      float yscale = float(height) / float(strips.size());

      // for each strip (y-direction)
      int stripy = 0;
      for (Strip strip : strips) {
        for (int stripx = 0; stripx < strip.getLength(); stripx++) {
          color c = get(int(float(stripx)*xscale), int(float(stripy)*yscale));
          strip.setPixel(c, stripx);
        }
        stripy++;
      }
    }
    // Secondly, scrape for the right hand half of the display

    strips = registry.getStrips(2);

    if (strips.size() > 0) {
      // yscale = how many pixels of y == one led strip.
      // xscale = how many pixels of x == one led pixel.
      float xscale = float(width/2) / float(strips.get(0).getLength());
      float yscale = float(height) / float(strips.size());

      // for each strip (y-direction)
      int stripy = 0;
      for (Strip strip : strips) {
        for (int stripx = 0; stripx < strip.getLength(); stripx++) {
          color c = get(width - int(float(stripx)*xscale), int(float(stripy)*yscale));
          strip.setPixel(c, stripx);
        }
        stripy++;
      }
    }
  }
}

