import KinectPV2.*;
KinectPV2 kinect2;
PImage img;
ParticleSystem ps;
Particle p ;
int offset;
float minThresh = 518;
float maxThresh = 1184;
int d;
int particleDensity;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;


import de.voidplus.leapmotion.*;


LeapMotion leap;

Minim minim;
AudioPlayer player;

void setup() {
  size(1920, 1200, P3D);
  frameRate(60);
  kinect2 = new KinectPV2(this);
 
  kinect2 = new KinectPV2(this);
  kinect2.enableDepthImg(true);
 img = createImage(kinect2.getDepthImage().width, kinect2.getDepthImage().height, RGB);
  println(img.width, img.height);
  kinect2.init();
  ps = new ParticleSystem();
 
 
  particleDensity =50;
  
   minim = new Minim( this );
  player = minim.loadFile("sound.mp3");
  player.play();
}


 
void draw() {
  background(0);
 // img.loadPixels();
 
 
  int[] depth = kinect2.getRawDepthData();
 
 
  // image(img,0,0);
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height; y ++) {
      offset = x + y*img.width;
      d = depth[offset];
      if (d> minThresh && d< maxThresh&& offset%300==30) {
        //int r =int(random(0, 255)) ;
        //int g =int(random(0, 255));
        //int b =int(random(0, 255));
        // img.pixels[offset] = color(r, g, b);
       // img.pixels[offset] = color(255, 0, 150); 
       
        ps.addParticle(new PVector(x, y));
        ps.run();
        
       
      } else {
        img.pixels[offset] = color(255);
      }
    }
  }
 
  img.updatePixels();

 
}
class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
 
  float lifespan;
  Particle(PVector l) {
    // The acceleration
    acceleration = new PVector(0, 0);
    // circel's x and y ==> range
    velocity = new PVector(0,0);
    // apawn's position
    location = l.copy();
    // the circle life time
    lifespan = 255.0;
  }
  void run() {
    update();
    display();
  }
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan-=9.0;
    
  }
 
  boolean isDead() {
    if (lifespan <= 0) {
      return true;
    } else {
      return false;
    }
  }
  void display() {
    
  // stroke(0, lifespan);
    // border's weight
    //strokeWeight(3);
  
    float r = random(0,255);
    float g = random(0,255);
    float b = random(0,255);
    
 
    //fill(r,g,b);

 //noStroke();

   
//strokeWeight(abs(player.left.get(o)*200));
strokeWeight(3);
 
   // stroke(r,g,b,250);
  stroke(r,250);
    
    fill(0);
   //rect(location.x*3.5, location.y*3,,10);
 int o=player.left.size()/30;
    ellipse(location.x*3.5, location.y*3,abs(player.left.get(o)*200),abs(player.left.get(o)*200));
  }
}// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 
 
class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
 
  ParticleSystem() {
    particles = new ArrayList<Particle>();
  }
 
  void addParticle(PVector position) {
    origin = position.copy();
    particles.add(new Particle(origin));
  }
 
  void run() {
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}

// Reference Code:
//http://codigogenerativo.com/code/kinectpv2-k4w2-processing-library/
//https://blog.csdn.net/Hewes/article/details/82971486
//https://processing.org/discourse/beta/num_1229300351.html
//https://github.com/msp/CANKinectPhysics
//http://studio.sketchpad.cc/ra7zG2hFWd?&clonePadId=ro.SG9ruRMd-X4&cloneRevNum=47
//https://github.com/enauman/CANKinectPhysics/tree/master/ComExample03_Physics
