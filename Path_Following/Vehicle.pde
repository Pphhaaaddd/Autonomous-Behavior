class Vehicle {
  PVector loc, vel, acc;
  float r, maxForce, maxSpeed; // maximum steering force and speed

Vehicle( PVector l, float ms, float mf) {
    loc = l.get();
    r = 4.0;
    maxSpeed = ms;
    maxForce = mf;
    acc = new PVector(0, 0);
    vel = new PVector(maxSpeed, 0);
  }

  // Main "run" function
  void run() {
    update();
    display();
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

    if (d<100) {
      float m= map(d, 0, 50, 0, maxSpeed/2);
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
    fill(0,255,0);
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

  void follow(Path p) {

    // Look 25 units into future
    PVector predict = vel.get();
    predict.normalize();
    predict.mult(40);
    PVector predictLoc = PVector.add(loc, predict);
    
    PVector a = p.getStart(predictLoc);
    PVector b = p.getEnd(predictLoc);
    
    PVector normalPoint = getNormalPoint(predictLoc,a,b);
    
    PVector dir = PVector.sub(b,a);
    dir.normalize();
    dir.mult(30);
    PVector target = PVector.add(normalPoint, dir);
    
    float distance = PVector.dist(predictLoc, normalPoint);
    
    if(distance > p.radius) {
      seek(target);
    }
    
    if (debug) {
      fill(0);
      stroke(0);
      line(loc.x, loc.y, predictLoc.x, predictLoc.y);
      ellipse(predictLoc.x, predictLoc.y, 4, 4);

      // Draw normal position
      fill(0);
      stroke(0);
      line(predictLoc.x, predictLoc.y, normalPoint.x, normalPoint.y);
      ellipse(normalPoint.x, normalPoint.y, 4, 4);
      stroke(0);
      if (distance > p.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x+dir.x, target.y+dir.y, 8, 8);
    }
  }
  
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }
  
  // Wraparound
  void borders(Path path) {
    if (loc.x > path.p.get(path.num-1).x + r) {
      loc.x = path.p.get(0).x - r;
      loc.y = path.p.get(0).y + (loc.y-path.p.get(path.num-1).y);
    }
  }
}