class User {
  int? id;
  String? name;
  String? contact;
  String? description;
  User({this.id, this.name, this.contact, this.description});

  Map<String, dynamic> userMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'description': description
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'],
        name: map['name'],
        contact: map['contact'],
        description: map['description']);
  }
}
