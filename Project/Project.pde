//Processing Assignment 5, DL Nicholas Braden

import java.util.ArrayList;

ArrayList<Cloud> clouds = new ArrayList<Cloud>();

//Variable/constant setup
double angle = TAU/8.0; //the firing angle
double v = 100.0; //the firing velocity
final double g = 9.80665; //the force of gravity
double maxT(){ return 2.0*v*Math.sin(angle)/g; } //the ending time of the simulation
final double initT = 0.0; //the starting time of the simulaton
double curT = initT; //the current time of the simulation
final double deltaT = 0.075; //the time step of the simulation
double targetX = 400.0;
double targetR = 50.0;
double targetA = 0.0;
int attempts = 0;
final int maxAttempts = 5;

PFont courier = null;
PFont arial16 = null;
PFont arial48 = null;

//See State.java for State enumeration
State state = State.Intro;
String introText = "Launch Target";

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
  switch(state) //act depending on which state we are in
  {
    case Intro: //on title screen
    {
      DrawBackground();
      if(attempts >= maxAttempts) DrawTarget();
      TracePath(maxT()/3.0, true);
      DrawCannon();
      filter(BLUR, 6);
      textFont(arial48);
      textAlign(CENTER);
      if(attempts >= maxAttempts) fill(255, 0, 0);
      else fill(0);
      text(introText, width/2, height/2);
      textFont(arial16);
      text("Click or press any key to play", width/2, height/2+32);
    } break;
    case Aiming: //user can aim cannon
    {
      //angle from mouse
      angle = Math.abs(Math.atan2(0.0-mouseX, mouseY-height)+TAU/4.0);
      if(angle > TAU/4.0) angle = TAU/4.0;
      else if(angle < 0.0) angle = 0.0;

      //velocity from mouse
      v = Math.sqrt(Math.pow(0.0-mouseX, 2.0)+Math.pow(mouseY-height, 2.0))/5.0;

      DrawBackground();

      DrawTarget();
      TracePath(maxT()/3.0, true); //draw partial path to help with aiming
      DrawCannon(); //draw the cannon
    } break;
    case Simulating: //projectile is moving
    {
      curT += deltaT; //increment time (time 0 never drawn)
      if(curT >= maxT() || CalcX(curT) > width) //finished simulation
      {
        curT = maxT();
        state = State.Ended; //stop simulating
        return; //keep last frame, don't redraw
      }
      
      DrawBackground();

      DrawTarget();
      if(curT < maxT() /3.0) TracePath(maxT()/3.0, true); //keep partial path
      TracePath(curT); //draw the tracer line over it
      DrawProjectile(); //draw the projectile itself
      DrawCannon(); //draw the cannon
    } break;
    case Ended: //simulation is over; projectile landed
    {
      DrawBackground();

      DrawTarget();
      TracePath(maxT()); //draw the full path
      DrawProjectile(); //draw the landed projectile
      DrawCannon(); //draw the cannon
    } break;
    default: break;
  }
//  DrawDebug(); //show variables in real time
  DrawHelp(); //show user what to do
}

/**
 * Calulates the x coordinate at a given time
 */
double CalcX(double time)
{
  return v*time*Math.cos(angle);
}
/**
 * Calulates the y coordinate at a given time
 */
double CalcY(double time)
{
  return v*time*Math.sin(angle) - 0.5*g*Math.pow(time, 2.0);
}

/**
 * Returns true if the current trajectory hits the target
 */
boolean HitsTarget()
{
  return CalcX(maxT()) >= targetX-targetR && CalcX(maxT()) <= targetX+targetR;
}

/**
 * Traces a dashed-line following the path of the projectile
 */
