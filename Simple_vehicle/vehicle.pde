class Vehicle {
  PVector loc, vel, acc;
  float r, maxForce, maxSpeed; // maximum steering force and speed

  Vehicle(float x, float y) {
    acc = new PVector(0, 0);
    vel = new PVector(0, -2);
    loc = new PVector(x, y);
    r=6;
    maxSpeed = 5;
    maxForce = 0.1;
  }

  void update() {
    vel.add(acc);
    loc.add(vel);

    acc.mult(0);
  }

  void applyForce(PVector f) {
    acc.add(f);
  }

  void seek(PVector target) {
    // A vector pointing from the position to the target
    PVector desired = PVector.sub(target, loc);
    float d=desired.mag();

    if (d<50) {
      float m= map(d, 0, 50, 0, maxSpeed);
      desired.setMag(m);
    } else
      desired.setMag(maxSpeed);

    // Steering = Desired - velocity
    PVector steering = PVector.sub(desired, vel);
    steering.limit(maxForce);

    applyForce(steering);
  }

  void display() {

    float dir = vel.heading2D() + PI/2;
    fill(127);
    noStroke();
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(dir);
    rectMode(CENTER);
    rect(0, 0, 8, 20);
    popMatrix();
  }
}