//Processing Assignment 3, DL Nicholas Braden

//Variable/constant setup
double angle = TAU/8.0; //the firing angle
double v = 100.0; //the firing velocity
final double g = 9.80665; //the force of gravity
double maxT(){ return 2.0*v*Math.sin(angle)/g; } //the ending time of the simulation
final double initT = 0.0; //the starting time of the simulaton
double curT = initT; //the current time of the simulation
final double deltaT = 0.05; //the time step of the simulation

PFont courier = null;
PFont arial16 = null;
PFont arial48 = null;

//See State.java for State enumeration
State state = State.Aiming;

/**
 * Initialize the program
 * (set window size, print debug info, etc.)
 */
void setup()
{
  size(1280, 720); //16:9 aspect ratio
  frame.setTitle("Processing Assignment #3"); //set window title

  //load fonts that will be used
  courier = loadFont("CourierNewPSMT-12.vlw");
  arial16 = loadFont("Arial-BoldMT-16.vlw");
  arial48 = loadFont("Arial-Black-48.vlw");
}

/**
 * Update time & redraw
 */
void draw()
{
  switch(state) //act depending on which state we are in
  {
    case Aiming: //user can aim cannon
    {
      background(255); //clear last frame

      TracePath(maxT()/5.0); //draw partial path to help with aiming
      DrawCannon(); //draw the cannon
    } break;
    case Simulating: //projectile is moving
    {
      curT += deltaT; //increment time (time 0 never drawn)
      if(curT >= maxT()) //finihed simulation
      {
        curT = maxT();
        state = State.Ended; //stop simulating
        DrawDebug(); //show how to restart simulation
        return; //keep last frame, don't redraw
      }
      
      background(255); //clear last frame
      
      TracePath(Math.max(curT, maxT()/5.0)); //draw the tracer line
      DrawProjectile(); //draw the projectile itself
      DrawCannon(); //draw the cannon
    } break;
    case Ended: //simulation is over; projectile landed
    {
      background(255); //clear last frame

      TracePath(maxT()); //draw the full path
      DrawProjectile(); //draw the landed projectile
      DrawCannon(); //draw the cannon
    } break;
    default: break;
  }
  DrawDebug(); //show variables in real time
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
 * Traces a dashed-line following the path of the projectile
 */
void TracePath(double to)
{
  //iterate from initial time to current time
  for(double t = initT+deltaT; t < to; t += deltaT)
  {
    //ony draw lines every-other time unit
    if((int)(t*10.0) % 2 == 0)
    {
      //draw the line from previous time to iterated time
      line((float)CalcX(t-deltaT), height-(float)CalcY(t-deltaT),
           (float)CalcX(t),        height-(float)CalcY(t));
    }
  }
}

/**
 * Draws the fired projectile, not past maxT
 */
void DrawProjectile()
{
  //Just a simple circle
  fill(255, 0, 0);
  ellipse((float)CalcX(curT), height-(float)CalcY(curT),
          10.0f, 10.0f);
}

/**
 * Draws the cannon.
 * Currently just a rectangle, could be an image
 */
void DrawCannon()
{
  fill(92); //gray
  pushMatrix();
  {
    translate(0, height); //move to bottom left corner
    rotate((float)(angle * -1.0)); //rotate the cannon
    rect(-5, -5, 40, 10); //draw the cannon
  }
  popMatrix();
}

/**
 * Draws real-time debugging info to the screen,
 * such as the variables affecting the simulation,
 * but without spoiling the max time until the end
 */
void DrawDebug()
{
  textFont(courier);
  fill(0); //black
  text(" angle = "+String.format("%.2f degrees", angle/TAU*360.0)+"\n" //show in degrees
      +"     v = "+String.format("%.2f meters per second", v)+"\n"
      +"     g = "+String.format("%.2f meters per second", g)+"\n"
      +"  maxT = "+(state != State.Ended ? (state == State.Aiming ? "(???)" : "(...)") //don't spoil max time
                                         : String.format("%.2f seconds", maxT()))+"\n"
      +" initT = "+String.format("%.2f seconds", initT)+"\n"
      +"  curT = "+String.format("%.2f seconds", curT)+"\n"
      +"     x = "+String.format("%.2f meters from cannon", CalcX(curT))+"\n"
      +"     y = "+String.format("%.2f meters above sea level", CalcY(curT))+"\n"
      +"deltaT = "+String.format("%.2f seconds per frame", deltaT)+"\n"
      +"   fps = "+String.format("%.2f frames per second", frameRate),
       10, 10,
       width-20, height-20);
}

/**
 * Show the user what to do to progress the game
 */
void DrawHelp()
{
  textFont(arial16);
  fill(0, 192, 0); //green
  switch(state)
  {
    case Aiming:
    {
      text("• Aim with Left and Right arrow keys\n"
          +"• adjust Power with Up and Down arrow keys\n"
          +"• press Space to fire the shot!",
           10, 192,
           width-20, height-20);
    } break;
    case Ended:
    {
      text("You made it approximately "+(int)(CalcX(curT)+0.5)+" meters\n"
          +"Press any key to make another shot",
           10, 192,
           width-20, height-20);
    } break;
    default: break;
  }
}

/**
 * Resets some variables but leaves others intact
 */
void Reset()
{
  state = State.Aiming;
  curT = initT;
}

/**
 * Allows aiming and restarting
 */
void keyPressed()
{
  switch(state)
  {
    case Aiming: //react to arrow keys
    {
      if(key == CODED)
      {
        switch(keyCode)
        {
          case UP:
          {
            v += 1.0;
          } break;
          case DOWN:
          {
            v -= 1.0;
            if(v < 0.0) v = 0.0;
          } break;
          case LEFT:
          {
            angle += radians((float)1.0);
            if(angle > TAU/4.0) angle = TAU/4.0;
          } break;
          case RIGHT:
          {
            angle -= radians((float)1.0);
            if(angle < 0) angle = 0;
          } break;
          default: break;
        }
      }
      else if(key == ' ') //fire!
      {
        state = State.Simulating;
      }
    } break;
    case Ended: //restart upon keypress
    {
      Reset();
    } break;
    default: break;
  }
}

//end of program

