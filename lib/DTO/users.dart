class UserDTO {
  final String email;
  final String kind;
  final int luminosity;
  final String name;
  final int temperature;
  final List<dynamic> offices;

  const UserDTO({
    required this.email,
    required this.kind,
    required this.luminosity,
    required this.name,
    required this.temperature,
    required this.offices,
  });

  toJson() {
    return {
      "Email": email,
      "Kind": kind,
      "Luminosity": luminosity,
      "Name": name,
      "Temperature": temperature,
      "Offices": offices,
    };
  }
}
