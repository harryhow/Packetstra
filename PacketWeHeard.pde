/**
* Notes and drawing are synchronised by the Draw framerate.
* Three SoundChiper instances are used to enable independent parts.
* Constrained randomness maintains a balance of order and variety.
* The music will continue as long as the drawing does.
*
* SoundCipher library example by Andrew R. Brown
*/

import arb.soundcipher.*;

SoundCipher sc = new SoundCipher(this);
SoundCipher sc2 = new SoundCipher(this);
SoundCipher sc3 = new SoundCipher(this);
SoundCipher sc4 = new SoundCipher(this);

//REVERSE_CYMBAL
float[] pitchSet = {57, 60, 60, 60, 62, 64, 67, 67, 69, 72, 72, 72, 74, 76, 76};
float setSize = pitchSet.length;
float keyRoot = 0;
float density = 0.8;

Table table;
int len;
int i=0;
int p=64;
ArrayList<String> traceSrc;
ArrayList<String> traceDes;
ArrayList<String> tracePrtc;
ArrayList<String> traceLen;

int totalNum = 0;
boolean colorSetOne, colorSetTwo, colorSetThree, whiteBG = false;
color strokeColor, shootColor, dotColor, hoverColor;
float connectionWeight, shootWeight, dotWeight, hoverWeight;


color [] colorList;

void setup() {
  int i=0;
  frameRate(4);
  size(1024, 768, P3D); 
  background(0);
  lights();
  colorSetOne = true;
  
  // setup csv from trace
  table = loadTable("wireshark.csv","header");
  totalNum = table.getRowCount();
  println(table.getRowCount() + " total rows in table"); 
  traceSrc = new ArrayList<String>();
  traceDes = new ArrayList<String>();
  tracePrtc = new ArrayList<String>();
  traceLen = new ArrayList<String>();

  
  
  for (TableRow row : table.rows()) {
    
    int time = row.getInt("Time");
    String source = row.getString("Source");
    String destination = row.getString("Destination");
    String protocol = row.getString("Protocol");
    String len = row.getString("Length");
    String info = row.getString("Info");
    traceSrc.add(source);
    traceDes.add(destination);
    tracePrtc.add(protocol);  
    traceLen.add(len);
    density = Integer.valueOf(len)/1000+0.8;
  }
  
  sc.instrument(sc.DRUM); // sound with drawing affected by density
  sc2.instrument(sc2.PIANO ); // TRANSPORTATION: TCP/UDP
  sc3.instrument(sc3.DOUBLE_BASS); // INTERNET: ICMP
  sc4.instrument(sc4.WOODBLOCKS /*VOICE*/); // APP: TLS/SSL/DNS/HTTP
  //REVERSE_CYMBAL
  

  //createStrokeColorsAndWeights();
  //createColorList();
}

void draw() {
  String s1 = "                   ";
    
  int pLen = Integer.valueOf(traceLen.get(i));
  if (random(1) < density) {
    //println("draw...");
    sc.playNote(pitchSet[(int)random(setSize)]+keyRoot, pLen/100, random(20)/10 + 0.2);
    // color matching
    // HTTP, IGMPv2, SSDP, DB-LSP-DISC, MDNS
    if (tracePrtc.get(i).equals("TCP")) {// TRANSPORT layer, b
      stroke(4,157,191,100);
    } else if (tracePrtc.get(i).equals("TLSv1")){ // APP layer, r
      stroke(243,151,74,100);
    } else if (tracePrtc.get(i).equals("TLSv1.2")){ // APP layer, r
      stroke(163,3,5,100);
    } else if (tracePrtc.get(i).equals("DNS")){ // App Layer, r
      stroke(141,2,0,100);
    } else if (tracePrtc.get(i).equals("HTTP")){ // App Layer, r
      stroke(245,15,28,100);
    } else if (tracePrtc.get(i).equals("ICMP")){ // INTERNET Layer, y
      stroke(249,227,14,100);
    }
    else
      stroke(64,63,64,100);
  }    
      
  noFill();
  ellipse(width/2+(i%random(1000)), height/2, float(pLen), float(pLen));
    
  if (tracePrtc.get(i).equals("TCP")) {
    println("TRANS layer");
    keyRoot = (random(4)-2)*pLen%10;
    density = random(pLen) / 10 + 0.3;
    sc2.playNote(36+keyRoot, pLen, pLen%8.0);
  } else if (tracePrtc.get(i).equals("TLSv1") || tracePrtc.get(i).equals("TLSv1.2") || tracePrtc.get(i).equals("DNS") || tracePrtc.get(i).equals("HTTP")){
    println("APP layer");
    float[] pitches = {pitchSet[(int)random(setSize)]+keyRoot+12, pitchSet[(int)random(setSize)]+keyRoot+12};
    sc4.playChord(pitches, pLen, 4.0);
  } else if (tracePrtc.get(i).equals("ICMP")) {
    println("INT layer");
    keyRoot = (random(4)-2)*pLen%5;
    density = random(pLen) / 10 + 0.3;
    sc3.playNote(16+keyRoot, pLen, pLen%4.0);
  }
  
  // pan, more duplicated destination more pan to right 
  if (p > 127 || p < 0)
      p = 64;

  if (traceDes.get(i).equals(traceDes.get(i+1))){
     println("same destination");
     if (p < 98)
       p+=30;
  }
  else if (!traceDes.get(i).equals(traceDes.get(i+1))){
    //println("different destination");
    if ((p > 20 && p < 60) || (p > 80 && p < 128))
      p-=20;
    
  }
  sc.pan(p);
  sc2.pan(p);
  sc3.pan(p);
  sc4.pan(p);
  
  String s = "i:"+i+" ,len:"+pLen;
  i++;
    
}    
//  if (frameCount%32 == 0) {
//    keyRoot = (random(4)-2)*2;
//    density = random(7) / 10 + 0.3;
//    sc2.playNote(36+keyRoot, random(40) + 70, 8.0);
//  }
//  if (frameCount%16 == 0) {
//    float[] pitches = {pitchSet[(int)random(setSize)]+keyRoot-12, pitchSet[(int)random(setSize)]+keyRoot-12};
//    sc3.playChord(pitches, random(50)+30, 4.0);
//   }


