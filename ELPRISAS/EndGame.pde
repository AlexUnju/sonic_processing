boolean gameOver = false; // Variable global para controlar el estado del juego

void endGameScreen() {
  // Dibuja la pantalla de fin de juego
  fill(0, 150);
  rect(0, 0, width, height); // Fondo semitransparente
  fill(255, 0, 0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Fin del Juego", width / 2, height / 2); // Mensaje principal
  fill(255);
  textSize(20);
  text("Gracias por jugar", width / 2, height / 2 + 50); // Mensaje adicional
}

//Agregar al draw:
void draw() {
  background(0);

  if (!gameOver) {
    // Actualiza y dibuja el fondo parallax
    parallax.update();
    parallax.display();

    // Dibuja el menú con el GIF animado
    dibujaMenu();

    // Aquí puedes agregar condiciones para terminar el juego
    // Ejemplo: si el jugador pierde o gana, establece gameOver en true
    if (frameCount > 1000) { // Simulación de fin de juego
      gameOver = true;
    }
  } else {
    // Muestra la pantalla de fin de juego
    endGameScreen();
  }
}
