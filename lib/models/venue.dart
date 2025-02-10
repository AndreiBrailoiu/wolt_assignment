class Venue {
  final String id;
  final String name;
  final String shortDescription;
  final String imageUrl;
  bool isFavorite;

  Venue({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.imageUrl,
    this.isFavorite = false,
  });

  // factory constructor to create a venue from JSON
  // factory does not always create a new instance, it can return an existing one
  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['venue']['id'],
      name: json['venue']['name'],
      shortDescription: json['venue']['short_description'],
      imageUrl: json['image']['url'],
    );
  }

  // added to be able to retrieve isFavorite from JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
