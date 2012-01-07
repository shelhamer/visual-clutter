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

// centering
int centerX, centerY;
int wallCenterX, wallCenterY;

void setup() {
  // configure app window & drawing
  size(maxW, maxH);
  noStroke();
  smooth();

  // determine rows and columns count from wall & square size
  rows = wallH / stride;
  cols = wallW / stride;
  padCols = shiftDelta*shiftPeriod / sqSize + 1; // need padding due to shifting

  // center wall for display
  centerX = (int) Math.round(maxW / 2.0 - wallW / 2.0);
  centerY = (int) Math.round(maxH / 2.0 - wallH / 2.0);
  wallCenterX = (int) Math.round((wallW - cols*stride) / 2.0);
  wallCenterY = (int) Math.round((wallH - rows*stride) / 2.0);
}

void draw() {
  background(bgColor);

  // fill in mortar
  translate(centerX, centerY);
  fill(mortarColor);
  rect(0, 0, wallW, wallH);

  // configure illusion drawing
  int shift = 0;

  // draw café wall squares
  translate(wallCenterX, wallCenterY);
  for (int j = 0; j < rows; j++) {
    // displace each row for the illusion:
    // "staircase" the tiles by shifting by a fixed delta each row,
    // switching direction every period # of steps
    shift += shiftDelta * Math.pow(-1, j / shiftPeriod);

    // draw a row (including padding cols)
    for (int i = -padCols; i < cols; i++) {
      fill(((i + j) % 2 == 0) ? onColor : offColor);
      rect(i*stride + shift, j*stride, sqSize, sqSize);
    }
  }
}