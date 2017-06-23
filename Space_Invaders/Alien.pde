/**
 * This file gives all specifications of the base alien class, as well as
 * the outlines for what happens when aliens shoot, get shot, and move.
 *
 * Acknowledgements:
 *   Space Invaders Images
 *   Perform actions every X seconds
 */

// Fields
float xSpeed = 2;
float ySpeed = 10;
int shotTimer;
PImage alienImg1, alienImg2;
ArrayList<Alien> alienList = new ArrayList<Alien>();

/**
 * Defines the characteristics of a base-level alien
 * with automated motion and shooting patterns.
 */
public class Alien
{
  boolean dropHeart, dropBolt, dropShield, dropTriple;
  float wid, hgt, xPos, yPos, xSpd, ySpd;
  public Alien(float x1, float y1)
  {
    this.wid = 50;
    this.hgt = 36;
    this.xSpd = xSpeed;
    this.ySpd = ySpeed;
    this.xPos = x1;
    this.yPos = y1;
  }
  float getWidth()
  {
    return this.wid;
  }
  float getHeight()
  {
    return this.hgt;
  }
  float getXSpeed()
  {
    return this.xSpd;
  }
  float getYSpeed()
  {
    return this.ySpd;
  }
  float getYPos()
  {
    return this.yPos;
  }
  float getXPos()
  {
    return this.xPos;
  }
  String getType()
  {
    return "alien";
  }
  void moveY(float newPos)
  {
    this.yPos = newPos;
  } 
  void moveX(float newPos)
  {
    this.xPos = newPos;
  }
  void flipXSpeed()
  {
    this.xSpd = -1*xSpd;
  }
  void setXSpeed(float add)
  {
    this.xSpd += add;
  }
  void removeLife()
  {
    // Do nothing
  }
  float livesLeft()
  {
    return -1;
  }
  /**
   * Gives an alien a heart to drop.
   */
  void heartDrop()
  {
    this.dropHeart = true;
  }
  /**
   * Returns whether or not the alien has a heart to drop.
   */
  boolean dropLife()
  {
    return this.dropHeart;
  }
  /**
   * Gives an alien a bolt to drop.
   */
  void boltDrop()
  {
    this.dropBolt = true;
  }
  /**
   * Returns whether or not the alien has a bolt to drop.
   */
  boolean dropBolt()
  {
    return this.dropBolt;
  }
  /**
   * Gives an alien a shield to drop.
   */
  void shieldDrop()
  {
    this.dropShield = true;
  }
  /**
   * Returns whether or not the alien has a shield to drop.
   */
  boolean dropShield()
  {
    return this.dropShield;
  }
  /**
   * Gives an alien a skull to drop.
   */
  void tripleDrop()
  {
    this.dropTriple = true;
  }
  /**
   * Returns whether or not the alien has a skull to drop.
   */
  boolean dropTriple()
  {
    return this.dropTriple;
  }
}

/**
 * Gives instructions for a regular alien to move
 * in an automated fashion.
 */
void moveAlien()
{
  for (Alien alien : alienList)
  {
    if (!alien.getType().equals("followAlien"))
    {
      alien.moveX(alien.getXPos() + alien.getXSpeed());
    }
  }
  if (alienList.size() !=0 
    && (alienList.get(findRightMostAlien()).getXPos() >= width - 25 
    || alienList.get(findLeftMostAlien()).getXPos() <= 25))
  {
    for (Alien alien : alienList)
    {
      alien.flipXSpeed();
      alien.moveY(alien.getYPos() + alien.getYSpeed());
    }
  }
}

/**
 * Gives instructions for a regular alien to shoot
 * in an automated fashion.
 */
