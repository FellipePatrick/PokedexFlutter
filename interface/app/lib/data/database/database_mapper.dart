import 'package:app/data/database/entity/pokemon_database_entity.dart';
import 'package:app/data/database/entity/equipe_database_entity.dart';
import 'package:app/domain/exception/mapper_exception.dart';
import 'package:app/domain/pokemon.dart';
import 'package:app/domain/team.dart';

class DatabaseMapper {
  // Função que converte uma entidade do banco de dados em uma instância de `Pokemon`
  Pokemon toPokemon(PokemonDatabaseEntity entity) {
    try {
      return Pokemon(
        name: entity.name,
        id: entity.id,
        type: entity.type.split(','), // Divide a string em uma lista
        base: Base(
          attack: entity.attack,
          defense: entity.defense,
          spAttack: entity.spAttack,
          spDefense: entity.spDefense,
          speed: entity.speed,
          hp: entity.hp,
        ),
      );
    } catch (e) {
      throw MapperException<PokemonDatabaseEntity, Pokemon>(e.toString());
    }
  }

  // Função que converte uma lista de entidades do banco de dados em uma lista de `Pokemon`
  List<Pokemon> toPokemons(List<PokemonDatabaseEntity> entities) {
    return entities.map(toPokemon).toList();
  }

  // Função que converte uma instância de `Pokemon` em uma entidade do banco de dados
  PokemonDatabaseEntity toPokemonDatabaseEntity(Pokemon pokemon) {
    try {
      return PokemonDatabaseEntity(
        id: pokemon.id,
        name: pokemon.name,
        type: pokemon.type.join(','), // Concatena a lista em uma string
        attack: pokemon.base.attack,
        defense: pokemon.base.defense,
        spAttack: pokemon.base.spAttack,
        spDefense: pokemon.base.spDefense,
        speed: pokemon.base.speed,
        hp: pokemon.base.hp,
      );
    } catch (e) {
      throw MapperException<Pokemon, PokemonDatabaseEntity>(e.toString());
    }
  }

  // Função que converte uma lista de `Pokemon` em uma lista de entidades do banco de dados
  List<PokemonDatabaseEntity> toPokemonDatabaseEntities(
      List<Pokemon> pokemons) {
    return pokemons.map(toPokemonDatabaseEntity).toList();
  }

  // Função que converte uma entidade do banco de dados em uma instância de `Team`
  Team toTeam(EquipeDatabaseEntity entity) {
    try {
      return Team(
        id: entity.id,
        identificadorApi: entity.identificadorApi,
        name: entity.name,
      );
    } catch (e) {
      throw MapperException<EquipeDatabaseEntity, Team>(e.toString());
    }
  }

  // Função que converte uma lista de entidades do banco de dados em uma lista de `Team`
  List<Team> toTeams(List<EquipeDatabaseEntity> entities) {
    return entities.map(toTeam).toList();
  }

  // Função que converte uma instância de `Team` em uma entidade do banco de dados
  EquipeDatabaseEntity toEquipeDatabaseEntity(Team team) {
    try {
      return EquipeDatabaseEntity(
        id: team.id,
        identificadorApi: team.identificadorApi,
        name: team.name,
      );
    } catch (e) {
      throw MapperException<Team, EquipeDatabaseEntity>(e.toString());
    }
  }

  // Função que converte uma lista de `Team` em uma lista de entidades do banco de dados
  List<EquipeDatabaseEntity> toEquipeDatabaseEntities(List<Team> teams) {
    return teams.map(toEquipeDatabaseEntity).toList();
  }
}
