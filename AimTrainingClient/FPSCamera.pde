class FPSCamera 
{
  public float yaw, pitch;
  public float x;
  public float y;
  public float z;
  
  public FPSCamera(float x, float y)
  {
     this.x = random(-x,0);
     this.y = -y + 150;
     z = random(-x/2,x/2);
  }
  void apply(PGraphics c, float zoom) 
  {
    if (!c.is3D()) return;
    PVector view = getViewDirection();
    c.perspective(PI/zoom, float(width)/height, 0.01, 100000);
    c.camera(view.x, view.y, view.z, 0,0,0, 0, 1, 0);
    c.translate(x, y, z);
  }
  PVector getViewDirection() 
  {
    return new PVector(cos(yaw) * cos(pitch), sin(pitch), sin(yaw) * cos(pitch));
  }
}
