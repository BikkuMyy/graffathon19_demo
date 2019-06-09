import moonlander.library.*;

// Minim must be imported when using Moonlander with soundtrack.
import ddf.minim.*;

Moonlander moonlander;

color c1 = #A19EFF;
color c2 = #94CCEB;
color c3 = #8CFFD7;
color c4 = #A1F598;
color c5 = #FFFF80;

color[] colors = new color[]{c1, c2, c3, c4, c5};

int bg_red = 0;
int bg_green = 0;
int bg_blue = 0;

void setup() {
    // Parameters: 
    // - PApplet
    // - soundtrack filename (relative to sketch's folder)
    // - beats per minute in the song
    // - how many rows in Rocket correspond to one beat
    moonlander = Moonlander.initWithSoundtrack(this, "data/exit_the_premises_short.mp3", 128, 8);
    // moonlander = new Moonlander(this, new TimeController(4));

    // Other initialization code goes here.
    //fullScreen();
    size(640, 360);
    background(0);
    noCursor();
    moonlander.start("localhost", 1338, "data/syncdata.rocket");
}

void draw() {
    // Handles communication with Rocket. In player mode
    // does nothing. Must be called at the beginning of draw().
    moonlander.update();
    //background(0);
    
    int scene = moonlander.getIntValue("scene");

    if (scene == 0) {
      intro();
    } else if (scene == 1){
      scene1();
    } else if (scene == 2){
      scene2();
    } else if (scene == 3){
      scene3();
    } else if (scene == 4){
      scene4();
    } else if (scene == 5){
      scene5();
    } else if (scene == 6){
      scene6();
    }

}

void scene1(){
  hexagonGrid();
}

void scene2(){
  drawManyTriangles();
}

void scene3(){
    background(0);
    int size = 5;
    //int size = moonlander.getIntValue("size");
    int n = 5;
    //int n = moonlander.getIntValue("n")
    float trianglesX = 0.01*width;
    float trianglesY = 0.01*height;
    float widthKerroin = 1 / trianglesX;
    float heightKerroin = 1 / trianglesY;

    for(float i=0; i <= 1; i+=widthKerroin){
      for (float j=0; j <= 1; j+=heightKerroin){ 
        drawTriangles(n, i, j, size);
      }
    }
}

void scene4(){
  background(0);
  int startRow = 872;
  int rowDelta = (int) moonlander.getCurrentRow() - startRow + 50;
  float insideRadius = (rowDelta/10);
  float outsideRadius = (rowDelta/10);
  for(int i=4; i <= 40; i+=2){
    pushMatrix();
    translate(width/2, height/2);
    rotate(frameCount);
    triangleStrip(i, insideRadius, outsideRadius);
    
    insideRadius = 1.2*insideRadius;
    outsideRadius = 1.2*outsideRadius; 
    fill(colors[i % colors.length]);
    popMatrix();
  }
}

void scene5() {
  expandingCircle();
}

double startRow5 = -1;

void scene6() {
  background(0);
  if (startRow5 == -1) {
    startRow5 = moonlander.getCurrentTime();
  }
  
  float deltaRow = (float)(startRow5 - moonlander.getCurrentTime())/2.13;
  
  int state = moonlander.getIntValue("state");
  float div = (state + 1)*10.0;
  float vertexRadius = width/div;
  float edgeRadius = vertexRadius/2 * tan(TWO_PI/6);
  
  float radMod = (cos(4*(float)deltaRow) + 9)/10.0;
  float hPad = 1.5*vertexRadius;
  float wPad = 2*edgeRadius;
  
  int k = 0;
  int p = 0;
  int n = 0;
  
  for(float i = 0; i < height + hPad; i+= hPad) {
    if(k%2==0) {
      resetMatrix();
      
    } else {
     translate(edgeRadius, 0);
    }
    
    for (float d =0; d <= width + wPad; d+= wPad) {
      pushMatrix();
      translate(d, i);
      if (state >= 1) {
        rotate(-(2.0/3)*deltaRow);
      }
      
      if(state <= 1) {
        fill(colors[4]);
      } else if (state == 2) {
        fill(colors[(k%5)]);
        //fill(colors[(int)random(5)]); 
      } else if(state >= 3) {
        fill(colors[((k*n + p)%5)]);
      }
      
      
      polygon(0, 0, radMod*vertexRadius, 6, PI/2);  // Hexagon 
      popMatrix();
      
      p++;
    }
    k++;
    n = max(k, n);
  }
}

