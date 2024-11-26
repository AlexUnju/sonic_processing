class Enemies2 extends EnemigosBase {
  Enemies2(PImage spriteSheet, float x, float y, int vida, int daño) {
    super(spriteSheet, x, y, vida, daño);
    cargarSprites();
  }

  @Override
  void cargarSprites() {
    // Cargar sprites específicos para Enemies2
    for (int i = 0; i < 8; i++) {
      int col = i % 4 + 2; // Columna 2 y 3 (mitad derecha)
      int row = i / 4;
      movimiento[i] = spriteSheet.get((int)(col * width), (int)(row * height), (int)width, (int)height);
    }

    for (int i = 0; i < 8; i++) {
      int col = i % 4; // Columnas 0 y 1 (mitad derecha)
      int row = i / 4 + 2;
      estatico[i] = spriteSheet.get((int)(col * width + spriteSheet.width / 2), (int)(row * height), (int)width, (int)height);
    }

    for (int i = 0; i < 3; i++) {
      explosion[i] = spriteSheet.get((int)(i * width), (int)(4 * height), (int)width, (int)height);
    }
  }
}
