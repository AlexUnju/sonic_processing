import gifAnimation.Gif; // Importa la librería gifAnimation
import processing.sound.*; // Importa la librería Sound

PImage fondo;
Parallax parallax;
Gif gif; // Variable para almacenar el GIF
SoundFile music; // Variable para almacenar el archivo de música

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
  fondo = loadImage("BACKGROUND.png"); // Asegúrate de que la imagen esté en la carpeta del sketch
  parallax = new Parallax(fondo, 0.5, 1.8, -100, -310); // Ajusta la imagen, velocidad, zoom y posición inicial en X e Y

  // Carga el GIF animado usando la librería gifAnimation
  gif = new Gif(this, "MENU.gif"); // Asegúrate de que el archivo GIF esté en la carpeta del sketch
  gif.loop(); // Configura el GIF para que se reproduzca en bucle
  
  // Carga la música de fondo desde la carpeta 'sound'
  music = new SoundFile(this, "sound/Sonic_The_Hedgehog.mp3"); // Ruta del archivo de música dentro de la carpeta 'sound'
  music.loop(); // Reproduce la música en bucle

  // Cambia los colores en la imagen
  cambiarColores(fondo);
}

void draw() {
  background(0);

  // Actualiza y dibuja el fondo parallax
  parallax.update();
  parallax.display();

  // Dibuja el menú con el GIF animado en el centro
  dibujaMenu();
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
