class SpawnEnemigos {
  ArrayList<EnemigoBase> enemigos; // Lista para almacenar enemigos
  
  SpawnEnemigos() {
    enemigos = new ArrayList<EnemigoBase>();
  }
  
  // Método para generar enemigos en posiciones aleatorias
  void generarEnemigos() {
    if (random(1) < 0.01) { // Probabilidad de generar un enemigo
      float x = width; // Aparecer desde el borde derecho
      float y = random(height); // Posición aleatoria en el eje Y
      int velocidad = int(random(2, 5)); // Velocidad aleatoria
      enemigos.add(new Enemigo1(x, y, velocidad)); // Crear y agregar un nuevo enemigo
    }
  }
  
  // Método para dibujar todos los enemigos
  void dibujarEnemigos() {
    for (EnemigoBase enemigo : enemigos) {
      enemigo.dibujar();
      enemigo.mover();
    }
  }
}
