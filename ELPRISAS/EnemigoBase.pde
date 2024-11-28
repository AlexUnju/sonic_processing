abstract class EnemigoBase {
  protected PVector position;
  private PImage sprite; // Imagen del enemigo
  protected int velocidad;
  
  // Constructor de la clase base
  EnemigoBase(float x, float y, int velocidad) {
    this.position = new PVector(x, y);
    this.velocidad = velocidad;
    this.sprite = loadImage("buzzer1.png"); // Carga el sprite del enemigo
  }
  
  // Método para dibujar al enemigo
  void dibujar() {
    image(sprite, position.x, position.y);
  }
  
  // Método para mover al enemigo (simple movimiento horizontal)
  void mover() {
    position.x -= velocidad; // Movimiento a la izquierda
  }
}
