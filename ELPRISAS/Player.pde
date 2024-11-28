// Clase Player
class Player {
  // Atributos para posición y movimiento
  private PVector position;    // Almacena la posición del jugador en el espacio 2D.
  private float yVel = 0;      // Velocidad en el eje Y (usada para el salto y la gravedad).
  private float xVel = 0;      // Velocidad en el eje X (usada para el movimiento).
  private float gravity = 0.8; // Aceleración de la gravedad.
  private float jumpStrength = -15; // Fuerza del salto (el valor negativo lo hace hacia arriba).
  private float speed = 2;     // Velocidad de movimiento horizontal del jugador.
  private float maxSpeed = 5;  // Velocidad máxima que el jugador puede alcanzar.
  private float friction = 0.8; // Fricción, reduce la velocidad al mover.
  private boolean jumping = false; // Determina si el jugador está en el aire.
  private float animationSpeed = 3.0; // Controla la velocidad de la animación.

  private float frame = 0;     // Controla el frame actual para la animación.
  private int cols = 6;        // Número de columnas en el sprite (cuántos frames por fila).
  private int rows = 4;        // Número de filas en el sprite (cuántas animaciones hay).
  private int spriteWidth, spriteHeight; // Dimensiones del sprite.

  private boolean facingLeft = false; // Indica si el jugador está mirando hacia la izquierda.
  private boolean isAnimating = false; // Si se está animando o no.

  private String state = "Idle"; // Estado actual del jugador (Idle, Running, Jumping, etc.)

  // Temporizadores y umbrales
  private int moveTimer = 0;   // Temporizador para manejar el movimiento.
  private int moveThreshold = 20; // Umbral para actualizar el movimiento.

  private int jumpTimer = 0;   // Temporizador para el salto.
  private int jumpDelay = 5;   // Retraso para controlar la rapidez del salto.
  
  private boolean onGround = false;


  private ArrayList<PVector> trajectory = new ArrayList<PVector>(); // Trayectoria del jugador para mostrar.
  private boolean showHitbox = false;  // Si se debe mostrar la caja de colisión del jugador.
  private boolean showTrajectory = false; // Si se debe mostrar la trayectoria del jugador.

  private int vidas; // Número de vidas del jugador.


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
    // Calcula la aceleración basada en si el jugador está en el aire o en el suelo
    float acceleration = dir * speed;
    if (!jumping) { 
        if (state.equals("Running")) { 
            // Aceleración normal al correr
            xVel += acceleration;
        } else {
            // Movimiento directo si no está corriendo
            xVel = dir * speed;
        }
    } else {
        // Menor control en el aire
        acceleration *= 0.5;
        xVel += acceleration;
    }

    // Constrain velocidad horizontal dentro de los límites permitidos
    xVel = constrain(xVel, -maxSpeed, maxSpeed);

    // Determina la dirección en la que está mirando el jugador
    facingLeft = dir < 0;

    // Actualiza el estado en función de la dirección
    state = dir < 0 ? "Moving Left" : "Moving Right";

    // Actualiza el temporizador de movimiento
    if (moveTimer < moveThreshold) {
        moveTimer++;
    }

    // Actualiza el frame de animación
    frame = (frame + animationSpeed) % cols;
}

  /**
   * Detiene el movimiento del jugador.
   */
public void stop() {
    if (state.equals("Running")) {
        state = "Inertia"; // Cambia el estado a "Inertia" cuando deja de correr.
    } else {
        state = "Idle"; // Si no está corriendo, cambia a "Idle".
        xVel = 0; // Detiene el movimiento horizontal.
    }
    frame = 0; // Reinicia la animación.
    moveTimer = 0; // Reinicia el temporizador de movimiento.
}

  /**
   * Hace que el jugador salte.
   */
