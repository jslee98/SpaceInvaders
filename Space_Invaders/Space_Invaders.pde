/**
 * Space Invaders is a classic arcade game, recreated
 * here with an unlimited amount of levels and intelligent
 * alien enemies. The game allows three lives for the user
 * to shoot down aliens, and drops power-ups and extra lives
 * along the way.
 *
 * The Space Invaders file houses the main information
 * for the styling and functionality of the game,
 * including the draw function, the keyboard inputs, 
 * the high score record, and more.
 *
 * Acknowledgements:
 *   Smooth Keyboard Movement
 *   Reading and Writing .txt Files
 *   Space Invaders Images
 *   Sound Bible Sounds
 *   Perform actions every X seconds
 *
 * Author: Jeff Lee
 * Course: Period 1 AP CS, Dr. Miles
 * Due: 2016-6-02
 */

import java.util.ArrayList;
import processing.sound.*;

// Shooter Fields
PImage shooter;
boolean loaded = true;
float shooterSpeed = 5;
float shooterXPos = 440;
float leftVal, rightVal = 0;
final float SHOOTERYPOS = 610;
final float SHOOTERWIDTH = 60;
final float SHOOTERHEIGHT = 38;

// Style Fields
PFont font;
float[][] colors;
int colorChoice;
boolean mute = false;
PImage skull, title, muteImg;
SoundFile shot, powerUp, alienDeath;

// Game Fields
int level = 1;
int lives = 3;
int hitCount, bulletsShot, points, roundPoints, highscore, restartTimer = 0;
boolean gameLost, gameWon, gameStart, gridFilled, pause, titleCleared = false;
String[] scoreStrings;

/**
 * Sets up the game by initializing program colors, screen size,
 * high scores, and importing all images and sounds used.
 */
void setup()
{
  size(880, 660);
  background(0); 
  colorChoices();
  scoreStrings = loadStrings("../highscore.txt");
  highScore();
  shooter = loadImage("Shooter.png");
  followImg1 = loadImage("followAlien.png");
  followImg2 = loadImage("followAlien2.png");
  defenderImg1 = loadImage("invader3.png");
  defenderImg2 = loadImage("invader3_2.png");
  alienImg1 = loadImage("invader_anime-1.png");
  alienImg2 = loadImage("invader_anime-2.png");
  title = loadImage("title.png");
  heartImg = loadImage("heart.png");
  skull = loadImage("skull.png");
  boltImg = loadImage("bolt.png");
  shieldImg = loadImage("shield.png");
  aimImg = loadImage("aimer.png");
  muteImg = loadImage("mute.png");
  font = loadFont("KongtextRegular-120.vlw");
  shot = new SoundFile(this, "laser.mp3");
  alienDeath = new SoundFile(this, "invaderkilled.wav");
  powerUp = new SoundFile(this, "powerup.mp3");
}

/**
 * The draw function continuously refreshes to create the
 * game's animation. It fills the background after objects 
 * move for clean shifts, writes the text and screen and 
 * allows the user's shooter to move slowly. Additionally,
 * it keeps track of all aliens and bullets in the game,
 * and displays a screen when the game is over.
 */
