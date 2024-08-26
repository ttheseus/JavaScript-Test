import processing.sound.*;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////// Global Variables /////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Scene Control
int sceneNum = 0;
boolean badEnd = false;
boolean goodEnd = false;

// Character Animation and Control
PImage character; // current frame
PImage charWalk[] = new PImage[8]; //0 and 4 stationary, 0-3 right facing, 4-7 left facing
PImage charBully[] = new PImage[4]; //0-1 right facing, 1-2 left facing

boolean jumping = false;
boolean jump2 = false;
boolean move = false;
boolean facingRight = true;
boolean paused = false;
int locationX = -80;
int locationY = 466;
int charRelativeX;
int speedY = 0;
int frame = 0;

// Backgrounds
PImage menu;
PImage menuText[] = new PImage[5]; // Menu and start screen
/*
0: blank
 1: start
 2: instructions
 3: developer
 */
PImage instructions;
PImage devMenu;
PImage devText[] = new PImage[6];
/*
 0: scene 1
 1: parkour 1
 2: parkour 2
 3: light puzzle
 4: hangman puzzle
 5: escape
 */

PImage scene1;
PImage scene2_1;
PImage scene2_2;
PImage scene3;
PImage scene4;
PImage scene5;
PImage badEnding;
PImage goodEnding;

PImage Back;
PImage BackSelected;

// Environment
int backgroundX = 0;
int MouseRelativeX;
float timer = 0;
float timerLight = 0;
boolean end[] = {false, false}; // 0 = good ending, 1 is bad end
PFont text;
boolean p1;
boolean p2;
boolean p3;
boolean p4;

PImage lights[] = new PImage[3];
/*
0: first light
 1: second light
 2: third light
 */

// Hangman level
String database[] = { "danger", "darkness", "destruct", "midnight", "nihilism", "shadow", "twilight" };
int databaseIndex[] = { 1, 2, 3, 4, 5, 6, 7 };
boolean databaseLetters[] = { true, false, false, false, false, true, false }; // true = 6 letters, false = 8 letters

boolean lettersTrue[] = new boolean[6];
boolean lettersFalse[] = new boolean[8];

//boolean correct;
//int wrongN = 0;
boolean firstGuess = true;

String guess = "";
String savedGuess = "";

PImage head;
PImage body;
PImage armL;
PImage armR;
PImage legL;
PImage legR;

// Music
boolean play1 = true;
SoundFile theme;
SoundFile start;
SoundFile bad;
SoundFile good;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// Prelims //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void setup() {
  size(800, 800);
  background(255);
  frameRate(20);

  // Font
  text = createFont("Arial Narrow", 25);

  // Character Animation
  charWalk[0] = loadImage("CHAR_walk1R.PNG");
  charWalk[1] = loadImage("CHAR_walk2R.PNG");
  charWalk[2] = loadImage("CHAR_walk3R.PNG");
  charWalk[3] = loadImage("CHAR_walk4R.PNG");
  charWalk[4] = loadImage("CHAR_walk1L.PNG");
  charWalk[5] = loadImage("CHAR_walk2L.PNG");
  charWalk[6] = loadImage("CHAR_walk3L.PNG");
  charWalk[7] = loadImage("CHAR_walk4L.PNG");
  character = charWalk[0];

  // main menu and start screen
  menu = loadImage("Menu.png");
  menuText[0] = loadImage("Text_Blank.png");
  menuText[1] = loadImage("Text_Start.png");
  menuText[2] = loadImage("Text_Instructions.png");
  menuText[3] = loadImage("Text_Developer.png");

  devMenu = loadImage("IMG_2057.PNG");
  devText[0] = loadImage("IMG_2058.PNG");
  devText[1] = loadImage("IMG_2059.PNG");
  devText[2] = loadImage("IMG_2060.PNG");
  devText[3] = loadImage("IMG_2061.PNG");
  devText[4] = loadImage("IMG_2062.PNG");
  devText[5] = loadImage("IMG_2063.PNG");

  // menu sublevels
  instructions = loadImage("Instructions.png");
  //devMenu = loadImage("");

  // back buttons
  Back = loadImage("IMG_1994.PNG");
  BackSelected = loadImage("IMG_1995.PNG");

  // scenes
  scene1 = loadImage("Scene1.png");
  scene2_1 = loadImage("Platform_Game.png");
  scene2_2 = loadImage("Platform_Game2.png");
  scene3 = loadImage("IMG_2020.PNG");
  scene4 = loadImage("Hangman.png");
  scene5 = loadImage("Escape.png");
  badEnding = loadImage("Bad_End.png");
  goodEnding = loadImage("Good_End.png");

  // lights
  lights[0] = loadImage("Lights_1.png");
  lights[1] = loadImage("Lights_2.png");
  lights[2] = loadImage("Lights_3.png");

  // hangman
  head = loadImage("head.PNG");
  body = loadImage("body.PNG");
  armL = loadImage("armL.PNG");
  armR = loadImage("armR.PNG");
  legL = loadImage("legL.PNG");
  legR = loadImage("legR.PNG");

  // music
  theme = new SoundFile(this, "BlindAlley_IB.mp3");
  bad = new SoundFile(this, "01 Dining Room (Ib OST).mp3");
  start = new SoundFile(this, "Theme_IB.mp3");
  good = new SoundFile(this, "Memory_IB.mp3");
} // End setup

