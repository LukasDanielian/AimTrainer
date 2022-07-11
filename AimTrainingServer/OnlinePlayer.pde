public class OnlinePlayer {
  public float x;
  public float y;
  public float z;
  public float yaw;
  public float pitch;
  public int id;
  public float health;

  public OnlinePlayer(float x, float y, float z, float yaw, float pitch, float health, int id)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.yaw = yaw;
    this.pitch = pitch;
    this.health = health;
    this.id = id;
  }

  public void updateHealth()
  {
    health--;
  }

  public void respawn()
  {
  }

  PVector getViewDirection() 
  {
    return new PVector(-cos(this.yaw) * cos(this.pitch), -sin(this.pitch), -sin(this.yaw) * cos(this.pitch));
  }
  boolean sphereRayCol(float x1, float y1, float z1, float x2, float y2, float z2)
  {
    float a, b, c, i;
    a =  sq(x2 - x1) + sq(y2 - y1) + sq(z2 - z1);
    b =  2* ( (x2 - x1)*(x1 - x)+ (y2 - y1)*(y1 - y)+ (z2 - z1)*(z1 - z) ) ;
    c =  sq(x) + sq(y) +sq(z) + sq(x1) +sq(y1) + sq(z1) -2* ( x*x1 + y*y1 + z*z1 ) - sq(50);
    i =   b * b - 4 * a * c ;
    if (i >= 0)
    {
      return true;
    } else
    {
      return false;
    }
  }
}
