class Misil {
  private PImage image;  // Imagen del misil
  private float x, y;    // Posición del misil
  private float speed;   // Velocidad del misil
  private float scale;   // Escala para ajustar el tamaño

  public Misil(PImage image, float startX, float startY, float speed, float scale) {
    this.image = image;
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
  }

  public void update() {
    // Mueve el misil hacia abajo
    y += speed;
  }

  public void display() {
    // Dibuja el misil en la pantalla
    if (image != null) {
      float newWidth = image.width * scale;
      float newHeight = image.height * scale;
      image(image, x - newWidth / 2, y, newWidth, newHeight);  // Centra el misil horizontalmente
    }

    // Primitiva que rodea al misil (Rectángulo)
    float newWidth = image.width * scale;
    float newHeight = image.height * scale;
    noFill();  // No rellenar el rectángulo
    stroke(255, 0, 0);  // Color rojo para el contorno
    rect(x - newWidth / 2, y, newWidth, newHeight);  // Dibuja el rectángulo alrededor del misil
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public boolean fueraDePantalla() {
    // Devuelve true si el misil salió de la pantalla
    return y > height;
  }
}
