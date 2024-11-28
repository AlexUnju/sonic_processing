class Misil {
  private PImage image;  // Imagen del misil
  private float x, y;    // Posición del misil
  private float speed;   // Velocidad del misil
  private float scale;   // Escala para ajustar el tamaño
  private float tiempoDeVida; // Tiempo que el misil sigue a Sonic (en segundos)
  private float tiempoMaximo = 10; // 2 segundos para perseguir a Sonic
  private boolean persigueSonic;  // Determina si el misil persigue a Sonic

  private Player player;  // Objeto Player para obtener la posición de Sonic
  private float targetX, targetY;  // Posición del objetivo (Sonic)

  private float gravedad = 0.1;  // Gravedad para afectar el movimiento del misil
  private float velocidadY = 0;  // Velocidad vertical del misil

  private float offsetX, offsetY;  // Desplazamiento inicial para la curvatura
  private boolean enCurvatura;    // Si el misil está en la fase de curvatura

  // Constructor de la clase Misil, ahora recibe el objeto Player
  public Misil(PImage image, float startX, float startY, float speed, float scale, Player player, boolean mirandoDerecha) {
    this.image = image;
    this.x = startX;
    this.y = startY;
    this.speed = speed;
    this.scale = scale;
    this.player = player;  // Guardamos el objeto player
    this.tiempoDeVida = 0;
    this.persigueSonic = true;  // El misil comienza persiguiendo a Sonic
    this.enCurvatura = true;    // El misil empieza en la fase de curvatura

    // Inicializamos el desplazamiento para la curvatura
    if (mirandoDerecha) {
      this.offsetX = 50;  // Desplazamiento a la derecha (curvatura inicial)
    } else {
      this.offsetX = -50;  // Desplazamiento a la izquierda
    }
    this.offsetY = -100;  // Desplazamiento vertical para la curvatura
  }

  // Actualización del misil
  public void update() {
    if (persigueSonic) {
      tiempoDeVida += 1.0 / frameRate;  // Incrementar el tiempo de vida según el frameRate (en segundos)

      if (tiempoDeVida <= tiempoMaximo) {
        // Obtener la posición de Sonic usando el objeto player
        targetX = player.getX();
        targetY = player.getY();

        // Calcular la dirección hacia Sonic
        float dx = targetX - x;
        float dy = targetY - y;
        float distancia = sqrt(dx * dx + dy * dy);

        // Si el misil aún está en curvatura, aplicar la curvatura inicial
        if (enCurvatura) {
          // Mover el misil con un desplazamiento en la dirección de curvatura
          x += offsetX * 0.1;  // Curvatura en el eje X
          y += offsetY * 0.1;  // Curvatura en el eje Y

          // Reducir gradualmente el desplazamiento de la curvatura
          offsetX *= 0.95;
          offsetY *= 0.95;

          // Si el desplazamiento de la curvatura es pequeño, el misil comienza a perseguir a Sonic
          if (abs(offsetX) < 1 && abs(offsetY) < 1) {
            enCurvatura = false;  // Deja de estar en la fase de curvatura
          }
        } else {
          // Después de la curvatura, el misil sigue a Sonic
          dx /= distancia;
          dy /= distancia;

          // Gravedad: hacer que el misil caiga (velocidadY)
          velocidadY += gravedad;  // Incrementar la velocidad vertical por la gravedad
          y += velocidadY;  // Mover el misil hacia abajo por la gravedad

          // Mover el misil de forma más fluida hacia Sonic
          x += dx * speed;  // Movimiento horizontal hacia Sonic
          y += dy * speed;  // Movimiento vertical hacia Sonic
        }
      } else {
        // Después de 2 segundos, dejar de perseguir a Sonic
        persigueSonic = false;
      }
    } else {
      // Si ya no persigue a Sonic, se mueve en línea recta hacia abajo
      velocidadY += gravedad;  // Continúa la caída por gravedad
      y += velocidadY;  // Movimiento hacia abajo
    }
    
      if (persigueSonic) {
    // Código existente para el movimiento y curvatura...
  } else {
    // Si ya no persigue a Sonic, se mueve en línea recta hacia abajo
    velocidadY += gravedad;
    y += velocidadY;
  }

// Verificar colisión con el jugador
if (isCollidingWithPlayer(player)) {
    // Disminuir vidas del jugador
    player.perderVida();  // Aquí no pasas la máquina de estados
    // Cambiar al estado de fin de juego si el jugador pierde todas sus vidas
    if (player.getVidas() <= 0) {
        maquinaDeEstado.setEstado(MaquinaDeEstado.ENDGAME);  // Cambiar a ENDGAME directamente
    }
    // Opcional: Destruir el misil o reiniciarlo
    this.destruir();  // Método que destruye o desactiva el misil
}



// Continuar con la lógica para el misil dependiendo si persigue a Sonic o no
if (persigueSonic) {
    // Código existente para el movimiento y curvatura...
} else {
    // Si ya no persigue a Sonic, se mueve en línea recta hacia abajo
    velocidadY += gravedad;
    y += velocidadY;
}
  
  }
  
  public void destruir() {
  // Desactivar el misil o eliminarlo de la lista de misiles activos
  x = -1000;  // Mueve el misil fuera de la pantalla
  y = 100;  // O puedes eliminar el misil de una lista de objetos activos
}

  
  // Método que verifica si el misil está colisionando con el jugador
public boolean isCollidingWithPlayer(Player player) {
  float playerX = player.getX();
  float playerY = player.getY();
  float playerWidth = player.getSpriteWidth();
  float playerHeight = player.getSpriteHeight();

  // Comprobar colisión rectangular entre el misil y el jugador
  return x < playerX + playerWidth && x + image.width * scale > playerX &&
         y < playerY + playerHeight && y + image.height * scale > playerY;
}


  // Mostrar el misil en la pantalla
  public void display() {
    float newWidth = image.width * scale;
    float newHeight = image.height * scale;

    if (image != null) {
      // Calcular el ángulo de rotación para que la punta apunte hacia Sonic
      float dx = targetX - x;
      float dy = targetY - y;
      float angle = atan2(dy, dx);  // Ángulo entre el misil y Sonic

      pushMatrix();
      translate(x, y);  // Trasladar el origen a la posición del misil
      rotate(angle);  // Rotar la imagen para que apunte a Sonic
      image(image, 0, 0, newWidth, newHeight);  // Dibujar la imagen centrada
      popMatrix();
    }
  }

  public float getX() {
    return x;
  }

  public float getY() {
    return y;
  }

  public boolean fueraDePantalla() {
    return y > height;
  }
}
