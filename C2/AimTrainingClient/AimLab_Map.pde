void aimLabsBounds()
{
  if (cam.x <= roomWidth * -1.5 + 50)
  {
    cam.x = roomWidth * -1.5 + 50;
  }
  if (cam.x > roomWidth/2 - 50)
  {
    cam.x = roomWidth/2 - 50;
  }
  if (cam.z >= roomWidth - 50)
  {
    cam.z = roomWidth - 50;
  }
  if (cam.z < -roomWidth + 50)
  {
    cam.z = -roomWidth + 50;
  }
}

//Movement shoot and zoom
void aimLabHitScan()
{
  //Hit scan and zooming
  if (mousePressed)
  {
    if (mouseButton == LEFT && !settings && !mainMenu)
    {
      //cam.pitch+=recoil;
      int numHit = 0;
      for (int i = 0; i < enemys.size(); i++)
      {
         println("VIEW " + view.x + " " + view.y + " " + view.z); 
         println(-cam.x, -cam.y, -cam.z);
        if (enemys.get(i).sphereRayCol(0,0,0, view.x, view.y, view.z))
        {
          hitSound(1);
          numHit++;
          enemys.get(i).updateHealth();
          effectTime = 1;
          if (enemys.get(i).health <= 0)
          {
            elimSound.play(1, .5, volume*10);
            enemys.remove(i);
            enemys.add(new Enemy(eSize));
          }
        }
      }
      if (numHit == 0)
      {
        hitSound(2);
      }
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
