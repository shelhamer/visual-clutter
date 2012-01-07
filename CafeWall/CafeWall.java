import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class CafeWall extends PApplet {

/**
 * Caf\u00e9 Wall
 * by Evan Shelhamer
 *
 * A geometric illusion in which parallel lines of a grid appear
 * sloped and crooked due to alternating black and white tiles row-by-row
 * displacement.
 *
 */

 // need to use version 0.5.4 for export

// =Illusion

// illusion size
int wallW = 600;
int wallH = 400;
final int minW = 100;
final int minH = 100;
final int maxW = 800;
final int maxH = 800;
int sqSize = 24;
final int minSqSize = 4;
final int maxSqSize = 96;
int mortarSize = 2;
int stride;
int rows, cols;
int padCols;

// illusion shifting
float shiftFactor = .25f; // proportion of square size to shift
int shiftDelta = (int) Math.round(shiftFactor*sqSize);
int shiftPeriod = 4;

// illusion colors
int onColor = color(255);
int offColor = color(0);
int mortarColor = color(127);
int bgColor = color(175, 33, 33);

// illusion graphic (for clipping)
PGraphics illusion;
int illW, illH;

// centering
int centerX, centerY;

// =Interface
ControlP5 cp5;

controlP5.Slider2D dimsSlide2;
controlP5.Slider sizeSlide, shiftSlide;

public void setup() {
  // configure app window & drawing
  size(800, 900);
  noStroke();
  smooth();

  // create interface
  int ifX = maxW / 2;
  int ifY = maxH + 10;
  cp5 = new ControlP5(this);
  dimsSlide2 = cp5.addSlider2D("wallDims", minW, maxW, minH, maxH, wallW-minW, wallH-minH, ifX - 100, ifY, 75, 75);
  dimsSlide2.setCaptionLabel("Wall Dims.");
  sizeSlide = cp5.addSlider("sqSize", minSqSize, maxSqSize, sqSize, ifX, ifY+30, 60, 10);
  sizeSlide.setCaptionLabel("Square Size");
  sizeSlide.setNumberOfTickMarks(23); // increments of 4
  sizeSlide.snapToTickMarks(true);
  shiftSlide = cp5.addSlider("rowShift", 0, 1, shiftFactor, ifX, ifY+55, 60, 10);
  shiftSlide.setCaptionLabel("Row Shift");

  // prepare & draw illusion
  updateSize(sqSize);
  updateDims(wallW, wallH);
  makeIllusion();
}

public void draw() {
  // poll 2D slider, and update illusion on change
  float[] dims = dimsSlide2.arrayValue();
  if (dims[0] != wallW || dims[1] != wallH) {
    updateDims(dims[0], dims[1]);
    makeIllusion();
  }

  // display
  background(bgColor);
  image(illusion, centerX, centerY);
}

// Draw the illusion w/ checkerboard, row shifting, and mortar background
public void makeIllusion() {
  // configure illusion drawing
  illusion = createGraphics(illW, illH, P2D);
  illusion.noStroke();
  illusion.beginDraw();

  // fill in mortar
  illusion.fill(mortarColor);
  illusion.rect(0, 0, wallW, wallH);

  // draw caf\u00e9 wall squares
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
}

// update illusion dimensions
public void updateDims(float w, float h) {
  wallW = (int) Math.round(w);
  wallH = (int) Math.round(h);

  updateSize(sqSize);

  centerX = (int) Math.round(maxW / 2.0f - (illW) / 2.0f);
  centerY = (int) Math.round(maxH / 2.0f - (illH) / 2.0f);
}

// update square size, rows, and columns
public void updateSize(int s) {
  sqSize = s;
  stride = sqSize + mortarSize;

  // determine rows and columns count from wall & square size
  rows = wallH / stride;
  cols = wallW / stride;
  padCols = shiftDelta*shiftPeriod / sqSize + 1; // need padding due to shifting

  // determine clipped illusion size
  illW = cols*stride;
  illH = rows*stride;
}

// square size callback
public void sqSize(int thisSize) {
  sqSize = thisSize;

  updateSize(thisSize);
  makeIllusion();
}

// shift delta callback
public void rowShift(float shFactor) {
  shiftFactor = shFactor;
  shiftDelta = (int) Math.round(shiftFactor * sqSize);
  updateSize(sqSize);
  makeIllusion();
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "CafeWall" });
  }
}
