boolean sphereRayCol(float x1, float y1, float z1, float x2, float y2, float z2, float x3, float y3, float z3)
{
  float a, b, c, i;
  a =  sq(x2 - x1) + sq(y2 - y1) + sq(z2 - z1);
  b =  2* ( (x2 - x1)*(x1 - x3)+ (y2 - y1)*(y1 - y3)+ (z2 - z1)*(z1 - z3) ) ;
  c =  sq(x3) + sq(y3) +sq(z3) + sq(x1) +sq(y1) + sq(z1) -2* ( x3*x1 + y3*y1 + z3*z1 ) - sq(50);
  i =   b * b - 4 * a * c ;
  if (i >= 0)
  {
    return true;
  } else
  {
    return false;
  }
}
boolean raySphereVectorCol(PVector rayOrigin, PVector rayDirection, PVector enemyOrigin, float radius) {
  
  float t = enemyOrigin.sub(rayOrigin).dot(rayDirection);
  PVector p = rayOrigin.add(rayDirection.mult(t));
  float y  = enemyOrigin.sub(p).mag();
  if( y < radius) {
    return false ;
  }
  return true;
}
