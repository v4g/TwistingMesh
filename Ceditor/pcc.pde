//Should ideally be returning a structure but for now let's draw it
void biarc(pt A, pt D, vec T1, vec T2)
{
  T1.normalize();
  T2.normalize();
  vec S = V(D,A);
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
    fill(black);
    show(A,9);
    show(D,9);
    fill(blue);
    show(B,6);
    show(C,6);
    int n = 20;
    fill(white);
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
  }
}
/*
  draw semi circle.
  t : the tangent at the point where the semicircle starts
  p_start : point on which the semicircle must start
  p_end : point on which the semicircle should end
*/
void drawSemiCircle(vec t, pt p_start, pt p_end)
{
  vec D = V(p_start,p_end);
  float diameter = D.norm();
  pt CP1 = P(p_start,diameter/2,t);
  pt CP2 = P(p_end,diameter/2,t);
  pt mid = P(CP1,CP2);
  
  int n = 20;
  fill(white);
  for (int i = 0; i < n; i++)
  {
    pt pOnCurve2 = Bezier(p_start,CP1,mid,(float)((i+1))/n);
    pt pOnCurve1 = Bezier(p_start,CP1,mid,(float)i/n);
    caplet(pOnCurve1,6,pOnCurve2,6);
  }
  for (int i = 0; i < n; i++)
  {
    pt pOnCurve2 = Bezier(mid,CP2,p_end,(float)((i+1))/n);
    pt pOnCurve1 = Bezier(mid,CP2,p_end,(float)i/n);
    caplet(pOnCurve1,6,pOnCurve2,6);
  }
}

/*
Draw an arc. Use two points on the elbow and the center of the circle as the other point
pt1 ,pt2 : start and end points on the elbow
o : the center of the circle
*/
void drawElbow(pt pt1, pt pt2, pt o)
{
  //Create axis as cross product of two vectors in circle's plane
  vec OP1 = V(o,pt1);
  vec OP2 = V(o,pt2);
  vec axis = cross(OP1,OP2);
  axis.normalize();
  //Get vector orthogonal to OP1 and axis
  vec orth = cross(axis,OP1);
  orth.normalize();
  orth.mul(OP2.norm());
  fill(red);
  arrow(o,OP1, 3);
  arrow(o,orth,3);
  arrow(o,100,axis,3);
  fill(yellow);
  //arrow(o,OP2, 3);
  fill(blue);
  show(pt1,2);
  show(pt2,2);
  show(o,2);
  float angle = angle(OP1,OP2);
    
  //We have everything we need to continously rotate OP1 till it reaches OP2
  //P` = O + cosa.OP1 + sina.Orth
  int n = 20;
  for (int i = 0; i < n; i++)
  {
    vec OPr1 = A(V(cos((float)i * angle/n),OP1),V(sin((float)i*angle/n),orth));
    pt p_r1 = P(o,OPr1);
    vec OPr2 = A(V(cos((float)(i+1)* angle/n),OP1),V(sin((float)(i+1)* angle/n),orth));
    pt p_r2 = P(o,OPr2);
    fill(black);
    show(p_r1,2);
    show(p_r2,2);
    fill(grey);
    caplet(p_r1,6,p_r2,6);
  }
}
