void keyPressed() 
  {
//  if(key=='`') picking=true; 
  if(key=='?') scribeText=!scribeText;
  if(key=='!') snapPicture();
  if(key=='~') filming=!filming;
  if(key==']') showBalls=!showBalls;
  if(key=='f') {P.setPicekdLabel(key);}
  if(key=='s') {P.setPicekdLabel(key);}
  //if(key=='b') {P.setPicekdLabel(key);}
  if(key=='c') {P.setPicekdLabel(key);}
  if(key=='F') {P.addPt(Of,'f');}
  if(key=='S') {P.addPt(Of,'s');}
  if(key=='B') {P.addPt(Of,'b');}
  if(key=='C') {P.addPt(Of,'c');}
  if(key=='m') {method=(method+1)%12;}
  //if(key=='[') {showControl=!showControl;}
  //if(key==']') {showQuads=!showQuads;}
  if(key=='{') {showCurve=!showCurve;}
  if(key=='\\') {showKeys=!showKeys;}
  if(key=='}') {showPath=!showPath;}
  if(key=='|') {showCorrectedKeys=!showCorrectedKeys;}
  if(key=='=') {showTube=!showTube;}
  if(key=='g') {showElbow=!showElbow;}
  if(key=='k') {showFreePath=!showFreePath;}
  if(key=='h') {showTangents=!showTangents;}
  if(key==']') {nRotations++;}
  if(key=='[') {nRotations--;}
  if(key=='b') {showBraid=!showBraid;}
  if(key=='d') {nBraids++;}
  if(key=='v') {showTwist = (showTwist+1)%3;}
  if(key=='c') {nBraids = max(nBraids-1,1);}
  if(key=='n') {changeSection();}
  if(key=='r')
  {
    tangentRoutine = (tangentRoutine + 1)%3;
    println("Tangent Routine " + tangentRoutine);
  }  
if(key=='3') {P.resetOnCircle(3,300); Q.copyFrom(P);}
  if(key=='4') {P.resetOnCircle(4,400); Q.copyFrom(P);}
  if(key=='5') {P.resetOnCircle(5,500); Q.copyFrom(P);}
  if(key=='^') track=!track;
  if(key=='q') Q.copyFrom(P);
  if(key=='p') P.copyFrom(Q);
  if(key==',') {level=max(level-1,0); f=0;}
  if(key=='.') {level++;f=0;}
 
  if(key=='e') {R.copyFrom(P); P.copyFrom(Q); Q.copyFrom(R);}
  if(key=='d') {P.set_pv_to_pp(); P.deletePicked();}
  if(key=='i') P.insertClosestProjection(Of); // Inserts new vertex in P that is the closeset projection of O
  if(key=='W') {P.savePts("data/pts"); Q.savePts("data/pts2");}  // save vertices to pts2
  if(key=='L') {P.loadPts("data/pts"); Q.loadPts("data/pts2");}   // loads saved model
  if(key=='w') P.savePts("data/pts");   // save vertices to pts
  if(key=='l') P.loadPts("data/pts"); 
  if(key=='a') {animating=!animating; P.setFifo();}// toggle animation
  if(key=='^') showVecs=!showVecs;
  if(key=='#') exit();
  if(key=='=') {}
  change=true;   // to save a frame for the movie when user pressed a key 
  }

void mouseWheel(MouseEvent event) 
  {
  dz -= (10*event.getAmount()); 
  change=true;
  }

void mousePressed() 
  {
  //if (!keyPressed) picking=true;
  if (!keyPressed) {T.set_pv_to_pp(); println("picked vertex "+T.pp);}
  if(keyPressed && key=='a') {T.addPt(Of);}
//  if(keyPressed && (key=='f' || key=='s' || key=='b' || key=='c')) {P.addPt(Of,key);}

 // if (!keyPressed) P.setPicked();
  change=true;
  }
  
void mouseMoved() 
  {
  //if (!keyPressed) 
  if (keyPressed && key==' ') {rx-=PI*(mouseY-pmouseY)/height; ry+=PI*(mouseX-pmouseX)/width;};
  if (keyPressed && key=='`') dz+=(float)(mouseY-pmouseY); // approach view (same as wheel)
  if (keyPressed && key=='s') {tw+=(float)(mouseY-pmouseY);};
  if (keyPressed && key=='p' && !showFreePath) {nRotations+=(int)(mouseY-pmouseY)/5;};
  change=true;
  }
  
void mouseDragged() 
  {
  if (!keyPressed) T.setPickedTo(Of); 
//  if (!keyPressed) {Of.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); }
  if (keyPressed && key==CODED && keyCode==SHIFT) {Of.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0)));};
  if (keyPressed && key=='x') T.movePicked(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='z') T.movePicked(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='X') T.moveAll(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='Z') T.moveAll(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
  if (keyPressed && key=='t')  // move focus point on plane
    {
    if(center) F.sub(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToIJ(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  if (keyPressed && key=='T')  // move focus point vertically
    {
    if(center) F.sub(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    else F.add(ToK(V((float)(mouseX-pmouseX),(float)(mouseY-pmouseY),0))); 
    }
  change=true;
  }  

// **** Header, footer, help text on canvas
void displayHeader()  // Displays title and authors face on screen 
    {
      int isc = 4;
      int topMargin = 40;
    scribeHeader(title,0); scribeHeaderRight(name); scribeHeaderRight2(name2);
    fill(white); 
    image(student1, width-student1.width/isc,topMargin,student1.width/isc,student1.height/isc);
    image(student2, width-student2.width/isc,topMargin+student1.height/isc,student2.width/isc,student2.height/isc);
    }
void displayFooter()  // Displays help text at the bottom
    {
    scribeFooter(guide,3); 
    scribeFooter(menu,2);
    scribeFooter(tc,1);
    scribeFooter(tc2,0);
    }
void changeSection()
{
  showSection = !showSection;
  if(showSection)
  {
    T.empty();
    T.addPt(bA);T.addPt(bB);
  }
  else
  {
    T.empty();
    T.addPt(bA);T.addPt(bB);T.addPt(bC);T.addPt(bD);T.addPt(bE);
  
  }
}

String title ="CS 6491 Project 2", name = "Vinayak Gargya", name2 = "Amita Karunakaran",
       menu="?:help, !:picture, ~:(start/stop)capture, space:rotate, `/wheel:closer, t/T:target, a:anim, #:quit",
       guide="click&drag:pick&slide on floor, xz/XZ:move/ALL, e:exchange, q/p:copy, l/L:load, w/W:write, m:subdivide method",
       tc="n:elbow/torus mode, d:incr braid strands, c:decr braid strands, v:cycle twist modes, h:tangent markers, g:show elbows, b:show braids",
       tc2="k:braiding/twisting mode, m:braiding functions, r: tangent modes, s&move mouse:twist elbows, p&move mouse: twist strands"; // user's guide
