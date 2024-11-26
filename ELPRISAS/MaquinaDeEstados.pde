private class MaquinaDeEstados {
  PApplet p;
  GameState estadoActual;

  MaquinaDeEstados(PApplet parent) {
    this.p = parent;
    this.estadoActual = GameState.MENU;
  }

  void cambiarEstado(GameState nuevoEstado) {
    this.estadoActual = nuevoEstado;
  }

  void display() {
    switch (estadoActual) {
      case MENU:
        mostrarMenu();
        break;
      case INICIO:
        mostrarInicio();
        break;
      case PAUSA:
        mostrarPausa();
        break;
      case VICTORIA:
        mostrarVictoria();
        break;
      case ENDGAME: // Nuevo caso para el estado ENDGAME
        mostrarEndGame();
        break;
    }
  }

  void mostrarMenu() {
    p.fill(255);
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.textSize(32);
    p.text("Menú Principal\nPresiona ENTER para comenzar", p.width / 2, p.height / 2);
  }

  void mostrarInicio() {
    p.fill(255);
    p.textAlign(PApplet.LEFT, PApplet.TOP);
    p.textSize(16);
    p.text("Juego en curso...\nPresiona ESPACIO para pausar", 10, 10);
  }

  void mostrarPausa() {
    p.loadPixels();
    for (int i = 0; i < p.pixels.length; i++) {
      color original = p.pixels[i];
      float brillo = (red(original) + green(original) + blue(original)) / 3; // Escala de grises
      p.pixels[i] = p.color(brillo, brillo, brillo, 150); // Tono semitransparente
    }
    p.updatePixels();
    p.fill(255);
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.textSize(32);
    p.text("PAUSA\nPresiona ESPACIO para continuar", p.width / 2, p.height / 2);
}

  void mostrarVictoria() {
    p.fill(0, 255, 0);
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.textSize(32);
    p.text("¡Felicidades, has ganado!\nPresiona ENTER para volver al menú", p.width / 2, p.height / 2);
  }

  void mostrarEndGame() {
    p.fill(255, 0, 0);
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.textSize(32);
    p.text("GAME OVER\nPresiona ENTER para volver al menú", p.width / 2, p.height / 2);
  }
}
