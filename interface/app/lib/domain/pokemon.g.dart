// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PokemonImpl _$$PokemonImplFromJson(Map<String, dynamic> json) =>
    _$PokemonImpl(
      name: json['name'] as String,
      id: (json['id'] as num).toInt(),
      type: (json['type'] as List<dynamic>).map((e) => e as String).toList(),
      base: Base.fromJson(json['base'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PokemonImplToJson(_$PokemonImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'id': instance.id,
      'type': instance.type,
      'base': instance.base,
    };

_$BaseImpl _$$BaseImplFromJson(Map<String, dynamic> json) => _$BaseImpl(
      attack: (json['attack'] as num).toInt(),
      defense: (json['defense'] as num).toInt(),
      hp: (json['hp'] as num).toInt(),
      spAttack: (json['spAttack'] as num).toInt(),
      spDefense: (json['spDefense'] as num).toInt(),
      speed: (json['speed'] as num).toInt(),
    );

Map<String, dynamic> _$$BaseImplToJson(_$BaseImpl instance) =>
    <String, dynamic>{
      'attack': instance.attack,
      'defense': instance.defense,
      'hp': instance.hp,
      'spAttack': instance.spAttack,
      'spDefense': instance.spDefense,
      'speed': instance.speed,
    };
