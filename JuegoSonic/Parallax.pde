class Parallax {
  // Atributos privados
  private PImage[] fondos;  // Array de imágenes del fondo
  private float x, y;
  private float x1, x2;  // Posiciones de las imágenes de fondo
  private float velocidad;  // Velocidad de movimiento del fondo
  private float escala;  // Factor de escala para redimensionar la imagen
  private float posX, posY;  // Posición inicial del fondo en los ejes X y Y
  private int currentFrame;  // Frame actual de la animación
  private int totalFrames;  // Total de frames en la animación
  private int frameDelay;  // Retraso entre cambios de frame
  private int frameCounter;  // Contador para el cambio de frame
  private float offsetX, offsetY;  // Desplazamiento adicional para movimiento
  private boolean movimientoManual;  // Indica si el movimiento es controlado manualmente

  // Constructor para inicializar el fondo
  public Parallax(String[] archivos, float velocidad, float escala, float posX, float posY, int frameDelay) {
    this.totalFrames = archivos.length;
    this.fondos = new PImage[totalFrames];
    for (int i = 0; i < totalFrames; i++) {
      this.fondos[i] = loadImage(archivos[i]);  // Cargar las imágenes
    }
    this.velocidad = velocidad;  // Establecer la velocidad de desplazamiento
    this.escala = escala;  // Establecer el factor de escala
    this.posX = posX;  // Establecer la posición en X
    this.posY = posY;  // Establecer la posición en Y
    this.x1 = posX;  // Inicializar la posición de la primera imagen
    this.x2 = posX + fondos[0].width * escala;  // Inicializar la posición de la segunda imagen
    this.currentFrame = 0;  // Inicializar el frame actual
    this.frameDelay = frameDelay;  // Establecer el retraso entre cambios de frame
    this.frameCounter = 0;  // Inicializar el contador de frames
    this.offsetX = 0;  // Inicializar el desplazamiento en X
    this.offsetY = 0;  // Inicializar el desplazamiento en Y
    this.movimientoManual = false;  // Inicialmente, el movimiento es automático
  }

  // Método para dibujar el fondo y moverlo de acuerdo con el desplazamiento
  public void dibujar() {
    // Si el movimiento es automático, mover el fondo en la dirección X
    if (!movimientoManual) {
      x1 -= velocidad;
      x2 -= velocidad;

      // Si la primera imagen ha salido de la pantalla, reiniciar su posición
      if (x1 <= posX - fondos[currentFrame].width * escala) {
        x1 = posX + fondos[currentFrame].width * escala;
      }

      // Si la segunda imagen ha salido de la pantalla, reiniciar su posición
      if (x2 <= posX - fondos[currentFrame].width * escala) {
        x2 = posX + fondos[currentFrame].width * escala;
      }
    }

    // Dibujar las dos imágenes de fondo escaladas, moviéndolas según el desplazamiento
    float fondoAncho = fondos[currentFrame].width * escala;  // Nuevo ancho de la imagen escalada
    float fondoAlto = fondos[currentFrame].height * escala;  // Nuevo alto de la imagen escalada

    image(fondos[currentFrame], x1 + offsetX, posY + offsetY, fondoAncho, fondoAlto);  // Dibujar la primera imagen escalada
    image(fondos[currentFrame], x2 + offsetX, posY + offsetY, fondoAncho, fondoAlto);  // Dibujar la segunda imagen escalada

    // Actualizar el frame actual
    frameCounter++;
    if (frameCounter >= frameDelay) {
      currentFrame = (currentFrame + 1) % totalFrames;
      frameCounter = 0;
    }
  }

  // Método para reiniciar la posición del parallax
  public void reiniciarPosicion() {
    // Reiniciar las posiciones de las imágenes de fondo
    this.x1 = posX;
    this.x2 = posX + fondos[0].width * escala;
    
    // Reiniciar los desplazamientos
    this.offsetX = 0;
    this.offsetY = 0;
  }

  // Métodos para ajustar el desplazamiento en X y Y
  public void moverX(float delta) {
    offsetX += delta;  // Mueve el fondo horizontalmente
  }

  public void moverY(float delta) {
    offsetY += delta;  // Mueve el fondo verticalmente
  }

  // Métodos para obtener y establecer la velocidad
  public float getVelocidad() {
    return this.velocidad;  // Retorna la velocidad del fondo
  }

  public void setVelocidad(float velocidad) {
    this.velocidad = velocidad;  // Establece una nueva velocidad
  }

  // Establecer el modo de movimiento (manual o automático)
  public void setMovimientoManual(boolean manual) {
    this.movimientoManual = manual;  // Habilitar o deshabilitar el movimiento manual
  }
}
