import 'package:app/domain/exception/mapper_exception.dart';
import 'package:app/domain/pokemon.dart' as domain;
import 'package:app/domain/pokemon.dart' hide Base;
import 'entity/http_paged_result.dart';

class NetworkMapper {
  Pokemon toPokemon(PokemonEntity entity) {
    try {
      return Pokemon(
        name: entity.name.english, // Assume que 'name' é um Map
        id: entity.id,
        type: List<String>.from(
            entity.type), // Garante que é uma lista de Strings
        base: _toDomainBase(entity.base), // Objeto Base
      );
    } catch (e) {
      throw MapperException<PokemonEntity, Pokemon>(e.toString());
    }
  }

  domain.Base _toDomainBase(Base entityBase) {
    return domain.Base(
      hp: entityBase.hp,
      attack: entityBase.attack,
      defense: entityBase.defense,
      spAttack: entityBase.spAttack,
      spDefense: entityBase.spDefense,
      speed: entityBase.speed,
    );
  }

  List<Pokemon> toPokemons(List<PokemonEntity> entities) {
    return entities.map((entity) => toPokemon(entity)).toList();
  }
}
