enum ToolType { rock, hatchet, pickaxe }

class Tool {
  final String name;
  final String image;
  final ToolType type;
  final int power;
  final bool isMetal;

  Tool({
    required this.name,
    required this.image,
    required this.type,
    required this.power,
    this.isMetal = false,
  });

  static Tool rock(String asset) => Tool(
    name: "Rock", 
    image: asset, 
    type: ToolType.rock, 
    power: 1
  );
}