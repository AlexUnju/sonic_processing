import processing.sound.*;  // Importa la librería de sonido

// Variables globales
private Menu menu;
private MaquinaDeEstado maquinaDeEstado;
private SoundFile startMenuSound;  // Variable para el sonido
private Parallax parallax;

// Variables para el jugador
private PImage spriteSheet;
private int spriteWidth = 252 / 6;  // Ancho de un sprite (6 columnas)
private int spriteHeight = 184 / 4; // Alto de un sprite (4 filas)
private Player sonic;  // Instancia del jugador
private Camera camera; // Instancia de la cámara
private PImage endGameImage;
private Boss boss;

//HUD
private HUD hud;

// Instancia de la clase Escenario
private Escenario escenario;

// Debug
private Debug debug;

void setup() {
  size(800, 600);  // Tamaño de la ventana
  String[] fondoArchivos = {"fondo/fondo0.png", "fondo/fondo1.png", "fondo/fondo2.png"};
  
  // Cargar el spriteSheet de Sonic
  spriteSheet = loadImage("sonic/sonic-10.png");
  // Crear objeto Parallax
  parallax = new Parallax(fondoArchivos, 1, 1.5, 0, -150, 16);
  
  // Cargar la imagen de fin de juego
  endGameImage = loadImage("endgame.png");

  // Cargar la fuente y crear el menú
  PFont pixelFont = createFont("Font/NiseSegaSonic.ttf", 32);
  menu = new Menu(40, 150, 100, pixelFont);

  sonic = new Player(100, height - spriteHeight, spriteWidth, spriteHeight);
  
  boss = new Boss("Eggman.png", sonic.getX(), sonic.getY() - 300, 4, 0.25, sonic);

  // Crear la máquina de estados
  maquinaDeEstado = new MaquinaDeEstado(menu);

  // Cargar y reproducir el sonido de fondo
  startMenuSound = new SoundFile(this, "data/sound/startMenu.mp3");
  startMenuSound.loop();  // Reproduce el sonido en bucle

  // Crear la cámara
  camera = new Camera();
  
  debug = new Debug();
  
  // Configurar el sprite sheet y sus dimensiones en la clase Debug
  debug.setSpriteSheet(spriteSheet);
  debug.setSpriteDimensions(spriteWidth, spriteHeight);
  
  // Establecer las posiciones manuales de los rectángulos
  debug.setSpriteRectPosition(570, 25);  // Ajusta la posición del rectángulo rojo
  
  //HUD
  hud = new HUD(sonic);
  
  // Crear una instancia de la clase Escenario
  escenario = new Escenario("escenario/scene0.png");  // Cargar la imagen del fondo
  // Establecer una posición manual del escenario
  escenario.setPosicionX(100);  // Desplaza el fondo 100 píxeles a la derecha
  escenario.setPosicionY(55);   // Desplaza el fondo 50 píxeles hacia abajo
}

void draw() {
  background(0);  // Limpia el fondo

  // Dibujar el parallax siempre
  parallax.dibujar();


  // Hacer que la cámara siga a Sonic
  camera.follow(sonic);
  // Aplicar la transformación de la cámara
  pushMatrix();
  camera.apply();

  // Verificar si estamos en el estado ESCENARIO
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ESCENARIO) {
    escenario.dibujar();
    sonic.update();  // Actualiza el estado y la posición del jugador
    sonic.display();  // Muestra al jugador en la pantalla
    
    // Dibujar al jefe
    boss.update();
    boss.display();
    
    // Dibujar el suelo (solo visual, no interactúa con la lógica de colisiones)
    stroke(0);
    line(-width, height, width * 2, height);
  }

  popMatrix();  // Vuelve a la matriz original para no afectar el resto
  
  //HUD
   // Dibujar HUD
  hud.display();
  
  // Actualizar la máquina de estados (esta controla qué se dibuja)
  maquinaDeEstado.update();
  
  // Mostrar la información de depuración
  debug.display(sonic, camera);  // Este método ahora maneja la depuración visual para Sonic y la cámara
}

void keyPressed() {
  maquinaDeEstado.keyPressed(key);  // Maneja la tecla presionada
  if (key == 'a') sonic.move(-1);   // Mover a la izquierda
  if (key == 'd') sonic.move(1);    // Mover a la derecha
  if (key == ' ') sonic.jump();     // Salto
  if (key == 'q') debug.toggleDebug(sonic);  // Alternar la depuración
  if (key == ENTER) startMenuSound.stop(); // Detener la música si se presiona ENTER
  // Simulación de recoger una vida extra
  if (key == 'r') { // Presiona 'r' para ganar una vida
    sonic.ganarVida();
  }
  // Cambiar a estado END_GAME con 'L'
  if (key == 'l' || key == 'L') {
    maquinaDeEstado.setEstado(MaquinaDeEstado.ENDGAME);
  }
  // Salir del juego al presionar ESC en estado END_GAME
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ENDGAME && key == ESC) {
    exit();
  }
}

void keyReleased() {
  if (key == 'a' || key == 'd') sonic.stop();  // Detener movimiento al soltar la tecla
}
