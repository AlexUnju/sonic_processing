class Abeja {
  private float x, y;
  private float speedX, speedY;
  private float velocidad;  // Velocidad constante de la abeja
  private PImage sprite;
  private float objetivoX, objetivoY; // Coordenadas objetivo (Sonic)

  public Abeja(float startX, float startY, float sonicX, float sonicY, String spritePath) {
    this.x = startX;
    this.y = startY;
    this.velocidad = 3;  // Velocidad fija de la abeja
    this.sprite = loadImage(spritePath);

    // Calcular dirección hacia Sonic
    float dx = sonicX - x;
    float dy = sonicY - y;
    float distancia = dist(x, y, sonicX, sonicY);
    speedX = (dx / distancia) * velocidad;  // Normalizar y multiplicar por la velocidad
    speedY = (dy / distancia) * velocidad;
  }

  public void update() {
    // Mover la abeja en dirección a Sonic
    x += speedX;
    y += speedY;
  }

  public void display() {
    if (sprite != null) {
      image(sprite, x, y);
    } else {
      ellipse(x, y, 20, 20);  // Dibujar un marcador por defecto si no hay sprite
    }
  }

  public boolean colisiona(Player player) {
    // Verificar si la abeja colisiona con el jugador
    return dist(x, y, player.getX(), player.getY()) < 20;  // Ajusta el radio de colisión
  }
}
