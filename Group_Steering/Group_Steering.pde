float s=5, a=1, c=1;

ArrayList<Vehicle> v;
void setup() {
  size(1280, 720);

  v=new ArrayList<Vehicle>();
}

void draw() {
  background(255);

  for (Vehicle v1 : v) {
    v1.flock(v, s, a, c);
    v1.run();
  }

  if (mousePressed) {
    v.add(new Vehicle(new PVector(mouseX, mouseY)));
  }
  fill(0);
  text("Separation multiplier : " + s,10,height-30);
  text("Aligning multiplier : " + a,10,height-20);
  text("Cohesion multiplier : " + c,10,height-10);
}
void keyPressed() {
  if (key =='a') {
    s++;
  }
  if (key =='z') {
    s--;
  }
  if (key =='s') {
    a++;
  }
  if (key =='x') {
    a--;
  }
  if (key =='d') {
    c++;
  }
  if (key =='c') {
    c--;
  }
}