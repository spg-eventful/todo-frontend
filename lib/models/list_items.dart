class ListItems {
  final int id;
  final String title;
  final String description;

  ListItems({required this.id, required this.title, required this.description});

  ListItems.fromJson(Map<String, dynamic> json)
      : id = json["id"] as int,
        title = json["title"] as String,
        description = json["description"] as String;

  Map<String, dynamic> toJson() =>
      {'id': id, 'title': title, 'description': description};
}