
Vehicle v;

void setup()  {
  size(600,400);
  v = new Vehicle(width/2,height/2);
  
}

void draw()  {
  background(0);
  
  v.seek(new PVector(mouseX,mouseY));
  v.update();
  v.display();
  
  
}