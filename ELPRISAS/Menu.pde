import gifAnimation.Gif;
import processing.core.PApplet;
import processing.core.PImage;

class Menu {
  // Variables privadas
  private PApplet sketch;
  private Gif gif;
  private Player sonic;
  private int menuHeight;
  private String menuText;
  /**
   * Constructor de la clase Menu.
   * @param sketch Referencia al PApplet principal.
   * @param gifPath Ruta del archivo GIF para el menú.
   * @param sonic Referencia al objeto Player (Sonic).
   * @param menuText Texto a mostrar en el menú.
   */
  public Menu(PApplet sketch, String gifPath, Player sonic, String menuText) {
    this.sketch = sketch;
    this.sonic = sonic;
    this.menuHeight = 100;
    this.menuText = menuText;
    
    // Carga el GIF animado
    this.gif = new Gif(sketch, gifPath);
    this.gif.loop();
  }

  /**
   * Muestra el menú en la pantalla.
   */
  public void display() {
    drawMenuBackground();
    drawMenuText();
    drawGif();
    controlAndDisplaySonic();
  }

  // Métodos privados para la lógica interna
  private void drawMenuBackground() {
    sketch.fill(255, 150);
    sketch.noStroke();
    sketch.rect(0, sketch.height - menuHeight, sketch.width, menuHeight);
  }

  private void drawMenuText() {
    sketch.fill(255);
    sketch.textSize(24);
    sketch.textAlign(PApplet.CENTER, PApplet.CENTER);
    sketch.text(menuText, sketch.width / 2, sketch.height - menuHeight / 2);
  }

  private void drawGif() {
    if (gif != null) {
      sketch.image(gif, sketch.width / 2 - gif.width / 2, sketch.height - 400 + 10);
    }
  }

  private void controlAndDisplaySonic() {
    float dx = 0, dy = 0;
    if (sketch.keyPressed) {
      if (sketch.keyCode == PApplet.UP) dy = -2;
      if (sketch.keyCode == PApplet.DOWN) dy = 2;
      if (sketch.keyCode == PApplet.LEFT) dx = -2;
      if (sketch.keyCode == PApplet.RIGHT) dx = 2;
    }
    sonic.mover(dx, dy);
    sonic.mostrar();
  }

  // Getters y setters
  public int getMenuHeight() {
    return menuHeight;
  }

  public void setMenuHeight(int menuHeight) {
    this.menuHeight = menuHeight;
  }

  public String getMenuText() {
    return menuText;
  }

  public void setMenuText(String menuText) {
    this.menuText = menuText;
  }
}
