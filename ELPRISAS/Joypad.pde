class Joypad {
  private Player player;
  private Debug debug;
  private MaquinaDeEstado maquinaDeEstado;

  public Joypad(Player player, Debug debug, MaquinaDeEstado maquinaDeEstado) {
    this.player = player;
    this.debug = debug;
    this.maquinaDeEstado = maquinaDeEstado;
  }

  public void keyPressed(char key) {
    if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ESPERA && key == ENTER) {
      maquinaDeEstado.setEstado(MaquinaDeEstado.TRANSICION);
    }
    
    if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ESCENARIO) {
      // Controles del jugador
      if (key == 'a') player.move(-1);   // Mover a la izquierda
      if (key == 'd') player.move(1);    // Mover a la derecha
      if (key == ' ') player.jump();     // Salto

      // Alternar depuración
      if (key == 'q') debug.toggleDebug(player);

      // Simular ganar vida
      if (key == 'r') player.ganarVida();

      // Cambiar al estado WIN
      if (key == 'p') maquinaDeEstado.setEstado(MaquinaDeEstado.WIN);

      // Cambiar al estado ENDGAME
      if (key == 'l' || key == 'L') maquinaDeEstado.setEstado(MaquinaDeEstado.ENDGAME);
    }

    // Salir del juego desde el estado ENDGAME
    if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ENDGAME && key == ESC) {
      exit();
    }
  }

  public void keyReleased(char key) {
    // Detener movimiento al soltar las teclas de movimiento
    if (key == 'a' || key == 'd') player.stop();
  }
}
