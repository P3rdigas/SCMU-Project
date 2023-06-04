class OfficeDTO {
  final String owner;
  final String name;
  final int blind;
  final bool isLightsOn;
  final int luminosity;
  final bool isHeaterOn;
  final int temperature;
  final List<dynamic> employees;
  final List<dynamic> employeesInRoom;

  const OfficeDTO({
    required this.owner,
    required this.name,
    required this.blind,
    required this.isLightsOn,
    required this.luminosity,
    required this.isHeaterOn,
    required this.temperature,
    required this.employees,
    required this.employeesInRoom,
  });

  toJson() {
    return {
      "Owner": owner,
      "Name": name,
      "Blind": blind,
      "Lights": isLightsOn,
      "Luminosity": luminosity,
      "Heater": isHeaterOn,
      "Temperature": temperature,
      "Employees": employees,
      "EmployeesInRoom": employeesInRoom,
    };
  }
}
