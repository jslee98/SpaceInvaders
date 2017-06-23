/**
 * This file outlines bullets that can be shot by aliens
 * and the user, as well as power-ups that can be dropped
 * by aliens. The file also gives power-ups instructions
 * to operate.
 *
 * Acknowledgements:
 *   Space Invaders Images
 *   Perform actions every X seconds
 */

// Fields
int speedTimer, invincibleTimer, tripleTimer;
int numActive = 0;
boolean heartDropped, spedUp, invincible, tripleShot = false;
PImage heartImg, boltImg, shieldImg;
ArrayList<Bullet> bulletList = new ArrayList<Bullet>();
ArrayList<Bullet> alienBulletList = new ArrayList<Bullet>();
ArrayList<Drop> dropList = new ArrayList<Drop>();

/**
 * The bullet class defines standard linear motion for a bullet
 * to be shot at.
 */
public class Bullet
{
  String type;
  float len, wid, xPos, yPos, ySpeed, xSpeed;
  public Bullet(float ySpd, float xSpd, float xStart, float yStart, String T)
  {
    this.len = 30;
    this.wid = 8;
    this.xPos = xStart;
    this.yPos = yStart;
    this.ySpeed = ySpd;
    this.xSpeed = xSpd;
    this.type = T;
  }
  float getLength()
  {
    return this.len;
  }
  float getWidth()
  {
    return this.wid;
  }
  float getXPos()
  {
    return this.xPos;
  }
  float getYPos()
  {
    return this.yPos;
  }
  float getYSpeed()
  {
    return this.ySpeed;
  }
  float getXSpeed()
  {
    return this.xSpeed;
  }
  void setY(float newPos)
  {
    this.yPos = newPos;
  }
  void setX(float newPos)
  {
    this.xPos = newPos;
  }
  String getType()
  {
    return this.type;
  }
}

/**
 * The drop class extends bullet as they are objects
 * shot in a similar motion when the alien is killed.
 */
public class Drop extends Bullet
{
  float dropWidth, dropLength;
  public Drop(float ySpd, float xStart, float yStart, 
    float xDim, float yDim, String type)
  {
    super(ySpd, 0, xStart, yStart, type);
    this.dropWidth = xDim;
    this.dropLength = yDim;
  }
  float getLength()
  {
    return this.dropLength;
  }
  float getWidth()
  {
    return this.dropWidth;
  }
}

/**
 * Gives instructions for the bullet to move linearly.
 */
void moveBullet()
{
  for (Bullet temp : bulletList)
  {
    temp.setY(temp.getYPos() + temp.getYSpeed());
    temp.setX(temp.getXPos() + temp.getXSpeed());
  }
  for (Bullet temp : dropList)
  {
    temp.setY(temp.getYPos() + temp.getYSpeed());
  }
  for (Bullet temp : alienBulletList)
  {
    temp.setY(temp.getYPos() + temp.getYSpeed());
    temp.setX(temp.getXPos() + temp.getXSpeed());
  }
}

/**
 * Removes bullets if they have left the screen
 * to speed up program.
 */
void bulletOOB()
{
  for (int i = bulletList.size()-1; i >= 0; i--)
  {
    if (bulletList.get(i).getXPos() < 0)
    {
      bulletList.get(i).setX(width);
    } else if (bulletList.get(i).getXPos() > width) {
      bulletList.get(i).setX(0);
    }

    if (bulletList.get(i).getYPos() < 0)
    {
      bulletList.remove(i);
    }
  }
  for (int i = alienBulletList.size()-1; i >= 0; i--)
  {
    if (alienBulletList.get(i).getYPos() > height)
    {
      alienBulletList.remove(i);
    }
  }
  for (int i = dropList.size()-1; i >= 0; i--)
  {
    if (dropList.get(i).getYPos() > height)
    {
      dropList.remove(i);
    }
  }
}

/**
 * Tests to see if bullets have come in contact and removes them
 * if they have.
 */
