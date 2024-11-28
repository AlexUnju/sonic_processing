class MaquinaDeEstado {
  private Menu menu;
  private Escenario escenario;
  private Win win;  // Añadir la referencia a la clase Win

  public static final int INICIO = 0;
  public static final int ESPERA = 1;
  public static final int TRANSICION = 2;
  public static final int ESCENARIO = 3;
  public static final int ENDGAME = 4;
  public static final int WIN = 5; // Nuevo estado WIN

  private int estado = INICIO;
  private int textAlpha = 255;
  private boolean fadeOut = true;
  private boolean animacionFinalizada = false;

  public MaquinaDeEstado(Menu menu) {
    this.menu = menu;
    this.escenario = new Escenario("escenario/scene0.png");
    this.win = new Win();  // Inicializar la clase Win
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
        menu.drawMenu("", 255);
        break;

      case ESPERA:
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
        }
        break;

      case ESCENARIO:
        // Aquí agregamos la lógica del juego mientras está en el escenario.
        break;

      case ENDGAME:
        background(0);
        if (endGameImage != null) {
          imageMode(CENTER);
          image(endGameImage, width / 2, height / 2 - 50);
        }
        textAlign(CENTER, CENTER);
        fill(255);
        textSize(20);
        text("Pulsa ESC para salir", width / 2, height / 2 + 150);
        break;

      case WIN:
        // Mostrar pantalla de victoria
        win.display();
        break;
    }
  }

  public void keyPressed(char key) {
    if (estado == ESPERA && key == ENTER) {
      estado = TRANSICION;
      textAlpha = 255;
    }
  }

  public void setEstado(int nuevoEstado) {
    estado = nuevoEstado;
  }

  public int getEstado() {
    return estado;
  }
}
