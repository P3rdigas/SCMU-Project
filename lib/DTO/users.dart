class UserDTO {
  final String email;
  final String kind;
  final int luminosity;
  final String name;
  final int temperature;
  final List<dynamic> offices;
  final List<dynamic> inOffice;

  const UserDTO({
    required this.email,
    required this.kind,
    required this.luminosity,
    required this.name,
    required this.temperature,
    required this.offices,
    required this.inOffice,
  });

  toJson() {
    return {
      "Email": email,
      "Kind": kind,
      "Luminosity": luminosity,
      "Name": name,
      "Temperature": temperature,
      "Offices": offices,
      "InOffice": inOffice,
    };
  }
}
