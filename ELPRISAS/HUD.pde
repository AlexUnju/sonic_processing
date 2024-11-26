private class HUD {
  private int vidas;          // Número de vidas restantes
  private int puntos;         // Puntos acumulados
  private int tiempoMaximo;   // Tiempo límite en segundos
  private int tiempoInicio;   // Marca de tiempo inicial

  // Constructor
  HUD(int vidasIniciales, int tiempoMaximo) {
    this.vidas = vidasIniciales;
    this.puntos = 0;
    this.tiempoMaximo = tiempoMaximo;
    this.tiempoInicio = millis(); // Registra el tiempo inicial
  }

  // Métodos públicos para interacción
  void modificarVidas(int cantidad) {
    vidas = max(0, vidas + cantidad); // Asegura que no sea negativo
  }

  int obtenerVidas() {
    return vidas;
  }

  void añadirPuntos(int cantidad) {
    puntos += cantidad;
  }

  int obtenerPuntos() {
    return puntos;
  }

  int tiempoRestante() {
    return max(0, tiempoMaximo - (millis() - tiempoInicio) / 1000);
  }

  boolean tiempoTerminado() {
    return tiempoRestante() <= 0;
  }

  void mostrar() {
    fill(255);
    textSize(20);
    textAlign(LEFT, TOP);
    text("Vidas: " + vidas, 10, 10);
    textAlign(CENTER, TOP);
    text("Tiempo: " + tiempoRestante(), width / 2, 10);
    textAlign(RIGHT, TOP);
    text("Puntos: " + puntos, width - 10, 10);
  }
}
