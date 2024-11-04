class EquipeDatabaseEntity {
  final int id; // ID autoincremental
  final int identificadorApi; // ID da API
  final String name; // Nome do Pokémon

  EquipeDatabaseEntity({
    required this.id,
    required this.identificadorApi,
    required this.name,
  });
}

abstract class EquipeDatabaseContract {
  static const String teamTable = "teamTable";
  static const String idColumn = "id";
  static const String identificadorApiColumn = "identificadorApi";
  static const String nameColumn = "name";
}
