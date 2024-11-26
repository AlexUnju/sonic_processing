private class Parallax {
  private PImage img;
  private PVector position;   // Vector para la posición actual de la imagen
  private float velocidad;
  private float zoom;

  Parallax(PImage img, float velocidad, float zoom, float startX, float startY) {
    this.img = img;
    this.velocidad = velocidad;
    this.zoom = zoom;
    this.position = new PVector(startX, startY); // Posición inicial en X e Y
  }

  void update() {
    // Mueve la imagen hacia la izquierda en el eje X solamente
    position.x -= velocidad;

    // Si la imagen se desplaza completamente a la izquierda, reinicia la posición en X
    if (position.x <= -img.width * zoom) {
      position.x = 0;
    }
  }

  void display() {
    // Dibuja dos instancias de la imagen escalada para crear un bucle continuo en el eje X
    image(img, position.x, position.y, img.width * zoom, img.height * zoom);
    image(img, position.x + img.width * zoom, position.y, img.width * zoom, img.height * zoom);
  }
}
