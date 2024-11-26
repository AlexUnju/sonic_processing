class SpawnerEnemigos {
  ArrayList<EnemigosBase> enemigos;
  PImage spriteSheet;

  float tiempoContador = 0;   // Contador de tiempo transcurrido
  float tiempoGeneracion = 10.0; // Tiempo total del ciclo (en segundos)
  int enemigosPorCiclo = 3;  // Número de enemigos a generar por ciclo
  int enemigosGenerados = 0; // Contador de enemigos generados en el ciclo actual

  SpawnerEnemigos(PImage spriteSheet) {
    this.spriteSheet = spriteSheet;
    enemigos = new ArrayList<EnemigosBase>();
  }

  // Método para generar un enemigo
  void spawnEnemigo() {
    float[][] posiciones = {
      {100, height - 150},
      {width / 2, height - 150},
      {width - 100, height - 150}
    };

    // Seleccionar una posición aleatoria de la lista
    int index = (int)random(0, posiciones.length);
    float x = posiciones[index][0];
    float y = posiciones[index][1];

    int vida = (int)random(1, 3); // Vida aleatoria
    int daño = 1; // Daño constante

    if (random(1) > 0.5) {
      enemigos.add(new Enemies(spriteSheet, x, y, vida, daño));
    } else {
      enemigos.add(new Enemies2(spriteSheet, x, y, vida, daño));
    }

    enemigosGenerados++; // Incrementar el contador de enemigos generados
  }

  // Método para actualizar y mostrar enemigos
  void actualizarEnemigos(float deltaTime) {
    tiempoContador += deltaTime; // Incrementar el contador de tiempo

    // Generar enemigos mientras no se exceda el límite por ciclo
    if (enemigosGenerados < enemigosPorCiclo && tiempoContador <= tiempoGeneracion) {
      spawnEnemigo();
    }

    // Reiniciar el ciclo cuando se cumpla el tiempo
    if (tiempoContador > tiempoGeneracion) {
      tiempoContador = 0;
      enemigosGenerados = 0; // Reiniciar el contador de enemigos generados
    }

    // Actualizar y mostrar todos los enemigos
    for (int i = enemigos.size() - 1; i >= 0; i--) {
      EnemigosBase e = enemigos.get(i);
      e.mostrar();
      e.mover(1, 0); // Ajusta la lógica del movimiento si es necesario
      if (e.isEliminado()) {
        enemigos.remove(i); // Eliminar enemigos eliminados
      }
    }
  }
}