void draw()
{
  if (!pause)
  {
    background(0);
    fill(255);
    textAlign(CENTER);
    rectMode(CENTER);
    imageMode(CENTER);
    if (!gameStart && !gridFilled)
    {
      image(title, width/2, height/2-20, 400, 168);
      text("Press ENTER to Start", width/2, height/2+100);
    }
    if (mute)
    {
      tint(255);
      image(muteImg, 820, 20, 27, 27);
    }
    textAlign(LEFT);
    textFont(font, 35);
    text("Wave " + level, 9, 40); 
    textFont(font, 20);
    text("Points: " + (points + roundPoints), 10, 65); 
    text("Lives: ", 10, 90);
    int lifeSpacing = 150;
    for (int i = 0; i < lives; i++)
    {
      tint(255);
      image(shooter, lifeSpacing, 80, 31, 20);
      lifeSpacing += 40;
    }
    textAlign(CENTER, CENTER);
    if (shooterXPos < SHOOTERWIDTH/2+5)
    {
      leftVal = 0;
    } else if ( shooterXPos > width - SHOOTERWIDTH/2-5)
    {
      rightVal = 0;
    }
    shooterXPos += (rightVal-leftVal) * shooterSpeed;
    imageMode(CENTER);
    indicatePowerUp();
    image(shooter, shooterXPos, SHOOTERYPOS, SHOOTERWIDTH, SHOOTERHEIGHT);
    for (Bullet temp : bulletList)
    {
      if (temp.getType().equals("single")) {
        rect(temp.getXPos(), temp.getYPos(), temp.getWidth(), temp.getLength());
      } else if (temp.getType().equals("triple")) {
        ellipse(temp.getXPos(), temp.getYPos(), 8, 8);
      }
    }

    for (Bullet temp : alienBulletList)
    {
      fill(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2]);
      if (temp.getType().equals("single"))
      {
        rect(temp.getXPos(), temp.getYPos(), temp.getWidth(), temp.getLength());
      } else if (temp.getType().equals("aimed")) {
        ellipse(temp.getXPos(), temp.getYPos(), 10, 10);
      }
    }

    for (Alien alien : alienList)
    {
      if (alien.getType().equals("followAlien"))
      {
        tint(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2], 255);
        alienAnimation(alien, followImg1, followImg2);
      } else if (alien.getType().equals("defenderAlien")) {
        if (alien.livesLeft() < 2)
        {
          tint(255);
        } else {
          tint(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2], 255);
        }
        alienAnimation(alien, defenderImg1, defenderImg2);
      } else if (alien.getType().equals("aimAlien")) {
        tint(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2], 255);
        image(aimImg, alien.getXPos(), alien.getYPos(), 
          alien.getWidth(), alien.getHeight());
      } else {
        tint(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2], 255);
        alienAnimation(alien, alienImg1, alienImg2);
      }
    }
    for (Drop power : dropList)
    {
      tint(255);
      if (power.getType().equals("heart"))
      {
        image(heartImg, power.getXPos(), power.getYPos(), 
          power.getWidth(), power.getLength());
      } else if (power.getType().equals("bolt")) {
        image(boltImg, power.getXPos(), power.getYPos(), 
          power.getWidth(), power.getLength());
      } else if (power.getType().equals("shield")) {
        image(shieldImg, power.getXPos(), power.getYPos(), 
          power.getWidth(), power.getLength());
      } else if (power.getType().equals("triple")) {
        image(skull, power.getXPos(), power.getYPos(), 
          power.getWidth(), power.getLength());
      }
    }
    if (alienList.size() == 0 && gridFilled == true)
    {
      fill(0);
      stroke(255);
      rect(width/2, height/2-15, 600, 150);
      fill(255);
      stroke(0);
      gameWon = true;
      points += roundPoints;
      roundPoints = 0;
      shooterSpeed = 0;
      textFont(font, 60);
      textAlign(CENTER, CENTER);
      text("You Won!", width/2, height/2 - 50);
      textFont(font, 20);
      text("Accuracy: " + (int)((double)hitCount/bulletsShot * 100)
        + "%", width/2, height/2-3);
      text("Press ENTER for the next wave", width/2, height/2+24);
    }
    if (killShot() && lives <= 1)
    {
      fill(0);
      stroke(255);
      rect(width/2, height/2-13, 550, 315);
      fill(255);
      stroke(0);
      lives = 0;
      points += roundPoints;
      roundPoints = 0;
      shooterSpeed = 0;
      textFont(font, 60);
      textAlign(CENTER, CENTER);
      tint(255);
      image(skull, width/2, height/2 - 100, 117, 150); 
      text("Game Over", width/2, height/2);
      textFont(font, 20);
      text("Points: " + points, width/2, height/2+45);
      text("High Score: " + highscore, width/2, height/2+70);
      text("Press ENTER to start again", width/2, height/2+95);
    }
    if (killShot() && lives > 1)
    {
      fill(0);
      stroke(255);
      rect(width/2, height/2-15, 500, 150);
      fill(255);
      stroke(0);
      shooterSpeed = 0;
      roundPoints = 0;
      textFont(font, 60);
      textAlign(CENTER, CENTER);
      text("You Died", width/2, height/2-50);
      textFont(font, 20);
      text("Accuracy: " + (int)((double)hitCount/bulletsShot * 100)
        + "%", width/2, height/2-3);
      text("Press ENTER to try again", width/2, height/2+24);
    }

    if (!gameLost && !gameWon)
    {
      drawActions();
    }
  } else {
    fill(255);
    rect(845, 20, 8, 20);
    rect(856, 20, 8, 20);
  }
}

/**
 * The methods included in drawActions are all called while the
 * game is still running and the user is alive. They include movement
 * of aliens, bullets, and power-ups, and keeps track of when power-ups
 * and bullets are out of play.
 */
void drawActions()
{
  alienShoot();
  followAlienShoot();
  aimAlienShoot();
  alienContact();
  bulletContact();
  dropContact();
  moveAlien();
  moveFollowAlien();
  moveBullet();
  bulletOOB();
  showActive();
  endPowerUp();
}

/**
 * keyPressed gives directions for when the space bar, return,
 * 'M', 'P', and arrow keys are pressed. It will help restart
 * pause, and mute the game, move the shooter, create bullets,
 * and more.
 */
