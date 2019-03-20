button start;
button scores;
button exit;
button voltar;
int col=0;
int modo=0;
int reset=0;

//Pacman
int direction = 1; // pacman virado para a direita
int direction2 = 0;
boolean obstaculo=false;

// Parâmetros do labirinto
int nCol, nLin;          // nº de linas e de colunas
int tamanho = 50;        // tamanho (largura e altura) das células do labirinto  
int espacamento = 2;     // espaço livre emtre células
float margemV, margemH;  // margem livre na vertical e na horizontal para assegurar que as células são quadrangulares
color corObstaculos =  color(100, 0 , 128);      // cor de fundo dos obstáculos

// Posicao e tamanho do Pacman
float px, py, pRaio, pxf, pyf;

boolean[][] obs = new boolean[720/50][520/50];
boolean[][] point = new boolean[720/50][520/50];


//velocidade na horizontal e vertical do Pacman
float vx, vy; 
//FIm Pacman

void setup(){
//Pacman
  // Definir o tamanho da janela; notar que size() não aceita variáveis.
  size(720, 520);
  background(0);
  nCol = (int)width/tamanho;
  nLin = (int)height/tamanho;

  // Assegurar que nº de linhas e nº de colunas é maior ou igual a 3
  assert nCol >= 5 && nLin >= 5;

  // Determinar margens para limitar a área útil do jogo 
  margemV = (width - nCol * tamanho) / 2.0;
  margemH = (height - nLin * tamanho) / 2.0;
  
  // Inicializar o Pacman
  px = centroX(1);
  py = centroY(1);
  pRaio = (tamanho - espacamento) / 2;
  
  // Inicializar o fantasma
  pxf = 10*tamanho;
  pyf = 3*tamanho;
  
  //specifies speeds in X and Y directions
  vx = 10;
  vy = 10;
//Fim Pacman

start=new button((width/2)-100,200,200,50);
scores=new button((width/2)-100,300,200,50);
exit=new button((width/2)-100,400,200,50);
voltar=new button((width/2)-80,440,150,50);

}

void draw(){
  switch(modo){
  case 0:
    background(corObstaculos);
    fill(0);
    rect(20,20,width-40,height-40,10);
    textSize(100);
    fill(232, 239, 40);
    text("PACMAN",width/2-200,140);
    fill(corObstaculos);
    start.draw();
    scores.draw();
    exit.draw();
    textSize(20);
    fill(255);
    text("START",width/2-30,231);
    text("SCORE",width/2-30,331);
    text("EXIT",width/2-18,431);
    
    break;
  case 1:
    //Pacman
      background(0);
  
    desenharLabirinto();
    desenharPontos();
    desenharPacman();
    desenharFantasma();
    //modo=0;
    fill(232, 239, 40);
    moveF();
    move();
    direcao();
  
    textAlign(LEFT, TOP);
    textSize(20);
    text("Score: "+score, 2, 2);
      //Fim Pacman
      break;
  
  case 2:
      background(corObstaculos);
      fill(0);
      rect(20,20,width-40,height-40,10);
      textSize(30);
      fill(232, 239, 40);
      text("Score: "+score,width/2-45,80);
      fill(corObstaculos);
      voltar.draw();
      textSize(20);
      fill(255);
      text("RETURN",width/2-45,475);
      break;
   }
}


//Pacman
void desenharPacman() {
  fill(232, 239, 40);
  //ellipseMode(CENTER);
  noStroke();
  //arc(px, py, pRaio, pRaio, PI/4.0, PI*7/4.0, PIE);
  //arc(px, py, pRaio, pRaio, map((millis() % 700), 0, 500, 0, 0.52), map((millis() % 700), 0, 500, TWO_PI, 5.76) );
  fill(0);
  triangle(px, py, px+pRaio/1.828427125, py-pRaio/1.828427125, px+pRaio/1.828427125, py+pRaio/1.828427125);
  
}

void desenharFantasma(){
fill(255, 25, 25);
rect(pxf+margemH+10,pyf+margemV+10,30,30,10);
}

void desenharLabirinto () {

  // desenha a fronteira da área de jogo
  fill(0);
  stroke(80, 60, 200);
  strokeWeight(espacamento);
  rect(margemH, margemV, width - 2*margemH, height - 2*margemV);

  // Desenha obstáculos
  desenharObstaculo(2,2, nCol-9, 1); 
  desenharObstaculo(9,2, nCol-9, 1);  
  desenharObstaculo(2,5, nCol-10, nLin-9);
  desenharObstaculo(3,4, nCol-13, nLin-5);
  desenharObstaculo(4,8, nCol-13, nLin-8);
  desenharObstaculo(5,9, nCol-9, nLin-9);
  desenharObstaculo(8,4, nCol-13, nLin-5);
  desenharObstaculo(9,10, nCol-13, nLin-9);
  desenharObstaculo(12,3, nCol-13, nLin-7);
  desenharObstaculo(12,7, nCol-13, nLin-8);
  desenharObstaculo(11,9, nCol-11, nLin-9);
  desenharObstaculo(2,10, nCol-13, nLin-9);
  desenharObstaculo(12,10, nCol-13, nLin-9);
  desenharObstaculo(10,1, nCol-13, nLin-9);
  desenharObstaculo(10,5, nCol-13, nLin-8);
}