void draw() {
  MouseRelativeX = abs(backgroundX) + mouseX;
  charRelativeX = abs(backgroundX) + locationX; // referenced from a previous project to find the character's location relative to the background

  timer += 0.01;
  textFont(text);
  textSize(25);
  fill(245, 202, 122);

  if (!theme.isPlaying() && sceneNum >= 1 && sceneNum <= 7) {
    loop();
    theme.play();
  }

  if (!start.isPlaying() && sceneNum <= 0) {
    loop();
    start.play();
  }

  if (sceneNum == 0) {
    menu();
  } else if (sceneNum == -2) {
    devMenu();
  } else if (sceneNum == -1) {
    instructions();
  } else if (sceneNum == 1) {
    scene1();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 2) {
    scene2();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 3) {
    scene2_2();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 4) {
    scene3();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 5) {
    scene4();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 6) {
    scene5();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 7) {
    scene6();
    darkText();
    if (start.isPlaying()) {
      start.stop();
    }
  } else if (sceneNum == 8) {
    badEnd();
    if (theme.isPlaying()) {
      theme.stop();
    } else {
      if (!bad.isPlaying() && sceneNum == 8) {
        loop();
        bad.play();
      }
    }
  } else if (sceneNum == 9) {
    goodEnd();
    if (theme.isPlaying()) {
      theme.stop();
    } else {
      if (!good.isPlaying() && sceneNum == 9) {
        loop();
        good.play();
      }
    }
  }
} // end draw

void mousePressed() {

  println(mouseX, mouseY);
  println(MouseRelativeX);
  println(charRelativeX);
  println(locationX);

  //(this used to find character/object locations and is not part of gameplay)


  if (sceneNum == 0) {
    if (mouseX >= 62 && mouseX <= 179 && mouseY >= 520 && mouseY <= 590) {
      sceneNum = 1;
      scene1();
    } else if (mouseX >= 60 && mouseX <= 325 && mouseY >= 600 && mouseY <= 666) {
      sceneNum = -1;
      instructions();
    } else if (mouseX >= 60 && mouseX <= 270 && mouseY >= 680 && mouseY <= 740) {
      sceneNum = -2;
      devMenu();
    }
  } // main menu

  if (sceneNum == -2) {
    if (mouseX >= 336 && mouseX <= 454 && mouseY >= 163 && mouseY <= 209)
      sceneNum = 1;
    else if (mouseX >= 318 && mouseX <= 474 && mouseY >= 266 && mouseY <= 299)
      sceneNum = 2;
    else if (mouseX >= 318 && mouseX <= 474 && mouseY >= 366 && mouseY <= 399)
      sceneNum = 3;
    else if (mouseX >= 302 && mouseX <= 498 && mouseY >= 457 && mouseY <= 498)
      sceneNum = 4;
    else if (mouseX >= 268 && mouseX <= 528 && mouseY >= 561 && mouseY <= 594)
      sceneNum = 5;
    else if (mouseX >= 348 && mouseX <= 454 && mouseY >= 657 && mouseY <= 694)
      sceneNum = 6;
  }

  if (sceneNum == -1) {
    if (mouseX >= 594 && mouseX <= 723 && mouseY >= 680 && mouseY <= 741) {
      sceneNum = 0;
    } // Back button
  }

  if (sceneNum == -2) {
    if (mouseX >= 594 && mouseX <= 723 && mouseY >= 680 && mouseY <= 741) {
      sceneNum = 0;
    } // Back button
  }
} // end mousePressed

