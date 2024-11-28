class Boss {
  private PImage image;  // La imagen del Boss
  private float x, y;
  private float speed;
  private float scale;
  private Player player;
  private boolean giro;  // Controla la dirección (izquierda o derecha)
  private int cols = 4;   // Número de columnas en la hoja de sprites
  private int rows = 4;   // Número de filas en la hoja de sprites
  private int spriteWidth, spriteHeight;
  private SpawnMisiles spawnMisiles;

  private boolean enPausa = false;  // Indica si el Boss está en pausa
  private int tiempoPausa = 0;      // Duración de la pausa
  private int contadorPausa = 0;    // Contador para gestionar la pausa
  private boolean adelantado = false; // Indica si el Boss ya se adelantó
  private boolean enAdelantamiento = false; // Indica si está en proceso de adelantarse
  private float targetX;  // Posición objetivo para el adelantamiento

  public Boss(String imagePath, float startX, float startY, float speed, float scale, Player player) {
    this.image = loadImage(imagePath);  // Cargar la imagen del Boss
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;
    this.giro = false;  // Inicialmente mirando hacia la izquierda

    this.spriteWidth = image.width / cols;
    this.spriteHeight = image.height / rows;

    this.spawnMisiles = new SpawnMisiles("Misil.png", 10);  // Cargar misiles
  }

  public void update() {
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
        if (abs(player.getX() - x) > 5) {  // Solo moverse si hay una diferencia significativa
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
    spawnMisiles.intentarDisparar(x, y + image.height * scale / 2, 1, 0.1, player, giro);
    }

    spawnMisiles.update();
  }

  private void iniciarAdelantamiento() {
    // Calcular la posición objetivo (adelantarse entre 2x y 3x la distancia actual)
    targetX = x + random(2, 3) * (player.getX() - x);
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

      // Mostrar misiles
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
