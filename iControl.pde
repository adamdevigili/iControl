import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;

import gab.opencv.*;

import processing.video.*;

import java.awt.*;
import java.awt.Robot;
import java.awt.event.InputEvent;


/*
Proof of concept to show a potential point tracking system for mouse movement. This is intended in the future to be written 
in Python and used as a plugin for GNOME Mousetrap as a potentially faster and more accurate alternative to the current solution
which uses facial feature detection to determine the orientation of the head.

- Adam Devigili
- Western New England University
*/

Capture video;
OpenCV opencv;
Robot rob;

int windowSizeX = 640;
int windowSizeY = 480;

int curX, curY;
int xRatio, yRatio;
int lastX, lastY;
int newX, newY;

int aveLoc;

float level;

int clickCooldown;

PointBuffer points;

Minim minim;
AudioInput in;

void setup() {
  size(windowSizeX, windowSizeY);
  
  minim = new Minim(this);
  in = minim.getLineIn(Minim.STEREO, 512); 
  
  try
  {
    rob = new Robot();
  }
  catch (AWTException e)
  {
    println("Robot class not supported by your system!");
    exit();
  }
  
  points = new PointBuffer(7);
  
  rob.mouseMove(displayWidth/2, displayHeight/2);
  points.add(new Point(displayWidth/2, displayHeight/2));
  
  xRatio = displayWidth/windowSizeX;
  yRatio = displayHeight/windowSizeY;
  
  video = new Capture(this, windowSizeX/2, windowSizeY/2);
  opencv = new OpenCV(this, windowSizeX/2, windowSizeY/2);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  println(video.list()[0]);
  clickCooldown = 0;

  //scale(-1, 1);
  video.start();
}

void draw() {
  scale(2);
  opencv.loadImage(video);

  level = in.mix.level() * 450;
  /*
  if(level > 50 && clickCooldown > 20)
  {
    rob.mousePress(InputEvent.BUTTON1_MASK);
    delay(10);
    rob.mouseRelease(InputEvent.BUTTON1_MASK);
    println("CLICK!");
    clickCooldown = 0;
  }
  */


 
  clickCooldown++;
  image(video, 0, 0);

  PVector loc = opencv.max();
  
  
  
  
  noStroke();
  
  fill(255, 0, 0, 50);
  rect(0, 0, 160, 120);
  
  fill(255, 255, 0, 50);
  rect(160, 0, 320, 120);
  
  fill(0, 0, 255, 50);
  rect(160, 120, 320, 240);
  
  fill(0, 255, 0, 50);
  rect(0, 120, 160, 240);
  

  stroke(255, 0, 0);
  strokeWeight(5);

  point(loc.x, loc.y);

  Point newPoint = new Point(abs(int(2 * loc.x * xRatio-displayWidth)), int(2 * loc.y * yRatio));

  points.add(newPoint);
  
  //points.printBuffer();
  points.average();
  
  rob.mouseMove(points.average().x, points.average().y);

}

void captureEvent(Capture c) {
  c.read();
}
  
void keyPressed() {
  if(key == ESC)
    exit();
}

public class Point
{
  int x, y;
  public Point(int x, int y)
  {
    this.x = x;
    this.y = y;
  }
}

public class PointBuffer
{
  Point[] points;
  int numElements;
  int size;
  
  
  public PointBuffer(int size)
  {
    this.size = size;
    points = new Point[size];
    for(int i = 0; i < size; i++)
      points[i] = null;
      
    numElements = 0;
  }
  
  public int size()
  {
    int sum = 0;
    for(Point P : points)
    {
      if(P != null)
        sum++;
    }
    
    return sum;
  }
  
  public void add(Point P)
  {
    if(numElements == size) //if buffer is full
    {
      for(int i = 0; i < size - 1; i++)
      {
        points[i] = points[i + 1];
      }
      
      points[size - 1] = P;

    }
    else
    {
      points[numElements] = P;
      numElements++;
    }
  }
  
  public Point average()
  {
    int aveX = 0;
    int aveY = 0;
    for(Point P: points)
    {
      if(P != null)
      {
        aveX += P.x;
        aveY += P.y;
      }
      
    }
    
    aveX /= numElements;
    aveY /= numElements;  
    
    Point avePoint = new Point(aveX, aveY);
    
    return avePoint;
  }
  
  public void printBuffer()
  {
    print("[");
    for(Point P: points)
    {
      if(P != null)
      {
        print("(" + P.x + ", ", + P.y + "), ");
      }
        
    }
    
    print("]\n");
  }
  
}


