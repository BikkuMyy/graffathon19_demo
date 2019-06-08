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

void setup() {
    // Parameters: 
    // - PApplet
    // - soundtrack filename (relative to sketch's folder)
    // - beats per minute in the song
    // - how many rows in Rocket correspond to one beat
    moonlander = Moonlander.initWithSoundtrack(this, "../common/exit_the_premises.mp3", 128, 8);
    // moonlander = new Moonlander(this, new TimeController(4));

    // Other initialization code goes here.
    //fullScreen();
    size(640, 360);

    // Last thing in setup; start Moonlander. This either
    // connects to Rocket (development mode) or loads data 
    // from 'syncdata.rocket' (player mode).
    // Also, in player mode the music playback starts immediately.
    moonlander.start();
}

void draw() {
    // Handles communication with Rocket. In player mode
    // does nothing. Must be called at the beginning of draw().
    moonlander.update();
    
    //translate(width/2, height/2);
    //scale(height/1000.0);

    // This shows how you can query value of a track.
    // If track doesn't exist in Rocket, it's automatically
    // created.
    double bg_red = moonlander.getValue("background_red");

    // All values in Rocket are floats; however, there's 
    // a shortcut for querying integer value (getIntValue)
    // so you don't need to cast.
    int bg_green = moonlander.getIntValue("background_green");
    int bg_blue = moonlander.getIntValue("background_blue");
    
    // Use values to control anything (in this case, background color).
    background((int)bg_red, bg_blue, bg_green);
    
    //scene1();
    
    scene2();
    
    //scene3();

    // You can also ask current time and row from Moonlander if you
    // want to do something custom in code based on time.
}

void scene1(){
    int size = 5;
    //int size = moonlander.getIntValue("vertex");
    int n = 5;
    //int n = moonlander.getIntValue("n")
    float widthKerroin = 0.2;
    float heightKerroin = 0.2;

    for(float i=0; i <= 1.0; i+=widthKerroin){
      for (float j=0; j <= 1.0; j+=heightKerroin){
        drawTriangles(n, 0.2, i, j, size);
      }
    }
}

void scene2(){
  float insideRadius = (frameCount/20);
  float outsideRadius = (frameCount/20);
  for(int i=4; i <= 40; i+=2){
    pushMatrix();
    translate(width/2, height/2);
    rotate(frameCount / 10);
    triangleStrip(i, insideRadius, outsideRadius);
    
    insideRadius = 1.2*insideRadius;
    outsideRadius = 1.2*outsideRadius; 
    fill(colors[i % colors.length]);
    popMatrix();
  }
}

void scene3() {
  float div = 10.0;
    float vertexRadius = width/div;
    float edgeRadius = vertexRadius/2 * tan(TWO_PI/6);
    
    float radMod = (sin(frameCount/ 20.0) + 9.0)/10.0;
    float hPad = 1.5*vertexRadius;
    float wPad = 2*edgeRadius;
    
    int k = 0;
    
    for(float i = 0; i < height + hPad; i+= hPad) {
      if(k%2==0) {
        resetMatrix();
        
      } else {
       translate(edgeRadius, 0);
      }
      k++;
      for (float d =0; d <= width + wPad; d+= wPad) {
        pushMatrix();
        translate(d, i);
        //rotate(frameCount / 100.0);
        polygon(0, 0, radMod*vertexRadius, 6, PI/2);  // Hexagon 
        popMatrix();
      }
      
    }
}

void drawTriangles(int n, float multiplier, float widthKerroin, float heightKerroin, int size){
    int x = 0;
    int y = 0;
    float multip = 1;
    float rotation = (frameCount / -100.0);
    //float rotation = moonlander.getValue("rotation");
    
    pushMatrix();
    translate(width*widthKerroin, height*heightKerroin);
    rotate(rotation);
    for(int i=0; i < n; i++){ 
      polygon(x, y, multip*size, 3);
      fill(colors[i]);
      x+=20;
      y+=20;
      multip += multiplier;
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
