//This file helps Project.pde

import processing.core.PApplet;
import static processing.core.PApplet.TAU;
import java.util.ArrayList;
import java.util.List;

public class Cannon extends AimedObject
{
  private ArrayList<Projectile> projs = new ArrayList<Projectile>();

  public Cannon(PApplet a)
  {
    super(a);
    angle = TAU/8.0;
    v = 100.0;
  }

  public List<Projectile> getProjectiles()
  {
    return projs;
  }

  public void fire()
  {
    projs.add(new Projectile(app, this, angle, v));
  }
  public boolean firing()
  {
    for(Projectile p : projs)
    {
      if(!p.landed())
      {
        return true;
      }
    }
    return false;
  }
  public void reset()
  {
    projs.clear();
  }

  @Override
  public void tick()
  {
    //angle from mouse
    angle = Math.abs(Math.atan2(0.0-app.mouseX, app.mouseY-app.height)+TAU/4.0);
    if(angle > TAU/4.0) angle = TAU/4.0;
    else if(angle < 0.0) angle = 0.0;

    //velocity from mouse
    v = Math.sqrt(Math.pow(0.0-app.mouseX, 2.0)+Math.pow(app.mouseY-app.height, 2.0))/5.0;

    //tick projectiles
    for(Projectile p : projs)
    {
      p.tick();
    }
  }
  @Override
  public void draw()
  {
    tracePath(maxT()/3.0, true);

    for(Projectile p : projs)
    {
      p.draw();
    }

    app.fill(92); //gray
    app.stroke(0); //black
    app.pushMatrix();
    {
      app.translate(0, app.height);
      app.rotate((float)(angle * -1.0));
      app.rect(-5, -5, 40, 10);
    }
    app.popMatrix();
  }
}

//end of file
