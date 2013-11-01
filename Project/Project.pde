//Processing Assignment 2, DL Nicholas Braden

//Variable/constant setup
final double angle = 45.0; //the firing angle
final double v = 100.0; //the firing velocity
final double g = 9.80665; //the force of gravity
final double maxT = 2.0*v*sin((float)angle)/g; //the ending time of the simulation
final double initT = 0.0; //the starting time of the simulaton
double curT = initT; //the current time of the simulation
final double deltaT = 0.05; //the time step of the simulation

/**
 * Initialize the program
 * (set window size, print debug info, etc.)
 */
void setup()
{
  size(1280, 720);
  println("maxT = "+maxT);
  textFont(loadFont("CourierNewPSMT-12.vlw"));
}

/**
 * Update time & redraw
 */
void draw()
{
  curT += deltaT; //increment time (time 0 never drawn)
  if(curT >= maxT) //finihed simulation
  {
    noLoop(); //disable redrawing
    DrawDebug(); //show how to restart simulation
    return; //keep last frame, don't redraw
  }
  
  background(255); //clear last frame

  TracePath(); //draw the tracer line
  DrawProjectile(); //draw the projectile itself
  DrawDebug(); //show variables in real time
}

/**
 * Calulates the x coordinate at a given time
 */
double CalcX(double time)
{
  return v*time*cos((float)angle);
}
/**
 * Calulates the y coordinate at a given time
 */
double CalcY(double time)
{
  return (v*time*sin((float)angle)) - 0.5*g*sq((float)time);
}

/**
 * Traces a dashed-line following the path of the projectile
 */
void TracePath()
{
  //iterate from initial time to current time
  for(double t = initT+deltaT; t < curT; t += deltaT)
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
 * Draws the fired projectile
 */
void DrawProjectile()
{
  //Just a simple circle
  fill(255, 0, 0);
  ellipse((float)CalcX(curT), height-(float)CalcY(curT),
          10.0f, 10.0f);
}

/**
 * Draws real-time debugging info to the screen,
 * such as the variables affecting the simulation
 */
void DrawDebug()
{
  fill(0);
  if(curT < maxT)
  {
    text(" angle = "+angle+"\n"
        +"     v = "+v+"\n"
        +"     g = "+g+"\n"
        +"  maxT = "+maxT+"\n"
        +" initT = "+initT+"\n"
        +"  curT = "+curT+"\n"
        +"     x = "+CalcX(curT)+"\n"
        +"     y = "+CalcY(curT)+"\n"
        +"deltaT = "+deltaT+"\n"
        +"   fps = "+frameRate,
         10, 10,
         width-20, height-20);
  }
  else
  {
    text("\n\n\n\n\n\n\n\n\n\n\n" //below debug info
        +"Press any key to restart simulation",
         10, 10,
         width-20, height-20);
  }
}

/**
 * Restarts the simulation upon pressing a key
 */
void keyPressed()
{
  curT = initT;
  loop();
}

//end of program

