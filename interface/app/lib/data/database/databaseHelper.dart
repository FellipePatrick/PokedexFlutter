import 'package:app/data/database/entity/equipe_database_entity.dart';
import 'package:app/data/database/entity/pokemon_database_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'pokemon_database.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ${EquipeDatabaseContract.teamTable} (
            ${EquipeDatabaseContract.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${EquipeDatabaseContract.identificadorApiColumn} INTEGER,
            ${EquipeDatabaseContract.nameColumn} TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE ${PokemonDatabaseContract.pokemonTable} (
            ${PokemonDatabaseContract.idColumn} TEXT PRIMARY KEY,
            ${PokemonDatabaseContract.nameColumn} TEXT,
            ${PokemonDatabaseContract.typeColumn} TEXT,
            ${PokemonDatabaseContract.hpColumn} INTEGER,
            ${PokemonDatabaseContract.attackColumn} INTEGER,
            ${PokemonDatabaseContract.defenseColumn} INTEGER,
            ${PokemonDatabaseContract.spAttackColumn} INTEGER,
            ${PokemonDatabaseContract.spDefenseColumn} INTEGER,
            ${PokemonDatabaseContract.speedColumn} INTEGER
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
              "ALTER TABLE ${PokemonDatabaseContract.pokemonTable} ADD COLUMN ${PokemonDatabaseContract.hpColumn} INTEGER");
        }
      },
    );
  }

  // Inserir Pokémon na tabela de Pokémon
  Future<void> insertPokemon(PokemonDatabaseEntity pokemon) async {
    final db = await database;
    await db.insert(
      PokemonDatabaseContract.pokemonTable,
      pokemon.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Selecionar todos os Pokémon do banco de dados
  Future<List<PokemonDatabaseEntity>> selectAllPokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(PokemonDatabaseContract.pokemonTable);
    return maps.map((map) => PokemonDatabaseEntity.fromJson(map)).toList();
  }

  // Selecionar Pokémon pelo ID
  Future<PokemonDatabaseEntity?> selectPokemonById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      PokemonDatabaseContract.pokemonTable,
      where: '${PokemonDatabaseContract.idColumn} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return PokemonDatabaseEntity.fromJson(maps.first);
    }
    return null;
  }

  // Inserir Pokémon na equipe
  Future<void> insertPokemonToEquipe(
      String identificadorApi, String name) async {
    final db = await database;
    await db.insert(
      EquipeDatabaseContract.teamTable,
      {
        EquipeDatabaseContract.identificadorApiColumn: identificadorApi,
        EquipeDatabaseContract.nameColumn: name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Selecionar todos os Pokémon da equipe
// Selecionar todos os Pokémon da equipe
  Future<List<int>> selectAllEquipePokemons() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query(EquipeDatabaseContract.teamTable);
    return maps
        .map((map) => map[EquipeDatabaseContract.identificadorApiColumn] as int)
        .toList();
  }

  // Remover Pokémon da equipe pelo ID
  Future<void> deletePokemonFromEquipe(String pokemonId) async {
    final db = await database;
    try {
      final result = await db.delete(
        EquipeDatabaseContract.teamTable,
        where: '${EquipeDatabaseContract.identificadorApiColumn} = ?',
        whereArgs: [pokemonId],
      );

      // Verifica se alguma linha foi afetada
      if (result == 0) {
        print('Nenhum Pokémon encontrado com o ID: $pokemonId');
      } else {
        print('Pokémon com ID: $pokemonId removido com sucesso!');
      }
    } catch (e) {
      print('Erro ao remover Pokémon: $e');
    }
  }

  // Contar Pokémon na equipe
  Future<int> getEquipeCount() async {
    final db = await database;
    return await db.transaction((txn) async {
      final result = await txn
          .rawQuery('SELECT COUNT(*) FROM ${EquipeDatabaseContract.teamTable}');
      int? count = Sqflite.firstIntValue(result);
      return count ?? 0;
    });
  }

  deletePokemon(int id) {}
}
