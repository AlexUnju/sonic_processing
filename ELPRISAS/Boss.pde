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


  // Nueva variable para la vida del Boss
  private int vida = 1000;  // Vida inicial del Boss

  public Boss(String imagePath, float startX, float startY, float speed, float scale, Player player, int vidaInicial, MaquinaDeEstado maquinaDeEstado) {
    this.image = loadImage(imagePath);  // Cargar la imagen del Boss
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;
    this.giro = false;  // Inicialmente mirando hacia la izquierda
    this.spawnMisiles = new SpawnMisiles("Misil.png", 100);  // Cargar misiles
    this.spawnAbejas = new SpawnAbejas();
    this.maquinaDeEstado = maquinaDeEstado;  // Inicializamos la referencia a MaquinaDeEstado

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
    
    // Detectar colisión con el Player y reducir vida
    if (checkCollisionWithPlayer()) {
      takeDamage(10);  // El Boss pierde 10 de vida cada vez que colisiona con el Player
    }
  }
  
    private void takeDamage(int damage) {
    vida -= damage;
    if (vida <= 0) {
      vida = 0;
      winScenario();  // Mostrar escenario WIN cuando el Boss muere
    }
  }
  
  
// Detecta la colisión entre el Boss y el Player
private boolean checkCollisionWithPlayer() {
    float bossWidth = image.width * scale;
    float bossHeight = image.height * scale;

    // Usando las dimensiones del Player si no tiene imagen
    float playerWidth = 50; // Ejemplo: el ancho del jugador es 50
    float playerHeight = 100; // Ejemplo: el alto del jugador es 100

    // Verifica si las áreas del Boss y el Player se solapan
    return (x < player.getX() + playerWidth &&
            x + bossWidth > player.getX() &&
            y < player.getY() + playerHeight &&
            y + bossHeight > player.getY());
}





  private void winScenario() {
    // Mostrar el escenario de WIN
    println("¡WIN! El Boss ha sido derrotado.");

    // Verifica si maquinaDeEstado no es null antes de llamar a setEstado
      maquinaDeEstado.setEstado(MaquinaDeEstado.WIN);
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
