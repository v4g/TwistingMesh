//Should ideally be returning a structure but for now let's draw it
void biarc(pt A, pt D, vec T1, vec T2)
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
    if(showVecs)
    {
      fill(magenta);
      arrow(E,50,T3,3);
      fill(pink);
      arrow(A,50,T1,3);
      arrow(D,50,T2,3);
    }
    if(T.norm() != 0)
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
    }/*fill(black);
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
  */  
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
  /*fill(red);
  arrow(o,OP1, 3);
  arrow(o,orth,3);
  arrow(o,100,axis,3);
  fill(yellow);
  arrow(o,OP2, 3);
  fill(blue);
  show(pt1,2);
  show(pt2,2);
  show(o,2);
  */
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

pt findCenterofTangentPoints(pt p1, vec v1, pt p2, vec v2)
{
  pt o;
  float a = 0f;
  //first find the axis 
  vec p1p2 = V(p1,p2);
  vec axis1 = cross(p1p2,v1);
  vec axis2 = cross(p1p2,v2);
  //the direction of axis1 and axis2 should be same, if not, we can't create a common axis
  //find orthogonal lines to axis1, v1 and axis2 v2
  vec l1 = cross(axis1,v1);
  vec l2 = cross(axis2,v2);
  //find intersection of these two points using a (L1 X L2) = (P2 - P1) X L2
  vec l1l2 = cross(l1,l2);
  //check if this vector is parallel
  if(l1l2.norm() == 0)
  {
    //return midpoint
    o = P(p1,p2);  
  }
  else
  {
    vec p1p2l2 = cross(p1p2,l2);
    a = p1p2l2.norm() / l1l2.norm();
    if(dot(p1p2l2, l1l2 ) < 0)
      a = -a;
    //center o = P1 + a V1
    o = P(p1, V(a,l1));
  }
  //display these points
  //fill(pink);
  if(showTangents)
  {
    show(p2,3);
    show(p1,3);
    fill(blue);
    //arrow(p1,100,v1, 3);
    arrow(o,1,axis1, 3);
    fill(red);
    arrow(p1,1,l1, 3);
    arrow(p2,1,l2, 3);
    //arrow(p2,100,v2, 3);
  }
  return o;
}
