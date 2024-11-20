class HUD {
  private int vidas;
  private int puntos;
  private int tiempoMaximo; // En segundos
  private int tiempoInicio; // Tiempo inicial del juego en milisegundos

  HUD(int vidasIniciales, int tiempoMaximo) {
    this.vidas = vidasIniciales;
    this.puntos = 0;
    this.tiempoMaximo = tiempoMaximo;
    this.tiempoInicio = millis(); // Registrar el tiempo inicial
  }

  // Métodos públicos para interactuar con el HUD

  // Actualiza las vidas
  void actualizarVidas(int cambio) {
    vidas += cambio;
    if (vidas < 0) vidas = 0; // Asegurar que las vidas no sean negativas
  }

  // Devuelve la cantidad de vidas actuales
  int getVidas() {
    return vidas;
  }

  // Agrega puntos
  void agregarPuntos(int cantidad) {
    puntos += cantidad;
  }

  // Devuelve los puntos actuales
  int getPuntos() {
    return puntos;
  }

  // Devuelve el tiempo restante en segundos
  int getTiempoRestante() {
    return max(0, tiempoMaximo - (millis() - tiempoInicio) / 1000);
  }

  // Indica si el tiempo se acabó
  boolean tiempoTerminado() {
    return getTiempoRestante() <= 0;
  }

  // Dibuja el HUD en pantalla
  void mostrar() {
    fill(255); // Color blanco para texto
    textSize(20);
    textAlign(LEFT, TOP);
    
    // Mostrar vidas
    text("Vidas: " + vidas, 10, 10);
    
    // Mostrar tiempo restante
    textAlign(CENTER, TOP);
    text("Tiempo: " + getTiempoRestante(), width / 2, 10);
    
    // Mostrar puntos
    textAlign(RIGHT, TOP);
    text("Puntos: " + puntos, width - 10, 10);
  }
}
