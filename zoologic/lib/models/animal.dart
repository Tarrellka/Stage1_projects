enum Difficulty { easy, medium, hard }

class Animal {
  final String name;
  final String description;
  final Difficulty difficulty;

  Animal({
    required this.name, 
    required this.description, 
    required this.difficulty
  });
}