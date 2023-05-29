class RecordDTO {
  final DateTime day;
  final String name;
  final String type;

  const RecordDTO({
    required this.day,
    required this.name,
    required this.type,
  });

  toJson() {
    return {
      "Day": day,
      "Name": name,
      "Type": type,
    };
  }
}
