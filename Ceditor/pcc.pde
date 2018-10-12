//Should ideally be returning a structure but for now let's draw it
void biarc(pt A, pt D, vec T1, vec T2)
{
  T1.normalize();
  T2.normalize();
  vec S = V(D,A);
  vec T = A(T1,T2);
  float epsilon = 0.2f,d = 0f,a = 0f;
  if (T.norm() > 4 - epsilon)
  {
    if ( dot(S,T1) > epsilon || dot(S,T1) < -epsilon)
      a = sq(S.norm())/(4 * dot(S,T1));
    else
      {
        //use semicircles
      }
  }
  else
  {
    d = (sq(dot(S,T))) + sq(S.norm()) *(4 - sq(T.norm()));
    a = (sqrt(d) - dot(S,T))/(4- sq(T.norm()));
  }
  pt B = P(A,V(a,T1));
  pt C = P(D,V(-a,T2));
  pt E = P(B,C);
  //do beziers
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
  for (int i = 0; i < n-1; i++)
  {
    pt pOnCurve2 = Bezier(E,C,D,(float)((i+1))/n);
    pt pOnCurve1 = Bezier(E,C,D,(float)i/n);
    caplet(pOnCurve1,6,pOnCurve2,6);
  }
}
