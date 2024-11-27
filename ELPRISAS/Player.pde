// Clase Player
class Player {
  // Atributos para posición y movimiento
  private PVector position;
  private float yVel = 0;
  private float xVel = 0;
  private float gravity = 0.8;
  private float jumpStrength = -15;
  private float speed = 1;
  private float maxSpeed = 5;
  private float friction = 0.95;
  private boolean jumping = false;
  private float animationSpeed = 1.0; // Velocidad de animación

  // Atributos para la animación
  private float frame = 0;
  private int cols = 6;
  private int rows = 4;
  private int spriteWidth, spriteHeight;
  private boolean facingLeft = false;
  private boolean isAnimating = false;

  // Estado actual del jugador
  private String state = "Idle";

  // Temporizadores y umbrales
  private int moveTimer = 0;
  private int moveThreshold = 20;
  private int jumpTimer = 0;
  private int jumpDelay = 10;
  
  // Atributo en la clase Player
  private ArrayList<PVector> trajectory = new ArrayList<PVector>();
  private boolean showHitbox = false;
  private boolean showTrajectory = false;

  private int vidas;


  /**
   * Constructor de la clase Player.
   */
  public Player(float x, float y, int w, int h) {
    this.position = new PVector(x, y);
    this.spriteWidth = w;
    this.spriteHeight = h;
    this.vidas = 3; // Sonic comienza con 3 vidas

  }

  /**
   * Mueve al jugador en la dirección especificada.
   */
  public void move(int dir) {
    if (!jumping) {
      if (state.equals("Running")) {
        xVel += dir * speed;
        xVel = constrain(xVel, -maxSpeed, maxSpeed);
      } else {
        xVel = dir * speed;
      }
      facingLeft = dir < 0;
      state = dir < 0 ? "Moving Left" : "Moving Right";
      frame = (frame + animationSpeed) % cols;

      if (moveTimer < moveThreshold) {
        moveTimer++;
      }
    }
  }

  /**
   * Detiene el movimiento del jugador.
   */
  public void stop() {
    if (state.equals("Running")) {
      state = "Inertia";
    } else {
      state = "Idle";
      xVel = 0;
    }
    frame = 0;
    moveTimer = 0;
  }

  /**
   * Hace que el jugador salte.
   */
  public void jump() {
    if (!jumping) {
      yVel = jumpStrength;
      jumping = true;
      state = "Jumping";
      frame = 0;
      jumpTimer = 0;
    }
  }

  /**
   * Actualiza el estado y la posición del jugador.
   */
public void update() {
  // Cambia a estado "Running" si se ha movido lo suficiente
  if (moveTimer >= moveThreshold && !jumping) {
    state = "Running";
  }

  // Aplica velocidad horizontal
  position.x += xVel;

  // Aplica fricción si está en estado de inercia
  if (state.equals("Inertia")) {
    // La fricción se aplica solo si la velocidad es mayor que un umbral mínimo
    xVel *= friction;

    // Detener completamente si la velocidad es muy baja, pero no de inmediato
    if (abs(xVel) < 0.1) {
      xVel = 0;  // Detener completamente si la velocidad es muy baja
      state = "Idle";  // Cambiar a estado "Idle" cuando la inercia termine
    }
  }

  // Aplica gravedad
  position.y += yVel;
  yVel += gravity;
  
    // Agregar puntos de la trayectoria solo cuando el jugador está saltando
  if (jumping) {
    trajectory.add(new PVector(position.x, position.y));
  }
  
    // Maneja colisión con el suelo y finalización del salto
  if (position.y >= height - spriteHeight) {
    position.y = height - spriteHeight;
    yVel = 1;
    if (state.equals("Jumping")) {
      state = (abs(xVel) > 0.1) ? "Inertia" : "Idle";
    }
    jumping = false;
    
    // Limpiar la trayectoria al aterrizar
    trajectory.clear();
  }
  
    position.y = constrain(position.y, 0, height - spriteHeight);


  // Maneja colisión con el suelo y finalización del salto
  if (position.y >= height - spriteHeight) {
    position.y = height - spriteHeight;
    yVel = 1;
    if (state.equals("Jumping")) {
      // Si hay velocidad horizontal, cambiar a "Inertia"
      state = (abs(xVel) > 0.1) ? "Inertia" : "Idle";
    }
    jumping = false;
  }
  
  position.y = constrain(position.y, 0, height - spriteHeight);

  // Actualiza la animación de salto
  if (jumping && state.equals("Jumping")) {
    jumpTimer++;
    if (jumpTimer >= jumpDelay) {
      frame++;
      jumpTimer = 0;
    }
    if (frame >= 5) {
      frame = 0;
    }
  }

  // Actualiza la velocidad de animación basada en el estado del jugador
  if (state.equals("Inertia") || state.equals("Running")) {
    animationSpeed = map(abs(xVel), 0, maxSpeed, 0.1, 1.0);
    isAnimating = true;
  } else if (state.equals("Idle")) {
    animationSpeed = 0;
    isAnimating = false;
    frame = 0; // Mantener el frame en 0 para el estado Idle
  } else {
    animationSpeed = 0.2;
    isAnimating = true;
  }

  // Actualiza el frame de la animación solo si está animando
  if (isAnimating) {
    frame = (frame + animationSpeed) % cols;
  }
  
    // Al aterrizar
  if (position.y >= height - spriteHeight) {
    position.y = height - spriteHeight;
    yVel = 1;
    if (state.equals("Jumping")) {
      state = (abs(xVel) > 0.1) ? "Inertia" : "Idle";
    }
    jumping = false;
    
    // Limpiar la trayectoria al aterrizar
    trajectory.clear();
  }
}