void TracePath(double to){TracePath(to, false);}
void TracePath(double to, boolean fade)
{
  stroke(64); //black
  double deltaT = 0.025; //shadows this.deltaT
  //iterate from initial time to current time
  for(double t = initT+deltaT; t < to; t += deltaT)
  {
    if(fade && t > to/2.0) //fade out
    {
      stroke(64, 64, 64, 255-(int)(255.0*2.0*((t-to/2.0)/to)));
    }
    //ony draw lines every-other time unit
    if((int)(t*10.0) % 2 == 0)
    {
      //draw the line from previous time to iterated time
      line((float)CalcX(t-deltaT), height-(float)CalcY(t-deltaT),
           (float)CalcX(t),        height-(float)CalcY(t));
    }
  }
}

void DrawBackground()
{
  background(128, 192, 255); //clear last frame

  image(background, 0, 0, width, height);

  textFont(arial48);
  textAlign(CENTER);
  fill(0); //black
  text(""+(maxAttempts-attempts), width-48, 64);

  for(int i = 0; i < clouds.size(); )
  {
    if(!clouds.get(i).OnScreen())
    {
      clouds.remove(i);
      clouds.add(new Cloud(this, false));
    }
    else ++i;
  }
  for(Cloud c : clouds)
  {
    c.Draw();
  }
}

/**
 * Draws the fired projectile.
 * Also shows where it is off-screen.
 */
void DrawProjectile()
{
  //Just a simple circle
  fill(255, 0, 0); //red
  stroke(0); //black
  ellipse((float)CalcX(curT), height-(float)CalcY(curT),
          10.0f, 10.0f);
  if(CalcY(curT) > height) //off-screen
  {
    textFont(arial16);
    textAlign(CENTER);
    fill(0); //black
    text((int)(CalcY(curT)-height), (float)CalcX(curT), 20f); 
  }
}

/**
 * Draws the cannon.
 * Currently just a rectangle, could be an image
 */
void DrawCannon()
{
  fill(92); //gray
  stroke(0); //black
  pushMatrix();
  {
    translate(0, height); //move to bottom left corner
    rotate((float)(angle * -1.0)); //rotate the cannon
    rect(-5, -5, 40, 10); //draw the cannon
  }
  popMatrix();
}

/**
 * Draws the target.
 * Represented by a line at the bottom of the screen,
 * with an identifier above it
 */
void DrawTarget()
{
  //fancy animation
  double targetR = this.targetR*Math.sin(Math.abs(targetA))*1.25; //shadow member variable
  if(targetA >= 0.0)
  {
    if(targetR <= this.targetR)
    {
      targetA += 0.01*TAU;
    }
    else
    {
      targetA *= -1.0;
    }
  }
  else
  {
    if(targetR > this.targetR)
    {
      targetA -= 0.01*TAU;
    }
    else
    {
      targetR = this.targetR;
    }
  }

  stroke(255, 0, 0); //red
  for(int i = 1; i <= 3; ++i)
  {
    line((float)(targetX-this.targetR), height-i,
         (float)(targetX+this.targetR), height-i);
  }
  fill(96); //dark gray
  stroke(255); //white
  triangle((float)targetX, height-4,
           (float)(targetX-targetR*1.7), height-4-(float)(targetR*2.0),
           (float)(targetX+targetR*1.7), height-4-(float)(targetR*2.0));
  fill(255); //white
  stroke(255, 0, 0); //red
  ellipse((float)targetX, height-14-(float)(targetR*2.5),
          (float)(targetR*4.0), (float)(targetR*4.0));
  stroke(255); //white
  fill(255, 0, 0); //red
  ellipse((float)targetX, height-14-(float)(targetR*2.5),
          (float)(targetR*3.0), (float)(targetR*3.0));
  fill(255); //white
  ellipse((float)targetX, height-14-(float)(targetR*2.5),
          (float)(targetR*2.0), (float)(targetR*2.0));
  fill(255, 0, 0); //red
  ellipse((float)targetX, height-14-(float)(targetR*2.5),
          (float)targetR, (float)targetR);
}

