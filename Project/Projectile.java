//This file helps Project.pde

import processing.core.PApplet;

public class Projectile extends AimedObject
{
  private double curT = initT;
  private Cannon c;

  public Projectile(PApplet a, Cannon can, double angl, double vel)
  {
    super(a);
    c = can;
    angle = angl;
    v = vel;
  }

  public double X(){ return calcX(curT); }
  public double Y(){ return calcY(curT); }

  public boolean landed()
  {
    return curT >= maxT();
  }

  @Override
  public void tick()
  {
    curT += deltaT;
    if(landed() || X() > app.width)
    {
      curT = maxT();
    }
  }
  @Override
  public void draw()
  {
    tracePath(curT);
    //just a simple circle
    app.fill(255, 0, 0); //red
    app.stroke(0); //black
    app.ellipse((float)X(), app.height-(float)Y(),
                10.0f, 10.0f);
//    if(Y() > app.height) //off-screen
//    {
//      app.textFont(app.arial16);
//      app.textAlign(CENTER);
//      app.fill(0); //black
//      app.text(""+(int)(Y()-height), (float)X(), 20.0f);
//    }
  }
}

//end of file