void alienShoot()
{
  int numShooters;
  switch (level) {
  case 1: 
    numShooters = 1;
    break;
  case 2: 
    numShooters = 2;
    break;
  case 3: 
  case 4:
  case 5:
  case 6:
  case 7:
    numShooters = 3;
    break;
  default:
    numShooters = 4;
    break;
  }
  if (millis() - shotTimer >= random(400, 600) && alienList.size() > 0 
    && millis() - restartTimer > 500) {
    for (int i = 0; i < numShooters && i < alienList.size(); i++)
    {
      int randomAlien = (int) random(0, alienList.size());
      if (!alienList.get(randomAlien).getType().equals("aimAlien"))
      {
        alienBulletList.add(new Bullet(8, 0, alienList.get(randomAlien).getXPos(), 
          alienList.get(randomAlien).getYPos(), "single"));
      }
    }
    shotTimer = millis();
  }
}

int findRightMostAlien()
{
  int rightMost = 0;
  for (int i = 1; i < alienList.size(); i++)
  {
    if (alienList.get(i).getXPos() > alienList.get(rightMost).getXPos())
    {
      rightMost = i;
    }
  }
  return rightMost;
}

int findLeftMostAlien()
{
  int leftMost = 0;
  for (int i = 1; i < alienList.size(); i++)
  {
    if (alienList.get(i).getXPos() < alienList.get(leftMost).getXPos())
    {
      leftMost = i;
    }
  }
  return leftMost;
}

/**
 * Determines if a shooter bullet has hit an alien,
 * and kills the alien if it has. Also drops any power-up
 * the alien was holding.
 */
void alienContact()
{
  for (int k = alienList.size()-1; k >= 0; k--)
  {
    for (int i = bulletList.size()-1; i >= 0; i--)
    {  
      if  (alienList.size() > k && bulletList.size() > i && 
        dist(bulletList.get(i).getXPos(), 0, alienList.get(k).getXPos(), 0) 
        <= alienList.get(k).getWidth() &&
        dist(0, bulletList.get(i).getYPos(), 0, alienList.get(k).getYPos()) 
        <= alienList.get(k).getHeight())
      {
        if (!mute)
        {
          alienDeath.play();
        }
        hitCount++;
        if (alienList.get(k).dropLife() && alienList.get(k).livesLeft() < 2 && !heartDropped)
        {
          dropList.add(new Drop(4, alienList.get(k).getXPos(), 
            alienList.get(k).getYPos(), 30, 30, "heart"));
          heartDropped = true;
        }
        if (alienList.get(k).dropBolt() && alienList.get(k).livesLeft() < 2)
        {
          dropList.add(new Drop(4, alienList.get(k).getXPos(), 
            alienList.get(k).getYPos(), 20, 40, "bolt"));
        }
        if (alienList.get(k).dropShield() && alienList.get(k).livesLeft() < 2)
        {
          dropList.add(new Drop(4, alienList.get(k).getXPos(), 
            alienList.get(k).getYPos(), 30, 34, "shield"));
        }
        if (alienList.get(k).dropTriple() && alienList.get(k).livesLeft() < 2)
        {
          dropList.add(new Drop(4, alienList.get(k).getXPos(), 
            alienList.get(k).getYPos(), 30, 34, "triple"));
        }
        bulletList.remove(i);
        if (alienList.get(k).getType().equals("defenderAlien"))
        {
          alienList.get(k).removeLife();
          if (alienList.get(k).livesLeft() < 1)
          {
            alienList.remove(k);
            roundPoints += 75;
          }
        } else if (alienList.get(k).getType().equals("followAlien")) {
          alienList.remove(k);
          roundPoints += 100;
        } else if (alienList.get(k).getType().equals("aimAlien")) {
          alienList.remove(k);
          roundPoints += 80;
        } else {
          alienList.remove(k);
          roundPoints += 50;
        }
      }
    }
  }
}

/**
 * Animates aliens to give them a more lifelike look.
 */
void alienAnimation(Alien alien, PImage img1, PImage img2)
{
  if (millis()/500%2 == 0)
  {
    image(img1, alien.getXPos(), alien.getYPos(), 
      alien.getWidth(), alien.getHeight());
    shotTimer = millis();
  } else {
    image(img2, alien.getXPos(), alien.getYPos(), 
      alien.getWidth(), alien.getHeight());
  }
}