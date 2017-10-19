class Vehicle {

  PVector loc, vel, acc;
  float maxSpeed = 5, maxForce=0.1;
  int r=4;


  Vehicle(PVector pos_) {
    loc = pos_;
    acc = new PVector(0, 0);
    vel = new PVector(random(-maxSpeed, maxSpeed), random(-maxSpeed, maxSpeed));
  }
  
  void flock(ArrayList<Vehicle> v,float s,float a,float c) {
    PVector sep = separate(v);   // Separation
    PVector ali = align(v);      // Alignment
    PVector coh = cohesion(v);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(s);
    ali.mult(a);
    coh.mult(c);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  PVector align(ArrayList<Vehicle> v) {
    PVector sum = new PVector(0, 0);
    int count =0;
    for (Vehicle v1 : v) {
      float d=PVector.dist(loc, v1.loc);
      if (d>0 && d<20) {
        sum.add(v1.vel);
        count++;
      }
    }
    if (count>0) {
      sum.div((float)count);
      sum.normalize();
      sum.mult(maxSpeed);
      PVector steer = PVector.sub(sum, vel);
      steer.limit(maxForce);
      return steer;
    }
    return new PVector(0,0);
  }

  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, loc);  // A vector pointing from the position to the target
    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxSpeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxForce);  // Limit to maximum steering force
    return steer;
  }

  PVector separate(ArrayList<Vehicle> v) {
    float desiredSep = r*2;
    PVector steer = new PVector(0, 0);
    int count =0;

    for (Vehicle v1 : v) {
      float d = PVector.dist(loc, v1.loc);

      if ((d > 0) && (d < desiredSep)) {

        PVector diff = PVector.sub(loc, v1.loc);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }

    if (count>0) {
      steer.div((float)count);
    }

    if (steer.mag() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxSpeed);
      steer.sub(vel);
      steer.limit(maxForce);
    }
    return steer;
  }

  void update() {

    vel.add(acc);
    loc.add(vel);
    acc.mult(0);
  }

  void display() {
    float dir = vel.heading2D() + PI/2;
    fill(0, 0, 0);
    noStroke();
    pushMatrix();
    translate(loc.x, loc.y);
    rotate(dir);

    //Pointy vehicle
    beginShape();
    vertex(0, -2*r);
    vertex(-r, 2*r);
    vertex(r, 2*r);
    endShape();

    popMatrix();
  }

  void applyForce(PVector f) {
    acc.add(f);
  }

  void run() {
    update();
    borders();
    display();
  }

  void borders() {
    if (loc.x > width + r) 
      loc.x = - r;
    else if (loc.x < - r)
      loc.x = width + r;
    if (loc.y > height + r) 
      loc.y = - r;
    else if (loc.y < - r)
      loc.y = height + r;
  }

  PVector cohesion (ArrayList<Vehicle> v) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Vehicle other : v) {
      float d = PVector.dist(loc, other.loc);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.loc); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
}