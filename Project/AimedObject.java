//This file helps Project.pde

import processing.core.PApplet;

public abstract class AimedObject extends GameObject
{
  protected double angle;
  protected double v;

  public AimedObject(PApplet a)
  {
    super(a);
  }

  public double maxT()
  {
    return 2.0*v*Math.sin(angle)/g;
  }
  public double calcX(double time)
  {
    return v*time*Math.cos(angle);
  }
  public double calcY(double time)
  {
    return v*time*Math.sin(angle) - 0.5*g*Math.pow(time, 2.0);
  }

  public boolean hits(Target t)
  {
    double xt = calcX(maxT());
    return xt >= t.xLeft() && xt <= t.xRight();
  }

  public void tracePath(double to)
  {
    tracePath(to, false);
  }
  public void tracePath(double to, boolean fade)
  {
    app.stroke(64); //dark gray
    double dT = 0.025;
    for(double t = initT+dT; t < to && calcX(t) < app.width; t += dT) //iterate over time
    {
      if(fade && t > to/2.0) //fade out
      {
        app.stroke(64, 64, 64, 256-(int)(256.0*2.0*((t-to/2.0)/to)));
      }
      //alternate drawing lines
      if((int)(t*10.0) % 2 == 0)
      {
        app.line((float)calcX(t-dT), app.height-(float)calcY(t-dT),
                 (float)calcX(t),    app.height-(float)calcY(t));
      }
    }
  }
}

//end of file
