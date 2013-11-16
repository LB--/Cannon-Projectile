//Processing Assignment 5, DL Nicholas Braden

import java.util.ArrayList;

ArrayList<Cloud> clouds = new ArrayList<Cloud>();
Target target = null;
Cannon cannon = null;

final int maxAttempts = 5;

public PFont courier = null;
public PFont arial16 = null;
public PFont arial48 = null;

//See State.java for State enumeration
State state = State.Intro;
String introText = "Loading...";

PImage background = null;

/**
 * Initialize the program
 * (set window size, print debug info, etc.)
 */
void setup()
{
  size(1280, 720); //16:9 aspect ratio
  frame.setTitle("Processing Assignment #5"); //set window title

  //load fonts that will be used
  courier = loadFont("CourierNewPSMT-12.vlw");
  arial16 = loadFont("Arial-BoldMT-16.vlw");
  arial48 = loadFont("Arial-Black-48.vlw");

  background = loadImage("Background.png");

  target = new Target(this);
  cannon = new Cannon(this);

  Reset(true);

  int nc = (int)(Math.random()*3.0+2.0);
  for(int i = 0; i < nc; ++i)
  {
    clouds.add(new Cloud(this));
  }
  clouds.add(new Cloud(this, false));
}

/**
 * Update time & redraw
 */
void draw()
{
  Skip:do
  if(cannon.getProjectiles().size() >= maxAttempts && !cannon.firing())
  {
    for(Projectile p : cannon.getProjectiles())
    {
      if(p.hits(target)) break Skip;
    }
    state = State.Intro;
    introText = "Game Over";
  }while(false);
  switch(state)
  {
    case Intro:
    {
      DrawBackground();

      if(cannon.getProjectiles().size() >= maxAttempts)
      {
        target.draw();
      }
      cannon.draw();

      filter(BLUR, 6);

      textFont(arial48);
      textAlign(CENTER);
      if(cannon.getProjectiles().size() >= maxAttempts)
      {
        fill(255, 0, 0);
      }
      else fill(0);
      text(introText, width/2, height/2);
      textFont(arial16);
      text("Click or press any key to play", width/2, height/2+32);
    } break;
    case Simulating:
    {
      target.tick();
      cannon.tick();
      
      DrawBackground();

      target.draw();
      cannon.draw();
    } break;
    default: break;
  }
  DrawHelp();
}

void DrawBackground()
{
  background(128, 192, 255); //clear last frame

  image(background, 0, 0, width, height);

  textFont(arial48);
  textAlign(CENTER);
  fill(0); //black
  text(""+(maxAttempts-cannon.getProjectiles().size()), width-48, 64);

  for(int i = 0; i < clouds.size(); )
  {
    if(!clouds.get(i).onScreen())
    {
      clouds.remove(i);
      clouds.add(new Cloud(this, false));
    }
    else ++i;
  }
  for(Cloud c : clouds)
  {
    for(Projectile p : cannon.getProjectiles())
    {
      c.disturbance(p.X(), height-p.Y());
    }
    c.tick();
    c.draw();
  }
}

/**
 * Show the user what to do to progress the game
 */
void DrawHelp()
{
  if(state == state.Simulating)
  {
    fill(255, 255, 255, 128); //white, faded
    noStroke();
    rect(5, 224-5, 400, 16*3+10);
    textFont(arial16);
    textAlign(LEFT);
    fill(0, 192, 0); //green
    text("• Aim with your Mouse\n"
        +"• Power is based on Mouse distance from Cannon\n"
        +"• Click to fire the shot!",
         10, 224,
         width-20, height-20);
  }
  for(Projectile p : cannon.getProjectiles())
  {
    if(p.hits(target) && p.landed())
    {
      fill(255, 255, 255, 128); //white, faded
      noStroke();
      rect(width/2-150, height/2-50, 300, 100);
      textFont(arial16);
      textAlign(CENTER);
      fill(0, 192, 0); //green
      text("You hit the target!\n"
          +"Press any key to make a harder shot",
           width/2, height/2+20);
      textFont(arial48);
      text("IT'S A HIT!", width/2, height/2);
      break;
    }
  }
}

/**
 * Resets some variables but leaves others intact
 */
void Reset(){Reset(false);}
void Reset(boolean total)
{
  state = State.Intro;
  if(total)
  {
    target = new Target(this);
    cannon = new Cannon(this);
    introText = "Launch Target";
  }
  else for(Projectile p : cannon.getProjectiles())
  {
    if(p.hits(target))
    {
      target.randomize();
      target.shrink();
    }
  }
  cannon.reset();
}

/**
 * Allows restarting
 */
void keyPressed()
{
  if(key == 'r') Reset(true);
  else if(key == 't')
  {
    target.randomize();
  }
  else if(key == 'c')
  {
    clouds.add(new Cloud(this));
  }
  else mouseClicked();
}
/**
 * Allows firing and restarting
 */
void mouseClicked()
{
  if(state == State.Intro)
  {
    Reset(true);
    state = State.Simulating;
  }
  else
  {
    for(Projectile p : cannon.getProjectiles())
    {
      if(p.landed() && p.hits(target))
      {
        Reset();
        state = State.Simulating;
        return;
      }
    }
    if(cannon.getProjectiles().size() < maxAttempts)
    {
      cannon.fire();
    }
  }
}

//end of program

