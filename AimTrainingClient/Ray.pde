class Ray
{ PVector origin;
  PVector direction;
  
  Ray(float Ax, float Ay, float Az
     ,float Bx, float By, float Bz)
  { origin = new PVector(Ax, Ay, Az);
    direction = new PVector(Bx, By, Bz);
  }
  Ray(PVector A, PVector B)
  { origin = new PVector(A.x, A.y, A.z);
    direction = PVector.sub(B,A);
  }
  Ray(Ray r)
  { origin = new PVector(r.origin.x, r.origin.y, r.origin.z);
    direction = new PVector(r.direction.x, r.direction.y, r.direction.z);
  }
  void set(PVector A, PVector B)
  { origin = new PVector(A.x, A.y, A.z);
    direction = PVector.sub(B,A);
  }
  void setOrigin(float x, float y, float z)
  { origin = new PVector(x, y, z);
  }
  void setOrigin(PVector pos)
  { origin = new PVector(pos.x, pos.y, pos.z);
  }
  void setDirection(float x, float y, float z)
  { direction = new PVector(x, y, z);
  }
  void setDirection(PVector dir)
  { direction = new PVector(dir.x, dir.y, dir.z);
  }
  void lookAt (float x, float y, float z)
  { direction = new PVector(x-origin.x, y-origin.y, z-origin.z);
  }
  
  void draw2d() 
  { line(origin.x, origin.y, origin.x+direction.x, origin.y+direction.y);
    ellipse (origin.x, origin.y, 2,2);   
  }
  void draw3d() 
  { 
    stroke(120, 120, 0);
     line(origin.x, origin.y, origin.z, origin.x+direction.x, origin.y+direction.y, origin.z+direction.z);
  }
}
