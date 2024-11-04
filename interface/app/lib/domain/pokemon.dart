import 'package:app/data/network/entity/http_paged_result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
class Pokemon with _$Pokemon {
  const factory Pokemon({
    required String name,
    required int id,
    required List<String> type,
    required Base base,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);
}

@freezed
class Base with _$Base {
  const factory Base({
    required int attack,
    required int defense,
    required int hp,
    required int spAttack,
    required int spDefense,
    required int speed,
  }) = _Base;

  factory Base.fromJson(Map<String, dynamic> json) => _$BaseFromJson(json);
}