void keyPressed() {
  if (!paused) {
    if (keyCode == RIGHT) {
      move = true;
      facingRight = true;
    } else if (keyCode == LEFT) {
      move = true;
      facingRight = false;
    } else if (key == ' ') {
      jumping = true;
      speedY = -40;
      /*if (key == ' ') {
       jump(2);
       }*/
    }
  }
  if (sceneNum == 5) {
    if (key == '\n') {
      savedGuess = guess;
      guess = "";
      firstGuess = false;
    } else {
      if (!(keyCode == LEFT) && !(keyCode == RIGHT)) {
        guess = guess + key;
      }
    }
  }
  if (key == 'n' && !(sceneNum == 5)) {
    sceneNum++;
  } else if (key == 'b' && !(sceneNum == 5)) {
    sceneNum = -2;
  }
} // end keyPressed

void keyReleased() {
  frame = 0;
  if (keyCode == RIGHT || keyCode == LEFT)
    move = false;
} // End keyReleased

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////// Scenes ///////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void menu() {
  sceneNum = 0;
  image(menu, 0, 0, 800, 800);
  if (mouseX >= 60 && mouseX <= 179 && mouseY >= 520 && mouseY <= 590)
    image(menuText[1], 0, 0, 800, 800);
  else if (mouseX >= 60 && mouseX <= 325 && mouseY >= 600 && mouseY <= 666)
    image(menuText[2], 0, 0, 800, 800);
  else if (mouseX >= 60 && mouseX <= 270 && mouseY >= 680 && mouseY <= 740)
    image(menuText[3], 0, 0, 800, 800);
  else
    image(menuText[0], 0, 0, 800, 800);
} // end menu

void instructions() {
  sceneNum = -1;
  image(instructions, 0, 0, 800, 800);
  if (mouseX >= 50 && mouseX <= 200 && mouseY >= 675 && mouseY <= 755)
    image(BackSelected, 0, 0, 800, 800);
  else
    image(Back, 530, 0, 800, 800);
} // end instructions

void devMenu() {
  sceneNum = -2;

  image(devMenu, 0, 0, 800, 800);

  if (mouseX >= 336 && mouseX <= 454 && mouseY >= 163 && mouseY <= 209)
    image(devText[0], 0, 0, 800, 800);
  else if (mouseX >= 318 && mouseX <= 474 && mouseY >= 266 && mouseY <= 299)
    image(devText[1], 0, 0, 800, 800);
  else if (mouseX >= 318 && mouseX <= 474 && mouseY >= 366 && mouseY <= 399)
    image(devText[2], 0, 0, 800, 800);
  else if (mouseX >= 302 && mouseX <= 498 && mouseY >= 457 && mouseY <= 498)
    image(devText[3], 0, 0, 800, 800);
  else if (mouseX >= 268 && mouseX <= 528 && mouseY >= 561 && mouseY <= 594)
    image(devText[4], 0, 0, 800, 800);
  else if (mouseX >= 348 && mouseX <= 454 && mouseY >= 657 && mouseY <= 694)
    image(devText[5], 0, 0, 800, 800);

  if (mouseX >= 50 && mouseX <= 200 && mouseY >= 675 && mouseY <= 755)
    image(BackSelected, 0, 0, 800, 800);
  else
    image(Back, 530, 0, 800, 800);
} // end devMenu

void scene1() {
  sceneNum = 1;
  display(scene1, 2022);
  if (locationX == 620) {
    sceneNum = 2;
    backgroundX = 0;
    charRelativeX = 0;
    locationX = 0;
  }
} // end scene1

// first parkour game
void scene2() {
  sceneNum = 2;
  display(scene2_1, 4035);
  if (locationX <= 0) {
    text("I don't want to go back", 400, 200);
  }
  if (locationX >= 500) {
    sceneNum = 3;
    backgroundX = 0;
  }

  if (!(jumping == true) && charRelativeX >= 650 && charRelativeX <= 834 && locationY <= 466 && sceneNum == 2) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // First gap

  if (!(jumping == true) && charRelativeX >= 1574 && charRelativeX <= 1842 && locationY <= 466 && sceneNum == 2) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Second gap

  if (!(jumping == true) && charRelativeX >= 2426 && charRelativeX <= 2650 && locationY <= 466 && sceneNum == 2) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Third gap

  if (!(jumping == true) && charRelativeX >= 3026 && charRelativeX <= 3187 && locationY <= 466 && sceneNum == 2) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Fourth gap
} // end scene2

