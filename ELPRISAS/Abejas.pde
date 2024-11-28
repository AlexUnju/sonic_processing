public class Abeja {
  private float x, y;
  private float speedX, speedY;
  private float velocidad;  // Velocidad constante de la abeja
  private PImage sprite;

  public Abeja(float startX, float startY, float sonicX, float sonicY, String spritePath) {
    this.x = startX;
    this.y = startY;
    this.velocidad = 12;  // Velocidad fija de la abeja
    this.sprite = loadImage(spritePath);

    // Calcular dirección hacia Sonic
    float dx = sonicX - x;
    float dy = sonicY - y;
    float distancia = dist(x, y, sonicX, sonicY);
    speedX = (dx / distancia) * velocidad;
    speedY = (dy / distancia) * velocidad;

    this.destruida = false;
    

  }

  public void update() {
    if (!destruida) {
      x += speedX;
      y += speedY;
    }
  }

  public void display() {
    if (!destruida) {
      if (sprite != null) {
        image(sprite, x, y);
      } else {
        ellipse(x, y, 20, 20);
      }
    }
  }

  public void destruir() {
    destruida = true; // Marcar abeja como destruida
  }

  public boolean colisiona(Player player) {
    // Comprobar colisión solo si la abeja no está destruida
    if (!destruida && dist(x, y, player.getX(), player.getY()) < 20) {
      // Si el jugador está saltando, destruimos la abeja sin que pierda vida
      if (player.isJumping()) {
        destruir();  // Destruir la abeja
        return false;  // No le quitamos vida al jugador
      } else {
        return true;  // El jugador pierde vida si no está saltando
      }
    }
    return false;
  }
}
