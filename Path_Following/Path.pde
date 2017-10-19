class Path {

  // A Path is line between two points (PVector objects)
  ArrayList<PVector> p; 
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  int num=60;
  float t=0;

  Path() {
    // Arbitrary radius of 20
    radius = 30;
    p = new ArrayList<PVector>();
    for (int i=0; i<num; i++) {
      PVector temp = new PVector(map(i, 0, num, 0, width), map(noise(t*i), 0, 1, 0, height));
      p.add(temp);
      t+=0.0003;
    }
  }

  // Draw the path
  void display() {

    for (int i=0; i < num-1; i++) {
      strokeWeight(radius*2);
      stroke(200);
      PVector prev = p.get(i);
      PVector next = p.get(i+1);
      line(prev.x, prev.y, next.x, next.y);
      strokeWeight(1);
      stroke(0);
      line(prev.x, prev.y, next.x, next.y);
    }
    for (int i=0; i < num-1; i++) {
      PVector prev = p.get(i);
      PVector next = p.get(i+1);
      strokeWeight(1);
      stroke(0);
      line(prev.x, prev.y, next.x, next.y);
    }
  }

  PVector getStart(PVector predictLoc) {
    float minD = 100000;
    int loc=0;
    for (int i=0; i < num-1; i++) {
      PVector temp = p.get(i);
      float d = predictLoc.dist(temp);
      if ( d < minD ) {
        minD = d;
        loc = i;
      }
    }
    PVector temp1 = p.get(loc);
    return temp1;
  }

  PVector getEnd(PVector predictLoc) {
    float minD = 100000;
    int loc=0;
    for (int i=0; i < num-1; i++) {
      float d = predictLoc.dist(p.get(i));
      if ( d < minD ) {
        minD = d;
        loc = i;
      }
    }
    if (loc==num-1) loc=num-2;
    PVector temp = p.get(loc+1);
    return temp;
  }

  void newPath() {
    p = new ArrayList<PVector>();
    for (int i=0; i<num; i++) {
      PVector temp = new PVector(map(i, 0, num, 0, width), map(noise(t*i), 0, 1, 0, height));
      p.add(temp);
      t+=0.0003;
    }
  }
}