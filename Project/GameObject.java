//This file helps Project.pde

import processing.core.PApplet;

public abstract class GameObject
{
  public static final double g = 9.80665;
  public static final double initT = 0.0;
  public static final double deltaT = 0.1;

  protected final PApplet app;
  protected GameObject(PApplet a)
  {
    app = a;
  }

  public abstract void tick();
  public abstract void draw();
}

//end of file
