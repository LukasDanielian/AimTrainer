import com.jogamp.newt.opengl.GLWindow;
import processing.sound.*;
import processing.net.*;
import java.util.Map;
float speed = 5;
String info;
Client client;
int idNum;
float roomHeight = 1000;
float roomWidth = 2000;
HashMap<Integer, Player> connectedPlayers = new HashMap<Integer, Player>();
//Player localPlayer;
boolean mainMenu = true;
boolean mapReady = false;
int mode;
Button aimLab;
Button sandbox;
float playerHealth = 100;

void setup()
{
  fullScreen(P3D);
  //size(1000, 500, P3D);
  frameRate(144);
  rectMode(CENTER);
  elimSound = new SoundFile(this, "elimSound.wav");
  hitSound = new SoundFile(this, "hitSound.wav");
  r=(GLWindow)surface.getNative();
  mouseLock = false;
  Sensitivity = 0.001;
  oldMouse = new PVector(mouseX, mouseY);
  keys = new boolean[256];
  eSize = 50;
  settings = false;
  newEnemys();
  makeButtons();
  close = new Button(width/2 + width * .3, height/2 - height * .3, 50, 50, "X");
  aimLab = new Button(width/2 - width/4, height/2, width/3, height/3, "Aim Lab");
  sandbox = new Button(width/2 + width/4, height/2, width/3, height/3, "Sandbox");
  homeMenu = new Button(width/2, height * .75, width * .15, height * .15, "Main Menu");
  updateLables();
}

void draw()
{
  background(0);
  if (mainMenu)
  {
    camera();
    ortho();
    aimLab.render(255, 0, 50);
    sandbox.render(255, 0, 50);
    if (aimLab.isClicked())
    {
      cam = new FPSCamera(roomWidth, roomHeight);
      mode = 1;
      mainMenu = !mainMenu;
      lockMouse();
    } else if (sandbox.isClicked())
    {
      cam = new FPSCamera(mapSize, mapHeight);
      mode = 2;
      mainMenu = !mainMenu;
      lockMouse();
      //localPlayer = new Player(-cam.x, -cam.y, -cam.z, cam.yaw, cam.pitch, 100, idNum);
      client = new Client(this, "127.0.0.1", 3000);
    }
  } else
  {
    if (mode == 1)
    {
      mouseAndCam();
      spotLight(255, 255, 255, -cam.x, -cam.y, -cam.z, -view.x, -view.y, -view.z, PI/2, 1);
      spotLight(150, 150, 150, 0, -height, 0, 0, 1, 0, PI/2, 1);

      pushMatrix();
      noStroke();
      fill(red, green, blue);
      translate(roomWidth/2, roomHeight/2, 0);
      box(roomWidth * 2, roomHeight, roomWidth * 2);
      popMatrix();

      translate(-cam.x, -cam.y, -cam.z);
      enemyRender();
      aimLabHitScan();
      aimLabsBounds();
      movement();
      flatEffects();
    } else if (mode == 2)
    {
      mouseAndCam();
      spotLight(255, 255, 255, -cam.x, -cam.y, -cam.z, -view.x, -view.y, -view.z, PI/2, 1);
      makeRoom();
      sandBoxHitScan();
      sandboxMovement();
      sandboxBounds();

      for (Map.Entry<Integer, Player> entry : connectedPlayers.entrySet())
      {
        Player p = entry.getValue();
        if (p.id != idNum) {
          p.draw();
          fill(0, 230, 0);

          Ray shooterRay = new Ray(p.x, p.y, p.z, p.getViewDirection().x * 100, p.getViewDirection().y * 100, p.getViewDirection().z * 100);
          shooterRay.draw3d();

          p.renderOnTop();
        }
      }

      flatEffects();

      sendData("PlayerXYZ", new String[]{idNum + "", -cam.x + "", -cam.y + "", -cam.z + "", cam.yaw + "", cam.pitch + "", playerHealth + ""});
    }
  }
}

void sendData(String type, String[] info) {
  if (client != null)
  {
    client.write(type + "/" + join(info, "/") + "\n");
  }
}
void updatePlayerHashmap(int id, String[] args)
{
  float pX = float(args[2]);
  float pY = float(args[3]);
  float pZ = float(args[4]);
  float pYaw = float(args[5]);
  float pPitch = float(args[6]);
  float pHealth = float(args[7]);
  if (id != idNum) {
    if (connectedPlayers.containsKey(id))
    {
      Player p = connectedPlayers.get(id);
      p.x = pX;
      p.y = pY;
      p.z = pZ;
      p.yaw = pYaw;
      p.pitch = pPitch;
      p.health = pHealth;
      connectedPlayers.put(id, p);
    } else {
      connectedPlayers.put(id, new Player(pX, pY, pZ, pYaw, pPitch, pHealth, id));
    }
  } else {
    //Lag back
    float dist = abs(-cam.x - pX) + abs(-cam.y - pY) + abs(-cam.z - pZ);

    if (dist > 30) {
      cam.x = -pX;
      cam.y = -pY;
      cam.z = -pZ;
    }
    if (id == idNum)
    {
      playerHealth = pHealth;
    }
  }
}

void clientEvent(Client client)
{
  if (client.available() > 0)
  {
    info = client.readString();
    info = info.substring(0, info.indexOf("\n"));
    String args[] = split(info, "/");
    if (args[0].equals("PlayerXYZ"))
    {
      updatePlayerHashmap(int(args[1]), args);
    }

    if (args[0].equals("ClientServerConnectionEstablished"))
    {
      idNum = int(args[1]);
      sendData("ServerPlayerI", new String[]{idNum + "", -cam.x + "", -cam.y + "", -cam.z + "", cam.yaw + "", cam.pitch + "", playerHealth + ""});
      noiseSeed(int(args[2]));
      mapReady = true;
    }
    if (args[0].equals("ClientServerConnectionLost"))
    {
      connectedPlayers.remove(int(args[1]));
    }
    if (args[0].equals("EnemyHit"))
    {
      if (args[1].equals(""+idNum))
      {
        effectTime = 1;
        hitSound(1);
      }
    }
    if (args[0].equals("EnemyMiss"))
    {
      if (args[1].equals(""+idNum))
      {
        hitSound(2);
      }
    }
    if(args[0].equals("Respawn") && args[1].equals("" + idNum))
    {
      cam = new FPSCamera(mapSize, mapHeight);
      playerHealth = 100;
    }
  }
}
