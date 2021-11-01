PImage bg;
PImage apple;
PImage watermelon;
PImage leftWatermelon;
PImage rightWatermelon;
PImage leftApple;
PImage rightApple;
PImage bomb;
PImage gameOver1;

final int DEFAULT_SIZE = 100;

//fruits

double[][] fruits = new double[100][4];
/*
 [0] - type
 [1] - Speed
 [2] - x
 [3] - y
 */

int fruitCount = 0;
int timer = 10;
int defaultTimer = 100;

//cut fruits
double[][] cutFruits = new double[100][4];
int cutFruitCount = 0;

/*
 [0] - type
 [1] - Speed
 [2] - x
 [3] - y
 */

//bombs
double[][] bombs = new double[100][3];
int bombCount = 0;

/*
 [0] - Speed
 [1] - x
 [2] - y
 */
 
//management
int score = 0;
int fails = 0;
boolean gameOver = false;
boolean slice = false;

void setup()
{
  size(1600, 900);
  bg = loadImage("bg.jpg");
  apple = loadImage("Apple.png");
  watermelon = loadImage("Watermelon.png");
  leftWatermelon = loadImage("leftWatermelon.png");
  rightWatermelon = loadImage("rightWatermelon.png");
  leftApple = loadImage("leftApple.png");
  rightApple = loadImage("rightApple.png");
  bomb = loadImage("bomb.png");
  gameOver1 = loadImage("gameOver1.png");
  strokeWeight(10);
  frameRate(60);
  textSize(35);
  rectMode(CENTER);
  imageMode(CENTER);
}

void draw()
{
  if (!gameOver)
  {
    background();
    score();
    fruitOrBomb();
    bomb();
    fruit();
    cutFruit();
    sliceFruits();
    checkExplode();
    fails();
    speedIncrease();
  }
  else
    gameOver();
}

void background()
{
  image(bg, 800, 450, 1600, 900);
}

void sliceFruits()
{
  if (slice)
  {
    for (int i = 0; i < fruitCount; i++)
    {
      if (dist((float)mouseX, (float)mouseY, (float)fruits[i][2], (float)fruits[i][3]) < 50)
      {
        newCutFruit(i);
        removeFruit(i);
        score += 100;
      }
    }
  }
}

void mousePressed()
{
  slice = true;
}

void mouseReleased()
{
  slice = false;
}

void fruitOrBomb()
{
  timer--;
  if (timer == 0)
  {
    if (random(0, 100) > 20)
      newFruit();
    else
      newBomb();
    timer = defaultTimer;
  }
}

void fruit()
{
  if (fruits[0][3] > 950)
  {
    removeFruit(0);
  }
  for (int i = 0; i < fruitCount; i++)
  {
    printFruit(i);
  }
}

