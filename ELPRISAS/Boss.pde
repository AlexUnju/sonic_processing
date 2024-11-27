class Boss {
  private PImage image;
  private float x, y;
  private float speed;
  private float scale;
  private Player player;
  private boolean giro;  // Variable para controlar la dirección

  public Boss(String imagePath, float startX, float startY, float speed, float scale, Player player) {
    this.image = loadImage(imagePath);
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;
    this.giro = true;  // Inicialmente mirando a la derecha
  }

  public void update() {
    if (player != null) {
      // Movimiento hacia el jugador
      if (player.getX() > x) {
        x += speed;
        giro = false;  // Mirando hacia la derecha
      } else if (player.getX() < x) {
        x -= speed;
        giro = true;  // Mirando hacia la izquierda
      }
    }
  }

  public void display() {
    if (image != null) {
      float newWidth = image.width * scale;
      float newHeight = image.height * scale;

      // Si está mirando a la izquierda, rota la imagen 180 grados
      pushMatrix();
      if (!giro) {
        scale(-1, 1);  // Rota la imagen horizontalmente
        image(image, -x - newWidth, y, newWidth, newHeight);  // Ajusta la posición tras la rotación
      } else {
        image(image, x, y, newWidth, newHeight);
      }
      popMatrix();
    }
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}
