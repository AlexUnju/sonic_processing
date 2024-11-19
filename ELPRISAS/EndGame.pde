class EndGame {
  PApplet p;

  EndGame(PApplet parent) {
    this.p = parent;
  }

  void display() {
    p.fill(0, 150);
    p.rect(0, 0, p.width, p.height); // Fondo semitransparente
    p.fill(255, 0, 0);
    p.textSize(50);
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.text("Fin del Juego", p.width / 2, p.height / 2); // Mensaje principal
    p.fill(255);
    p.textSize(20);
    p.text("Gracias por jugar", p.width / 2, p.height / 2 + 50); // Mensaje adicional
  }
}

// Detecta la tecla espacio para activar el fin del juego
void keyPressed() {
  if (key == ' ') { // Si se presiona la barra espaciadora
    gameOver = true;
  }
}
