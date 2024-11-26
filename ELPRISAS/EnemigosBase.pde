abstract class EnemigosBase {
  protected PImage spriteSheet; // Imagen completa de los sprites
  private PImage[] movimiento; // Sprites de movimiento
  private PImage[] estatico;   // Sprites estáticos
  private PImage[] explosion;  // Sprites de explosión
  private int currentFrame;    // Frame actual
  protected float x, y;          // Posición
  private float width, height; // Tamaño de los sprites
  protected int vida;            // Vida del enemigo
  protected int daño;            // Daño al jugador
  private int estado;          // 0: Movimiento, 1: Estático, 2: Explosión
  private int frameDelay;      // Velocidad de animación
  private int frameCounter;    // Contador para control de frames
  private boolean eliminado;   // Indica si el enemigo debe eliminarse

  // Constructor común para todos los enemigos
  EnemigosBase(PImage spriteSheet, float x, float y, int vida, int daño) {
    this.spriteSheet = spriteSheet;
    this.x = x;
    this.y = y;
    this.vida = vida;
    this.daño = daño;
    this.estado = 0; // Inicialmente en movimiento
    this.frameDelay = 5;
    this.frameCounter = 0;
    this.currentFrame = 0;
    this.eliminado = false;

    // Calcular tamaño de cada sprite
    this.width = spriteSheet.width / 8.0;
    this.height = spriteSheet.height / 5.0;

    // Inicializar los arreglos de animación
    movimiento = new PImage[8];
    estatico = new PImage[8];
    explosion = new PImage[3];
  }

  // Método para cargar los sprites de los enemigos
  void cargarSprites() {
    // Esto debe ser implementado en las clases hijas
  }

  // Método para mostrar el enemigo
  void mostrar() {
    if (eliminado) return;

    PImage[] animacionActual;
    switch (estado) {
      case 0:
        animacionActual = movimiento;
        break;
      case 1:
        animacionActual = estatico;
        break;
      case 2:
        animacionActual = explosion;
        break;
      default:
        animacionActual = movimiento;
    }

    image(animacionActual[currentFrame], x, y);
    actualizarAnimacion(animacionActual.length);
  }

  // Método para actualizar la animación
  void actualizarAnimacion(int totalFrames) {
    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame++;
      if (estado == 2 && currentFrame >= totalFrames) {
        eliminado = true;
      } else {
        currentFrame %= totalFrames;
      }
      frameCounter = 0;
    }
  }

  // Método para mover al enemigo
  void mover(float velocidadX, float velocidadY) {
    if (estado != 2 && !eliminado) {
      this.x += velocidadX;
      this.y += velocidadY;
    }
  }

  // Método para verificar si el enemigo está eliminado
  boolean isEliminado() {
    return eliminado;
  }
}
