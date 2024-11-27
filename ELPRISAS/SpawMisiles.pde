class SpawnMisiles {
  private PImage misilImage;  // Imagen del misil
  private ArrayList<Misil> misiles;  // Lista de misiles activos
  private int intervalo;  // Intervalo entre disparos (en fotogramas)
  private int temporizador;  // Temporizador para controlar el disparo

  public SpawnMisiles(String misilImagePath, int intervalo) {
    this.misilImage = loadImage(misilImagePath);
    this.misiles = new ArrayList<Misil>();
    this.intervalo = intervalo;
    this.temporizador = 0;
  }

  public void disparar(float x, float y, float velocidad, float escala) {
    // Crear un nuevo misil y añadirlo a la lista
    Misil nuevoMisil = new Misil(misilImage, x, y, velocidad, escala);
    misiles.add(nuevoMisil);
  }

  public void update() {
    temporizador++;
    // Actualizar cada misil
    for (int i = misiles.size() - 1; i >= 0; i--) {
      Misil misil = misiles.get(i);
      misil.update();
      // Eliminar misiles que salieron de la pantalla
      if (misil.fueraDePantalla()) {
        misiles.remove(i);
      }
    }
  }

  public void display() {
    // Dibujar todos los misiles
    for (Misil misil : misiles) {
      misil.display();
    }
  }

  public void intentarDisparar(float x, float y, float velocidad, float escala) {
    if (temporizador >= intervalo) {
      disparar(x, y, velocidad, escala);
      temporizador = 0;  // Reiniciar el temporizador
    }
  }
}
