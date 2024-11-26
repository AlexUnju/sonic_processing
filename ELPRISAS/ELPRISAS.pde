import gifAnimation.Gif; // Importa la librería gifAnimation
import processing.sound.*; // Importa la librería Sound

enum GameState {
  MENU,      // Estado del menú principal
  INICIO,    // Estado del juego en curso
  PAUSA,     // Estado de pausa
  VICTORIA,  // Estado de victoria
  ENDGAME    // Estado de derrota
}

private PImage fondo;
private Parallax parallax;
private SoundFile music;
private Player sonic;
private PImage spriteSheet; // Imagen de los sprites de los enemigos
public PImage spriteSheet2;
private HUD hud;
private MaquinaDeEstados maquinaDeEstados;
private Menu menu;
private EndGame endGame; // Instancia de la clase EndGame
private Collision collisionHandler;
private Escenario escenario;
private SpawnerEnemigos spawner; // Instancia del spawner
private float deltaTime;  // Variable para almacenar el tiempo entre frames
public boolean gameOver = false;

// Colores
private color color1Original = #771177;
private color color2Original = #993399;
private color color3Original = #dd77dd;
private color color4Original = #bb55bb;
private color color1Nuevo = #b4d6f0;
private color color2Nuevo = #0092ff;
private color color3Nuevo = #ffffff;
private color color4Nuevo = #0090fc;

public void setup() {
  size(800, 500);
  fondo = loadImage("fondo.png");

  // Maquina de estados
  maquinaDeEstados = new MaquinaDeEstados(this);
  endGame = new EndGame(this);

  parallax = new Parallax(fondo, 0.5, 1.8, -100, -310);
  hud = new HUD(3, 60);
  
  collisionHandler = new Collision();
  
  music = new SoundFile(this, "sound/Sonic_The_Hedgehog.mp3");
  music.loop();

  cambiarColores(fondo);
 
  escenario = new Escenario(this, height - 50); // El piso está a 100 píxeles del fondo
  sonic = new Player(width / 2, escenario.getFloorY() - 50, "sonic.gif", 50, 50, this);
  menu = new Menu(this, "MENU.gif", sonic, "Menú Principal\nPresiona ENTER para comenzar");
                                                                                            
  spriteSheet = loadImage("buzzer.png"); // Cargar sprite sheet
  spawner = new SpawnerEnemigos(spriteSheet);
}

public void draw() {
  background(0);

  // Mostrar Parallax en MENU e INICIO
  if (maquinaDeEstados.estadoActual == GameState.MENU || maquinaDeEstados.estadoActual == GameState.INICIO || maquinaDeEstados.estadoActual == GameState.PAUSA) {
    parallax.update();
    parallax.display();
  }
  // Calcular el deltaTime (tiempo entre cuadros)
  deltaTime = millis() / 1000.0; // Dividir entre 1000 para convertir milisegundos a segundos

  // Manejo de estados del juego
  switch (maquinaDeEstados.estadoActual) {
    case MENU:
      menu.display(); // Mostrar el menú
      break;
     case INICIO:
      escenario.mostrar();
      escenario.verificarColision(sonic);

      // Movimiento del jugador
      float dx = 0, dy = 0;
      if (keyPressed) {
        if (keyCode == LEFT) dx = -5;
        if (keyCode == RIGHT) dx = 5;
        if (keyCode == UP && sonic.getPosicion().y >= escenario.getFloorY() - sonic.alto) dy = -20; // Salto
      }
      sonic.mover(dx, dy);

      // Gravedad
      if (sonic.getPosicion().y < escenario.getFloorY() - sonic.alto) {
        sonic.mover(0, 0.5);
      }
      sonic.mostrar();

<<<<<<< Updated upstream
     // Generar enemigos periódicamente
      spawner.actualizarEnemigos(deltaTime); // Pasar deltaTime a actualizarEnemigos
=======
      // Actualizar enemigos y verificar colisiones
      spawner.spawnEnemigo();
      spawner.actualizarEnemigos(deltaTime);
      for (EnemigosBase enemigo : spawner.enemigos) {
        collisionHandler.handleCollision(sonic, enemigo, hud);
      }
>>>>>>> Stashed changes

      // Mostrar HUD
      hud.mostrar();

      // Verificar condiciones de victoria o derrota
      if (hud.tiempoTerminado()) {
        maquinaDeEstados.cambiarEstado(GameState.ENDGAME);
      }
      break;

    case PAUSA:
      fill(255, 150);
      rect(0, 0, width, height); // Fondo semitransparente
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(32);
      text("PAUSA\nPresiona ESPACIO para continuar", width / 2, height / 2);
      break;

    case VICTORIA:
      fill(0, 255, 0);
      textAlign(CENTER, CENTER);
      textSize(32);
      text("¡Felicidades, has ganado!\nPresiona ENTER para volver al menú", width / 2, height / 2);
      break;

    case ENDGAME:
      endGame.display(); // Mostrar pantalla de Game Over
      break;
  }
}

public void cambiarColores(PImage img) {
  img.loadPixels();
  
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    
    if (esColorCercano(c, color1Original)) {
      img.pixels[i] = color1Nuevo;
    } else if (esColorCercano(c, color2Original)) {
      img.pixels[i] = color2Nuevo;
    } else if (esColorCercano(c, color3Original)) {
      img.pixels[i] = color3Nuevo;
    } else if (esColorCercano(c, color4Original)) {
      img.pixels[i] = color4Nuevo;
    }
  }
  
  img.updatePixels();
}

private boolean esColorCercano(color c, color original) {
  float r1 = red(c);
  float g1 = green(c);
  float b1 = blue(c);
  float r2 = red(original);
  float g2 = green(original);
  float b2 = blue(original);
  float dif = dist(r1, g1, b1, r2, g2, b2);
  return dif < 30;
}

public void keyPressed() {
  switch (maquinaDeEstados.estadoActual) {
    case MENU:
      if (key == ENTER) {
        maquinaDeEstados.cambiarEstado(GameState.INICIO);
      }
      break;

    case INICIO:
      if (key == ' ') { // Activar pausa
        maquinaDeEstados.cambiarEstado(GameState.PAUSA);
      }
      break;

    case PAUSA:
      if (key == ' ') { // Salir de la pausa
        maquinaDeEstados.cambiarEstado(GameState.INICIO);
      }
      break;

    case VICTORIA:
    case ENDGAME:
      if (key == ENTER) {
        maquinaDeEstados.cambiarEstado(GameState.MENU);
      }
      break;
  }
}
