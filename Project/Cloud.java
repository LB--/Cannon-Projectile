//This file helps Project.pde

import processing.core.PApplet;
import static processing.core.PApplet.TAU;
import java.util.ArrayList;

public class Cloud extends GameObject
{
  private double x, y;
  private double moisture;
  private double speed;
  private double shade;
  private ArrayList<WaterPuff> puffs = new ArrayList<WaterPuff>();

  public Cloud(PApplet a)
  {
    this(a, true);
  }
  public Cloud(PApplet a, boolean onscreen)
  {
    super(a);
    if(onscreen) x = Math.random()*app.width;
    else x = -150.0;
    y = Math.random()*app.height/3.0;
    moisture = Math.random()/2.0+0.25;
    speed = Math.random()/3.0+0.25;
    shade = Math.random()/4.0+0.75;
    int wp = (int)(Math.random()*20.0+10.0);
    for(int i = 0; i < wp; ++i)
    {
      puffs.add(new WaterPuff(app));
    }
  }

  public boolean onScreen()
  {
    if(app == null) return true;
    return app.width > x-150.0;
  }
  public void disturbance(double dx, double dy)
  {
    for(WaterPuff puff : puffs)
    {
      puff.disturbance(dx, dy);
    }
  }

  @Override
  public void tick()
  {
    for(WaterPuff puff : puffs)
    {
      puff.tick();
    }
    x += speed;
  }
  @Override
  public void draw()
  {
    for(WaterPuff puff : puffs)
    {
      puff.draw();
    }
  }

  private class WaterPuff extends GameObject
  {
    private double relx, rely;
    private double wiggle, agitation;

    public WaterPuff(PApplet a)
    {
      super(a);
      relx = ((Math.random()-0.5)*2.0)*100.0;
      rely = ((Math.random()-0.5)*2.0)*50.0;
      wiggle = Math.random()*TAU;
      agitation = 0.0;
    }

    private double curX(){ return x+relx+Math.cos(wiggle)*10.0; }
    private double curY(){ return y+rely+Math.sin(wiggle)*10.0; }

    public void disturbance(double dx, double dy)
    {
      if(Math.abs(curX()-dx) < 25.0 && Math.abs(curY()-dy) < 25.0)
      {
        agitation = 0.25;
      }
    }

    @Override
    public void tick()
    {
      wiggle += 0.01+agitation;
      if(agitation > 0.0) agitation -= 0.0025;
    }
    @Override
    public void draw()
    {
      app.noStroke();
      int col = (int)(256.0*shade);
      app.fill(col, col, col, (int)(256*moisture));
      app.ellipse((float)curX(), (float)curY(),
                  50.0f, 50.0f);
    }
    public boolean OnScreen()
    {
      return app.width > curX()-25.0;
    }
  }
}

//end of file
