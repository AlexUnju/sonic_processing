class SpawnMisiles {
  private PImage misilImage;
  private ArrayList<Misil> misiles;
  private int intervalo;
  private int temporizador;

  public SpawnMisiles(String misilImagePath, int intervalo) {
    this.misilImage = loadImage(misilImagePath);
    this.misiles = new ArrayList<Misil>();
    this.intervalo = intervalo;
    this.temporizador = 0;
  }

  public void disparar(float x, float y, float velocidad, float escala, Player player, boolean mirandoDerecha) {
    // Crear un nuevo misil y añadirlo a la lista
    Misil nuevoMisil = new Misil(misilImage, x, y, velocidad, escala, player, mirandoDerecha);  // Ahora pasamos 'mirandoDerecha'
    misiles.add(nuevoMisil);
  }

  public void update() {
    temporizador++;
    // Actualizar cada misil
    for (int i = misiles.size() - 1; i >= 0; i--) {
      Misil misil = misiles.get(i);
      misil.update();
      if (misil.fueraDePantalla()) {
        misiles.remove(i);
      }
    }
  }

  public void display() {
    for (Misil misil : misiles) {
      misil.display();
    }
  }

  public void intentarDisparar(float x, float y, float velocidad, float escala, Player player, boolean mirandoDerecha) {
    if (temporizador >= intervalo) {
      disparar(x, y, velocidad, escala, player, mirandoDerecha);  // Ahora pasamos 'mirandoDerecha'
      temporizador = 0;
    }
  }
}
