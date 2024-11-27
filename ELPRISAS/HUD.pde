class HUD {
  private PImage vidaIcono; // Imagen para representar una vida
  private Player player;

  public HUD(Player player) {
    this.player = player;
    this.vidaIcono = loadImage("vida.png"); // Asegúrate de tener esta imagen en la carpeta `data/hud/`
  }

  public void display() {
    // Dibujar las vidas en la esquina superior izquierda
    for (int i = 0; i < player.getVidas(); i++) {
      image(vidaIcono, 20 + i * 40, 20, 30, 30);
    }
  }
}
