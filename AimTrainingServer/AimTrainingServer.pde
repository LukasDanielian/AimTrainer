import processing.net.*;
import java.util.Map;
float speed = 5;
Server server;
int id;
long mapSeed;
HashMap<Client, OnlinePlayer> connectedPlayers = new HashMap<Client, OnlinePlayer>();
//HashMap<Client, Thread> threads = new HashMap<Client, Thread>();
void setup()
{
  size(150, 150);
  frameRate(144);
  background(0);
  rectMode(CENTER);
  id = 0;
  server = new Server(this, 3000);
  mapSeed = (long)random(0,MAX_INT);
}

void draw()
{
  fill(255);
  text("SERVER", width/2, height/2);
  thread("pData");
}

void pData() {
  for (Map.Entry<Client, OnlinePlayer> entry : connectedPlayers.entrySet())
  {
    OnlinePlayer p = entry.getValue();
    sendData("PlayerXYZ", new String[]{p.id +"", p.x + "", p.y + "", p.z + "", p.yaw + "", p.pitch + "", p.health + ""});
  }
}
//PlayerXYZ - ID of Player - X - Y - Z - yaw - pitch
void sendData(String type, String[] info) {
  server.write(type + "/" + join(info, "/") + "\n");
}

void clientEvent(Client client) {

  if (client != null) {
    Runnable pHandler = new PacketHandler(client, client.readString());
    Thread thread = new Thread(pHandler);
    thread.start();
  }
}

void serverEvent(Server s, Client c) {
  println("Client Connected: " );
  c.write("ClientServerConnectionEstablished/" + id + "/" + mapSeed + "/\n");
  id++;
  String recieved = c.readString();
  println("Server Event: " + recieved);

}

void disconnectEvent(Client c) {
  int cID = connectedPlayers.get(c).id;
   connectedPlayers.remove(c);
  for (Map.Entry<Client, OnlinePlayer> entry : connectedPlayers.entrySet())
  {
    Client cO = entry.getKey();
    cO.write("ClientServerConnectionLost/" + cID + "\n");
  }
}

public boolean processHS(OnlinePlayer shooter, OnlinePlayer other) {
  PVector S1 = new PVector();
  PVector S2  = new PVector();
  Ray shooterRay = new Ray(shooter.x, shooter.y, shooter.z, shooter.getViewDirection().x, shooter.getViewDirection().y, shooter.getViewDirection().z);
  PSphere otherSphere = new PSphere(new PVector(other.x, other.y, other.z), 50);
  int ip = raySphereIntersection(shooterRay,otherSphere, S1, S2 );
  println(ip);
  if(ip>0) return true;
  return false;
}


int raySphereIntersection(Ray ray, PSphere c, PVector S1, PVector S2) 
{
  PVector e = new PVector(ray.direction.x, ray.direction.y, ray.direction.z);   // e=ray.dir
  e.normalize();                            // e=g/|g|
  PVector h = PVector.sub(c.center,ray.origin);  // h=r.o-c.M
  float lf = e.dot(h);                      // lf=e.h
  float s = sq(c.radius)-h.dot(h)+sq(lf);   // s=r^2-h^2+lf^2
  if (s < 0.0) return 0;                    // no intersection points ?
  s = sqrt(s);                              // s=sqrt(r^2-h^2+lf^2)

  int result = 0;
  if (lf < s)                               // S1 behind A ?
  { if (lf+s >= 0)                          // S2 before A ?}
    { s = -s;                               // swap S1 <-> S2}
      result = 1;                           // one intersection point
  } }
  else result = 2;                          // 2 intersection points

  S1.set(PVector.mult(e, lf-s));  S1.add(ray.origin); // S1=A+e*(lf-s)
  S2.set(PVector.mult(e, lf+s));  S2.add(ray.origin); // S2=A+e*(lf+s)
  
  // println (" s=" + nf( s,0,2)+ "  lf=" + nf(lf,0,2));  // only for testing
  return result;
}
