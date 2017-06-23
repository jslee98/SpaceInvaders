/**
 * This file gives instructions for levels. The first 9
 * increase in difficulty, then level 10 and beyond supply
 * randomly ordered 6-line levels.
 */

/**
 * Fills alien grid with a given amount of
 * aliens based on the user's level.
 */
void fillGrid()
{
  int[] row = {140, 185, 230, 275, 320, 365, 410};
  if (level == 1)
  {
    createFollowerAlien(row[0]);
    createAlienLine(row[1]);
    createAlternatingLine(row[2]);
  } else if (level == 2) {
    createAimAlien(row[0]);
    createAlienLine(row[1]);
    createAlienLine(row[2]);
    createDefenderLine(row[3]);
  } else if (level == 3) {
    createFollowerAlien(row[0]);
    createAlienLine(row[1]);
    createDefenderLine(row[2]);
    createDefenderLine(row[3]);
  } else if (level == 4) {
    createAimAlien(row[0]);
    createAlienLine(row[1]);
    createAlienLine(row[2]);
    createAlternatingLine(row[3]);
    createDefenderLine(row[4]);
  } else if (level == 5) {
    createFollowerAlien(row[0]);
    createAlienLine(row[1]);
    createAlienLine(row[2]);
    createDefenderLine(row[3]);
    createDefenderLine(row[4]);
  } else if (level == 6) {
    createAimAlien(row[0]);
    createAlienLine(row[1]);
    createAlienLine(row[2]);
    createFollowerAlien(row[3]);
    createDefenderLine(row[4]);
    createDefenderLine(row[5]);
  } else if (level == 7) {
    createFollowerAlien(row[0]);
    createDefenderLine(row[1]);
    createDefenderLine(row[2]);
    createDefenderLine(row[3]);
    createDefenderLine(row[4]);
  } else if (level == 8) {
    createFollowerAlien(row[0]);
    createAimAlien(row[1]);
    createAlienLine(row[2]);
    createDefenderLine(row[3]);
    createAlternatingLine(row[4]);
    createDefenderLine(row[5]);
  } else if (level == 9) {
    createAlienLine(row[0]);
    createAlienLine(row[1]);
    createAlienLine(row[2]);
    createAlienLine(row[3]);
    createAlienLine(row[4]);
    createAlienLine(row[5]);
    createAlienLine(row[6]);
  } else if (level >= 10)
  {
    randomLineGenerator(6, row);
  }
}

/**
 * Creates a new line with a single follower alien.
 */
void createFollowerAlien(int row)
{
  alienList.add(new FollowAlien(width/2, row));
}

/**
 * Creates a new line with a single aiming alien.
 */
void createAimAlien(int row)
{
  alienList.add(new AimAlien(width/2, row));
}

/**
 * Creates a new line with a eight basic aliens.
 */
void createAlienLine(int row)
{
  int xGridStart = 200;
  for (int i = 0; i < 8; i++)
  {
    alienList.add(new Alien(xGridStart, row));
    xGridStart += 70;
  }
}

/**
 * Creates a new line with a eight defender aliens.
 */
void createDefenderLine(int row)
{
  int xGridStart = 200;
  for (int i = 0; i < 8; i++)
  {
    alienList.add(new DefenderAlien(xGridStart, row));
    xGridStart += 70;
  }
}

/**
 * Creates an alternating line of basic and defender aliens.
 */
void createAlternatingLine(int row)
{
  int xGridStart = 200;
  for (int i = 0; i < 8; i++)
  {
    if (i % 2 == 0)
    {
      alienList.add(new DefenderAlien(xGridStart, row));
    } else {
      alienList.add(new Alien(xGridStart, row));
    }
    xGridStart += 70;
  }
}

/**
 * Creates a random line of the previously outlines types.
 */
void randomLineGenerator(int numLines, int[] rows)
{
  int row = 0;
  for (int i = 0; i < numLines; i++)
  {
    int randomType = (int) random(0, 5);
    if (randomType == 0) {
      createFollowerAlien(rows[row]);
      row++;
    } else if (randomType == 1) {
      createAlienLine(rows[row]);
      row++;
    } else if (randomType == 2) {
      createDefenderLine(rows[row]);
      row++;
    } else if (randomType == 3) {
      createAlternatingLine(rows[row]);
      row++;
    } else if (randomType == 4) {
      createAimAlien(rows[row]);
      row++;
    }
  }
}