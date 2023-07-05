package javas.services;

public class Another {
  private int x;

  public Another (int x){
    this.x = x;
    this.x++;
  }

  public String toString(){
    return "" + x;
  }
}