/*
 void createColorList ()
  {
    for (int i = 0; i < totalNum+1; i++)
    {
      float maxA = 10+i*totalNum;
      float minA = 8+i*2;
 
      if (colorSetOne) colorList [i] = color (random (10,80), random (10,80), random (10,80), random (minA,maxA));
 
      if (colorSetTwo)
      {
        maxA = 255;
        minA = 120;
 
        colorList [i] = color ( random (5, 247+i*totalNum*5), random (minA,maxA));
      }
 
 
      if (colorSetThree)
      {
        minA = 240-i*totalNum*5;
        maxA = 247-i*3;
 
        colorList [i] = color (random (50,230), random (50,230), random (50,120), random (minA,maxA));
      }
    }
  }
 
  void createStrokeColorsAndWeights ()
  {
    if (colorSetOne)
    {
      if (whiteBG)
      {
        strokeColor = color (0,50);
        dotColor = strokeColor;
        shootColor  = color (0,150);
        hoverColor = color (0,120);
        connectionWeight = 0.5;
        shootWeight = 1.0;
        dotWeight = 10;
        hoverWeight = 3.0;
      }
      else
      {
        strokeColor = color (255,80);
        dotColor = color (255,120);
        hoverColor = color (255,150);
        shootColor = color (255, 180);
        connectionWeight = 0.75;
        dotWeight = 10;
        shootWeight = 1.25;
        hoverWeight = 3.0;
      }
    }
 
    if (colorSetTwo)
    {
      if (whiteBG)
      {
        strokeColor = color (0,20);
        dotColor = color (180,0,0,180);
        shootColor = color (180,0,0,180);
        hoverColor = color (180,0,0,180);
        connectionWeight = 3.0;
        shootWeight = 3;
        dotWeight = 10;
        hoverWeight = 4.0;
      }
      else
      {
        strokeColor = color (255,80);
        dotColor = color (180,0,0,150);
        shootColor = color (180,0,0,150);
        hoverColor = color (180,0,0,150);
        connectionWeight = 3.0;
        dotWeight = 10;
        shootWeight = 3.0;
        hoverWeight = 4.0;
      }
    }
 
    if (colorSetThree)
    {
      if (whiteBG)
      {
        strokeColor = color (colorList[0]);
        dotColor = color (0,200);
        shootColor = color (0,200);
        hoverColor = color (0,200);
        connectionWeight = 1.0;
        shootWeight = 2.0;
        dotWeight = 10;
        hoverWeight = 4.0;
      }
      else
      {
        strokeColor = color (colorList[0]);
        dotColor = color (255,200);
        shootColor = color (255,180);
        hoverColor = color (255,180);
        connectionWeight = 1.5;
        dotWeight = 10;
        shootWeight = 2.0;
        hoverWeight = 4.0;
      }
    }
  }
*/
