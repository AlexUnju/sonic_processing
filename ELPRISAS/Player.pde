class Player {
  PVector posicion;
  PVector velocidad;
  int currentFrame; // Índice del frame actual
  int frameDelay;   // Para controlar la velocidad de la animación
  int delayCount;   // Contador para el retraso
  
  Player(float x, float y) {
    posicion = new PVector(x, y);
    velocidad = new PVector(2, 0);
    currentFrame = 0;
    frameDelay = 5; // Cambia el frame cada 5 cuadros
    delayCount = 0;
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
    image(frames[currentFrame], posicion.x, posicion.y);
  }
}
