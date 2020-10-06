color drawColor;
int pixelSize = 16;
int colorIndex = 0;
color[] colors = {
  #000000, #0000AA, #00AA00, #00AAAA, 
  #AA0000, #AA00AA, #AA5500, #AAAAAA, 
  #555555, #5555FF, #55FF55, #55FFFF, 
  #FF5555, #FF55FF, #FFFF55, #FFFFFF};
  
PImage img;

String mode = "sheet";

color[] sprite;
color[] sheet = new color[65536];
int sheetIndex = 0;

void setup() {
  size(640, 480);
  background(255);
  
  drawColor = colors[colorIndex];  
  
  strokeWeight(3);
  
  //for (int i = 0; i < 65536; i++){
  //  sheet[i] = colors[(i % 256)/16];
  //}
  
  loadSheet();
}

void draw() {
  background(255);
  if (mode == "sprite"){
    drawSprite();
    drawPalette();
  } else if (mode == "sheet") {
    drawSheet();
  }
}

void mouseDragged() {
  if (mode == "sprite"){
    drawPixel();
  } else if (mode == "sheet") {
    
  }
}

void mousePressed() {
  if (mode == "sprite"){
    drawPixel();
  }
}

void drawPixel() {
  // in the range
  if(mouseX < 256 && mouseY < 256) {
    sprite[(mouseY/pixelSize)*pixelSize+ mouseX/pixelSize] = drawColor;      
  }
}

void keyPressed() {
  if (mode == "sprite"){
    if (key == CODED) {
      if (keyCode == RIGHT) {
        if (colorIndex != 7 && colorIndex!= 15) {
          colorIndex++;
        }   
      }else if (keyCode == LEFT) {
        if (colorIndex != 0 && colorIndex!= 8) {
          colorIndex--;
        } 
      } else if (keyCode == UP) {
        if (colorIndex >= 8) {
          colorIndex-=8;
        } 
      } else if (keyCode == DOWN) {
        if (colorIndex < 8) {
          colorIndex+=8;
        } 
      }
      drawColor = colors[colorIndex];
    }
    else {
      if (key == ENTER || key == RETURN) {
        saveSprite();
      }
    }
  } else if (mode == "sheet") {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        if (sheetIndex%16 != 15) {
          sheetIndex++;
        }   
      }else if (keyCode == LEFT) {
        if (sheetIndex%16 != 0) {
          sheetIndex--;
        } 
      } else if (keyCode == UP) {
        if (sheetIndex >= 16) {
          sheetIndex-=16;
        } 
      } else if (keyCode == DOWN) {
        if (sheetIndex < 240) {
          sheetIndex+=16;
        } 
      }
    } else {
      if (key == ENTER || key == RETURN) {
        loadSprite();
      } else if (key == 's') {
        saveSheet();
      }
    }
  }
}

void drawPalette() {  
  noStroke();
  fill(255);
  rect(256, 0, width-256, 100); 
  int y = 5;
  for(int i = 0; i < 16; i++) {
    fill(colors[i]);
    //x = (i % num per row) * size of pixel + offset
    //y = (i / num per row) * size of pixel + offset
    rect((i%8)*32 + 272, (i/8)*32+5, 32, 32);
  }
  stroke(0);
  fill(colors[colorIndex]);
  rect((colorIndex%8)*32 + 272, (colorIndex/8)*32+5, 32, 32);
} 

void drawSprite() {
  noStroke();
  fill(0);
  rect(0,0,256,256);
  for(int i = 0; i < sprite.length; i++) {
    fill(sprite[i]);
    rect((i%pixelSize)*16, (i/pixelSize)*16, pixelSize, pixelSize);
  }
}

void drawSheet() {
  noStroke();
  for(int i = 0; i < sheet.length; i++) {
    fill(sheet[i]);
    rect(i%256+16, i/256+16, 1, 1);
    // stroke(sheet[i]);
    // point(i%256+16, i/256+16);
  }
  stroke(#FFFFFF);
  fill(0,0);
  rect((sheetIndex%16)*16+16, (sheetIndex/16)*16+16, 16, 16);
}

// loads sprite edit mode
void loadSprite() {
  sprite = new color[256];
  // horrizontal in row
  int bigX = (sheetIndex%16)*16;
  // how many rows
  int bigY = (sheetIndex/16)*16;
  // 0,0 for sprite
  int first = bigX + (bigY*256);
  
  for (int i = 0; i < 256; i++) {
    // local x
    int x = i%16;
    // local y
    int y = i/16;
    sprite[i] = sheet[first + x + (y*256)];
  }
  mode = "sprite";
}

void saveSprite() {
  // horrizontal in row
  int bigX = (sheetIndex%16)*16;
  // how many rows
  int bigY = (sheetIndex/16)*16;
  // 0,0 for sprite
  int first = bigX + (bigY*256);
  
  for (int i = 0; i < 256; i++) {
    // local x
    int x = i%16;
    // local y
    int y = i/16;
    sheet[first + x + (y*256)] = sprite[i];
  }
  
  mode = "sheet";
}

void saveSheet() {
  img = createImage(256, 256, RGB);
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++){
    img.pixels[i] = sheet[i];
  }
  img.updatePixels();
  img.save("test.png");
}

void loadSheet() {
  img = loadImage("test.png");
  img.loadPixels();
  for (int i = 0; i < img.pixels.length; i++){
    sheet[i] = img.pixels[i];
  }
}
