public class PacketHandler implements Runnable {
  Client packet_client;
  String message;
  Boolean running = true;
  public PacketHandler(Client client, String message) {
    this.packet_client = client;
    this.message = message;
  }
  public synchronized void stopRunning() {
    this.running = false;
  }

  public void run() {
    if (running && message != null) {
      String recieved = message;
      recieved = recieved.substring(0, recieved.indexOf("\n"));
      if (recieved != null) {
        String[] args = split(recieved, "/");
        //println( packet_client.ip() + "\t" + recieved);
        if (args[0].equals("PlayerXYZ")) {
          OnlinePlayer op = connectedPlayers.get(packet_client);
          if (op != null) {
            op.x = float(args[2]);
            op.y = float(args[3]);
            op.z = float(args[4]);
            op.yaw = float(args[5]);
            op.pitch = float(args[6]);
            op.health = float(args[7]);
          }
        }
        if (args[0].equals("ServerPlayerI")) {
          connectedPlayers.put(packet_client, new OnlinePlayer(float(args[2]), float(args[3]), float(args[4]), float(args[5]), float(args[6]), float(args[7]), int(args[1])));
        }
        if (args[0].equals("PlayerShot"))
        {
          OnlinePlayer op = connectedPlayers.get(packet_client);
          if (op != null)
          {
            PVector view = op.getViewDirection();
            for (Map.Entry<Client, OnlinePlayer> entry : connectedPlayers.entrySet())
            {
              OnlinePlayer p = entry.getValue();
              if (p != null && p.id != op.id)
              {
                println("VIEW " + view.x + " " + view.y + " " + view.z);
                if (processHS(op, p))
                {
                  sendData("EnemyHit", new String[]{op.id + ""});
                  p.updateHealth();
                  if (p.health <= 0)
                  {
                    sendData("Respawn", new String[]{p.id + ""});
                  }
                } else
                {
                  sendData("EnemyMiss", new String[]{op.id + ""});
                }
              }
            }
          }
        }
      }
    }
  }
}
