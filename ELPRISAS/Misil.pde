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
    // Calcular el tamaño escalado de la imagen
    float newWidth = image.width * scale;
    float newHeight = image.height * scale;

    // Dibujar la imagen del misil centrada en (x, y)
    if (image != null) {
      image(image, x - newWidth / 2, y, newWidth, newHeight);  // Centra la imagen horizontalmente
    }

    // Dibujar el contorno alrededor de la imagen
    noFill();  // No rellenar el rectángulo
    stroke(255, 0, 0);  // Color rojo para el contorno (puedes cambiarlo)

    // Calcular la posición del rectángulo para que esté centrado alrededor de la imagen
    float rectX = x;  // Alineación horizontal
    float rectY = y - newHeight + 90;                 // Alineación vertical con la imagen
    rect(rectX, rectY, newWidth, newHeight);  // Dibuja el rectángulo de contorno
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
