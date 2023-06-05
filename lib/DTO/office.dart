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
  final bool heaterBoolAutomatic;
  final bool lightsBoolAutomatic;
  final int targetLuminosity;
  final int targetTemperature;
  final bool isEmpty;

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
    required this.heaterBoolAutomatic,
    required this.lightsBoolAutomatic,
    required this.targetLuminosity,
    required this.targetTemperature,
    required this.isEmpty,
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
      "automatic_Temperature": heaterBoolAutomatic,
      "automatic_light": lightsBoolAutomatic,
      "target_Luminosity": targetLuminosity,
      "target_Temperature": targetTemperature,
      "IsEmpty": isEmpty,
    };
  }
}