void keyPressed() {
  if (keyCode == 32 && loaded && !gameWon && !gameLost && gridFilled && !pause)
  {
    if (!tripleShot)
    {
      bulletList.add(new Bullet(-10, 0, shooterXPos, SHOOTERYPOS - SHOOTERHEIGHT, "single"));
      bulletsShot++;
      loaded = false;
      if (!mute)
      {
        shot.play();
      }
    } else if (tripleShot) {
      bulletList.add(new Bullet(-10, 0, shooterXPos, SHOOTERYPOS - SHOOTERHEIGHT, "triple"));
      bulletList.add(new Bullet(-10, -2, shooterXPos, SHOOTERYPOS - SHOOTERHEIGHT, "triple"));
      bulletList.add(new Bullet(-10, 2, shooterXPos, SHOOTERYPOS - SHOOTERHEIGHT, "triple"));
      bulletsShot+=3;
      if (!mute)
      {
        shot.play();
      }
    }
  }
  if (keyCode == 39)
  {
    rightVal = 1;
  }
  if (keyCode == 37)
  { 
    leftVal = 1;
  }
  if (keyCode == 10 && (gameStart || gameLost || gameWon) && !pause)
  {
    titleCleared = true;
    gameStart = true;
    gridFilled = false;
  }
  if (keyCode == 80)
  {
    pause = !pause;
  }
  if (keyCode == 77)
  {
    mute = !mute;
  }
}

/**
 * keyReleased gives directions for when the space bar, return,
 * 'M', 'P', and arrow keys are pressed. It will help restart
 * pause, and mute the game, move the shooter, create bullets,
 * and more.
 */
void keyReleased() {
  if (keyCode == 32)
  {
    loaded = true;
  }
  if (keyCode == 39)
  {
    rightVal = 0;
  }
  if (keyCode == 37)
  {
    leftVal = 0;
  }
  if (keyCode == 10 && !gridFilled && 
    (!titleCleared || gameStart || gameLost || gameWon) && !pause)
  {
    bulletList.clear();
    alienBulletList.clear();
    alienList.clear();
    colorChoice = (int) random(0, 6);
    if (gameWon)
    {
      heartDropped = false;
      level++;
      if (level < 4 || level == 7)
      {
        xSpeed+=1;
        ySpeed+=1;
      }
    }
    if (gameLost)
    {
      lives--;
    }
    if (lives < 0)
    {
      if (points > highscore)
      {
        newHighScore();
        highScore();
      }
      points = 0;
      level = 1;
      xSpeed = 2;
      ySpeed = 10;
      lives = 3;
    }
    restartTimer = millis();
    tripleShot = false;
    invincible = false;
    spedUp = false;
    shooterSpeed = 5;
    gameStart = false;
    gameWon = false;
    gameLost = false;
    dropList = new ArrayList<Drop>();
    fillGrid();
    dropPower();
    gridFilled = true;
    bulletsShot = 0;
    hitCount = 0;
  }
}

/**
 * killShot keeps track of whether an alien bullet has hit the
 * shooter, and if it has, removes a life and shows a death screen.
 */
boolean killShot()
{
  for (Bullet bullet : alienBulletList)
  {
    if (dist(bullet.getXPos(), 0, shooterXPos, 0) <= SHOOTERWIDTH/2 &&
      dist(0, bullet.getYPos(), 0, SHOOTERYPOS) <= SHOOTERHEIGHT/2 &&
      !invincible)
    {
      gameLost = true;
    }
  }
  if (alienList.size() > 0 && gridFilled 
    && alienList.get(alienList.size()-1).getYPos() >= SHOOTERYPOS)
  {
    gameLost = true;
  }
  return gameLost;
}

/**
 * colorChoices initializes a float array array of different,
 * eye-pleasing colors that are randomly chosen each time a
 * wave is started.
 */
void colorChoices()
{
  colors = new float[6][3];
  // Salmon
  colors[0][0] = 255;
  colors[0][1] = 70;
  colors[0][2] = 70;
  // Carolina
  colors[1][0] = 80;
  colors[1][1] = 157;
  colors[1][2] = 232;
  // Green
  colors[2][0] = 37;
  colors[2][1] = 229;
  colors[2][2] = 61;
  // Purple
  colors[3][0] = 134;
  colors[3][1] = 17;
  colors[3][2] = 209;
  // Teal
  colors[4][0] = 61;
  colors[4][1] = 201;
  colors[4][2] = 174;
  // Yellow
  colors[5][0] = 252;
  colors[5][1] = 240;
  colors[5][2] = 94;
}

/**
 * highScore retrieves the current highScore saved on a .txt file. 
 */
void highScore() 
{
  highscore = Integer.parseInt(scoreStrings[0]);
}

/**
 * newHighScore writes over the previous high score on a
 * saved .txt file.
 */
void newHighScore()
{
  scoreStrings[0] = Integer.toString(points);
  saveStrings("highscore.txt", scoreStrings);
}