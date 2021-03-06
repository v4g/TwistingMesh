
class pts // class for manipulaitng and displaying pointclouds or polyloops in 3D 
  { 
    int maxnv = 16000;                 //  max number of vertices
    pt[] G = new pt [maxnv];           // geometry table (vertices)
    pt[] MP = new pt [maxnv];           // Midpoints (vertices)
    pt[] O = new pt[maxnv];            //The centers of circles
    char[] L = new char [maxnv];             // labels of points
    vec [] LL = new vec[ maxnv];  // displacement vectors
    vec [] T = new vec[maxnv];   //tangent vectors
    float [] arcLength = new float[maxnv];  
    Boolean loop=true;          // used to indicate closed loop 3D control polygons
    int pv =0,     // picked vertex index,
        iv=0,      //  insertion vertex index
        dv = 0,   // dancer support foot index
        nv = 0,    // number of vertices currently used in P
        pp=1; // index of picked vertex

  pts() {}
  pts declare() 
    {
    for (int i=0; i<maxnv; i++) G[i]=P(); 
    for (int i=0; i<maxnv; i++) MP[i]=P(); 
    for (int i=0; i<maxnv; i++) O[i]=P(); 
    for (int i=0; i<maxnv; i++) LL[i]=V(); 
    for (int i=0; i<maxnv; i++) T[i]=V(); 
    return this;
    }     // init all point objects
  pts empty() {nv=0; pv=0; return this;}                                 // resets P so that we can start adding points
  pts addPt(pt P, char c) { G[nv].setTo(P); pv=nv; L[nv]=c; nv++;  return this;}          // appends a new point at the end
  pts addPt(pt P) { G[nv].setTo(P); pv=nv; L[nv]='f'; nv++;  return this;}          // appends a new point at the end
  pts addPt(float x,float y) { G[nv].x=x; G[nv].y=y; pv=nv; nv++; return this;} // same byt from coordinates
  pts copyFrom(pts Q) {empty(); nv=Q.nv; for (int v=0; v<nv; v++) G[v]=P(Q.G[v]); return this;} // set THIS as a clone of Q

  pts resetOnCircle(int k, float r)  // sets THIS to a polyloop with k points on a circle of radius r around origin
    {
    empty(); // resert P
    pt C = P(); // center of circle
    for (int i=0; i<k; i++) addPt(R(P(C,V(0,-r,0)),2.*PI*i/k,C)); // points on z=0 plane
    pv=0; // picked vertex ID is set to 0
    return this;
    } 
  // ********* PICK AND PROJECTIONS *******  
  int SETppToIDofVertexWithClosestScreenProjectionTo(pt M)  // sets pp to the index of the vertex that projects closest to the mouse 
    {
    pp=0; 
    for (int i=1; i<nv; i++) if (d(M,ToScreen(G[i]))<=d(M,ToScreen(G[pp]))) pp=i; 
     return pp;
    }
  pts showPicked() {show(G[pv],23); return this;}
  pt closestProjectionOf(pt M)    // Returns 3D point that is the closest to the projection but also CHANGES iv !!!!
    {
    pt C = P(G[0]); float d=d(M,C);       
    for (int i=1; i<nv; i++) if (d(M,G[i])<=d) {iv=i; C=P(G[i]); d=d(M,C); }  
    for (int i=nv-1, j=0; j<nv; i=j++) { 
       pt A = G[i], B = G[j];
       if(projectsBetween(M,A,B) && disToLine(M,A,B)<d) {d=disToLine(M,A,B); iv=i; C=projectionOnLine(M,A,B);}
       } 
    return C;    
    }

  // ********* MOVE, INSERT, DELETE *******  
  pts insertPt(pt P) { // inserts new vertex after vertex with ID iv
    for(int v=nv-1; v>iv; v--) {G[v+1].setTo(G[v]);  L[v+1]=L[v];}
     iv++; 
     G[iv].setTo(P);
     L[iv]='f';
     nv++; // increments vertex count
     return this;
     }
  pts insertClosestProjection(pt M) {  
    pt P = closestProjectionOf(M); // also sets iv
    insertPt(P);
    return this;
    }
  pts deletePicked() 
    {
    for(int i=pv; i<nv; i++) 
      {
      G[i].setTo(G[i+1]); 
      L[i]=L[i+1]; 
      }
    pv=max(0,pv-1); 
    nv--;  
    return this;
    }
  pts setPt(pt P, int i) { G[i].setTo(P); return this;}
  
  pts drawBalls(float r) {for (int v=0; v<nv; v++) show(G[v],r); return this;}
  pts showPicked(float r) {show(G[pv],r); return this;}
  pts drawClosedCurve(float r) 
  {
    fill(dgreen);
    for (int v=0; v<nv; v++) show(G[v],r*3);    
    fill(magenta);
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
   //<>//
    /*
    pushMatrix(); //translate(0,0,1); 
    scale(1,1,0.03);  
    fill(grey);
    for (int v=0; v<nv; v++) show(G[v],r*3);    
    for (int v=0; v<nv-1; v++) stub(G[v],V(G[v],G[v+1]),r,r);  
    stub(G[nv-1],V(G[nv-1],G[0]),r,r);
    popMatrix();
    */
    return this;
    }
  pts set_pv_to_pp() {pv=pp; return this;}
  pts movePicked(vec V) { G[pv].add(V); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts setPickedTo(pt Q) { G[pv].setTo(Q); return this;}      // moves selected point (index p) by amount mouse moved recently
  pts moveAll(vec V) {for (int i=0; i<nv; i++) G[i].add(V); return this;};   
  pt Picked() {return G[pv];} 
  pt Pt(int i) {if(0<=i && i<nv) return G[i]; else return G[0];} 

  // ********* I/O FILE *******  
 void savePts(String fn) 
    {
    String [] inppts = new String [nv+1];
    int s=0;
    inppts[s++]=str(nv);
    for (int i=0; i<nv; i++) {inppts[s++]=str(G[i].x)+","+str(G[i].y)+","+str(G[i].z)+","+L[i];}
    saveStrings(fn,inppts);
    };
  
  void loadPts(String fn) 
    {
    println("loading: "+fn); 
    String [] ss = loadStrings(fn);
    String subpts;
    int s=0;   int comma, comma1, comma2;   float x, y;   int a, b, c;
    nv = int(ss[s++]); print("nv="+nv);
    for(int k=0; k<nv; k++) 
      {
      int i=k+s; 
      //float [] xy = float(split(ss[i],",")); 
      String [] SS = split(ss[i],","); 
      G[k].setTo(float(SS[0]),float(SS[1]),200);
      print("points");
      print(float(SS[0]),float(SS[1]),float(SS[2]));
      L[k]=SS[3].charAt(0);
      }
    pv=0;
    };
 
  // Dancer
  void setPicekdLabel(char c) {L[pp]=c;}
  


  void setFifo() 
    {
    _LookAtPt.reset(G[dv],60);
    }              


  void next() {dv=n(dv);}
  int n(int v) {return (v+1)%nv;}
  int p(int v) {if(v==0) return nv-1; else return v-1;}
  
  pts subdivideDemoInto(pts Q) 
    {
    Q.empty();
    for(int i=0; i<nv; i++)
      {
      Q.addPt(P(G[i])); 
      Q.addPt(P(G[i],G[n(i)])); 
      //...
      }
    return this;
    }  
  
  void displaySkater() 
      {
      if(showCurve) {fill(yellow); for (int j=0; j<nv; j++) caplet(G[j],6,G[n(j)],6); }
      pt[] B = new pt [nv];           // geometry table (vertices)
      for (int j=0; j<nv; j++) B[j]=P(G[j],V(0,0,100));
      if(showPath) {fill(lime); for (int j=0; j<nv; j++) caplet(B[j],6,B[n(j)],6);} 
      if(showKeys) {fill(cyan); for (int j=0; j<nv; j+=4) arrow(B[j],G[j],3);}
      
      if(animating) f=n(f);
      if(showSkater) 
        {
        // ....
        }
      else {fill(red); arrow(B[f],G[f],20);} //
      }

  public void drawCurve()
  {
    float pretwist=0f, totalTwist = 0f,totalLength = 0f;
    float twist[] = new float[maxnv];
    for(int k=0; k<nv; k++) 
    {
      int l = (k+1)%nv;
      biarc(G[k],G[l],T[k],T[l],2*k);
    }
    float offset = 0f;
    for(int k=0; k<2*nv; k++) 
    {
      int l = (k+1)%(2*nv);
      int m = (l+1)%(2*nv);
      //calculate the y vector of next elbow
      //and find the angle between this one and the next one's
      arcLength[k] = findArcLength(MP[k],MP[l],O[k]);
      totalLength += arcLength[k];
      vec yk = cross(V(O[k],MP[k]),V(O[k],MP[l]));
      vec yl = cross(V(O[l],MP[l]),V(O[l],MP[m]));
      vec n = cross(V(O[k],MP[l]),yk);
      float dir = dot(n,cross(yk,yl));
      //don't compute twist for last one. Calculate pretwist
      twist[k] = angle(yk,yl);
      if(dir<0)
        twist[k] = TWO_PI-twist[k];
      totalTwist += twist[k];
      if(k == 2*nv - 1)
      {
        pretwist = twist[k];
        twist[k] = 0;
      }
      
    }
    pretwist = (totalTwist%TWO_PI);
    float pretwistPerSec = pretwist/totalLength;
    
    float rotationsPerSec = (nRotations * TWO_PI)/totalLength;
    float startAngle = 0;
    float endAngle = 0;
    for(int k=0; k<2*nv; k++) 
    {
      endAngle = startAngle + rotationsPerSec * arcLength[k];
      int l = (k+1)%(2*nv);
      float pretwistInSec = pretwistPerSec * arcLength[k];
      if(showTwist==0)
        drawElbow(MP[k],MP[l],O[k],0,0);
      else if(showTwist ==1)
      {
        drawElbow(MP[k],MP[l],O[k],offset,0,startAngle,endAngle);
        offset += -twist[k];
      }
      else
      {
        drawElbow(MP[k],MP[l],O[k],offset,pretwistInSec,startAngle,endAngle);
        offset += (pretwistInSec-twist[k]);
      }
      startAngle = endAngle;
    }
  }
  
  void calculateTangents(boolean weight)
  {
     for(int k=0; k<nv; k++) 
     {
         int l = (k+1)%nv;
         int m = (k+2)%nv;
         
         vec a = V(G[m],G[k]);
         vec b = V(G[m],G[l]);
         
         vec aCb = cross(a,b);
         vec n1 = V(sq(a.norm()),b);
         vec n2 = V(sq(b.norm()),a);
         vec n3 = cross(M(n1,n2),aCb);
         float den = 2 * sq(aCb.norm());
         vec n4 = V(1/den,n3);
         pt C = P(G[m], n4);
         
         float radius = weight? n4.norm(): 1;
         
         aCb.normalize();
         vec a1 = V(G[k],C);
         vec tangent1 = cross(a1,aCb);
         vec tangent2 = cross(V(G[l],C),aCb);
         vec tangent3 = cross(V(G[m],C),aCb);
         
         tangent1.normalize();
         tangent2.normalize();
         tangent3.normalize();
         
         T[k] = A(T[k],V(radius,tangent1));
         T[l] = A(T[l],V(radius,tangent2));
         T[m] = A(T[m],V(radius,tangent3));
         
         /*fill(blue);
         show(C,3);
         arrow(G[k],100,tangent1,3);
         arrow(G[l],100,tangent2,3);
         arrow(G[m],100,tangent3,3);
       */  
     }
  }
  
  public void calculateAverageTangents()
  {
    for(int k=0; k<nv; k++) 
     {
         int l = (k+1)%nv;
         int m = (k+2)%nv;
         
         vec a = V(G[k],G[l]);
         vec b = V(G[l],G[m]);
         
         T[l] = V(a,b);
     }
  }
  
  public void tangentRoutine()
  {
    if(tangentRoutine == 0)
    {
      calculateTangents(false);
    }
    else if(tangentRoutine == 1)
    {
      calculateAverageTangents();
    }
    else if(tangentRoutine == 2)
    {
      calculateTangents(true);
    }
  }

  void biarc(pt A, pt D, vec T1, vec T2,int k)
  {
    T1.normalize();
    T2.normalize();
    vec S = V(A,D);
    vec T = A(T1,T2);
    float epsilon = 0.2f,d = 0f,a = 0f;
    boolean done = false;
    if (T.norm() > 4 - epsilon)
    {
      if ( dot(S,T1) > epsilon || dot(S,T1) < -epsilon )
        a = sq(S.norm())/(4 * dot(S,T1));
      else
      {
        //use semicircles
        drawSemiCircle(T1,A,P(A,D));
        drawSemiCircle(V(-1,T2),D,P(A,D));
        done = true;  
      }
    }
    else
    {
      d = (sq(dot(S,T))) + sq(S.norm()) *(4 - sq(T.norm()));
      a = (sqrt(d) - dot(S,T))/(4- sq(T.norm()));
    }
    if(!done)
    {
      pt B = P(A,V(a,T1));
      pt C = P(D,V(-a,T2));
      pt E = P(B,C);
      //do beziers for now. Change to something else
      //find tangent at intermediate point
      vec T3 = V(B,E);
      T3.normalize();
      pt O1 = findCenterofTangentPoints(A,T1,E,T3);
      pt O2 = findCenterofTangentPoints(E,T3,D,T2);
      
      MP[k] = A;
      MP[k+1] = E;
      O[k] = O1;
      O[k+1] = O2;
      
      if(showVecs)
      {
        fill(magenta);
        arrow(E,50,T3,3);
        fill(pink);
        arrow(A,50,T1,3);
        arrow(D,50,T2,3);
      }
      /*if(T.norm() != 0)
      {
        if(showElbow)
        {
          drawElbow(A,E,O1);
          drawElbow(E,D,O2);
        }
      }
      else
      {
        fill(white);
        int n = 20;
        
        for (int i = 0; i < n; i++)
        {
          pt pOnCurve2 = Bezier(A,B,E,(float)((i+1))/n);
          pt pOnCurve1 = Bezier(A,B,E,(float)i/n);
          caplet(pOnCurve1,6,pOnCurve2,6);
        }
        for (int i = 0; i < n; i++)
        {
          pt pOnCurve2 = Bezier(E,C,D,(float)((i+1))/n);
          pt pOnCurve1 = Bezier(E,C,D,(float)i/n);
          caplet(pOnCurve1,6,pOnCurve2,6);
        }
      } */ 
    }
  }
} // end of pts class
