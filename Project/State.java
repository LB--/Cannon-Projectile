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
   * User can aim the cannon and change firing power
   */
  Aiming,
  /**
   * User is watching the projectile in flight
   */
  Simulating,
  /**
   * The projectile has landed
   */
  Ended;
  public String toString()
  {
    switch(this)
    {
      case Intro:      return "Intro";
      case Aiming:     return "Aiming";
      case Simulating: return "Simulating";
      case Ended:      return "Ended";
    }
    throw new IllegalStateException();
  }
}

//end of file