 /**
   * Dibuja el hitbox si está habilitado.
   */
  public void drawHitbox() {
    if (showHitbox) {
      noFill();
      stroke(0, 255, 0); // Color verde para la hitbox
      rectMode(CENTER);
      rect(position.x + 20, position.y + 20, spriteWidth, spriteHeight);
    }
  }

public void drawTrajectory() {
  if (showTrajectory) {
  stroke(255, 255, 0); // Color amarillo para la trayectoria
  noFill();
  beginShape();
  for (PVector point : trajectory) {
    vertex(point.x, point.y);
  }
  endShape();
  
  // Al aterrizar
  if (position.y >= height - spriteHeight) {
    position.y = height - spriteHeight;
    yVel = 1;
    if (state.equals("Jumping")) {
      state = (abs(xVel) > 0.1) ? "Inertia" : "Idle";
    }
    jumping = false;
    
    // Limpiar la trayectoria al aterrizar
    trajectory.clear();
  }
  }
}


  /**
   * Muestra al jugador en la pantalla.
   */
  public void display() {
    int col = int(frame) % cols;
    int row = getRowForState();
    
  // Dibuja la trayectoria mientras Sonic está saltando
    
    // Determina la fila del sprite según el estado de Sonic
    if (state.equals("Jumping")) {
      row = 3;
    } else if (state.equals("Running") || state.equals("Inertia")) {
      row = 2;
      col = int(frame) % 4;
    } else if (state.equals("Moving Left") || state.equals("Moving Right")) {
      row = 1;
    } else {
      row = 0;
      col = 0;
    }

    pushMatrix();
    if (facingLeft) {
      scale(-1, 1);
      image(spriteSheet, -position.x - spriteWidth, position.y, spriteWidth, spriteHeight,
            col * spriteWidth, row * spriteHeight,
            (col + 1) * spriteWidth, (row + 1) * spriteHeight);
    } else {
      image(spriteSheet, position.x, position.y, spriteWidth, spriteHeight,
            col * spriteWidth, row * spriteHeight,
            (col + 1) * spriteWidth, (row + 1) * spriteHeight);
    }
    popMatrix();
    
    
    // Dibuja el hitbox y la trayectoria en función del estado de depuración
    drawHitbox();
    drawTrajectory();
  }

  // Getters and setters
    public void setShowHitbox(boolean showHitbox) {
    this.showHitbox = showHitbox;
  }

  public void setShowTrajectory(boolean showTrajectory) {
    this.showTrajectory = showTrajectory;
  }
  public ArrayList<PVector> getTrajectory() {
  return trajectory;
}
  public PVector getPosition() { return position.copy(); }
  public void setPosition(PVector position) { this.position = position.copy(); }
  public float getX() { return position.x; }
  public void setX(float x) { this.position.x = x; }
  public float getY() { return position.y; }
  public void setY(float y) { this.position.y = y; }
  public float getYVel() { return yVel; }
  public void setYVel(float yVel) { this.yVel = yVel; }
  public float getXVel() { return xVel; }
  public void setXVel(float xVel) { this.xVel = xVel; }
  public float getGravity() { return gravity; }
  public void setGravity(float gravity) { this.gravity = gravity; }  
  public float getJumpStrength() { return jumpStrength; }
  public void setJumpStrength(float jumpStrength) { this.jumpStrength = jumpStrength; }
  public float getSpeed() { return speed; }
  public void setSpeed(float speed) { this.speed = speed; }
  public float getMaxSpeed() { return maxSpeed; }
  public void setMaxSpeed(float maxSpeed) { this.maxSpeed = maxSpeed; }
  public float getFriction() { return friction; }
  public void setFriction(float friction) { this.friction = friction; }
  public boolean isJumping() { return jumping; }
  public void setJumping(boolean jumping) { this.jumping = jumping; }
  public float getFrame() { return frame; }
  public void setFrame(int frame) { this.frame = frame; }
  public int getCols() { return cols; }
  public void setCols(int cols) { this.cols = cols; }
  public int getRows() { return rows; }
  public void setRows(int rows) { this.rows = rows; }
  public int getSpriteWidth() { return spriteWidth; }
  public void setSpriteWidth(int spriteWidth) { this.spriteWidth = spriteWidth; }
  public int getSpriteHeight() { return spriteHeight; }
  public void setSpriteHeight(int spriteHeight) { this.spriteHeight = spriteHeight; }
  public boolean isFacingLeft() { return facingLeft; }
  public void setFacingLeft(boolean facingLeft) { this.facingLeft = facingLeft; }
  public String getState() { return state; }
  public void setState(String state) { this.state = state; }
  public int getMoveTimer() { return moveTimer; }
  public void setMoveTimer(int moveTimer) { this.moveTimer = moveTimer; }
  public int getMoveThreshold() { return moveThreshold; }
  public void setMoveThreshold(int moveThreshold) { this.moveThreshold = moveThreshold; }
  public int getJumpTimer() { return jumpTimer; }
  public void setJumpTimer(int jumpTimer) { this.jumpTimer = jumpTimer; }
  public int getJumpDelay() { return jumpDelay; }
  public void setJumpDelay(int jumpDelay) { this.jumpDelay = jumpDelay; }
  public boolean isAnimating() { return isAnimating; }
  public int getRowForState() {
    switch (state) {
        case "Jumping":
            return 3;
        case "Running":
        case "Inertia":
            return 2;
        case "Moving Left":
        case "Moving Right":
            return 1;
        default: // Idle
            return 0;
    }
  }
// Métodos para manejar vidas
  public int getVidas() {
    return vidas;
  }

  public void perderVida() {
    if (vidas > 0) {
      vidas--;
    }
  }

  public void ganarVida() {
    if (vidas < 3) {
      vidas++;
    }
  }

  public boolean estaVivo() {
    return vidas > 0;
  }
}
