class Attendece {
  final String subname;
  final String subcode;
  bool attended;

  Attendece({
    required this.subname,
    required this.subcode,
    required this.attended,
  });

  // Convert the object to a map
  Map<String, dynamic> toMap() {
    return {
      'subname': subname,
      'subcode': subcode,
      'attended': attended,
    };
  }

  // Factory method to create an Attendece object from a map
  factory Attendece.fromMap(Map<String, dynamic> map) {
    return Attendece(
      subname: map['subname'],
      subcode: map['subcode'],
      attended: map['attended'],
    );
  }
}
