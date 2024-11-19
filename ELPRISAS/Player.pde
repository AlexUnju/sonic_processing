import gifAnimation.Gif;

class Player {
  private PVector posicion; // Position of Sonic
  private PVector velocidad; // Speed of Sonic
  private Gif sprite; // Sonic's GIF animation

  // Constructor
  Player(float xInicial, float yInicial, String rutaGif, PApplet app) {
    this.posicion = new PVector(xInicial, yInicial);
    this.velocidad = new PVector(0, 0);
    this.sprite = new Gif(app, rutaGif); // Pass the main sketch reference
    this.sprite.loop(); // Start the animation
  }

  // Move Sonic by updating its velocity and position
  void mover(float dx, float dy) {
    velocidad.set(dx, dy);
    posicion.add(velocidad);
  }

  // Get Sonic's position
  PVector getPosicion() {
    return posicion.copy();
  }

  // Display Sonic on the screen
  void mostrar() {
    image(sprite, posicion.x, posicion.y);
  }
}