/* Desenha um obstáculo interno de um labirinto:
   x: índice da célula inicial segundo eixo dos X - gama (1..nCol) 
   y: índice da célula inicial segundo eixo dos Y - gama (1..nLin)
   numC: nº de colunas (células) segundo eixo dos X (largura do obstáculo)
   numL: nº de linhas (células) segundo eixo dos Y (altura do obstáculo) 
*/
void desenharObstaculo(int x, int y, int numC, int numL) {
  float x0, y0, larg, comp;
  x0 = margemH + (x-1) * tamanho;
  y0 = margemV + (y-1) * tamanho;
  larg = numC * tamanho;
  comp = numL * tamanho;
  for(int pX=0; pX<numC; pX++){
    for(int pY=0; pY<numL; pY++){
    obs[x-1+pX][y-1+pY]=true;
    }
  }
  
  fill(corObstaculos);
  noStroke();
  strokeWeight(espacamento/2);
  rect(x0, y0, larg, comp);
  obstaculo=true;
}

/*
Desenhar pontos nas células vazias (que não fazem parte de um obstáculo). 
Esta função usa a cor de fundo no ecrã para determinar se uma célula está vazia ou se faz parte de um obstáculo.
*/
void desenharPontos() {
  float cx, cy;
  
  ellipseMode(CENTER);
  fill(255);
  noStroke();
  score=0;
  // Insere um ponto nas células vazias
  for(int i=1; i<=nCol; i++)
    for(int j=1; j<=nLin; j++) {
      cx = centroX(i);
      cy = centroY(j);
      color c = get((int)cx, (int)cy);
      if(c != corObstaculos) {
        fill(255);
        if(! (point[i-1][j-1])){
          ellipse(cx, cy, pRaio/2, pRaio/2);
        }
        if((point[i-1][j-1])){
          score++;
        }
        
      }  
    }
}

int movingDirX=0;
int movingDirY=0;
int moved=0;
int score=0;

void move(){
  if(moved==tamanho){
    moved=0;
    movingDirX=0;
    movingDirY=0;
    //desencrementar pontos
    point[(int(px)/tamanho)][(int(py)/tamanho)]=true;
    //println("pacman = ",px," ",py);
    //println("fantasma = ",pxf," ",pyf);
    if(keyCode==RIGHT){
      if( (px<720-(margemH+pRaio+5)) && !(obs[(int(px)/tamanho)+1][int(py)/tamanho]) ){
      movingDirX=1;
      movingDirY=0;
      direction = 1;
      direction2 = 0;
      moved=0;
      }
    }
    if(keyCode==LEFT){
      if( (px>margemH+pRaio+5) && !(obs[(int(px)/tamanho)-1][int(py)/tamanho]) ){
      movingDirX=-1;
      movingDirY=0;
      direction = -1;
      direction2 = 0;
      moved=0;
      }
    }
    if(keyCode==DOWN){
      if( (py<520-(margemV+pRaio+5)) && !(obs[int(px)/tamanho][(int(py)/tamanho)+1]) ){
      movingDirX=0;
      movingDirY=1;
      direction = 0;
      direction2 = 1;
      moved=0;
      }
    }
    if(keyCode==UP){
      if( (py>margemV+pRaio+5) && !(obs[int(px)/tamanho][(int(py)/tamanho)-1]) ){
      movingDirX=0;
      movingDirY=-1;
      direction = 0;
      direction2 = -1;
      moved=0;
      }
    }  
  }
  
  
  if(moved>=0){

    px=px+movingDirX*2;
    py=py+movingDirY*2;
    moved=moved+2;
  }
}

int movingDX=0;
int movingDY=0;
int movede=0;

void moveF(){
  if(movede==tamanho){
    movede=0;
    movingDX=0;
    movingDY=0;
    //println("pacman = ",px," ",py);
    //println("fantasma = ",pxf," ",pyf);
    float m = random(0,4);
    if(px==pxf+35 && py==pyf+35){
      modo=0;
      //reset pacman
    }
    if(m>=0 && m<1){
      if( (pxf<720-(margemH+60+5)) && !(obs[(int(pxf)/tamanho)+1][int(pyf)/tamanho]) ){
      movingDX=1;
      movingDY=0;
      movede=0;
      }
    }
    if(m>=1 && m<2){
      if( (pxf>margemH+60+5) && !(obs[(int(pxf)/tamanho)-1][int(pyf)/tamanho]) ){
      movingDX=-1;
      movingDY=0;
      movede=0;
      }
    }
    if(m>=2 && m<3){
      if( (pyf<520-(margemV+60+5)) && !(obs[int(pxf)/tamanho][(int(pyf)/tamanho)+1]) ){
      movingDX=0;
      movingDY=1;
      movede=0;
      }
    }
    if(m>=3 && m<=4){
      if( (pyf>margemV+60+5) && !(obs[int(pxf)/tamanho][(int(pyf)/tamanho)-1]) ){
      movingDX=0;
      movingDY=-1;
      movede=0;
      }
    }  
  }
  
  
  if(movede>=0){

    pxf=pxf+movingDX*2;
    pyf=pyf+movingDY*2;
    movede=movede+2;
  }
}

void direcao() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(px + (i * width), py + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, pRaio, pRaio, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}

// transformar o índice de uma célula em coordenada no ecrã
float centroX(int col) {
  return margemH + (col - 0.5) * tamanho;
}

// transformar o índice de uma célula em coordenada no ecrã
float centroY(int lin) {
  return margemV + (lin - 0.5) * tamanho;
}
//Fim Pacman



void mousePressed(){
  int x = mouseX;
  int y = mouseY;
  if(start.click(x,y)){
    modo=1;
  }
  if(scores.click(x,y)){
    modo=2;
  }
  if(exit.click(x,y)){
    exit();
  }
  if(voltar.click(x,y)){
    modo=0;
  }
  
}