class EndGame {
  private String mensaje;
  private String submensaje;

  public EndGame() {
    this.mensaje = "GAME OVER";
    this.submensaje = "Presiona 'ESC' para salir";
  }

  public void display() {
    background(0, 150); // Fondo negro con opacidad

    // Texto principal
    textAlign(CENTER, CENTER);
    textSize(50);
    fill(255, 0, 0);
    text(mensaje, width / 2, height / 2 - 50);

    // Submensaje
    textSize(20);
    fill(255);
    text(submensaje, width / 2, height / 2 + 20);
  }
}
