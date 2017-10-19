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
    fill(0, 255, 0);
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

    // Predict position 50 (arbitrary choice) frames ahead
    // This could be based on speed 
    PVector predict = vel.get();
    predict.normalize();
    predict.mult(30);
    PVector predictpos = PVector.add(loc, predict);

    // Now we must find the normal to the path from the predicted position
    // We look at the normal for each line segment and pick out the closest one

    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  // Start with a very high record distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < p.points.size()-1; i++) {

      // Look at a line segment
      PVector a = p.points.get(i);
      PVector b = p.points.get(i+1);

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictpos, a, b);
      // This only works because we know our path goes from left to right
      // We could have a more sophisticated test to tell if the point is in the line segment or not
      if (normalPoint.x < a.x || normalPoint.x > b.x) {
        // This is something of a hacky solution, but if it's not within the line segment
        // consider the normal to just be the end of the line segment (point b)
        normalPoint = b.get();
      }

      // How far away are we from the path?
      float distance = PVector.dist(predictpos, normalPoint);
      // Did we beat the record and find the closest line segment?
      if (distance < worldRecord) {
        worldRecord = distance;
        // If so the target we want to steer towards is the normal
        normal = normalPoint;

        // Look at the direction of the line segment so we can seek a little bit ahead of the normal
        PVector dir = PVector.sub(b, a);
        dir.normalize();
        // This is an oversimplification
        // Should be based on distance to path & velocity
        dir.mult(10);
        target = normalPoint.get();
        target.add(dir);
      }
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > p.radius) {
      seek(target);
    }


    // Draw the debugging stuff
    if (debug) {
      // Draw predicted future position
      stroke(0);
      fill(0);
      line(loc.x, loc.y, predictpos.x, predictpos.y);
      ellipse(predictpos.x, predictpos.y, 4, 4);

      // Draw normal position
      stroke(0);
      fill(0);
      ellipse(normal.x, normal.y, 4, 4);
      // Draw actual target (red if steering towards it)
      line(predictpos.x, predictpos.y, normal.x, normal.y);
      if (worldRecord > p.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x, target.y, 8, 8);
    }
  }



  // Wraparound
  void borders(Path path) {
    if (loc.x > path.points.get(path.num-1).x + r) {
      loc.x = path.points.get(0).x - r;
      loc.y = path.points.get(0).y + (loc.y-path.points.get(path.num-1).y);
    }
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