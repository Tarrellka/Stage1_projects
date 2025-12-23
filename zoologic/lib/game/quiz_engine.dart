import '../models/animal.dart';

class QuizEngine {
  final List<Animal> _allAnimals = [
    // EASY
    Animal(name: 'Слон', difficulty: Difficulty.easy, description: 'Огромное серое животное с хоботом и большими ушами.'),
    Animal(name: 'Жираф', difficulty: Difficulty.easy, description: 'У него самая длинная шея и он ест листья с верхушек деревьев.'),
    Animal(name: 'Зебра', difficulty: Difficulty.easy, description: 'Похожа на лошадку, но вся в черно-белую полоску.'),
    // MEDIUM
    Animal(name: 'Пингвин', difficulty: Difficulty.medium, description: 'Птица в "фракe", которая не летает, но отлично ныряет в ледяную воду.'),
    Animal(name: 'Верблюд', difficulty: Difficulty.medium, description: 'Житель пустыни с горбами, который может долго обходиться без воды.'),
    Animal(name: 'Хамелеон', difficulty: Difficulty.medium, description: 'Мастер маскировки, меняющий цвет кожи под окружающую среду.'),
    // HARD
    Animal(name: 'Утконос', difficulty: Difficulty.hard, description: 'Странный зверь из Австралии: имеет клюв утки, хвост бобра и откладывает яйца.'),
    Animal(name: 'Аксолотль', difficulty: Difficulty.hard, description: 'Розовая "водяная собака", которая всю жизнь выглядит как личинка и умеет отращивать лапы.'),
    Animal(name: 'Муравьед', difficulty: Difficulty.hard, description: 'Обладатель самого длинного языка и очень длинной морды, питается насекомыми.'),
  ];

  late List<Animal> _currentPool;
  late Animal currentAnimal;
  late List<String> options;
  late Difficulty selectedDifficulty;
  int score = 0;
  bool isFinished = false;

  void start(Difficulty difficulty) {
    selectedDifficulty = difficulty;
    _currentPool = _allAnimals.where((a) => a.difficulty == difficulty).toList()..shuffle();
    score = 0;
    isFinished = false;
    nextQuestion();
  }

  void nextQuestion() {
    if (_currentPool.isEmpty) {
      isFinished = true;
      return;
    }
    currentAnimal = _currentPool.removeLast();
    // 4 варианта для легкого/среднего, 6 вариантов для сложного
    int count = (selectedDifficulty == Difficulty.hard) ? 6 : 4;
    _generateOptions(count);
  }

  void _generateOptions(int count) {
    List<String> choices = [currentAnimal.name];
    List<String> others = _allAnimals.map((a) => a.name).toSet().toList();
    others.remove(currentAnimal.name);
    others.shuffle();
    
    choices.addAll(others.take(count - 1));
    choices.shuffle();
    options = choices;
  }

  bool checkAnswer(String name) {
    if (name == currentAnimal.name) {
      score++;
      return true;
    }
    return false;
  }
}