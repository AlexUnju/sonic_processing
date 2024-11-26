private class EndGame {
  PApplet p;                // Referencia a la instancia de Processing
  PImage gameOverImage;     // Imagen de "Game Over"

  EndGame(PApplet parent) {
    this.p = parent;
    this.gameOverImage = p.loadImage("GameOver.png"); // Carga la imagen desde la carpeta 'data'
    p.image(gameOverImage, 0, 0, p.width, p.height); // Ajustar al tamaño de la ventan
  }

  void display() {
    // Dibuja la imagen de Game Over en pantalla completa
    p.image(gameOverImage, 0, 0, p.width, p.height);

    // Mostrar mensaje en la parte inferior
    p.textAlign(PApplet.CENTER, PApplet.CENTER);
    p.textSize(24);
    p.fill(255);
    p.text("Presiona ENTER para volver al menú", p.width / 2, p.height - 50);
  }
}
