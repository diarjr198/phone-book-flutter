class Contact {
  String id = '';
  String id_user = '';
  String name = '';
  String phone = '';
  String company = '';
  String job = '';
  String email = '';
  String favorite = '';

  Contact({
    required this.id,
    required this.id_user,
    required this.name,
    required this.phone,
    required this.company,
    required this.job,
    required this.email,
    required this.favorite,
  });

  Contact.fromJson(json) {
    id = json['_id'];
    id_user = json['id_user'];
    name = json['name'];
    phone = json['telp'];
    company = json['company'];
    job = json['job'];
    email = json['email'];
    favorite = json['favorite'];
  }
}
