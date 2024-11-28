class SpawnAbejas {
  private ArrayList<Abeja> abejas;
  private int tiempoEntreAbejas;
  private int contadorTiempo;
  private String spritePath = "Abeja.png";
  private MaquinaDeEstado maquinaDeEstado;  // Atributo para guardar la referencia a MaquinaDeEstado

  public SpawnAbejas(MaquinaDeEstado maquinaDeEstado) {
    this.maquinaDeEstado = maquinaDeEstado;  // Guardamos la instancia de MaquinaDeEstado
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

    // Verificar si la abeja colisiona con el jugador
    if (abeja.colisiona(player)) {
      // Si la abeja no se destruyó (el jugador no estaba saltando), el jugador pierde vida
      if (!abeja.destruida) {
        player.perderVida(maquinaDeEstado);  // Llamamos a perder vida
      }
      abejas.remove(i);  // Eliminar la abeja de la lista
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