// second parkour game
void scene2_2() {
  sceneNum = 3;
  display(scene2_2, 4035);
  if (locationX <= 0) {
    text("I don't want to go back", 400, 200);
  }
  if (locationX >= 500) {
    sceneNum = 4;
    backgroundX = 0;
    locationX = -80;
  }

  // hieght of platform 1 is about 366

  if (charRelativeX >= 650 && charRelativeX <= 1727)
    p1 = true;
  else
    p1 = false;

  if (charRelativeX >= 1728 && charRelativeX <= 2143)
    p2 = true;
  else
    p2 = false;

  if (charRelativeX >= 2144 && charRelativeX <= 2807)
    p3 = true;
  else
    p3 = false;

  if (p1 == false && p2 == false && p3 == false) {
    p4 = true;
  }

  if (!(jumping == true) && charRelativeX >= 642 && charRelativeX <= 778 && locationY <= 466 && sceneNum == 3) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // First gap

  if (!(jumping == true) && charRelativeX >= 1726 && charRelativeX <= 1820 && locationY <= 466 && sceneNum == 3) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Second gap

  if (!(jumping == true) && charRelativeX >= 2142 && charRelativeX <= 2188 && locationY <= 466 && sceneNum == 3) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Third gap

  if (!(jumping == true) && charRelativeX >= 2806 && charRelativeX <= 2954 && locationY <= 466 && sceneNum == 3) {
    if (!(locationY > 466)) {
      sceneNum = 8;
    }
  } // Fourth gap
} // End scene2_2

// lights game
void scene3() {
  sceneNum = 4;
  display(scene3, 2022);
  light(2022);

  if (locationX <= 0) {
    text("I don't want to go back", 400, 200);
  }

  if (charRelativeX >= 1783) {
    sceneNum = 5;
    locationX = 0;
    backgroundX = 0;
  }
} // End scene3

// hangman game
void scene4() {
  sceneNum = 5;
  display(scene4, 858);

  if (hangman() == true) {
    sceneNum = 6;
  } /*else {
   sceneNum = 8;
   } */
} // End scene4

// successful guess
void scene5() {
  sceneNum = 6;
  display(scene4, 858);
  text("oh look, the portal activated! let's go!", 60, 295);
  if (charRelativeX == 622) {
    sceneNum = 7;
    locationX = -90;
    backgroundX = 0;
  }
} // end scene5

// final scene
void scene6() {
  sceneNum = 7;
  display(scene5, 3502);

  text("i see the escape! quickly, let's go before he catches us!", 200, 200);

  if (charRelativeX >= 3325) {
    sceneNum = 9;
  }
} // end scene6

// if you fail a game
void badEnd() {
  sceneNum = 8;
  image(badEnding, 0, 0);
} // End badEnd

// if you win the game
void goodEnd() {
  sceneNum = 9;
  image(goodEnding, 0, 0);
} // End goodEnd

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////// UTIL ////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// moving class
void moving() {
  if (move == true) {
    if (facingRight == true)
      locationX += 9;
    if (facingRight == false)
      locationX -= 9;
    frame++;
    if (frame == 20) {
      frame = 5;
    } else if (frame == 20) {
      frame = 0;
    }
  }
  walk();
  jump(2);
}// End moving

// jump class
void jump(int max) {
  locationY += speedY;

  if (jumping == true) {
    speedY += 3;
  }

  if (speedY >= 50 && !(locationY <= 0)) {
    speedY = 0;
    locationY = 466;
    jumping = false;
  }
} // End jumping

// the walking animation function is borrowed code from one of my past projects, with a bit of help from one of my classmates
void walk() {
  if (facingRight == true) {
    switch(frame) {
    case 0:
      character = charWalk[0];
      break;
    case 5:
      character = charWalk[1];
      break;
    case 10:
      character = charWalk[2];
      break;
    case 15:
      character = charWalk[3];
      break;
    }
  } else if (facingRight == false) {
    switch(frame) {
    case 0:
      character = charWalk[4];
      break;
    case 5:
      character = charWalk[5];
      break;
    case 10:
      character = charWalk[6];
      break;
    case 15:
      character = charWalk[7];
      break;
    }
  }
}//end walking

