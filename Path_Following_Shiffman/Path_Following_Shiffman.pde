// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following
// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = true;

// A path object (series of connected points)
Path path;

ArrayList<Vehicle> car;

void setup() {
  size(640, 360);
  path = new Path();

  // Each vehicle has different maxspeed and maxforce for demo purposes
  car = new ArrayList<Vehicle>();
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
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
    Vehicle v = new Vehicle(new PVector(mouseX, mouseY), random(3, 5), random(0.02, 0.04));
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