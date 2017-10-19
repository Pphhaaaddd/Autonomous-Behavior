boolean debug = true;

// A path object (series of connected points)
Path path;

// Two vehicles
ArrayList<Vehicle> car;

void setup() {
  size(640, 360);
  path = new Path();

  car = new ArrayList<Vehicle>();
}

void draw() {
  background(255);
  // Display the path
  path.display();
  for (Vehicle car : car) {
    // The boids follow the path
    car.follow(path);

    // Call the generic run method (update, borders, display, etc.)
    car.run();

    // Check if it gets to the end of the path since it's not a loop
    car.borders(path);
  }
  // Instructions
  fill(0);
  text("Hit space bar to toggle debugging lines.", 10, height-30);
  text("Hit p to toggle paths.", 10, height-20);


  if (mousePressed) {
    Vehicle v = new Vehicle(new PVector(mouseX, mouseY), random(2, 5), random(0.02, 0.04));
    car.add(v);
  }
}

public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
  
  if(key == 'p')
    path.newPath();
}