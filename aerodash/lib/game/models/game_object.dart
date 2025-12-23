class GameObject {
  double x;
  double y;
  double width;
  double height;

  GameObject({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  // Проверка столкновения (Rect vs Rect)
  bool collidesWith(GameObject other) {
    return x < other.x + other.width &&
           x + width > other.x &&
           y < other.y + other.height &&
           y + height > other.y;
  }
}