void darkText() {
  timer += 0.1;
  boolean swch1 = false;
  boolean swch2 = false;
  boolean swch3 = false;
  boolean swch4 = false;
  boolean swch5 = false;

  if (timer%15 <= 8) { // debug here
    if (swch1 == false && swch2 == false && swch3 == false) {
      swch1 = true;
    } else if (swch1 == true && swch2 == false && swch3 == false) {
      swch1 = false;
      swch2 = true;
    } else if (swch1 == false && swch2 == true && swch3 == false) {
      swch2 = false;
      swch3 = true;
    }
  } else if (timer%15 > 8) {
    if (swch4 == false && swch5 == false) {
      swch4 = true;
    } else if (swch4 == true && swch5 == false) {
      swch5 = true;
    } else if (swch4 == false && swch5 == true) {
      swch5 = false;
      swch4 = false;
    }
  }

  if (swch1 == true && !(sceneNum == 7)) {
    text("Please come back", 150, 740);
  } else if (swch2 == true && !(sceneNum == 7)) {
    text("Why are you running away? You're safer in the dark", 150, 740);
  } else if (swch3 == true && !(sceneNum == 7)) {
    text("Where are you going?", 150, 740);
  } else if (swch4 == true && !(sceneNum == 7)) {
    text("Don't run away", 150, 740);
  } else if (swch5 == true && !(sceneNum == 7)) {
    text("Stay", 150, 740);
  } else {
    text(" ", 150, 740);
  }

  if (sceneNum == 7) {
    text("DON'T GO. THE BLUE EYES ARE NOT SAFE", 150, 740);
  }
} // end darkText

// some of the display function is borrowed from some past code, however, I did make many changes to a large portion of the function
void display(PImage background, int Length) {
  image(background, backgroundX, 0, Length, 800);
  moving();
  image(character, locationX, locationY, 270, 270);

  if (locationX <= -90 && backgroundX >= 0) { //very very edge left
    locationX = -90;
  } else if (locationX >= 400 && backgroundX > -(Length-800) && move == true) { //fake edge right
    backgroundX -= 10;
    locationX = 400;
  } else if (locationX <= 140 && backgroundX < 0 && move == true) { //fake edge left
    backgroundX += 10;
    locationX = 140;
  } else if (locationX >= 620) { //very very edge right
    locationX = 620;
  }
} //end display

void light(int Length) {
  boolean lightb[] = { false, false, false };
  boolean swch1 = false;

  timerLight += 0.1;

  if (timerLight%15 <= 8) {
    swch1 = false;
  } else if (timerLight%15 > 8) {
    swch1 = true;
  }

  if (swch1 == true) {
    lightb[0] = true;
    lightb[1] = false;
    lightb[2] = true;
  } else if (swch1 == false) {
    lightb[0] = false;
    lightb[1] = true;
    lightb[2] = false;
  } else {
    lightb[0] = true;
    lightb[1] = false;
    lightb[3] = true;
  }

  if (lightb[0])
    image(lights[0], backgroundX, 0, Length, 800);
  if (lightb[1])
    image(lights[1], backgroundX, 0, Length, 800);
  if (lightb[2])
    image(lights[2], backgroundX, 0, Length, 800);

  if (charRelativeX >= 244 && charRelativeX <= 430 && locationY >= 114 && lightb[0] == true) {
    sceneNum = 8;
  } else if (charRelativeX >= 787 && charRelativeX <= 950 && locationY >= 114 && lightb[1] == true) {
    sceneNum = 8;
  } else if (charRelativeX >= 1293 && charRelativeX <= 1450 && locationY >= 114 && lightb[2] == true) {
    sceneNum = 8;
  }
  loop();
} //end light

boolean hangman() {
  /**
   if guess is wrong, add a limb to the thing
   idfk anymore
   
   **/

  boolean wrong = false;
  text("Your guess here: " + guess, 60, 295);

  int wrongN = 0;
  boolean checkInt = check(database, savedGuess);

  if (checkInt == false) {
    wrongN++;

    if (wrongN == 1) {
      image(head, 0, 0);
    }
    if (wrongN == 2) {
      image(body, 0, 0);
    }
    if (wrongN == 3) {
      image(armL, 0, 0);
    }
    if (wrongN == 4) {
      image(armR, 0, 0);
    }
    if (wrongN == 5) {
      image(legL, 0, 0);
    }
    if (wrongN == 6) {
      image(legR, 0, 0);
    }

    if (wrongN >= 7) {
      return false;
    }
  }

  if (checkInt == true) {
    return true;
  } else {
    return false;
  }
} // end hangman

boolean check(String[] arr, String savedGuess) {
  int l = 0, r = database.length-1;
  while (!(l > r)) {
    int mid = l + (r - l) / 2;
    int res = savedGuess.compareToIgnoreCase(arr[mid]);

    if (res == 0)
      return true;

    if (res > 0)
      l = mid + 1;

    else
      r = mid - 1;
  }
  return false;
} // end check
