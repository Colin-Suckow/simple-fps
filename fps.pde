static int displayWidth = 512;
static int displayHeight = 512;

static int mapHeight = 16;
static int mapWidth = 16;

static int minimapHeight = 128;
static int minimapWidth = 128;

//Only works with square screen and map right now
static int tileWidth = displayWidth / mapWidth;

//Define map data
// # = Wall
// . = Empty Space
String[] map = {
  "################",
  "#..............#",
  "#..............#",
  "#..............#",
  "#..............#",
  "#.......#......#",
  "#.......#......#",
  "#.......#......#",
  "#.......#......#",
  "#..............#",
  "#..............#",
  "#..............#",
  "#..............#",
  "#..............#",
  "#..............#",
  "################"
};

//player position
float playerX;
float playerY;
float playerA;

//player properties
float playerFov = 110; //degrees
int maxRenderDistance = 20;

int tileSize = (minimapWidth / mapWidth);

int maxWallHeight = 500;

void setup() {
  size(displayWidth, displayHeight);
  //Start player 3 tiles down and from the right of the top left corner
  playerX = 3;
  playerY = 3;
  playerA = 0;
};

void draw() {
  //Clear screen
  background(BLACK);
  
  //Handle player input
  handleInput();
  enforceBoundary();
  
  float checkInterval = 0.1; //Increase to increase resolution of raycast
   //Draw walls
  for(int i = 0; i < displayWidth; i++) {
    float checkX = playerX;
    float checkY = playerY;
    float rayLength = 0;
    
    boolean wallHit = false;
    int roundCheckX;
    int roundCheckY;
    while(!wallHit) {
      roundCheckX = round(checkX);
      roundCheckY = round(checkY);
      
      if(rayLength >= maxRenderDistance) {
        wallHit = true;
        //print("Maxed out \n");
      }
      
      if (str(map[roundCheckY].charAt(roundCheckX)).equals("#")) {
        wallHit = true;
        //print("Hit!\n");
      } else {
        rayLength += checkInterval;
        checkX += cos( (playerA - (radians(playerFov) / 2)) + (radians(playerFov / displayWidth) * i) );
        checkY += sin( (playerA - (radians(playerFov) / 2)) + (radians(playerFov / displayWidth) * i) );
      }
    }
    
    if(rayLength < 1000) {
      drawSlice(i, round(maxWallHeight / rayLength), color(0, round(200 - rayLength * 100), 0));
      //print("Raylength: " + str(rayLength) + "\n");
      //print("Drew slice at: " + str(i) + "\n");
    }
    
  }
  
  //Draw minimap
  for(int y = 0; y < map.length; y++) {
    for(int x = 0; x < map[y].length(); x++) {
      //print("X: " + str(x) + " Y: " + str(y) + "\n");
      int startX = x * tileSize;
      int startY = y * tileSize;
      if(str(map[y].charAt(x)).equals("#")) {
        fill(WHITE);
        stroke(WHITE);
        rect(startX, startY, tileSize, tileSize);
      } 
    }
  }
  
  //Draw minimap player position
  fill(WHITE);
  ellipse(playerX * tileSize - 5, playerY * tileSize - 5, 10, 10);
  stroke(RED);
  line(playerX * tileSize - 5, playerY * tileSize - 5, playerX * tileSize - 5 + cos(playerA) * 20, playerY * tileSize - 5 + sin(playerA) * 20);
  //Draw FOV lines on minimap
  stroke(GREEN);
  line(playerX * tileSize - 5, playerY * tileSize - 5, playerX * tileSize - 5 + cos(playerA - (radians(playerFov) / 2)) * 50, playerY * tileSize - 5 + sin(playerA - (radians(playerFov) / 2)) * 50);
  line(playerX * tileSize - 5, playerY * tileSize - 5, playerX * tileSize - 5 + cos(playerA + (radians(playerFov) / 2)) * 50, playerY * tileSize - 5 + sin(playerA + (radians(playerFov) / 2)) * 50);
  
  
 //Draw fps
 fill(RED);
 text(round(frameRate), displayWidth - 20, 15);
};


void drawSlice(int x, int height, color sliceColor) {
  stroke(sliceColor);
  fill(sliceColor);
  line(x, displayHeight / 2 - height / 2, x, displayHeight / 2 + height / 2);
}

void handleInput() {
    if(keyPressed) {
    if (key == 'w') {
      playerX += cos(playerA) * 0.1;
      playerY += sin(playerA) * 0.1;
    }
    
    if (key == 's') {
      playerX -= cos(playerA) * 0.1;
      playerY -= sin(playerA) * 0.1;
    }
    
    if (key == 'a') {
      playerA -= 0.07;
    }
    
     if (key == 'd') {
      playerA += 0.07;
    }
  }
}

void enforceBoundary() {
  if(playerX > mapWidth -1) {playerX = mapWidth -1;}
  if(playerX < 0) {playerX = 0;}
  if(playerY > mapHeight -1) {playerY = mapHeight -1;}
  if(playerY < 0) {playerY = 0;}
}





//Color definitions
color RED = color(255, 0, 0);
color GREEN = color(0, 255, 0);
color BLUE = color(0, 0, 255);
color BLACK = color(0, 0, 0);
color WHITE = color(255, 255, 255);
