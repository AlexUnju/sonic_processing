class MaquinaDeEstado {
  private Menu menu;
  private Escenario escenario;

  public static final int INICIO = 0;     // Campo estático
  public static final int ESPERA = 1;     // Campo estático
  public static final int TRANSICION = 2; // Campo estático
  public static final int ESCENARIO = 3;  // Campo estático
  public static final int ENDGAME = 4; // Nuevo estado


  private int estado = INICIO;
  private int textAlpha = 255;
  private boolean fadeOut = true;
  private boolean animacionFinalizada = false;

  public MaquinaDeEstado(Menu menu) {
    this.menu = menu;
    this.escenario = new Escenario("escenario/scene0.png");
  }

  public void update() {
    switch (estado) {
      case INICIO:
        if (menu.getCurrentFrame() < 12) {
          if (frameCount % 5 == 0) {
            menu.setCurrentFrame(menu.getCurrentFrame() + 1);
          }
        } else {
          estado = ESPERA;
        }
        menu.drawMenu("", 255);  // No dibuja texto en INICIO
        break;

      case ESPERA:
        // Cicla el menú y anima el texto
        if (frameCount % 5 == 0) {
          int current = menu.getCurrentFrame();
          if (current < 12 || current >= 29) {
            menu.setCurrentFrame(12);
          } else {
            menu.setCurrentFrame(current + 1);
          }
        }

        if (frameCount % 5 == 0) {
          if (fadeOut) {
            textAlpha -= 15;
            if (textAlpha <= 50) fadeOut = false;
          } else {
            textAlpha += 15;
            if (textAlpha >= 255) fadeOut = true;
          }
        }

        menu.drawMenu("Presiona ENTER para iniciar", textAlpha);
        break;

      case TRANSICION:
        if (menu.getCurrentFrame() < 39) {
          if (frameCount % 5 == 0) {
            menu.setCurrentFrame(menu.getCurrentFrame() + 1);
          }
        } else {
          animacionFinalizada = true;
        }

        if (textAlpha > 0) {
          textAlpha -= 10;
        }

        menu.drawMenu("Iniciando juego...", textAlpha);

        if (animacionFinalizada) {
          estado = ESCENARIO;
          animacionFinalizada = false;
          // Reiniciar la posición del parallax al entrar al estado ESCENARIO
          parallax.setMovimientoManual(true);  // Activar control manual
          parallax.reiniciarPosicion();  // Método para reiniciar la posición del parallax
        }
        break;

      case ESCENARIO:
        // En el estado ESCENARIO, el movimiento es manual
        parallax.setMovimientoManual(true);  // Activar control manual

        // Ahora sí, dibuja el escenario en este estado

        // Ya no es necesario dibujar a Sonic aquí, ya lo haces en el 'sketch'
        break;
      
      case ENDGAME:
        // Mostrar imagen de fin de juego
        background(0); // Fondo negro para mayor contraste
        if (endGameImage != null) {
          imageMode(CENTER);
          image(endGameImage, width / 2, height / 2 - 50);
        }

        // Mostrar el texto
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(20);
        text("Pulsa ESC para salir", width / 2, height / 2 + 150);
        break;
    }
  }

  public void keyPressed(char key) {
    if (estado == ESPERA && key == ENTER) {
      estado = TRANSICION;
      textAlpha = 255;
      parallax.setMovimientoManual(false);  // Desactivar movimiento automático al pasar a la transición
    }
  }
  
  public void setEstado(int nuevoEstado) {
    estado = nuevoEstado;
  }

  // Getter para obtener el estado actual
  public int getEstado() {
    return estado;
  }
}
