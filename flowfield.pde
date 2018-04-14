float scl = 30;
int rows, cols;
int numberOfParticles = 10000;
Particle[] pars;
PVector[] flow;
void setup() {
  size(3800, 2100);
  background(0);
  hint(DISABLE_DEPTH_MASK);

  rows = floor(width / scl);
  cols = floor(height / scl);
  flow = new PVector[(cols * rows)];

  pars = new Particle[numberOfParticles];
  for (int numPar = 0; numPar < pars.length; numPar++) {
    pars[numPar] = new Particle();
  }
}

float inc = 0.1;
float speed = 5;
float xoff;
float yoff;
float zoff;

void draw() {
  strokeWeight(5);
  yoff = 0;
  for (int y = 0; y < rows; y++) {
    xoff = 0;
    for (int x = 0; x < cols; x++) {
      float angle = noise(xoff, yoff, zoff) * TWO_PI * 4;
      PVector v = PVector.fromAngle(angle);
      v.setMag(0.1);
      int index = (x + y * cols);
      flow[index] = v;
      xoff += inc;

      //stroke(255);
      //pushMatrix();
      //translate(y * scl, x * scl);
      //rotate(v.heading());
      //line(0, 0, scl, 0);
      //popMatrix();
    }
    yoff += inc;
  }
  //zoff += 0.0005;

  for (int numPar = 0; numPar < pars.length; numPar++) {
    pars[numPar].Follow(flow);
    pars[numPar].Update();
    pars[numPar].Edges();
    pars[numPar].Show();
  }
}

/////////////////////////
class Particle {
  PVector pos, vel, acc;
  int maxSpeed = 4;

  Particle() {
    pos = new PVector (random(width), random(height));
    vel = new PVector (0, 0);
    acc = new PVector (0, 0);
  }
  void Update() {
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(vel);
    acc.mult(0);
  }

  void ApplyForce(PVector force) {
    acc.add(force);
  }

  void Show() {
    stroke(255, 5);
    strokeWeight(3);
    point(pos.x, pos.y);
  }

  void Edges() {
    if (pos.x > width) pos.x = 0;
    if (pos.x < 0) pos.x = width;
    if (pos.y > height) pos.y = 0;
    if (pos.y < 0) pos.y = height;
  }
  void Follow(PVector[] flow) {
    int x = floor(pos.x / scl);
    int y = floor(pos.y / scl);

    int index = (x-1) + ((y-1) * cols);
    index = index - 1;
    if (index > flow.length || index < 0) {
      index = flow.length - 1;
    }
    PVector force = flow[index];
    ApplyForce(force);
  }
}
