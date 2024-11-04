import 'package:json_annotation/json_annotation.dart';

part 'pokemon_database_entity.g.dart';

@JsonSerializable()
class PokemonDatabaseEntity {
  @JsonKey(name: PokemonDatabaseContract.idColumn)
  final int id;

  @JsonKey(name: PokemonDatabaseContract.nameColumn)
  final String name;

  @JsonKey(name: PokemonDatabaseContract.typeColumn)
  final String type; // Alterado para String

  final int hp;
  final int attack;
  final int defense;
  final int spAttack;
  final int spDefense;
  final int speed;

  PokemonDatabaseEntity({
    required this.id,
    required this.name,
    required this.type, // Agora é uma String
    required this.hp,
    required this.attack,
    required this.defense,
    required this.spAttack,
    required this.spDefense,
    required this.speed,
  });

  // Métodos para serialização e deserialização JSON
  factory PokemonDatabaseEntity.fromJson(Map<String, dynamic> json) =>
      _$PokemonDatabaseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$PokemonDatabaseEntityToJson(this);
}

// Contrato do banco de dados, contendo constantes para colunas e tabelas
abstract class PokemonDatabaseContract {
  static const String pokemonTable = "pokemon_table";
  static const String idColumn = "id";
  static const String nameColumn = "name";
  static const String typeColumn = "type";
  static const String hpColumn = "hp";
  static const String attackColumn = "attack";
  static const String defenseColumn = "defense";
  static const String spAttackColumn = "spAttack";
  static const String spDefenseColumn = "spDefense";
  static const String speedColumn = "speed";
}
