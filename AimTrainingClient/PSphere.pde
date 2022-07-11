//----------------------------------------------------------
// spheres are defined by center point and radius  
//----------------------------------------------------------
class PSphere 
{ PVector center;
  float radius;
  PSphere()
  { center = new PVector(222,222);
    radius = 200;
  }
  PSphere(PVector center, float radius)
  { this.center = center;
    this.radius = radius;  
  }
  PSphere(PSphere sph)
  { this.center = sph.center;
    this.radius = sph.radius;  
  }
  void set(PVector center, float radius)
  { this.center = center;
    this.radius = radius;  
  }
  void setCenter(PVector center)
  { this.center = center;
  }
  void draw() 
  { pushMatrix();
      translate (center.x, center.y, center.z);
      sphere(radius);
    popMatrix();  
  }
}
