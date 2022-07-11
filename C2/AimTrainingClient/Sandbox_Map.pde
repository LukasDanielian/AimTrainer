float mapSize = 10000;
float mapHeight = 3000;
int scl = 50;
int rows = int((mapSize/scl));
float[][] terrain = new float[rows][rows];

void makeRoom()
{
  pushMatrix();
  fill(#F761B9);
  translate(mapSize/2,mapHeight/2,0);
  noStroke();
  box(mapSize, mapHeight, mapSize);
  popMatrix();
  
  float yOff = 0;
  for (int y = 0; y < rows; y++)
  {
    float xOff = 0;
    for (int x = 0; x < rows; x++)
    {
      terrain[x][y] = -map(noise(xOff, yOff) * 10, 0, 1, 0, 300);
      xOff += .01;
    }
    yOff += .01;
  }
  
  noStroke();
  pushMatrix();
  translate(0, mapHeight, -mapSize/2);
  for (int z = 0; z < rows-1; z++)
  {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < rows; x++)
    {
      fill(#2C37E8);
      vertex(x*scl, terrain[x][z], z*scl);
      vertex(x*scl, terrain[x][z+1], (z+1)*scl);
    }
    endShape();
  }
  popMatrix();
}

void sandboxBounds()
{
  if (cam.x >= -50)
  {
    cam.x = -50;
  }
  if (cam.x <= -mapSize + 50)
  {
    cam.x = -mapSize + 50;
  }
  if (cam.z >= mapSize/2 - 50)
  {
    cam.z = mapSize/2 -50;
  }
  if (cam.z <= -mapSize/2 + 50)
  {
    cam.z = -mapSize/2 + 50;
  }
  
  float zVal = cam.z;
  if(zVal < 0)
  {
    zVal = 4950 + abs(zVal);
  }
  else
  {
    zVal = 4950 - abs(zVal);
  }
  cam.y = - mapHeight - terrain[int(abs(map(cam.x,50,10050,0,rows-1)))][int(abs(map(zVal,50,10050,0,rows-1)))] + 150;
}


//Movement shoot and zoom
void sandBoxHitScan()
{
  //Hit scan and zooming
  if (mousePressed)
  {
    if (mouseButton == LEFT && !settings && !mainMenu)
    {
      cam.pitch+=recoil;
      sendData("PlayerShot", new String[]{idNum + ""});
    } else if (mouseButton == RIGHT)
    {
      zoomer = .25;
    }
  }
  zoom += zoomer;
  if (zoom >= maxZoom)
  {
    zoom = maxZoom;
  } else if (zoom <= 3)
  {
    zoom = 3;
  }
}


void sandboxMovement()
{
  if (keyPressed)
  {
    if (keyDown('W'))
    {
      cam.x += view.x * 30;
      cam.z += view.z * 30;
    }
    if (keyDown('S'))
    {
      cam.x -= view.x * 30;
      cam.z -= view.z * 30;
    }
    if (keyDown('A'))
    {
      cam.x += cos(cam.yaw - PI/2) * cos(cam.pitch) * 30;
      cam.z += sin(cam.yaw - PI/2) * cos(cam.pitch) * 30;
    }
    if (keyDown('D'))
    {
      cam.x -= cos(cam.yaw - PI/2) * cos(cam.pitch) * 30;
      cam.z -= sin(cam.yaw - PI/2) * cos(cam.pitch) * 30;
    }
  }
}
