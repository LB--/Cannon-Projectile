//This file helps Project.pde

import java.util.ArrayList;

public class Cloud
{
  private Project p;
  private double x, y;
  private double moisture;
  private double speed;
  private double shade;
  private ArrayList<WaterPuff> puffs = new ArrayList<WaterPuff>();
  public Cloud(Project app){this(app, true);}
  public Cloud(Project app, boolean onscreen)
  {
    p = app;
    if(onscreen) x = Math.random()*p.width;
    else x = -150.0;
    y = Math.random()*p.height/3.0;
    moisture = Math.random()/2.0+0.25;
    speed = Math.random()/3.0+0.25;
    shade = Math.random()/4.0+0.75;
    int wp = (int)(Math.random()*20.0+10.0);
    for(int i = 0; i < wp; ++i)
    {
      puffs.add(new WaterPuff());
    }
  }
  public void Draw()
  {
    for(WaterPuff puff : puffs)
    {
      puff.Draw();
    }
    x += speed;
  }
  public boolean OnScreen()
  {
    boolean visible = false;
    for(WaterPuff puff : puffs)
    {
      visible = visible || puff.OnScreen();
    }
    return visible;
  }
  private class WaterPuff
  {
    private double relx, rely;
    private double wiggle, agitation;
    public WaterPuff()
    {
      relx = ((Math.random()-0.5)*2.0)*100.0;
      rely = ((Math.random()-0.5)*2.0)*50.0;
      wiggle = Math.random()*p.TAU;
      agitation = 0.0;
    }
    private double curX(){ return x+relx+Math.cos(wiggle)*10.0; }
    private double curY(){ return y+rely+Math.sin(wiggle)*10.0; }
    public void Draw()
    {
      p.noStroke();
      int col = (int)(256.0*shade);
      p.fill(col, col, col, (int)(256*moisture));
      p.ellipse((float)curX(), (float)curY(),
                50f, 50f);
      wiggle += 0.01+agitation;
      if(agitation > 0.0) agitation -= 0.0025;
      if(Math.abs(curX()-p.CalcX(p.curT)) < 25.0 && Math.abs(curY()-(p.height-p.CalcY(p.curT))) < 25.0)
      {
        agitation = 0.25;
      }
    }
    public boolean OnScreen()
    {
      return p.width > curX()-25.0;
    }
  }
}

//end of file

