class Todo {
  final String id;
  final String title;
  final String? description;
  final DateTime? deadline;
  final String category;
  final bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.description,
    this.deadline,
    required this.category,
    this.isDone = false,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    String? category,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      deadline: deadline ?? this.deadline,
      category: category ?? this.category,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    deadline:
        json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
    category: json['category'],
    isDone: json['isDone'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'deadlline': deadline,
    'category': category,
    'isDone': isDone,
  };
}
