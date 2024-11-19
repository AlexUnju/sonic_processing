boolean gameOver = false; // Variable para controlar el estado del juego

void setup() {
  size(800, 600);
  // Configuración inicial
}

void draw() {
  if (!gameOver) {
    // Lógica principal del juego
    background(0, 150, 255); // Fondo azul, típico de Sonic
    fill(255);
    textSize(32);
    text("Jugando...", width / 2 - 70, height / 2);

    // Simular condición de fin del juego
    if (frameCount > 300) { // Fin del juego después de 10 segundos como ejemplo
      gameOver = true;
    }
  } else {
    // Pantalla de fin del juego
    endGameScreen();
  }
}

void endGameScreen() {
  background(0); // Fondo negro
  fill(255, 0, 0); // Texto rojo
  textSize(50);
  textAlign(CENTER, CENTER);
  text("Fin del Juego", width / 2, height / 2); // Mensaje principal
  fill(255);
  textSize(20);
  text("Gracias por jugar", width / 2, height / 2 + 50); // Mensaje adicional
}
