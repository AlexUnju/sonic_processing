class Enemigo {
  PImage spriteSheet; // Imagen completa de los sprites
  PImage[] movimiento; // Sprites de movimiento
  PImage[] estatico;   // Sprites estáticos
  PImage[] explosion;  // Sprites de explosión
  int currentFrame;    // Frame actual
  float x, y;          // Posición
  float width, height; // Tamaño de los sprites
  int vida;            // Vida del enemigo
  int daño;            // Daño al jugador
  int estado;          // 0: Movimiento, 1: Estático, 2: Explosión
  int frameDelay;      // Velocidad de animación
  int frameCounter;    // Contador para control de frames
  
  Enemigo(PImage spriteSheet, float x, float y, int vida, int daño) {
    this.spriteSheet = spriteSheet;
    this.x = x;
    this.y = y;
    this.vida = vida;
    this.daño = daño;
    this.estado = 0; // Inicialmente en movimiento
    this.frameDelay = 5;
    this.frameCounter = 0;
    this.currentFrame = 0;

    // Calcular tamaño de cada sprite
    this.width = spriteSheet.width / 8.0;
    this.height = spriteSheet.height / 5.0;

    // Inicializar los arreglos de animación
    movimiento = new PImage[8]; // 2 columnas * 4 filas
    estatico = new PImage[8];   // 2 columnas * 4 filas
    explosion = new PImage[3];  // Última fila, 3 sprites

    cargarSprites();
  }

  void cargarSprites() {
    // Cargar sprites de movimiento
    for (int i = 0; i < 8; i++) {
      int col = i % 4;
      int row = i / 4;
      movimiento[i] = spriteSheet.get((int)(col * width), (int)(row * height), (int)width, (int)height);
    }

    // Cargar sprites estáticos
    for (int i = 0; i < 8; i++) {
      int col = i % 4 + 2; // Columnas 2 y 3
      int row = i / 4;
      estatico[i] = spriteSheet.get((int)(col * width), (int)(row * height), (int)width, (int)height);
    }

    // Cargar sprites de explosión
    for (int i = 0; i < 3; i++) {
      explosion[i] = spriteSheet.get((int)(i * width), (int)(4 * height), (int)width, (int)height);
    }
  }

  void mostrar() {
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
        // Detener animación al final de la explosión
        currentFrame = totalFrames - 1;
      } else {
        currentFrame %= totalFrames; // Asegura que el índice sea válido
      }
      frameCounter = 0;
    }
  }

  void mover(float velocidadX, float velocidadY) {
    if (estado != 2) { // No moverse si está en explosión
      this.x += velocidadX;
      this.y += velocidadY;
    }
  }

}
