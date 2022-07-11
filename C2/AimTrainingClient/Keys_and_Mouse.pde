//Locks mouse into place
void lockMouse() {
  if (!mouseLock) {
    oldMouse = new PVector(mouseX, mouseY);
    offsetX = mouseX - width/2;
    offsetY = mouseY - height/2;
  }
  mouseLock = true;
}

//unlocks mouse
void unlockMouse() {

  if (mouseLock) {
    r.warpPointer((int) oldMouse.x, (int) oldMouse.y);
  }
  mouseLock = false;
}

//opens menu
void keyPressed()
{
  if (keyCode >= 0 && keyCode < 256) {
    keys[keyCode] = true;
  }
  if (keyDown('P'))
  {
    updateMenu();
  }
}

void keyReleased() {
  if (keyCode >= 0 && keyCode < 256) {
    keys[keyCode] = false;
  }
}

boolean keyDown(int key) {
  return keys[key];
}

//Menu buttons
void mousePressed()
{
  if (settings)
  {
    hitSound(4);
    preformAction();
  }
  if (mouseButton == RIGHT)
  {
    Sensitivity /= 2;
  }
}

//Zoomer effect
void mouseReleased()
{
  if (mouseButton != LEFT)
  {
    zoomer = -.25;
    Sensitivity *= 2;
  }
}

// mouse shenanigans
void mouseAndCam()
{
  if (!focused && mouseLock) {
    unlockMouse();
  }
  if (mouseLock) {
    // camera code here
    cam.yaw += (mouseX-offsetX-width/2.0)*Sensitivity;
    cam.pitch -= (mouseY-offsetY-height/2.0)*Sensitivity;
    r.setPointerVisible(false); //When locked and trying to move, the pointer jerks all over the place, so best to hide it.
    r.warpPointer(width/2, height/2); //Move it to the exact center of the sketch window.
    r.confinePointer(true); //Locks pointer inside of the sketch's window so it doesn't escape.
  } else {
    r.confinePointer(false);
    r.setPointerVisible(true);
  }
  offsetX=offsetY=0;
  cam.pitch = constrain(cam.pitch, -HALF_PI + 0.0001, HALF_PI- .0001); // glitchyness near 90 degrees
  cam.apply(g, zoom);
  view = cam.getViewDirection();
}

void movement()
{
  if (keyPressed)
  {
    if (keyDown('W'))
    {
      cam.x += view.x * speed;
      cam.z += view.z * speed;
    }
    if (keyDown('S'))
    {
      cam.x -= view.x * speed;
      cam.z -= view.z * speed;
    }
    if (keyDown('A'))
    {
      cam.x += cos(cam.yaw - PI/2) * cos(cam.pitch) * speed * 2;
      cam.z += sin(cam.yaw - PI/2) * cos(cam.pitch) * speed * 2;
    }
    if (keyDown('D'))
    {
      cam.x -= cos(cam.yaw - PI/2) * cos(cam.pitch) * 10;
      cam.z -= sin(cam.yaw - PI/2) * cos(cam.pitch) * 10;
    }
  }
}
