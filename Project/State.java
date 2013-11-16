//This file helps Project.pde

/**
 * Enum of valid states we can be in
 */
public enum State
{
  /**
   * User is on title screen
   */
  Intro,
  /**
   * User is aiming and/or watching the projectile(s) in flight
   */
  Simulating;
  public String toString()
  {
    switch(this)
    {
      case Intro:      return "Intro";
      case Simulating: return "Simulating";
    }
    throw new IllegalStateException();
  }
}

//end of file
