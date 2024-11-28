class Boss {
  private PImage image;
  private float x, y;
  private float speed;
  private float scale;
  private Player player;
  private boolean giro;  // Variable para controlar la dirección
  private SpawnMisiles spawnMisiles;  // Sistema de misiles

  public Boss(String imagePath, float startX, float startY, float speed, float scale, Player player) {
    this.image = loadImage(imagePath);
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;
    this.giro = false;  // Inicialmente mirando a la derecha

    // Inicializar el sistema de misiles
    this.spawnMisiles = new SpawnMisiles("Misil.png", 60);  // Un misil cada 60 frames
  }

  public void update() {
    if (player != null) {
      // Verificar si Sonic está quieto
      boolean sonicEstaQuieto = player.getXVel() == 0;
  
      // Si Sonic está quieto y Eggman está sobre Sonic, Eggman se queda quieto
      if (sonicEstaQuieto && abs(player.getX() - x) < 10) { 
        // No hacer nada, Eggman está quieto
      } else {
        // Mover a Eggman hacia Sonic
        if (player.getX() > x) {
          x += speed;
          giro = true;  // Mirando hacia la derecha
        } else if (player.getX() < x) {
          x -= speed;
          giro = false;  // Mirando hacia la izquierda
        }
      }

      // Intentar disparar un misil con escala más pequeña (25% del tamaño original)
      spawnMisiles.intentarDisparar(x, y + image.height * scale / 2, 5, 0.25);
    }

    // Actualizar los misiles
    spawnMisiles.update();
  }

  public void display() {
  if (image != null) {
    // Obtener el tamaño de la imagen escalada
    float newWidth = image.width * scale;
    float newHeight = image.height * scale;

    // Dibujar la imagen de Eggman
    pushMatrix();
    if (!giro) {
      scale(-1, 1);  // Rota la imagen horizontalmente si está mirando hacia la izquierda
      image(image, -x - newWidth, y, newWidth, newHeight);  // Ajusta la posición tras la rotación
    } else {
      image(image, x, y, newWidth, newHeight);  // Dibuja la imagen normalmente
    }
    popMatrix();

    // Dibujar un rectángulo alrededor de la imagen para visualizar su área
    stroke(255, 0, 0);  // Establecer el color del borde del rectángulo (rojo, por ejemplo)
    noFill();  // No rellenar el rectángulo, solo dibujar el contorno

    pushMatrix();
    if (!giro) {
      // Dibuja el rectángulo alrededor de la imagen cuando está mirando a la izquierda
      rect(-x - newWidth, y, newWidth, newHeight);
    } else {
      // Dibuja el rectángulo alrededor de la imagen cuando está mirando a la derecha
      rect(x, y, newWidth, newHeight);
    }
    popMatrix();

    // Dibujar los misiles
    spawnMisiles.display();
  }
}


  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
}
