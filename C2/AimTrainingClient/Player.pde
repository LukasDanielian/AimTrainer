public class Player {
  float x;
  float y;
  float z;
  float yaw;
  float pitch;
  float health;
  int id;
  public Player(float x, float y, float z, float yaw, float pitch, float health, int id)
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.yaw = yaw;
    this.pitch = pitch;
    this.health = health;
    this.id = id;
  }
  void draw()
  {
    pushMatrix();
    translate((x), (y), (z));
    rotateY((-yaw));
    fill(#FF0000);
    stroke(255);
    strokeWeight(1);
    sphere(50);
    translate(0, 100, 0);
    box(50, 100, 50);
    fill(0);
    translate(-25, -25, 25);
    rotateZ(pitch);
    box(50, 10, 10);






    popMatrix();
  }

  public String toString()
  {
    return "Player " + id + " X: " + x + " Y: " + y + " Z: " + z + " Yaw: " + yaw + "Pitch: " + pitch + "Health: " + health;
  }
  PVector getViewDirection()
  {
    return new PVector(-cos(this.yaw) * cos(this.pitch), -sin(this.pitch), -sin(this.yaw) * cos(this.pitch));
  }
  
  
  void renderOnTop()
  {
    if(health < 0)
    {
      health = 0;
    }
    pushMatrix();
    translate(x, y, z);
    translate(0, -60, 0);
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
}
