class Escenario {
  private PImage escenario;   // Imagen única del fondo
  private float offsetX = 0;  // Desplazamiento horizontal del fondo
  private float velocidadFondo = 2.0; // Velocidad de desplazamiento del fondo

  // Posición manual
  private float posX = 0;  // Posición manual de la imagen en X
  private float posY = 0;  // Posición manual de la imagen en Y
  
  // Lista de rectángulos verdes
  private ArrayList<float[]> rectangulos; // Cada rectángulo: {x, y, ancho, alto}

  // Constructor
  // Recibe la ruta de la imagen y el frameDelay (aunque solo usaremos la imagen)
  public Escenario(String rutaFondo) {
    this.escenario = loadImage(rutaFondo);  // Cargar solo una imagen
    this.rectangulos = new ArrayList<>();

  }
  
    // Método para añadir un rectángulo al escenario
  public void agregarRectangulo(float x, float y, float ancho, float alto) {
    rectangulos.add(new float[]{x, y, ancho, alto});
  }

  // Método para actualizar y dibujar el escenario
  public void dibujar() {
    // Dibujar la imagen de fondo con desplazamiento
    image(escenario, posX + offsetX, posY + height - escenario.height);

    // Dibujar una segunda copia para un desplazamiento continuo
    if (offsetX + escenario.width < width) {
      image(escenario, posX + offsetX + escenario.width, posY + height - escenario.height);
    }
    
       // Dibujar rectángulos verdes
    fill(0, 255, 0);  // Color verde
    noStroke();
    for (float[] rect : rectangulos) {
      rect(rect[0] + offsetX, rect[1], rect[2], rect[3]); // Ajustar posición por desplazamiento
    }
  }

  // Cambiar el desplazamiento horizontal de la imagen en función del movimiento
  public void mover(float velocidad) {
    offsetX -= velocidad * velocidadFondo;

    // Reiniciar el desplazamiento cuando la imagen ha salido completamente de la pantalla
    if (offsetX <= -escenario.width) {
      offsetX = 0;
    }
  }

public ArrayList<float[]> getRectangulos() {
    return rectangulos;
  }

  // Métodos para establecer posiciones manuales de la imagen
  public void setPosicionX(float x) {
    posX = x;
  }

  public void setPosicionY(float y) {
    posY = y;
  }

  // Getters y setters adicionales para el desplazamiento y la velocidad
  public float getOffsetX() {
    return offsetX;
  }

  public void setOffsetX(float offsetX) {
    this.offsetX = offsetX;
  }

  public float getVelocidadFondo() {
    return velocidadFondo;
  }

  public void setVelocidadFondo(float velocidadFondo) {
    this.velocidadFondo = velocidadFondo;
  }
}
