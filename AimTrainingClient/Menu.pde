//MENU
void renderMenu()
{
  if (close.isClicked())
  {
    clicked = buttons.size();
  }
  if (homeMenu.isClicked())
  {
    mainMenu = true;
    settings = false;
    mode = 0;
    return;
  }

  fill(0);
  stroke(255);
  rect(width/2, height/2, width * .75, height * .75, 25);

  for (int i = 0; i < buttons.size(); i++)
  {
    if (i % 2 == 0)
    {
      fill(255);
      textSize(25);
      text(headings[i/2] + " " + data[i/2], buttons.get(i).x + buttons.get(i).w/2, buttons.get(i).y - buttons.get(i).h);
    }
    buttons.get(i).render(255, 0, 50);
    if (buttons.get(i).isClicked())
    {
      clicked = i;
    }
  }
  close.render(#FF0000, 0, 25);
  homeMenu.render(255, 0, 25);
}

//ON Screen 2D effects
void flatEffects()
{
  pushMatrix();
  hint(DISABLE_DEPTH_TEST);
  rectMode(CENTER);
  camera();
  ortho();

  if (settings)
  {
    //renderMenu();
  } else
  {
    stroke(255, 0, 0);
    strokeWeight(1);
    rect(width/2, height/2, 1, 15);
    rect(width/2, height/2, 15, 1);
    noFill();
    strokeWeight(2);
    ellipse(width/2, height/2, 25, 25);
  }

  textAlign(LEFT, TOP);
  fill(255);
  textSize(25);
  text("FPS: " + frameRate, 5, 5);

  textAlign(CENTER, CENTER);
  text("Settings: 'P'", width/2, 25);
  text("Connected Players", width/2, 50);
  int pI = 0;
  for (Map.Entry<Integer, Player> entry : connectedPlayers.entrySet()) {
    Player p = entry.getValue();
    text(p.toString(), width/2, 75 + 25 * pI);
    pI++;
  }

  if (effectTime > 0)
  {
    noFill();
    stroke(255, 0, 0);
    pushMatrix();
    translate(width/2, height/2);
    rotate(QUARTER_PI);
    for (int i = 0; i < 4; i++)
    {
      rotate(HALF_PI);
      rect(0, -30, 1, 15);
    }
    popMatrix();
    effectTime--;
  }

  hint(ENABLE_DEPTH_TEST);
  popMatrix();
}

void updateLables()
{
  data[0] = (int)eSize;
  data[1] = (int)(Sensitivity * 10000);
  data[2] = (int)(rotSpeed * 1000);
  data[3] = (int)maxEnemys;
  data[4] = (int)(maxZoom * 10);
  data[5] = (int)fHealth;
  data[6] = (int)(volume * 100);
  data[7] = (int)speed;
  data[8] = (int)(recoil * 10000);
  data[9] = (int)red;
  data[10] = (int)green;
  data[11] = (int)blue;
}

void updateMenu()
{
  settings = !settings;
  if (!mouseLock)
  {
    newEnemys();
    lockMouse();
  } else if (mouseLock)
  {
    unlockMouse();
  }
}
//What each button does
void preformAction()
{
  switch(clicked)
  {
    //Enemy Size
  case 0:
    {
      if (eSize > 10)
      {
        eSize -= 10;
      }
      break;
    }
  case 1:
    {
      if (eSize < 100)
      {
        eSize += 10;
      }
      break;
    }

    //Sensitivity
  case 2:
    {
      if (Sensitivity > .0001)
      {
        Sensitivity -= .0001;
      }
      break;
    }
  case 3:
    {
      if (Sensitivity < .05)
      {
        Sensitivity += .0001;
      }
      break;
    }

    //Rotation Speed
  case 4:
    {
      if (rotSpeed > 0)
      {
        rotSpeed -= .001;
      }
      break;
    }
  case 5:
    {
      if (rotSpeed < .05)
      {
        rotSpeed += .001;
      }
      break;
    }

    //Enemys
  case 6:
    {
      if (maxEnemys > 1)
      {
        maxEnemys--;
      }
      break;
    }
  case 7:
    {
      if (maxEnemys < 15)
      {
        maxEnemys++;
      }
      break;
    }

    //Zoom Amount
  case 8:
    {
      if (maxZoom > 3.5)
      {
        maxZoom -= .25;
      }
      break;
    }
  case 9:
    {
      if (maxZoom < 10)
      {
        maxZoom += .25;
      }
      break;
    }

    //Health
  case 10:
    {
      if (fHealth > 5)
      {
        fHealth-=5;
      }
      break;
    }
  case 11:
    {
      if (fHealth < 100)
      {
        fHealth+=5;
      }
      break;
    }

    //Volume
  case 12:
    {
      if (volume > .01)
      {
        volume-=.01;
      }
      break;
    }
  case 13:
    {
      if (volume < .1)
      {
        volume+=.01;
      }
      break;
    }

    //Movement Speed
  case 14:
    {
      if (speed > 1)
      {
        speed--;
      }
      break;
    }
  case 15:
    {
      if (speed < 10)
      {
        speed++;
      }
      break;
    }

    //Recoil
  case 16:
    {
      if (recoil > 0)
      {
        recoil -= .0001;
      }
      break;
    }
  case 17:
    {
      if (recoil < .002)
      {
        recoil += .0001;
      }
      break;
    }

    //Wall Red
  case 18:
    {
      if (red > 0)
      {
        red -= 5;
      }
      break;
    }
  case 19:
    {
      if (red < 255)
      {
        red += 5;
      }
      break;
    }

    //Wall Green
  case 20:
    {
      if (green > 0)
      {
        green -= 5;
      }
      break;
    }
  case 21:
    {
      if (green < 255)
      {
        green += 5;
      }
      break;
    }

    //Wall Blue
  case 22:
    {
      if (blue > 0)
      {
        blue -= 5;
      }
      break;
    }
  case 23:
    {
      if (blue < 255)
      {
        blue += 5;
      }
      break;
    }

    //Close
  case 24:
    {
      updateMenu();
      break;
    }
  }
  updateLables();
  clicked = -1;
}
