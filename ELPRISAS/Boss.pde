class Boss {
  private PImage image;  // La imagen del Boss
  private float x, y;
  private float speed;
  private float scale;
  private Player player;
  private boolean giro;  // Controla la dirección (izquierda o derecha)
  private SpawnMisiles spawnMisiles;
  private SpawnAbejas spawnAbejas;

  private boolean enPausa = false;  // Indica si el Boss está en pausa
  private int tiempoPausa = 0;      // Duración de la pausa
  private int contadorPausa = 0;    // Contador para gestionar la pausa
  private boolean adelantado = false; // Indica si el Boss ya se adelantó
  private boolean enAdelantamiento = false; // Indica si está en proceso de adelantarse
  private float targetX;  // Posición objetivo para el adelantamiento
  private MaquinaDeEstado maquinaDeEstado;  // Declara la referencia a MaquinaDeEstado
  
  // Atributo para almacenar el sonido de colisión
  private SoundFile collisionSound; // Sonido al recibir daño
  private SoundFile crashSound; // Sonido al chocar con el jugador

  // Nueva variable para la vida del Boss
  private int vida = 1000;  // Vida inicial del Boss

  public Boss(PApplet app, String imagePath, float startX, float startY, float speed, float scale, Player player, int vidaInicial, MaquinaDeEstado maquinaDeEstado) {
    this.image = loadImage(imagePath);
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;
    this.giro = false;

    // Instanciar SpawnMisiles con la ruta de la imagen del misil y el sonido
    this.spawnMisiles = new SpawnMisiles(app, "Misil.png", "sound/Fireball.wav", 100);  // Pasar la referencia de PApplet

    this.spawnAbejas = new SpawnAbejas(maquinaDeEstado);
    
    // Instanciar los sonidos directamente
    collisionSound = new SoundFile(app, "sound/CollapsePlatform.wav");
    crashSound = new SoundFile(app, "sound/Crash.wav");

    this.maquinaDeEstado = maquinaDeEstado;
  }

  public void update() {
     // Detectar colisión mientras el jugador está saltando
    if (checkCollisionWithPlayer()) {
    if (player.isJumping()) {
        takeDamage(10); // Reducir vida del Boss
        if (collisionSound != null) collisionSound.play(); // Sonido de daño al Boss
    } else {
        player.perderVida(); // Reducir vida del jugador
        if (crashSound != null) crashSound.play(); // Sonido de choque
    }
}
    
    if (enPausa) {
      contadorPausa++;
      if (contadorPausa >= tiempoPausa) {
        enPausa = false;
        contadorPausa = 0;
        tiempoPausa = 0;
        adelantado = false;  // El Boss puede adelantarse nuevamente
        enAdelantamiento = false;
      }
    } else if (enAdelantamiento) {
      moverHaciaAdelante();
    } else {
      if (player.getXVel() > 2 && player.getX() > x && !adelantado) {
        iniciarAdelantamiento();  // Iniciar el adelantamiento si Sonic está corriendo rápido hacia la derecha
      } else if (!adelantado) {
        if (abs(player.getX() - x) > 15) {  // Solo moverse si hay una diferencia significativa
          if (player.getX() > x) {
            x += speed;
            giro = true;
          } else if (player.getX() < x) {
            x -= speed;
            giro = false;
          }
        }
      }
    }

    if (adelantado || enPausa) {
    spawnMisiles.intentarDisparar(x, y + image.height * scale / 2, 10, 0.1, player, giro);
    }

    spawnMisiles.update();
    spawnAbejas.update(player, x, y + image.height * scale / 2);
  }
  
private void takeDamage(int damage) {
    vida -= damage;
    if (vida <= 0) {
        vida = 0;
        winScenario(); // Escenario de victoria
    }
}
  
// Detecta la colisión entre el Boss y el Player
// Detecta la colisión entre el Boss y el Player
private boolean checkCollisionWithPlayer() {
    float bossWidth = image.width * scale;
    float bossHeight = image.height * scale;
    float playerWidth = 50; // Ajusta al tamaño del jugador
    float playerHeight = 100;

    // Calcular si hay colisión
    boolean collision = (x < player.getX() + playerWidth &&
                         x + bossWidth > player.getX() &&
                         y < player.getY() + playerHeight &&
                         y + bossHeight > player.getY());
    return collision;
}

  private void winScenario() {
    // Mostrar el escenario de WIN
    println("¡WIN! El Boss ha sido derrotado.");

    // Verifica si maquinaDeEstado no es null antes de llamar a setEstado
    if (maquinaDeEstado != null) {
      maquinaDeEstado.setEstado(MaquinaDeEstado.WIN);
    } else {
      println("Error: maquinaDeEstado es null.");
    }
  }

  private void iniciarAdelantamiento() {
    // Calcular la posición objetivo (adelantarse entre 2x y 3x la distancia actual)
    targetX = x + random(0.5, 1) * (player.getX() - x);
    enAdelantamiento = true;  // Comienza el proceso de adelantamiento
    giro = true;  // Asumimos que el adelantamiento será hacia la derecha
  }

  private void moverHaciaAdelante() {
    if (abs(targetX - x) > 5) {  // Moverse gradualmente hacia la posición objetivo
      x += speed * 2;  // Doble velocidad para adelantar rápido
    } else {
      x = targetX;  // Ajustar la posición al objetivo
      enAdelantamiento = false;
      adelantado = true;  // Marcamos que ya se adelantó
      enPausa = true;  // Entrar en pausa después del adelantamiento
      tiempoPausa = int(random(60, 120));  // Pausa entre 1 y 2 segundos
    }
  }

  public void display() {
    if (image != null) {
      pushMatrix();

      // Reflejar horizontalmente si mira hacia la izquierda
      if (!giro) {
        translate(x + image.width * scale, y);
        scale(-1, 1);
        image(image, 0, 0, image.width * scale, image.height * scale);
      } else {
        image(image, x, y, image.width * scale, image.height * scale);
      }

      popMatrix();
      

        // Mostrar barra de vida del Boss
        drawHealthBar();
      // Mostrar misiles
      spawnMisiles.display();
      // Mostrar abejas
      spawnAbejas.display();
      drawHitbox();
    }
  }

  /**
 * Dibuja el hitbox del Boss (rectángulo alrededor de su imagen).
 */
private void drawHitbox() {
    stroke(148, 0, 211);  // Color violeta para el borde (RGB)
    noFill();  // Sin relleno
    rect(x, y, image.width * scale, image.height * scale);  // Rectángulo que representa el hitbox
}

/**
 * Dibuja la barra de vida del Boss.
 */
private void drawHealthBar() {
    float barWidth = image.width * scale;   // Ancho de la barra basado en la imagen del Boss
    float barHeight = 10;                   // Altura de la barra de vida
    float barX = x;                         // Posición horizontal de la barra (encima del Boss)
    float barY = y - 20;                    // Posición vertical de la barra (encima del Boss)
    
    // Porcentaje de vida restante
    float healthPercentage = (float) vida / 1000; // Ajustar según la vida máxima

    // Dibujar fondo de la barra (rojo para la barra vacía)
    fill(255, 0, 0);  // Rojo
    rect(barX, barY, barWidth, barHeight);

    // Dibujar la parte verde de la barra que representa la vida restante
    fill(0, 255, 0);  // Verde
    rect(barX, barY, barWidth * healthPercentage, barHeight);

    // Borde negro alrededor de la barra de vida
    noFill();
    stroke(0);  // Negro
    rect(barX, barY, barWidth, barHeight);
}

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }
  
    public int getVida() {
    return vida;
  }

}
