/**
 * Café Wall
 * by Evan Shelhamer
 *
 * A geometric illusion in which parallel lines of a grid appear
 * sloped and crooked due to alternating black and white tiles row-by-row
 * displacement.
 *
 */

// illusion size
int wallW = 600;
int wallH = 400;
final int maxW = 800;
final int maxH = 800;
int sqSize = 24;
int mortarSize = 2;
int stride = sqSize + mortarSize;
int rows, cols;
int padCols;

// illusion shifting
int shift;
int shiftDelta = 8;
int shiftPeriod = 4;

// illusion colors
color onColor = color(255);
color offColor = color(0);
color mortarColor = color(127);
color bgColor = color(175, 33, 33);

// illusion graphic (for clipping)
PGraphics illusion;
int illW, illH;

// centering
int centerX, centerY;

void setup() {
  // configure app window & drawing
  size(maxW, maxH);
  noStroke();
  smooth();

  // determine rows and columns count from wall & square size
  rows = wallH / stride;
  cols = wallW / stride;
  padCols = shiftDelta*shiftPeriod / sqSize + 1; // need padding due to shifting

  // create graphics pad for drawing illusion
  illW = cols*stride;
  illH = rows*stride;
  illusion = createGraphics(illW, illH, P2D);
  illusion.noStroke();

  // center wall for display
  centerX = (int) Math.round(maxW / 2.0 - (illW) / 2.0);
  centerY = (int) Math.round(maxH / 2.0 - (illH) / 2.0);
}

void draw() {
  background(bgColor);

  // configure illusion drawing
  illusion.beginDraw();

  // fill in mortar
  illusion.fill(mortarColor);
  illusion.rect(0, 0, wallW, wallH);

  // draw café wall squares
  int shift = 0;
  for (int j = 0; j < rows; j++) {
    // displace each row for the illusion:
    // "staircase" the tiles by shifting by a fixed delta each row,
    // switching direction every period # of steps
    shift += shiftDelta * Math.pow(-1, j / shiftPeriod);

    // draw a row (including padding cols)
    for (int i = -padCols; i < cols; i++) {
      illusion.fill(((i + j) % 2 == 0) ? onColor : offColor);
      illusion.rect(i*stride + shift, j*stride, sqSize, sqSize);
    }
  }
  illusion.endDraw();

  image(illusion, centerX, centerY);
}