import 'dart:math';

double applyGravity(double velocity, double gravity, double elapsedTime, double mass, double maxSpeed) {
  velocity += gravity * mass * elapsedTime;
  return velocity > maxSpeed ? maxSpeed : velocity;
}

bool fiftyFifty() {
  Random random = Random();
  return random.nextInt(2) == 1;
}