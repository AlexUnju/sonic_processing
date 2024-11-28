import processing.sound.*;
import processing.core.PApplet;  // Importar PApplet

class SpawnMisiles {
  private PImage misilImage;
  private ArrayList<Misil> misiles;
  private int intervalo;
  private int temporizador;
  private SoundFile sonidoDisparo;  // Archivo de sonido para el disparo
  private PApplet app;  // Referencia a PApplet

  // Constructor modificado para recibir PApplet
  public SpawnMisiles(PApplet app, String misilImagePath, String soundPath, int intervalo) {
    this.app = app;  // Guardar referencia de PApplet
    this.misilImage = app.loadImage(misilImagePath);  // Usar app para cargar la imagen
    this.misiles = new ArrayList<Misil>();
    this.intervalo = intervalo;
    this.temporizador = 0;

    // Cargar el sonido del disparo usando la referencia de PApplet
    sonidoDisparo = new SoundFile(app, soundPath);
  }

  public void disparar(float x, float y, float velocidad, float escala, Player player, boolean mirandoDerecha) {
    // Crear un nuevo misil y añadirlo a la lista
    Misil nuevoMisil = new Misil(misilImage, x, y, velocidad, escala, player, mirandoDerecha);
    misiles.add(nuevoMisil);

    // Reproducir el sonido de disparo
    sonidoDisparo.play();
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
      disparar(x, y, velocidad, escala, player, mirandoDerecha);
      temporizador = 0;
    }
  }
}
