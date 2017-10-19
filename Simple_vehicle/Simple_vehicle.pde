
Vehicle v;

int x=25,y=200;
boolean dir;

void setup()  {
  size(600,400);
  v = new Vehicle(width/2,height/2);
  
}

void draw()  {
  background(0);
  fill(0);stroke(255);
  if(x>500)
    dir = false;
  if(x<100)
    dir=true;
  if(dir){
    x+=3;point(500,200);}
  else{
    x-=3;point(100,200);}
    
  PVector target= new PVector(x,y);
  
  v.seek(target);
  v.update();
  v.display();
  
}