void bulletContact()
{
  for (int k = alienBulletList.size()-1; k >= 0; k--)
  {
    for (int i = bulletList.size()-1; i >= 0; i--)
    {  
      if  (alienBulletList.size() > k && bulletList.size() > i && 
        dist(bulletList.get(i).getXPos(), 0, alienBulletList.get(k).getXPos(), 0) 
        <= alienBulletList.get(k).getWidth() &&
        dist(0, bulletList.get(i).getYPos(), 0, alienBulletList.get(k).getYPos()) 
        <= alienBulletList.get(k).getLength())
      {
        bulletList.remove(i);
        alienBulletList.remove(k);
        roundPoints += 5;
        hitCount++;
      }
    }
  }
}

/**
 * Tests to see if dropped objects have come in contact with
 * the shooter and engages them if they have.
 */
void dropContact()
{
  for (int k = dropList.size()-1; k >= 0; k--)
  {
    if  (dropList.size() > k && 
      dist(shooterXPos, 0, dropList.get(k).getXPos(), 0) 
      <= SHOOTERWIDTH &&
      dist(0, SHOOTERYPOS, 0, dropList.get(k).getYPos()) 
      <= SHOOTERHEIGHT)
    {
      if (!mute)
      {
        powerUp.play();
      }
      if (dropList.get(k).getType().equals("heart"))
      {
        dropList.remove(k);
        lives++;
      } else if (dropList.get(k).getType().equals("bolt")) {
        dropList.remove(k);
        shooterSpeed = 10;
        spedUp = true;
        speedTimer = millis();
        numActive++;
      } else if (dropList.get(k).getType().equals("shield")) {
        dropList.remove(k);
        invincible = true;
        invincibleTimer = millis();
        numActive++;
      } else if (dropList.get(k).getType().equals("triple")) {
        dropList.remove(k);
        tripleShot = true;
        tripleTimer = millis();
        numActive++;
      }
    }
  }
}

/**
 * Adds objects to random aliens to enable dropping.
 */
void dropPower()
{
  int random = (int)random(0, alienList.size());
  int chanceHeart = (int)random(0, 3);
  if (chanceHeart % 2 == 0)
  {
    alienList.get(random).heartDrop();
  }
  int random2 = (int)random(0, alienList.size());
  int chanceBolt = (int)random(0, 3);
  while (random2 == random)
  {
    random2 = (int)random(0, alienList.size());
  }
  if (chanceBolt % 2 == 0)
  {
    alienList.get(random2).boltDrop();
  }
  int random3 = (int)random(0, alienList.size());
  int chanceShield = (int)random(1, 4);
  while (random3 == random2 || random3 == random)
  {
    random3 = (int)random(0, alienList.size());
  }
  if (chanceShield % 3 == 0)
  {
    alienList.get(random3).shieldDrop();
  }
  int random4 = (int)random(0, alienList.size());
  int chanceTriple = (int)random(1, 4);
  while (random4 == random2 || random4 == random || random4 == random3)
  {
    random4 = (int)random(0, alienList.size());
  }
  if (chanceTriple % 3 == 0)
  {
    alienList.get(random4).tripleDrop();
  }
}

/**
 * Ends power up if it has timed out.
 */
void endPowerUp()
{
  if (millis() - speedTimer > 5000)
  {
    shooterSpeed = 5;
    spedUp = false;
    numActive--;
  }
  if (millis() - invincibleTimer > 4000)
  {
    invincible = false;
    numActive--;
  }
  if (millis() - tripleTimer > 2000)
  {
    tripleShot = false;
    numActive--;
  }
}

/**
 * Displays active power-ups in left-hand corner.
 */
void showActive()
{
  tint(255);
  int iconSpacing = 790;
  if (spedUp)
  {
    image(boltImg, iconSpacing, 20, 15, 29);
    iconSpacing -= 30;
  }
  if (invincible)
  {
    image(shieldImg, iconSpacing, 20, 23, 27);
    iconSpacing -= 30;
  }
  if (tripleShot)
  {
    image(skull, iconSpacing, 20, 25, 25);
    iconSpacing -= 30;
  }
}

/**
 * Indicates invincibility by changing shooter's color.
 */
void indicatePowerUp()
{
  if (invincible)
  {
    tint(colors[colorChoice][0], colors[colorChoice][1], colors[colorChoice][2]);
  } else {
    tint(255);
  }
}