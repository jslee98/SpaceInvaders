/**
 * This files gives class information and special functions for
 * the aliens that are more sophisticated than the base aliens.
 *
 * Acknowledgements:
 *   Space Invaders Images
 *   Perform actions every X seconds
 */

// Fields
PImage defenderImg1, defenderImg2, followImg1, followImg2, aimImg;
int followTimer, aimTimer;

/**
 * Gives parameters for an alien to be created that follows
 * the user's movement.
 */
public class FollowAlien extends Alien
{
  float wid, hgt, xPos, yPos, xSpd, ySpd;
  public FollowAlien(float x2, float y2)
  {
    super(x2, y2);
    this.wid = 40;
  }
  String getType()
  {
    return "followAlien";
  }
  void flipXSpeed()
  {
    // Do Nothing
  }
}

/**
 * Gives parameters for an alien to be created that shoots
 * directly at the user, rather than straight down.
 */
public class AimAlien extends Alien
{
  float wid, hgt, xPos, yPos, xSpd, ySpd;
  public AimAlien(float x2, float y2)
  {
    super(x2, y2);
    this.wid = 82;
  }
  String getType()
  {
    return "aimAlien";
  }
  float getWidth()
  {
    return 82;
  }
}

/**
 * Gives parameters for an alien to be created that needs
 * to be hit twice in order to die.
 */
public class DefenderAlien extends Alien
{
  float wid, hgt, xPos, yPos, xSpd, ySpd, lives;
  public DefenderAlien(float x3, float y3)
  {
    super(x3, y3);
    this.wid = 37;
    this.lives = 2;
  }
  String getType()
  {
    return "defenderAlien";
  }
  float livesLeft()
  {
    return this.lives;
  }
  void removeLife()
  {
    this.lives--;
  }
}

/**
 * Gives instructions for Follow Aliens to follow the user.
 */
void moveFollowAlien()
{
  {
    for (Alien alien : alienList)
    {
      if (alienList.size() > 0 && alien.getType().equals("followAlien"))
      {
        float easing = .05;
        float xTarget = shooterXPos;
        float xDist = xTarget - alien.getXPos();
        alien.moveX(alien.getXPos() + xDist * easing);
      }
    }
  }
}

/**
 * Gives instructions for Follow Aliens to shoot.
 */
void followAlienShoot()
{
  for (Alien follower : alienList)
  {
    if (millis() - followTimer >= random(1000, 1300) && alienList.size() > 0 
      && millis() - restartTimer > 500 && follower.getType().equals("followAlien")) 
    {
      alienBulletList.add(new Bullet(8, 0, follower.getXPos(), 
        follower.getYPos(), "single"));
      followTimer = millis();
    }
  }
}

/**
 * Gives instructions for Aim Aliens to shoot at the user.
 */
void aimAlienShoot()
{
  for (Alien aimer : alienList)
  {
    if (millis() - aimTimer >= random(1000, 1200) && alienList.size() > 0
      && aimer.getType().equals("aimAlien") && millis() - restartTimer > 500)
    {
      float xVelocity = 10*(shooterXPos-aimer.getXPos())/(SHOOTERYPOS-aimer.getYPos());
      alienBulletList.add(new Bullet(10, xVelocity, aimer.getXPos(), 
        aimer.getYPos(), "aimed"));
      aimTimer = millis();
    }
  }
}