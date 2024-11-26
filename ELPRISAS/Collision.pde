class Collision {
  // Constructor vacío, ya que no necesitamos inicializar nada al crear un objeto Collision
  Collision() {}

  // Verifica si dos rectángulos se están superponiendo (colisión)
  boolean checkCollision(PVector pos1, float width1, float height1, PVector pos2, float width2, float height2) {
    return pos1.x < pos2.x + width2 &&
           pos1.x + width1 > pos2.x &&
           pos1.y < pos2.y + height2 &&
           pos1.y + height1 > pos2.y;
  }

  // Manejo de la colisión entre Sonic y cualquier enemigo (hereda de EnemigosBase)
  void handleCollision(Player player, EnemigosBase enemigo, HUD hud) {
    PVector playerPos = player.getPosicion();
    float playerWidth = player.ancho;
    float playerHeight = player.alto;

    PVector enemigoPos = new PVector(enemigo.x, enemigo.y);
    float enemigoWidth = enemigo.width;
    float enemigoHeight = enemigo.height;

    if (checkCollision(playerPos, playerWidth, playerHeight, enemigoPos, enemigoWidth, enemigoHeight)) {
      if (playerPos.y < escenario.getFloorY() - playerHeight) {
        // Sonic está en el aire, destruir enemigo
        enemigo.estado = 2; // Cambia al estado de explosión
        enemigo.currentFrame = 0; // Reinicia la animación de explosión
        hud.añadirPuntos(10); // Suma 10 puntos
      } else {
        // Sonic no está en el aire, pierde vida
        hud.modificarVidas(-1);
      }
    }
  }
}
