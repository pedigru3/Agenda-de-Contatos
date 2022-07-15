const String tableContact = 'tableContact';

class ContactFields {
  static List<String> values = [
    columnId,
    columnName,
    columnImg,
    columnPhone,
    columnEmail
  ];

  static const String columnId = 'id';
  static const String columnName = 'name';
  static const String columnImg = 'img';
  static const String columnEmail = 'email';
  static const String columnPhone = 'phone';
}

class Contact {
  int? id;
  String? name;
  String? img;
  String? email;
  int? phone;

  Contact({
    this.id,
    this.name,
    this.img,
    this.email,
    this.phone,
  });

  Map<String, Object?> toJson() {
    Map<String, Object?> map = {
      ContactFields.columnEmail: email,
      ContactFields.columnImg: img,
      ContactFields.columnName: name,
      ContactFields.columnPhone: phone,
    };
    if (id != null) {
      map[ContactFields.columnId] = id;
    }
    return map;
  }

  static Contact fromJson(Map<String, Object?> json) => Contact(
      id: json[ContactFields.columnId] as int?,
      name: json[ContactFields.columnName] as String,
      img: json[ContactFields.columnImg] as String?,
      email: json[ContactFields.columnEmail] as String?,
      phone: json[ContactFields.columnPhone] as int?);

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
