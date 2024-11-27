/**
 * Clase que maneja la carga y el dibujo de las imágenes del menú, junto con la animación y el texto.
 */
class Menu {
  private PImage[] images;  // Array que contiene las imágenes del menú
  private int totalImages;  // Número total de imágenes
  private int currentFrame;  // Frame actual para la animación
  private int x, y;  // Posición del menú en la pantalla
  private PFont pixelFont;  // Fuente utilizada para el texto

  /**
   * Constructor que inicializa el menú con un número de imágenes y una fuente específica.
   */
  public Menu(int totalImages, int x, int y, PFont pixelFont) {
    this.totalImages = totalImages;
    this.x = x;
    this.y = y;
    this.currentFrame = 0;  // Inicializa el frame en 0
    this.pixelFont = pixelFont;
    this.images = new PImage[totalImages];
    loadImages();  // Carga las imágenes del menú al inicializar
  }

  /**
   * Carga las imágenes desde la carpeta "data/menu" y las almacena en el array de imágenes.
   */
  private void loadImages() {
    for (int i = 0; i < totalImages; i++) {
      String imageName = "menu/menu" + nf(i, 2) + ".png";  // Formato de nombre para las imágenes
      images[i] = loadImage(imageName);  // Carga cada imagen
    }
  }

  /**
   * Establece el frame actual para la animación del menú.
   */
  public void setCurrentFrame(int frame) {
    if (frame >= 0 && frame < totalImages) {
      this.currentFrame = frame;  // Cambia al frame solicitado si está dentro del rango
    }
  }

  /**
   * Obtiene el frame actual de la animación.
   */
  public int getCurrentFrame() {
    return this.currentFrame;  // Devuelve el frame actual
  }

  /**
   * Dibuja el menú en la pantalla con la imagen y el texto correspondiente.
   */
  public void drawMenu(String text, int alpha) {
    // Dibuja la imagen correspondiente al frame actual
    if (images[currentFrame] != null) {
      image(images[currentFrame], x, y);  // Muestra la imagen en la posición especificada
    }

    // Dibuja el texto con animación de opacidad
    textFont(pixelFont);
    textSize(32);  // Tamaño del texto
    fill(255, 255, 255, alpha);  // Opacidad controlada por el parámetro alpha
    textAlign(CENTER, CENTER);  // Centra el texto
    text(text, x + images[currentFrame].width / 2, y + 350);  // Dibuja el texto centrado
  }
}
