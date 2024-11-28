import processing.sound.*;  // Importa la librería de sonido

// Variables globales
private Menu menu;
private MaquinaDeEstado maquinaDeEstado;
private SoundFile startMenuSound;  // Variable para el sonido
private SoundFile gameMusic;
private Parallax parallax;
SpawnEnemigos spawn;
// Variables para el jugador
private PImage spriteSheet;
private int spriteWidth = 252 / 6;  // Ancho de un sprite (6 columnas)
private int spriteHeight = 184 / 4; // Alto de un sprite (4 filas)
private Player sonic;  // Instancia del jugador
private Camera camera; // Instancia de la cámara
private PImage endGameImage;
private Win win;
private Boss boss;

//HUD
private HUD hud;

// Instancia de la clase Escenario
private Escenario escenario;

private SoundFile jumpSound;  // Variable para el sonido del salto


// Debug
private Debug debug;

private SoundFile gameoverSound;  // Variable para el sonido del Game Over
private boolean gameoverSoundPlayed = false;  // Flag para saber si se ha reproducido el Game Over

void setup() {
  size(800, 600);  // Tamaño de la ventana
  String[] fondoArchivos = {"fondo/fondo0.png", "fondo/fondo1.png", "fondo/fondo2.png"};
  jumpSound = new SoundFile(this, "data/sound/jump.wav");

  // Cargar el spriteSheet de Sonic
  spriteSheet = loadImage("sonic/sonic-10.png");
  
  // Crear objeto Parallax
  parallax = new Parallax(fondoArchivos, 1, 1.5, 0, -150, 16);
  
  // Crear una instancia de la clase Win
  win = new Win();

  // Cargar la imagen de fin de juego
  endGameImage = loadImage("endgame.png");

  // Cargar la fuente y crear el menú
  PFont pixelFont = createFont("Font/NiseSegaSonic.ttf", 32);
  menu = new Menu(40, 150, 100, pixelFont);

  // Crear la máquina de estados
  maquinaDeEstado = new MaquinaDeEstado(menu, sonic);

  sonic = new Player(100, height - 100, spriteWidth, spriteHeight);
  
  // Ahora que `maquinaDeEstado` está inicializado, creamos el Boss
  boss = new Boss("Eggman.png", sonic.getX(), sonic.getY() - 300, 5, 0.25, sonic, 10, maquinaDeEstado);

  // Cargar y reproducir el sonido de fondo
  startMenuSound = new SoundFile(this, "data/sound/startMenu.mp3");
  startMenuSound.loop();  // Reproducir el sonido en bucle
  
  gameMusic = new SoundFile(this, "data/sound/Sonic_The_Hedgehog.mp3");

  // Cargar sonido de Game Over
  gameoverSound = new SoundFile(this, "data/sound/gameover.mp3");

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
  
  spawn = new SpawnEnemigos(); // Crear el objeto de spawn
  // Agregar rectángulos verdes al escenario
  escenario.agregarRectangulo(100, 590, 2000, 70);
  escenario.agregarRectangulo(300, 350, 100, 50);
  escenario.agregarRectangulo(650, 490, 190, 10);
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
     if (!gameMusic.isPlaying()) {
      startMenuSound.stop();  // Detener música del menú
      gameMusic.loop();       // Reproducir música del juego en bucle
    }

    escenario.dibujar();
    sonic.update(escenario.getRectangulos());  // Pass rectangles to update method
    sonic.display();  // Muestra al jugador en la pantalla
    
    // Dibujar al jefe
    boss.update();
    boss.display();
   
  }
  
  // Verificar si estamos en el estado WIN (pantalla de victoria)
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.WIN) {
    win.display();  // Mostrar la pantalla de victoria
  }
  
  // Verificar si estamos en el estado ENDGAME
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ENDGAME) {
    if (!gameoverSoundPlayed) {
      gameMusic.stop();  // Detener la música de fondo del juego
      gameoverSound.play();  // Reproducir sonido de Game Over
      gameoverSoundPlayed = true;  // Marcar como reproducido
    }

    // Aquí puedes mostrar la pantalla de fin de juego
    image(endGameImage, 0, 0);
  }

  popMatrix();  // Vuelve a la matriz original para no afectar el resto
  
  //HUD
   // Dibujar HUD
  hud.display();
  
  // Actualizar la máquina de estados (esta controla qué se dibuja)
  maquinaDeEstado.update();
  
  // Mostrar la información de depuración
  debug.display(sonic, camera);  // Pasa la instancia de Boss
  spawn.generarEnemigos(); // Generar enemigos de forma aleatoria
}

void keyPressed() {
  maquinaDeEstado.keyPressed(key);  // Maneja la tecla presionada
  if (key == 'a') sonic.move(-1);   // Mover a la izquierda
  if (key == 'd') sonic.move(1);    // Mover a la derecha
  if (key == ' ') sonic.jump();     // Salto
  if (key == 'q') debug.toggleDebug(sonic);  // Alternar la depuración
  // Simulación de recoger una vida extra
  if (key == 'r') { // Presiona 'r' para ganar una vida
    sonic.ganarVida();
  }
  // Cambiar al estado WIN al presionar la tecla 'p'
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ESCENARIO && key == 'p') {
    maquinaDeEstado.setEstado(MaquinaDeEstado.WIN);
  }
// Cambiar al estado ENDGAME al presionar 'l' o 'L' en estado ESCENARIO
  if (maquinaDeEstado.getEstado() == MaquinaDeEstado.ESCENARIO && (key == 'l' || key == 'L')) {
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
