class RecordDTO {
  final DateTime day;
  final String email;
  final String type;

  const RecordDTO({
    required this.day,
    required this.email,
    required this.type,
  });

  toJson() {
    return {
      "Day": day,
      "Email": email,
      "Type": type,
    };
  }
}
