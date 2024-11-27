class Debug {
  private boolean showDebug = false;
  private PImage spriteSheet;
  private int spriteWidth;
  private int spriteHeight;

  // Variables para las posiciones manuales de los rectángulos
  private int spriteRectX = 50;
  private int spriteRectY = 10;

  /**
   * Muestra la información de depuración en pantalla si el modo debug está activado.
   * @param player El objeto Player para mostrar información.
   * @param camera El objeto Camera para mostrar información.
   */
public void display(Player player, Camera camera) {
    if (!showDebug) return;
   

    // Establecer el tamaño de fuente pequeño
    textSize(10); // Cambia el tamaño según lo necesites

    // Definir color del texto y del contorno
    fill(255);  // Texto blanco
    stroke(0);  // Contorno negro
    strokeWeight(1);  // Grosor del contorno

    // Accedemos a la posición del jugador utilizando el método getPosition()
    PVector position = player.getPosition();  // Obtiene la posición actual del jugador

    // Mostrar texto con contorno
    drawTextWithOutline("Player X: " + position.x + ", Y: " + position.y, 100, 20);
    drawTextWithOutline("Camera X: " + camera.getX() + ", Y: " + camera.getY(), 100, 40);
    drawTextWithOutline("State: " + player.getState(), 100, 60);
    drawTextWithOutline("Y Velocity: " + player.getYVel(), 100, 80);
    drawTextWithOutline("X Velocity: " + player.getXVel(), 100, 100);

    // Mostrar el sprite sheet completo
    if (spriteSheet != null) {
        image(spriteSheet, 550, 5); // Aquí dibujamos el sprite sheet en una posición fija
        drawSpriteRectangle(player);  // Mostrar rectángulo rojo del sprite actual
    }
    
    // Controlar hitbox y trayectoria desde el modo Debug
    player.setShowHitbox(true);       // Mostrar hitbox mientras está en debug
    player.setShowTrajectory(true);   // Mostrar trayectoria mientras está en debug
}

public void toggleDebug(Player player) {
    showDebug = !showDebug;

    // Mostrar u ocultar hitbox y trayectoria dependiendo del estado de debug
    player.setShowHitbox(showDebug);
    player.setShowTrajectory(showDebug);
}



/**
 * Dibuja un texto con un contorno negro.
 */
private void drawTextWithOutline(String txt, float x, float y) {
    // Dibuja el contorno negro (múltiples direcciones para simular borde)
    fill(0);  // Contorno negro
    text(txt, x - 1, y - 1);
    text(txt, x + 1, y - 1);
    text(txt, x - 1, y + 1);
    text(txt, x + 1, y + 1);

    // Dibuja el texto principal en blanco
    fill(255);  // Texto blanco
    text(txt, x, y);
}


  /**
   * Dibuja el rectángulo de depuración para el sprite (rojo).
   */
  private void drawSpriteRectangle(Player player) {
    int col = player.isAnimating() ? (int) player.getFrame() % player.getCols() : 0;
    int row = player.getRowForState();
    noFill();
    stroke(255, 0, 0); // Rojo
    rect(spriteRectX + col * spriteWidth, spriteRectY + row * spriteHeight, spriteWidth, spriteHeight);
  }


  // Métodos getter y setter para showDebug
  public void setShowDebug(boolean showDebug) {
    this.showDebug = showDebug;
  }

  public boolean isShowDebug() {
    return showDebug;
  }

  // Métodos getter y setter para el sprite sheet y dimensiones
  public void setSpriteSheet(PImage spriteSheet) {
    this.spriteSheet = spriteSheet;
  }

  public PImage getSpriteSheet() {
    return spriteSheet;
  }

  public void setSpriteDimensions(int spriteWidth, int spriteHeight) {
    this.spriteWidth = spriteWidth;
    this.spriteHeight = spriteHeight;
  }

  public int getSpriteWidth() {
    return spriteWidth;
  }

  public int getSpriteHeight() {
    return spriteHeight;
  }

  // Métodos para configurar las posiciones de los rectángulos
  public void setSpriteRectPosition(int x, int y) {
    this.spriteRectX = x;
    this.spriteRectY = y;
  }
}
