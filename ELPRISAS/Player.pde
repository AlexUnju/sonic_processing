class Player {
  PVector posicion;
  PVector velocidad;
  int currentFrame; // Índice del frame actual
  int frameDelay;   // Para controlar la velocidad de la animación
  int delayCount;   // Contador para el retraso
  PImage[] frames;  // Frames de la animación
  int ancho, alto;  // Tamaño del sprite
  PApplet p;        // Referencia a Processing

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
    p.image(frames[currentFrame], posicion.x, posicion.y, ancho, alto);
  }

  // Método para mostrar el jugador en la pantalla
  void mostrar() {
    dibujar();  // Llama a la función dibujar para renderizar la animación
  }

  void mover(float dx, float dy) {
    posicion.x += dx;
    posicion.y += dy;
  }

  PVector getPosicion() {
    return posicion;
  }
}