void printFruit(int i)
{
  if (fruits[i][0] == 1)
    image(apple, (int)fruits[i][2], (int)fruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
  if (fruits[i][0] == 2)
    image(watermelon, (int)fruits[i][2], (int)fruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
  fruits[i][3] -= fruits[i][1];
  fruits[i][1] -= 0.4;
}

void newFruit()
{
  fruits[fruitCount][0] = (int)random(1, 3);
  fruits[fruitCount][1] = 24;
  fruits[fruitCount][2] = (int)random(100, 1500);
  fruits[fruitCount][3] = 950;
  fruitCount++;
}

void removeFruit(int i)
{
  for (; i < fruitCount; i++)//removes fruit
  {
    fruits[i][0] = fruits[i + 1][0];
    fruits[i][1] = fruits[i + 1][1];
    fruits[i][2] = fruits[i + 1][2];
    fruits[i][3] = fruits[i + 1][3];
  }
  fruitCount--;
}

void cutFruit()
{
  if (cutFruits[0][3] > 950)
  {
    removeCutFruit(0);
    removeCutFruit(0);
  }
  for (int i = 0; i < cutFruitCount; i++)
  {
    printCutFruit(i);
  }
}

void printCutFruit(int i)
{
  if (cutFruits[i][0] == 1)
  {
    if (i % 2 == 0)
    {
      image(leftApple, (int)cutFruits[i][2], (int)cutFruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
      cutFruits[i][2] -= 5;
    } else
    {
      image(rightApple, (int)cutFruits[i][2], (int)cutFruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
      cutFruits[i][2] += 5;
    }
  }
  if (cutFruits[i][0] == 2)
  {
    if (i % 2 == 0)
    {
      image(leftWatermelon, (int)cutFruits[i][2], (int)cutFruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
      cutFruits[i][2] -= 5;
    } else
    {
      image(rightWatermelon, (int)cutFruits[i][2], (int)cutFruits[i][3], DEFAULT_SIZE, DEFAULT_SIZE);
      cutFruits[i][2] += 5;
    }
  }
  cutFruits[i][3] -= cutFruits[i][1];
  cutFruits[i][1] -= 0.4;
}

void newCutFruit(int i)
{
  cutFruits[cutFruitCount][0] = fruits[i][0];
  cutFruits[cutFruitCount][1] = 0;
  cutFruits[cutFruitCount][2] = fruits[i][2];
  cutFruits[cutFruitCount][3] = fruits[i][3];
  cutFruits[cutFruitCount+1][0] = fruits[i][0];
  cutFruits[cutFruitCount+1][1] = 0;
  cutFruits[cutFruitCount+1][2] = fruits[i][2];
  cutFruits[cutFruitCount+1][3] = fruits[i][3];
  cutFruitCount = cutFruitCount + 2;
}

void removeCutFruit(int i)
{
  for (; i < cutFruitCount; i++)//removes cutFruit
  {
    cutFruits[i][0] = cutFruits[i + 1][0];
    cutFruits[i][1] = cutFruits[i + 1][1];
    cutFruits[i][2] = cutFruits[i + 1][2];
    cutFruits[i][3] = cutFruits[i + 1][3];
  }
  cutFruitCount--;
}

void bomb()
{
  if (bombs[0][2] > 950)
  {
    removeBomb(0);
  }
  for (int i = 0; i < bombCount; i++)
  {
    printBomb(i);
  }
}

void printBomb(int i)
{
  image(bomb, (int)bombs[i][1], (int)bombs[i][2], DEFAULT_SIZE, DEFAULT_SIZE);
  bombs[i][2] -= bombs[i][0];
  bombs[i][0] -= 0.4;
}
void newBomb()
{
  bombs[bombCount][0] = 24;
  bombs[bombCount][1] = (int)random(100, 1500);
  bombs[bombCount][2] = 950;
  bombCount++;
}

void removeBomb(int i)
{
  for (; i < bombCount; i++)//removes bomb
  {
    bombs[i][0] = bombs[i + 1][0];
    bombs[i][1] = bombs[i + 1][1];
    bombs[i][2] = bombs[i + 1][2];
  }
  bombCount--;
}

void checkExplode()
{
  if (slice)
  {
    for (int i = 0; i < bombCount; i++)
    {
      if (dist((float)mouseX, (float)mouseY, (float)bombs[i][1], (float)bombs[i][2]) < 50)
      {
        removeBomb(i);
        fails++;
      }
    }
  }
}

void fails()
{
  stroke(255, 0, 0);
  if (fails > 0)
  {
    line(1400, 20, 1440, 60);
    line(1440, 20, 1400, 60);
  }
  if (fails > 1)
  {
    line(1460, 20, 1500, 60);
    line(1500, 20, 1460, 60);
  }
  if (fails > 2)
  {
    line(1520, 20, 1560, 60);
    line(1560, 20, 1520, 60);
    gameOver = true;
  }
  stroke(0);
}

void score()
{
  fill(255, 255, 0);
  text("Score: " + score, 10, 35);
  fill(0);
}

void gameOver()
{
  image(gameOver1, 800, 450, 774, 143);
}
void speedIncrease()
{
  if (score == 500)
    defaultTimer = 90;
  if (score == 1000)
    defaultTimer = 80;
  if (score == 1500)
    defaultTimer = 70;
  if (score == 2000)
    defaultTimer = 60;
  if (score == 2500)
    defaultTimer = 50;
  if (score == 3000)
    defaultTimer = 40;
  if (score == 3500)
    defaultTimer = 30;
}
