double applyGravity(double velocity, double gravity, double elapsedTime, double mass, double maxSpeed) {
  velocity += gravity * mass * elapsedTime;
  return velocity > maxSpeed ? maxSpeed : velocity;
}
