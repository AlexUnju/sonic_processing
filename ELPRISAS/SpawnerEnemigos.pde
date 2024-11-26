class SpawnerEnemigos {
  ArrayList<EnemigosBase> enemigos;
  PImage spriteSheet;
  float tiempoContador = 0;
  float tiempoGeneracion = 2; // Tiempo en segundos para generar enemigos

  // Constructor con PImage
  SpawnerEnemigos(PImage spriteSheet) {
    this.spriteSheet = spriteSheet;
    enemigos = new ArrayList<EnemigosBase>();
  }

  // Método para generar un enemigo en una posición aleatoria
  void spawnEnemigo() {
    float x = random(100, width - 100); // Posición X aleatoria
    float y = random(100, height - 100); // Posición Y aleatoria
    int vida = (int)random(1, 3); // Vida aleatoria
    int daño = 1; // Daño constante por ahora

    if (random(1) > 0.5) {
      enemigos.add(new Enemies(spriteSheet, x, y, vida, daño));
    } else {
      enemigos.add(new Enemies2(spriteSheet, x, y, vida, daño));
    }
  }

  // Método para actualizar y mostrar todos los enemigos
  void actualizarEnemigos(float deltaTime) {
    tiempoContador += deltaTime; // Incrementar el contador de tiempo

    // Si el contador excede el tiempo de generación, crear un nuevo enemigo
    if (tiempoContador >= tiempoGeneracion) {
      spawnEnemigo(); // Llamar al método para crear un nuevo enemigo
      tiempoContador = 0; // Reiniciar el contador
    }

    // Actualizar y mostrar todos los enemigos
    for (int i = enemigos.size() - 1; i >= 0; i--) {
      EnemigosBase e = enemigos.get(i);
      e.mostrar(); // Mostrar enemigo
      e.mover(1, 0); // Mover enemigo (ajustar lógica si es necesario)
      if (e.isEliminado()) {
        enemigos.remove(i); // Eliminar enemigos eliminados
      }
    }
  }
}
