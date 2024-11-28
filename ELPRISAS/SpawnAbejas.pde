class SpawnAbejas {
  private ArrayList<Abeja> abejas;
  private int tiempoEntreAbejas;  // Intervalo entre spawns
  private int contadorTiempo;     // Contador para gestionar el tiempo
  private String spritePath = "Abeja.png";

  public SpawnAbejas() {
    abejas = new ArrayList<Abeja>();
    tiempoEntreAbejas = 120;  // 2 segundos a 60 fps
    contadorTiempo = 0;
  }

  public void update(Player player, float bossX, float bossY) {
    contadorTiempo++;
    if (contadorTiempo >= tiempoEntreAbejas) {
      generarAbeja(bossX, bossY, player.getX(), player.getY());
      contadorTiempo = 0;
    }
  
    for (int i = abejas.size() - 1; i >= 0; i--) {
      Abeja abeja = abejas.get(i);
      abeja.update();
  
      if (abeja.colisiona(player)) {
player.perderVida(maquinaDeEstado);  // Pasar la instancia correcta de MaquinaDeEstado
        abejas.remove(i);
      }
    }
  }


  public void display() {
    for (Abeja abeja : abejas) {
      abeja.display();
    }
  }

  private void generarAbeja(float bossX, float bossY, float sonicX, float sonicY) {
    abejas.add(new Abeja(bossX, bossY, sonicX, sonicY, spritePath));
  }
}
