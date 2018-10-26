//  ******************* Basecode for P2 ***********************
Boolean 
  animating=true, 
  PickedFocus=false, 
  center=true, 
  track=false, 
  showViewer=false, 
  showBalls=false, 
  showControl=true, 
  showCurve=true, 
  showPath=true, 
  showKeys=true, 
  showSkater=false, 
  scene1=false,
  solidBalls=false,
  showCorrectedKeys=true,
  showQuads=true,
  showVecs=false,
  showTube=false,
  showTangents=false,
  showElbow=true,
  showBraid=false,
  showFreePath=true,
  showSection=true;
float 
  t=0, 
  s=0;
int
  f=0, maxf=2*30, level=4, method=0, tangentRoutine = 0;
String SDA = "angle";
float defectAngle=0;
pts P = new pts(); // polyloop in 3D
pts Q = new pts(); // second polyloop in 3D
pts R = new pts(); // inbetweening polyloop L(P,t,Q);
pts T = new pts();
//delete later
pt bA = P(-150,100,100);
pt bB = P(150,100,100);
pt bC = P(200,200,70);
pt bE = P(-200,200,120);
pt bD = P(-0,150,90);
pt O = P(0,0,100);
vec T1 = V(0,1,0);
vec T2 = V(1,0,0);
float tw = 0f, offset = 0f;
int nBraids = 2;
int showTwist = 1;  
float nRotations = 1;
void setup() {
  student1 = loadImage("data/student1.jpg");
  student2 = loadImage("data/student2.jpg");
  textureMode(NORMAL);          
  //size(900, 900, P3D); // P3D means that we will do 3D graphics
  size(900, 900, P3D); // P3D means that we will do 3D graphics
  P.declare(); Q.declare(); R.declare(); // P is a polyloop in 3D: declared in pts
  //P.resetOnCircle(6,100); Q.copyFrom(P); // use this to get started if no model exists on file: move points, save to file, comment this line
  P.loadPts("data/pts");  //Q.loadPts("data/pts2"); // loads saved models from file (comment out if they do not exist yet)
  T.declare();T.addPt(bA);T.addPt(bB);
  noSmooth();
  frameRate(30);
  }

void draw() {
  background(255);
  hint(ENABLE_DEPTH_TEST); 
  pushMatrix();   // to ensure that we can restore the standard view before writing on the canvas
  setView();  // see pick tab
  showFloor(); // draws dance floor as yellow mat
  doPick(); // sets Of and axes for 3D GUI (see pick Tab)
  if(showSection)
  {
    drawElbow(T.G[0],T.G[1],O,offset,tw,0,nRotations*PI);
  }
  else
  {
    T.tangentRoutine();
    T.drawCurve();
    
  }
  //findCenterofTangentPoints(bA, T1, bB, T2);
  T.SETppToIDofVertexWithClosestScreenProjectionTo(Mouse()); // for picking (does not set P.pv)
  R.copyFrom(P); 
  for(int i=0; i<level; i++) 
    {
    //Q.copyFrom(R); 
    //if(method==5) {Q.subdivideDemoInto(R);}
    //if(method==4) {Q.subdivideQuinticInto(R);}
    //if(method==3) {Q.subdivideCubicInto(R); }
    //if(method==2) {Q.subdivideJarekInto(R); }
    //if(method==1) {Q.subdivideFourPointInto(R);}
    //if(method==0) {Q.subdivideQuadraticInto(R); }
    }
  //R.displaySkater();
  
  //fill(blue); if(showCurve) Q.drawClosedCurve(3);
  //if(showControl) {fill(grey); P.drawClosedCurve(3);}  // draw control polygon 
  fill(yellow,100); P.showPicked(); 
  
  fill(black);
  //biarc(bA,bB,T1,T2);
  
  //if(animating)  
  //  {
  //  f++; // advance frame counter
  //  if (f>maxf) // if end of step
  //    {
  //    P.next();     // advance dv in P to next vertex
 ////     animating=true;  
  //    f=0;
  //    }
  //  }
  //t=(1.-cos(PI*f/maxf))/2; //t=(float)f/maxf;

  //if(track) F=_LookAtPt.move(X(t)); // lookAt point tracks point X(t) filtering for smooth camera motion (press'.' to activate)
 
  popMatrix(); // done with 3D drawing. Restore front view for writing text on canvas
  hint(DISABLE_DEPTH_TEST); // no z-buffer test to ensure that help text is visible
    if(method==11) scribeHeader("Floor Sin",2);
    if(method==10) scribeHeader("Sin of Offset angle",2);
    if(method==9) scribeHeader("Inverted Sin",2);
    if(method==8) scribeHeader("Halved Sin",2);
    if(method==7) scribeHeader("Sin^2",2);    
    if(method==6) scribeHeader("Quintic UBS",2);    
    if(method==5) scribeHeader("Ceiling Sin",2);
    if(method==4) scribeHeader("Quintic UBS",2);
    if(method==3) scribeHeader("Sin on cosine",2);
    if(method==2) scribeHeader("Sin",2);
    if(method==1) scribeHeader("Cosine",2);
    if(method==0) scribeHeader("Helix",2);

  // used for demos to show red circle when mouse/key is pressed and what key (disk may be hidden by the 3D model)
  if(mousePressed) {stroke(cyan); strokeWeight(3); noFill(); ellipse(mouseX,mouseY,20,20); strokeWeight(1);}
  if(keyPressed) {stroke(red); fill(white); ellipse(mouseX+14,mouseY+20,26,26); fill(red); text(key,mouseX-5+14,mouseY+4+20); strokeWeight(1); }
  if(scribeText) {fill(black); displayHeader();} // dispalys header on canvas, including my face
  if(scribeText && !filming) displayFooter(); // shows menu at bottom, only if not filming
  if(filming && (animating || change)) saveFrame("FRAMES/F"+nf(frameCounter++,4)+".tif");  // save next frame to make a movie
  change=false; // to avoid capturing frames when nothing happens (change is set uppn action)
  change=true;
  }
