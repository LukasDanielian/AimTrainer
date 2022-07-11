class Enemy
{
  float x;
  float y = random(-roomHeight + 250 + eSize, -250);
  float z;
  float dist = random(roomWidth/2, roomWidth);
  float theta = random(0, 360);
  float tMover = random(-rotSpeed, rotSpeed);
  float health = fHealth;
  float size;

  public Enemy(float size)
  {
    this.size = size;
  }

  void render()
  {
    noStroke();
    pushMatrix();
    translate(x, y, z);
    fill(map(health, 100, 0, 175, 255), map(health, 100, 50, 255, 0), 0);
    sphere(size);
    popMatrix();
    x = cos(theta) * dist + cam.x + roomWidth/2;
    z = sin(theta) * dist + cam.z;
    theta += tMover;
  }

  void renderOnTop() 
  {
    pushMatrix();
    translate(x, y, z);
    translate(0, -size-size*.2, 0);
    fill(map(health, 100, 0, 175, 255), map(health, 100, 50, 255, 0), 0);
    rotateY(-cam.yaw + HALF_PI);
    rotateX(-cam.pitch);
    rectMode(CORNER);
    rect(-50, -7.5, health, 15);
    rectMode(CENTER);
    noFill();
    stroke(0);
    strokeWeight(2);
    rect(0, 0, 100, 15);
    popMatrix();
  }

  boolean sphereRayCol(float x1, float y1, float z1, float x2, float y2, float z2)
  {
    println(x1, y1, z1);
    println(x, y, z);
    float a, b, c, i;
    a =  sq(x2 - x1) + sq(y2 - y1) + sq(z2 - z1);
    b =  2* ( (x2 - x1)*(x1 - x)+ (y2 - y1)*(y1 - y)+ (z2 - z1)*(z1 - z) ) ;
    c =  sq(x) + sq(y) +sq(z) + sq(x1) +sq(y1) + sq(z1) -2* ( x*x1 + y*y1 + z*z1 ) - sq(size);
    i =   b * b - 4 * a * c ;
    if (i >= 0)
    {
      return true;
    } else
    {
      return false;
    }
  }

  void updateHealth()
  {
    size *= random(.9, 1.1);
    if (size >= eSize * 1.25 || size <= eSize * .75)
    {
      size = eSize;
    }
    health--;
  }
}

//Resets all enemys
void newEnemys()
{
  enemys.clear();
  for (int i = 0; i < maxEnemys; i++)
  {
    enemys.add(new Enemy(eSize));
  }
}

void hitSound(int num)
{
  if (frameCount % 15 == 0)
  {
    hitSound.stop();
    hitSound.play(num * 2, .5, volume / num, 0, .1 * num/2);
  }
  else if(num == 4)
  {
    hitSound.stop();
    hitSound.play(num * 2, .5, volume / num, 0, .1 * num/2);
  }
}

void enemyRender()
{
  //Renders all enemys
  for (int i = 0; i < enemys.size(); i++)
  {
    enemys.get(i).render();
  }


  hint(DISABLE_DEPTH_TEST);
  for (Enemy e : enemys) {
    e.renderOnTop();
  }
  hint(ENABLE_DEPTH_TEST);
}