void drawTriangles(int n, float widthKerroin, float heightKerroin, int size){
    int x = 0;
    int y = 0;
    float multip = 0.001*height ;
    float rowCount = (float)moonlander.getCurrentRow() * 8;
    float rotation = (sin(rowCount/ 25.0) + sin(rowCount/ -75.0));

    pushMatrix();
    translate(width*widthKerroin, height*heightKerroin);
    rotate(rotation);
    for(int i=0; i <= n; i++){ 
      polygon(x, y, multip*size, 3);
      fill(colors[i % colors.length]);
      x+=20;
      y+=20;
      multip += 0.1;
    }
    popMatrix();
    
}

void polygon(float x, float y, float radius, int npoints, float sAngle) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = sAngle; a < TWO_PI + sAngle; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void polygon(float x, float y, float radius, int npoints) {
  polygon(x, y, radius, npoints, 0);  
}

void triangleStrip(int sides, float outsideRadius, float insideRadius){
    int x = 0;
    int y = 0;
    //int sides = moonlander.getIntValue("sides");
    float angle = 0;
    float angleStep = 180.0 / sides;
    
    beginShape(TRIANGLE_STRIP); 
    for (int i = 0; i <= sides; i++) {
      float px = x + cos(radians(angle)) * outsideRadius;
      float py = y + sin(radians(angle)) * outsideRadius;
      angle += angleStep;
      vertex(px, py);
      px = x + cos(radians(angle)) * insideRadius;
      py = y + sin(radians(angle)) * insideRadius;
      vertex(px, py); 
      angle += angleStep;
    }
    endShape();
}

void drawManyTriangles(){
  int row = (int) moonlander.getCurrentRow();
  //check exact row
  if(row >= 384){
    drawColorfulTriangles();
  } else {
    drawBlackTriangles();
  }
}

void drawColorfulTriangles(){
  int startRow = 248;
  int rowDelta = (int) moonlander.getCurrentRow() - startRow;
  float randX = random(width);
  float randY = random(height);
  for(int i=0; i<=rowDelta; i++){
    polygon(randX, randY, random(width*0.1), 3);
    fill(colors[(int)random(5)]);
    
  }
}

void drawBlackTriangles(){
  float randX = random(width);
  float randY = random(height);
  polygon(randX, randY, random(width*0.2), 3);
  fill(random(150), random(150));
}

void expandingCircle(){
  //background(0);
  int startRow = 1384;
  int size = ((int)moonlander.getCurrentRow() - startRow)*width/16;
  fill(255);
  circle(width/2, height/2, size);
}

void hexagonGrid(){
   int startRow = 136;
   int row = (int) moonlander.getCurrentRow();
   //tie speed to the width
   int x = (row - startRow)*(width/64);
   float max_distance = dist(0, 0, width, height);
   if (row % 2 == 0){
     for(int i = 0; i <= x; i += 20) {
      for(int j = 0; j <= height; j += 20) {
        float size = dist(x, height-j, i, j);
        size = size/max_distance * 15;
        polygon(i, j, size, 6);
        fill(colors[(int)random(5)]);
      }
    }
  }
}

void intro() {
  background(bg_red, bg_green, bg_blue);
  boolean blink = moonlander.getIntValue("beat") == 1;
  blinkScreen(blink);
}

void blinkScreen(boolean blink) {
  int k = 10;
  if(blink) {
    bg_red =255; bg_green=255; bg_blue=255; 
  } else {
    bg_red -=k; bg_green-=k; bg_blue-=k; 
  }

}
