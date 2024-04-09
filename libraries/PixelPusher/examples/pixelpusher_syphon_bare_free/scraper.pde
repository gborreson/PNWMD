
void scrape() {
  // scrape for the strips
  loadPixels();
  if (testObserver.hasStrips) {
    registry.startPushing();
    List<Strip> strips = registry.getStrips();

    // each point in l1 has a corresponding point in l2
    // we iterate over l1 and generate a line between the two,
    // then sample that line.
    Line l1 = new Line(ax, ay, dx, dy, strips.size()); // left hand edge of array
    Line l2 = new Line(bx, by, cx, cy, strips.size()); // right hand edge of array

    // iterate over l1
    for (int i=0; i<l1.intervals; i++) {
      // given the edges, sample a line between them
      Line lc = new Line(l1.startx + l1.incx*i, l1.starty + l1.incy*i, 
      l2.startx + l2.incx*i, l2.starty + l2.incy*i, strips.get(i).getLength());
      // iterate over this new line
      for (int j=0; j<lc.intervals; j++) {
        strips.get(i).setPixel(get( int(lc.startx + lc.incx*j), int(lc.starty + lc.incy*j)), j);
      }
    }
  }
}
