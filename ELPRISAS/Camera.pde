class Camera {
  private float x, y;
  private float offsetY;  // Desfase vertical

  public Camera() {
    x = width / 2;
    y = height / 2;
    offsetY = 100;  // Desfase de 50 píxeles hacia abajo
  }
  
  public void follow(Player target) {
    x = -target.getX() + width / 2;
    y = -target.getY() + height / 2 + offsetY;  // Aplica el desfase vertical
  }
  
  public void apply() {
    translate(x, y);
  }
  
  public float getX() { return x; }
  public void setX(float x) { this.x = x; }
  public float getY() { return y; }
  public void setY(float y) { this.y = y; }
}
