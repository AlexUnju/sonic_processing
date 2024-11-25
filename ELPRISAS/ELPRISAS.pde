import gifAnimation.Gif;
import processing.sound.*;

PImage fondo;
Parallax parallax;
SoundFile music;
Player sonic;
EndGame endGame;
PImage spriteSheet;
Enemigo enemigo;
PImage spriteSheet2;
Enemies2 enemigo2;
HUD hud;
Collision collisionHandler;
Menu menu;
Escenario escenario;

boolean gameOver = false;

// Colores
color color1Original = #771177;
color color2Original = #993399;
color color3Original = #dd77dd;
color color4Original = #bb55bb;

color color1Nuevo = #b4d6f0;
color color2Nuevo = #0092ff;
color color3Nuevo = #ffffff;
color color4Nuevo = #0090fc;

void setup() {
  size(800, 500);
  fondo = loadImage("fondo.png");
  parallax = new Parallax(fondo, 0.5, 1.8, -100, -310);
  hud = new HUD(3, 60);
  collisionHandler = new Collision();
  
  music = new SoundFile(this, "sound/Sonic_The_Hedgehog.mp3");
  music.loop();

  cambiarColores(fondo);
 
  escenario = new Escenario(this, height - 100); // El piso está a 100 píxeles del fondo
  sonic = new Player(width / 2, escenario.getFloorY() - 50, "sonic.gif", 50, 50, this);
  menu = new Menu(this, "MENU.gif", sonic, "Menú Parallax");
  endGame = new EndGame(this);
  
  spriteSheet = loadImage("buzzer.png");
  enemigo = new Enemigo(spriteSheet, 300, 300, 100, 10);
  
  spriteSheet2 = loadImage("buzzer.png");
  enemigo2 = new Enemies2(spriteSheet2, 300, 300, 120, 15);
}

void draw() {
  background(0);

  if (!gameOver) {
    parallax.update();
    parallax.display();
    
    escenario.mostrar();
    escenario.verificarColision(sonic);
    
    // Control de Sonic
    float dx = 0, dy = 0;
    if (keyPressed) {
      if (keyCode == LEFT) dx = -5;
      if (keyCode == RIGHT) dx = 5;
      if (keyCode == UP && sonic.getPosicion().y >= escenario.getFloorY() - sonic.alto) dy = -10; // Salto simple
    }
    sonic.mover(dx, dy);
    
    // Aplicar gravedad
    if (sonic.getPosicion().y < escenario.getFloorY() - sonic.alto) {
      sonic.mover(0, 0.5); // Gravedad
    }
    
    sonic.mostrar();
    
    if (!enemigo.isEliminado()) {
      enemigo.mostrar();
      enemigo.mover(-1, 0);
      collisionHandler.handleCollision(sonic, enemigo, hud);
    }

    if (!enemigo2.isEliminado()) {
      enemigo2.mostrar();
      enemigo2.mover(-3, 0);
      collisionHandler.handleCollision(sonic, enemigo2, hud);
    }

    hud.mostrar();
    menu.display();

    if (hud.tiempoTerminado()) {
      gameOver = true;
    }
  } else {
    endGame.display();
  }
}

void cambiarColores(PImage img) {
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

boolean esColorCercano(color c, color original) {
  float r1 = red(c);
  float g1 = green(c);
  float b1 = blue(c);

  float r2 = red(original);
  float g2 = green(original);
  float b2 = blue(original);

  float dif = dist(r1, g1, b1, r2, g2, b2);
  
  return dif < 30;
}
