class Win {
  private PImage winImage;

  public Win() {
    winImage = loadImage("Win.png");  // Cargar la imagen de victoria
  }

  public void display() {
    background(0);  // Fondo negro para contraste

    // Mostrar la imagen de victoria
    imageMode(CENTER);
    image(winImage, width / 2, height / 2 - 50);

    // Mostrar el texto de victoria
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(32);
    // Mover el mensaje de victoria más arriba, por ejemplo, 100 píxeles hacia arriba
    text("¡Felicidades, has ganado!", width / 2, height / 2 - 100);  // Ajusta la posición aquí
    textSize(20);
    // Mover el mensaje de "Presiona ESC para salir" también hacia arriba
    text("Presiona ESC para salir", width / 2, height / 2 - 20);  // Ajusta la posición aquí
  }
}
