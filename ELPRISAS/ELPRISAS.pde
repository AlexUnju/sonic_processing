import gifAnimation.Gif; // Importa la librería gifAnimation
import processing.sound.*; // Importa la librería Sound

PImage fondo;
Parallax parallax;
Gif gif; // Variable para almacenar el GIF
SoundFile music; // Variable para almacenar el archivo de música
Player sonic; // Objeto Sonic
EndGame endGame; // Objeto EndGame
PImage spriteSheet;  // Declarar la imagen de sprites
Enemigo enemigo;     // Instancia de la clase Enemigo
PImage spriteSheet2;
Enemies2 enemigo2;
HUD hud; // HUD verificar que todo este bien


boolean gameOver = false; // Controla el estado del juego

// Colores originales en hexadecimales
color color1Original = #771177;
color color2Original = #993399;
color color3Original = #dd77dd;
color color4Original = #bb55bb;

// Colores nuevos en hexadecimales
color color1Nuevo = #b4d6f0;
color color2Nuevo = #0092ff;
color color3Nuevo = #ffffff;
color color4Nuevo = #0090fc;

void setup() {
  size(800, 500); // Tamaño de la ventana
  fondo = loadImage("fondo.png"); // Asegúrate de que la imagen esté en la carpeta del sketch
  parallax = new Parallax(fondo, 0.5, 1.8, -100, -310); // Ajusta la imagen, velocidad, zoom y posición inicial en X e Y
  //HUD
  hud = new HUD(3, 60); // 3 vidas iniciales y 60 segundos de tiempo


  // Carga el GIF animado usando la librería gifAnimation
  gif = new Gif(this, "MENU.gif"); // Asegúrate de que el archivo GIF esté en la carpeta del sketch
  gif.loop(); // Configura el GIF para que se reproduzca en bucle
  
  // Carga la música de fondo desde la carpeta 'sound'
  music = new SoundFile(this, "sound/Sonic_The_Hedgehog.mp3"); // Ruta del archivo de música dentro de la carpeta 'sound'
  music.loop(); // Reproduce la música en bucle

  // Cambia los colores en la imagen
  cambiarColores(fondo);
 
  sonic = new Player(width / 2, height / 2, "sonic.gif", 50, 50, this); // Sonic scaled to 50x50 pixels
  endGame = new EndGame(this); // Instancia de la clase EndGame
  // gestiona el sprite del enemigo
  spriteSheet = loadImage("buzzer.png"); // Cargar la hoja de sprites desde /data
  enemigo = new Enemigo(spriteSheet, 300, 300, 100, 10); // Crear un enemigo
   // enemigo 2
  spriteSheet = loadImage("buzzer.png");
  enemigo2 = new Enemies2(spriteSheet, 300, 300, 120, 15); // Variante del enemigo
}

void draw() {
  background(0);

  if (!gameOver) {
    // Actualiza y dibuja el fondo parallax
    parallax.update();
    parallax.display();

    // Dibuja el menú con el GIF animado
    dibujaMenu();
  } else {
    // Muestra la pantalla de fin de juego desde la clase EndGame
    endGame.display();
  }
  //anze:
  enemigo.mostrar(); // Mostrar al enemigo en pantalla
  enemigo.mover(-1, 0); // Hacer que el enemigo se mueva hacia la izquierda
  enemigo2.mostrar();
  enemigo2.mover(-3, 0);

  // Mostrar el HUD
  hud.mostrar();

  // Verificar si el tiempo se terminó
  if (hud.tiempoTerminado()) {
    gameOver = true;
  }
}

void dibujaMenu() {
  fill(255, 150);
  noStroke();
  rect(0, height - 100, width, 100); // Menú en la parte inferior
  
  fill(255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text("Menú Parallax", width / 2, height - 50);

  // Dibuja el GIF animado en el centro del menú
  if (gif != null) {
    image(gif, width / 2 - gif.width / 2, height - 400 + 10); // Centra el GIF en el menú
  }
  
  // Control Sonic con teclas
  float dx = 0, dy = 0;
  if (keyPressed) {
    if (keyCode == UP) dy = -2;
    if (keyCode == DOWN) dy = 2;
    if (keyCode == LEFT) dx = -2;
    if (keyCode == RIGHT) dx = 2;
  }

  // Mueve y dibuja a Sonic
  sonic.mover(dx, dy);
  sonic.mostrar();
}

void cambiarColores(PImage img) {
  img.loadPixels(); // Carga los píxeles de la imagen
  
  for (int i = 0; i < img.pixels.length; i++) {
    color c = img.pixels[i];
    
    // Compara y cambia los colores de la imagen
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
  
  img.updatePixels(); // Actualiza los píxeles de la imagen
}

// Función para determinar si un color es cercano al color original
boolean esColorCercano(color c, color original) {
  float r1 = red(c);
  float g1 = green(c);
  float b1 = blue(c);

  float r2 = red(original);
  float g2 = green(original);
  float b2 = blue(original);

  // Calcular la diferencia de colores
  float dif = dist(r1, g1, b1, r2, g2, b2);
  
  // Si la diferencia es pequeña, lo consideramos el mismo color
  return dif < 30; // Ajusta este valor para definir el rango de colores similares
}
