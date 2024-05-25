class Breed {
  final String id;
  final String type;
  final String name;
  final String description;
  final LifeSpan life;
  final Weight maleWeight;
  final Weight femaleWeight;
  final bool hypoallergenic;
  final Group group;

  Breed({
    required this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.life,
    required this.maleWeight,
    required this.femaleWeight,
    required this.hypoallergenic,
    required this.group,
  });

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      type: json['type'],
      name: json['attributes']['name'],
      description: json['attributes']['description'],
      life: LifeSpan.fromJson(json['attributes']['life']),
      maleWeight: Weight.fromJson(json['attributes']['male_weight']),
      femaleWeight: Weight.fromJson(json['attributes']['female_weight']),
      hypoallergenic: json['attributes']['hypoallergenic'],
      group: Group.fromJson(json['relationships']['group']['data']),
    );
  }
}

class LifeSpan {
  final int min;
  final int max;

  LifeSpan({
    required this.min,
    required this.max,
  });

  factory LifeSpan.fromJson(Map<String, dynamic> json) {
    return LifeSpan(
      min: json['min'],
      max: json['max'],
    );
  }
}

class Weight {
  final int min;
  final int max;

  Weight({
    required this.min,
    required this.max,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
      min: json['min'],
      max: json['max'],
    );
  }
}

class Group {
  final String id;
  final String type;

  Group({
    required this.id,
    required this.type,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      type: json['type'],
    );
  }
}
