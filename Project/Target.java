//This file helps Project.pde

import processing.core.PApplet;
import static processing.core.PApplet.TAU;

public class Target extends GameObject
{
  private double x = 400.0;
  private double r = 50.0;
  private double a = 0.0;
  private double tr = 0.0;

  public Target(PApplet a)
  {
    super(a);
    randomize();
  }

  public double xLeft()
  {
    return x-r;
  }
  public double xCenter()
  {
    return x;
  }
  public double xRight()
  {
    return x+r;
  }

  public void randomize()
  {
    x = Math.random()*(app.width-r*2.0)+r;
    a = 0.0;
  }
  public void shrink()
  {
    r *= 0.5;
  }

  @Override
  public void tick()
  {
    tr = r*Math.sin(Math.abs(a))*1.25;
    if(a >= 0.0)
    {
      if(tr <= r)
      {
        a += 0.01*TAU;
      }
      else
      {
        a *= -1.0;
      }
    }
    else
    {
      if(tr > r)
      {
        a -= 0.01*TAU;
      }
      else
      {
        tr = r;
      }
    }
  }
  @Override
  public void draw()
  {
    app.stroke(255, 0, 0); //red
    for(int i = 1; i <= 3; ++i)
    {
      app.line((float)(x-tr), app.height-i,
               (float)(x+tr), app.height-i);
    }
    app.fill(96); //dark gray
    app.stroke(255); //white
    app.triangle((float)x, app.height-4,
                 (float)(x-tr*1.7), app.height-4-(float)(tr*2.0),
                 (float)(x+tr*1.7), app.height-4-(float)(tr*2.0));
    app.fill(255); //white
    app.stroke(255, 0, 0); //red
    app.ellipse((float)x, app.height-14-(float)(tr*2.5),
                (float)(tr*4.0), (float)(tr*4.0));
    app.stroke(255); //white
    app.fill(255, 0, 0); //red
    app.ellipse((float)x, app.height-14-(float)(tr*2.5),
                (float)(tr*3.0), (float)(tr*3.0));
    app.fill(255); //white
    app.ellipse((float)x, app.height-14-(float)(tr*2.5),
                (float)(tr*2.0), (float)(tr*2.0));
    app.fill(255, 0, 0); //red
    app.ellipse((float)x, app.height-14-(float)(tr*2.5),
                (float)tr, (float)tr);
  }
}

//end of file