/**
 * Draws real-time debugging info to the screen,
 * such as the variables affecting the simulation,
 * but without spoiling the max time until the end
 */
void DrawDebug()
{
  textFont(courier);
  textAlign(LEFT);
  fill(0); //black
  text("   angle = "+String.format("%.2f degrees", angle/TAU*360.0)+"\n" //show in degrees
      +"       v = "+String.format("%.2f meters per second", v)+"\n"
      +"       g = "+String.format("%.2f meters per second", g)+"\n"
      +"  deltaT = "+String.format("%.2f seconds per frame", deltaT)+"\n"
      +"   initT = "+String.format("%.2f seconds", initT)+"\n"
      +"    curT = "+String.format("%.2f seconds", curT)+"\n"
      +"    maxT = "+String.format("%.2f seconds", maxT())+"\n"
      +"       x = "+String.format("%.2f meters from cannon", CalcX(curT))+"\n"
      +"       y = "+String.format("%.2f meters above sea level", CalcY(curT))+"\n"
      +"  target = "+String.format("%.2f meters from cannon", targetX)+"\n"
      +"           "+String.format("%.2f meters wide", targetR*2.0)+"\n"
      +"    hits = "+HitsTarget()+"\n"
      +"attempts = "+attempts+" out of "+maxAttempts+" projectiles fired"+"\n"
      +"   state = "+state+"\n"
      +"     fps = "+String.format("%.2f frames per second", frameRate),
       10, 10,
       width-20, height-20);
}

/**
 * Show the user what to do to progress the game
 */
void DrawHelp()
{
  switch(state)
  {
    case Aiming:
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
    } break;
    case Ended:
    {
      if(HitsTarget())
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
      }
      else
      {
        fill(255, 255, 255, 128); //white, faded
        noStroke();
        rect(width/2-125, height/2-50, 250, 100);
        textFont(arial16);
        textAlign(CENTER);
        fill(255, 0, 0); //red
        text("You missed by "+(int)Math.abs(targetX-CalcX(maxT()))+" meters...\n"
            +(attempts < maxAttempts? "Press any key to try again" : "Press any key"),
             width/2, height/2+20);
        textFont(arial48);
        text("MISS", width/2, height/2);
      }
    } break;
    default: break;
  }
}

/**
 * Resets some variables but leaves others intact
 */
void Reset(){Reset(false);}
void Reset(boolean total)
{
  state = State.Intro;
  curT = initT;

  if(HitsTarget() || total)
  {
    //randomize target
    RandomizeTarget();
    targetR *= 0.5;
    targetA = 0.0;
    attempts = 0;
  }
  if(total)
  {
    targetR = 50.0;
  }
}

void RandomizeTarget()
{
  targetX = Math.random()*(width-targetR*2.0)+targetR;
}

/**
 * Allows restarting
 */
void keyPressed()
{
  if(state == State.Intro)
  {
    Reset(true);
    state = State.Aiming;
  }
  if(state == State.Ended)
  {
    if(attempts >= maxAttempts)
    {
      state = State.Intro;
      introText = "Game Over";
    }
    else
    {
      Reset();
      state = state.Aiming;
    }
  }
  if(key == 'r') Reset(true);
  else if(key == 't')
  {
    RandomizeTarget();
    targetA = 0.0;
  }
  else if(key == 'c')
  {
    clouds.add(new Cloud(this));
  }
}
/**
 * Allows firing and restarting
 */
void mouseClicked()
{
  switch(state)
  {
    case Intro:
    {
      Reset(true);
      state = State.Aiming;
    } break;
    case Aiming:
    {
      state = State.Simulating;
      ++attempts;
    } break;
    case Ended:
    {
      if(attempts >= maxAttempts)
      {
        state = State.Intro;
        introText = "Game Over";
      }
      else
      {
        Reset();
        state = state.Aiming;
      }
    } break;
    default: break;
  }
}

//end of program