public void jump() {
  if (!jumping) {  // Si el jugador no está saltando.
    yVel = jumpStrength; // Aplica la fuerza del salto en el eje Y.
    jumping = true; // Marca que el jugador está saltando.
    state = "Jumping"; // Cambia el estado a "Jumping".
    frame = 0; // Reinicia la animación.
    jumpTimer = 0; // Reinicia el temporizador del salto.
    jumpSound.play();  // Reproduce el sonido de salto
  }
}

  public void update(ArrayList<float[]> rectangulos) {
  // Aplica la gravedad si no está en el suelo
  if (!onGround) {
    yVel += gravity;
  }

  // Aplica la velocidad horizontal y vertical
  if (moveTimer >= moveThreshold && !jumping) {
    state = "Running";
  }

  // Aplica la velocidad horizontal y vertical
  position.x += xVel;
  position.y += yVel;

  // Verificar colisiones con rectángulos
  onGround = false;  // Inicializamos en false, indicando que el jugador no está en el suelo.

for (float[] rect : rectangulos) {  // Iteramos sobre cada rectángulo en la lista de "rectangulos".
  
  // Comprobamos si hay colisión entre el jugador y el rectángulo actual.
  if (isColliding(position.x, position.y, spriteWidth, spriteHeight, rect)) {
    
    // Si el jugador está cayendo (yVel > 0), se verifica si está por encima del rectángulo y lo ajustamos.
    if (yVel > 0 && position.y + spriteHeight <= rect[1] + yVel) {
      
      // Ajustar la posición del jugador para que quede justo encima del rectángulo
      position.y = rect[1] - spriteHeight;  
      
      // Marcamos que el jugador ha aterrizado en el suelo
      onGround = true;  
      
      // Detenemos la velocidad vertical, ya que el jugador ha dejado de caer
      yVel = 0;  
      
      // Terminamos el estado de salto, ya que el jugador ha aterrizado
      jumping = false;  
    }
  }
}


  // Aplica la fricción si está en el estado de "Inertia"
  if (state.equals("Inertia")) {
    xVel *= friction;
    if (abs(xVel) < 0.1) {
      xVel = 0;
      state = "Idle";
    }
  }

  // Añadir puntos a la trayectoria cuando Sonic está saltando
  if (jumping) {
    trajectory.add(new PVector(position.x, position.y));
  }

  // Actualiza la animación del salto
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

  // Actualiza la velocidad de la animación según el estado del jugador
  if (state.equals("Inertia") || state.equals("Running")) {
    animationSpeed = map(abs(xVel), 0, maxSpeed, 0.1, 1.0);
    isAnimating = true;
  } else if (state.equals("Idle")) {
    animationSpeed = 0;
    isAnimating = false;
    frame = 0;
  } else {
    animationSpeed = 0.5;
    isAnimating = true;
  }

  // Actualiza el frame de la animación si está animando
  if (isAnimating) {
    frame = (frame + animationSpeed) % cols;
  }

  // Restringir la posición del jugador dentro de los límites de la pantalla
// Definir un límite para el mapa
float mapWidth = 2000;  // Ancho total del mapa (ajusta este valor según el tamaño real del mapa)

// Restringir la posición de Sonic para que no se salga del mapa
  position.x = constrain(position.x, 100, mapWidth - spriteWidth);
  position.y = constrain(position.y, 0, height);
}  

 /**
   * Dibuja el hitbox si está habilitado.
   */
  public void drawHitbox() {
    if (showHitbox) {
      noFill();
      stroke(#FF0303); // Color rojo para la hitbox
      rectMode(CENTER);
      rect(position.x+20, position.y+20, spriteWidth, spriteHeight); // Dibuja el rectángulo centrado
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
  }
}

  private boolean isColliding(float x1, float y1, float w1, float h1, float[] rect) {
    float x2 = rect[0];
    float y2 = rect[1];
    float w2 = rect[2];
    float h2 = rect[3];
    
    return x1 < x2 + w2 && x1 + w1 > x2 &&
           y1 < y2 + h2 && y1 + h1 > y2;
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

// Método para manejar la pérdida de vida y notificar al sistema de estados
public void perderVida(MaquinaDeEstado maquinaDeEstado) {
    vidas--;  // Disminuir una vida
    if (vidas <= 0) {
        // Si las vidas llegan a 0, notificamos a la máquina de estados
    }
}


// Método que maneja la muerte del jugador
public void morir() {
  // Lógica para manejar la muerte, como reiniciar el nivel o mostrar un mensaje de Game Over
  println("¡Game Over!");
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
