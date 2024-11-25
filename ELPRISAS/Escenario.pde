import processing.core.PApplet;
import processing.core.PVector;
import java.util.ArrayList;

class Escenario {
  private PApplet sketch;
  private float floorY;
  private ArrayList<Obstaculo> obstaculos;
  private int colorPiso;
  private int colorObstaculos;

  /**
   * Constructor de la clase Escenario.
   * @param sketch Referencia al PApplet principal.
   * @param floorY Posición Y del piso.
   */
  public Escenario(PApplet sketch, float floorY) {
    this.sketch = sketch;
    this.floorY = floorY;
    this.obstaculos = new ArrayList<Obstaculo>();
    this.colorPiso = sketch.color(100, 200, 100);
    this.colorObstaculos = sketch.color(150, 75, 0);
    
    inicializarObstaculos();
  }

  private void inicializarObstaculos() {
    obstaculos.add(new Obstaculo(300, floorY - 50, 50, 50));
    obstaculos.add(new Obstaculo(500, floorY - 30, 30, 30));
    obstaculos.add(new Obstaculo(700, floorY - 70, 70, 70));
  }

  public void mostrar() {
    dibujarPiso();
    dibujarObstaculos();
  }

  private void dibujarPiso() {
    sketch.fill(colorPiso);
    sketch.rect(0, floorY, sketch.width, sketch.height - floorY);
  }

  private void dibujarObstaculos() {
    sketch.fill(colorObstaculos);
    for (Obstaculo obstaculo : obstaculos) {
      sketch.rect(obstaculo.x, obstaculo.y, obstaculo.ancho, obstaculo.alto);
    }
  }

  public void verificarColision(Player jugador) {
    // Colisión con el piso
    if (jugador.getPosicion().y + jugador.alto > floorY) {
      jugador.getPosicion().y = floorY - jugador.alto;
    }

    // Colisión con obstáculos
    for (Obstaculo obstaculo : obstaculos) {
      if (obstaculo.colisionaCon(jugador)) {
        // Manejar la colisión (por ejemplo, detener al jugador)
        jugador.getPosicion().x -= jugador.velocidad.x;
        jugador.getPosicion().y -= jugador.velocidad.y;
      }
    }
  }

  private class Obstaculo {
    float x, y, ancho, alto;

    Obstaculo(float x, float y, float ancho, float alto) {
      this.x = x;
      this.y = y;
      this.ancho = ancho;
      this.alto = alto;
    }

    boolean colisionaCon(Player jugador) {
      return jugador.getPosicion().x < this.x + this.ancho &&
             jugador.getPosicion().x + jugador.ancho > this.x &&
             jugador.getPosicion().y < this.y + this.alto &&
             jugador.getPosicion().y + jugador.alto > this.y;
    }
  }

  // Getters y setters
  public float getFloorY() {
    return floorY;
  }

  public void setFloorY(float floorY) {
    this.floorY = floorY;
  }

  public int getColorPiso() {
    return colorPiso;
  }

  public void setColorPiso(int colorPiso) {
    this.colorPiso = colorPiso;
  }

  public int getColorObstaculos() {
    return colorObstaculos;
  }

  public void setColorObstaculos(int colorObstaculos) {
    this.colorObstaculos = colorObstaculos;
  }
}
