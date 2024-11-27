class Time {
  private float deltaTime;
  private float lastFrameTime;
  private float timeScale;

  public Time() {
    this.deltaTime = 0;
    this.lastFrameTime = millis();
    this.timeScale = 1.0f;
  }

  public void update() {
    float currentTime = millis();
    deltaTime = (currentTime - lastFrameTime) / 1000f * timeScale;
    lastFrameTime = currentTime;
  }

  public float getDeltaTime() {
    return deltaTime;
  }

  public void setTimeScale(float scale) {
    this.timeScale = scale;
  }

  public float getTimeScale() {
    return timeScale;
  }
}
