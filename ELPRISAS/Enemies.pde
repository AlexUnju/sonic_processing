class Enemigo {
  PImage spriteSheet;
  PImage[] movimiento;
  PImage[] estatico;
  PImage[] explosion;
  int currentFrame;
  float x, y;
  float width, height;
  int vida;
  int daño;
  int estado;
  int frameDelay;
  int frameCounter;
  boolean eliminado; // Bandera para eliminar al enemigo

  Enemigo(PImage spriteSheet, float x, float y, int vida, int daño) {
    this.spriteSheet = spriteSheet;
    this.x = x;
    this.y = y;
    this.vida = vida;
    this.daño = daño;
    this.estado = 0;
    this.frameDelay = 5;
    this.frameCounter = 0;
    this.currentFrame = 0;
    this.eliminado = false; // Inicialmente no eliminado

    this.width = spriteSheet.width / 8.0;
    this.height = spriteSheet.height / 5.0;

    movimiento = new PImage[8];
    estatico = new PImage[8];
    explosion = new PImage[3];
    cargarSprites();
  }

  void cargarSprites() {
    for (int i = 0; i < 8; i++) {
      int col = i % 4;
      int row = i / 4;
      movimiento[i] = spriteSheet.get((int)(col * width), (int)(row * height), (int)width, (int)height);
    }
    for (int i = 0; i < 8; i++) {
      int col = i % 4 + 2;
      int row = i / 4;
      estatico[i] = spriteSheet.get((int)(col * width), (int)(row * height), (int)width, (int)height);
    }
    for (int i = 0; i < 3; i++) {
      explosion[i] = spriteSheet.get((int)(i * width), (int)(4 * height), (int)width, (int)height);
    }
  }

  void mostrar() {
    if (eliminado) return; // No mostrar si está eliminado
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

  void actualizarAnimacion(int totalFrames) {
    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame++;
      if (estado == 2 && currentFrame >= totalFrames) {
        eliminado = true; // Marca el enemigo como eliminado al final de la explosión
      } else {
        currentFrame %= totalFrames;
      }
      frameCounter = 0;
    }
  }

  void mover(float velocidadX, float velocidadY) {
    if (estado != 2 && !eliminado) {
      this.x += velocidadX;
      this.y += velocidadY;
    }
  }

  boolean isEliminado() {
    return eliminado;
  }
}
