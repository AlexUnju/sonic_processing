private class Player {
  private PVector posicion;
  private PVector velocidad;
  private int currentFrame; // Índice del frame actual
  private int frameDelay;   // Para controlar la velocidad de la animación
  private int delayCount;   // Contador para el retraso
  private PImage[] frames;  // Frames de la animación
  private int ancho, alto;  // Tamaño del sprite
  private PApplet p;        // Referencia a Processing
  private boolean mirandoDerecha = true; // Dirección del personaje

  // Constructor extendido
  Player(float x, float y, String spritePath, int ancho, int alto, PApplet p) {
    this.posicion = new PVector(x, y);
    this.velocidad = new PVector(2, 0);
    this.currentFrame = 0;
    this.frameDelay = 5;
    this.delayCount = 0;
    this.ancho = ancho;
    this.alto = alto;
    this.p = p;

    // Cargar los frames de la animación
    this.frames = new PImage[1]; // Cambiar si hay más frames en la animación
    this.frames[0] = p.loadImage(spritePath);
  }

  void actualizar() {
    // Actualiza la posición
    posicion.add(velocidad);

    // Cambia de frame según el delay
    delayCount++;
    if (delayCount >= frameDelay) {
      currentFrame = (currentFrame + 1) % frames.length;
      delayCount = 0;
    }
  }

  void dibujar() {
    p.pushMatrix(); // Guarda el estado actual de la matriz
    p.translate(posicion.x, posicion.y); // Mueve al origen del personaje

    // Voltea horizontalmente si está mirando a la izquierda
    if (!mirandoDerecha) {
      p.scale(-1, 1); // Voltea en el eje X
      p.translate(-ancho, 0); // Ajusta la posición tras voltear
    }

    p.image(frames[currentFrame], 0, 0, ancho, alto); // Dibuja el sprite
    p.popMatrix(); // Restaura la matriz original
  }

  // Método para mostrar el jugador en la pantalla
  void mostrar() {
    dibujar();  // Llama a la función dibujar para renderizar la animación
  }

  void mover(float dx, float dy) {
    if (dx > 0) mirandoDerecha = true;   // Movimiento a la derecha
    if (dx < 0) mirandoDerecha = false;  // Movimiento a la izquierda

    posicion.x += dx;
    posicion.y += dy;
  }
  
  PVector getVelocidad() {
    return velocidad;
  }

  PVector getPosicion() {
    return posicion;
  }
}
