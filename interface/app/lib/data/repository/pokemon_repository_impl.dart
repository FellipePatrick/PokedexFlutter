import 'package:app/data/database/dao/PokemonDao.dart';
import 'package:app/data/database/database_mapper.dart';
import 'package:app/data/database/entity/pokemon_database_entity.dart';
import 'package:app/data/network/client/api_client.dart';
import 'package:app/data/network/network_mapper.dart';
import 'package:app/data/repository/pokemon_repository.dart';
import '../../domain/pokemon.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final ApiClient apiClient;
  final NetworkMapper networkMapper;
  final PokemonDao pokemonDao;
  final DatabaseMapper databaseMapper;

  PokemonRepositoryImpl({
    required this.pokemonDao,
    required this.databaseMapper,
    required this.apiClient,
    required this.networkMapper,
  });

  Future<List<Pokemon>> getPokemons({
    required int page,
    required int limit,
  }) async {
    try {
      // Carrega do banco de dados local
      final pokemonsFromDb = await _loadFromDatabase(page, limit);
      if (pokemonsFromDb.isNotEmpty) {
        return pokemonsFromDb;
      }

      // Carrega da API remota e salva no banco de dados
      return await _loadFromApiAndCache(page, limit);
    } catch (e) {
      print('Erro ao carregar Pokémons: $e');
      throw Exception('Falha ao carregar Pokémons');
    }
  }

  Future<List<Pokemon>> _loadFromDatabase(int page, int limit) async {
    final dbEntities = await pokemonDao.selectAll(
      limit: limit,
      offset: (page - 1) * limit, // Corrigido o cálculo do offset
    );
    return dbEntities.isNotEmpty ? databaseMapper.toPokemons(dbEntities) : [];
  }

  Future<List<Pokemon>> _loadFromApiAndCache(int page, int limit) async {
    final networkEntity = await apiClient.getPokemons(page: page, limit: limit);
    final pokemons = networkMapper.toPokemons(networkEntity);
    await pokemonDao
        .insertAll(databaseMapper.toPokemonDatabaseEntities(pokemons));
    return pokemons;
  }

  Future<Pokemon> getPokemonById(int id) async {
    try {
      final networkEntity = await apiClient.getPokemonById(id);
      // Verifica se a entidade retornada não é nula
      if (networkEntity == null) {
        throw Exception('Pokémon não encontrado');
      }

      final pokemon = networkMapper.toPokemon(networkEntity);
      await pokemonDao.insert(databaseMapper.toPokemonDatabaseEntity(pokemon));
      return pokemon;
    } catch (e) {
      print('Erro ao carregar Pokémon com ID $id: $e');
      throw Exception('Falha ao carregar Pokémon');
    }
  }
}