import 'package:app/data/database/entity/equipe_database_entity.dart';
import 'package:app/data/database/entity/pokemon_database_entity.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDao {
  static const databaseVersion = 1;
  static const _databaseName = 'pokemon_database.db';

  Database? _database;

  @protected
  Future<Database> getDb() async {
    _database ??= await _getDatabase();
    return _database!;
  }

  Future<Database> _getDatabase() async {
    try {
      print("Tentando abrir o banco de dados...");
      final dbPath = join(await getDatabasesPath(), _databaseName);

      return await openDatabase(
        dbPath,
        version: databaseVersion,
        onCreate: (db, version) async {
          final batch = db.batch();
          _createPokemonTableV1(batch);
          _createTeamTableV1(batch); // Garantir que essa tabela é criada
          await batch.commit();
          print("Banco de dados criado com sucesso!");
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          print(
              "Atualizando banco de dados da versão $oldVersion para $newVersion");
          if (oldVersion < 2) {
            await db.execute(
              "ALTER TABLE ${PokemonDatabaseContract.pokemonTable} ADD COLUMN ${PokemonDatabaseContract.hpColumn} INTEGER",
            );
            print("Colunas adicionais foram incluídas com sucesso.");
          }
        },
      );
    } catch (e) {
      print("Erro ao abrir o banco de dados: $e");
      rethrow;
    }
  }

  void _createPokemonTableV1(Batch batch) {
    batch.execute('''
      CREATE TABLE ${PokemonDatabaseContract.pokemonTable} (
        ${PokemonDatabaseContract.idColumn} INTEGER PRIMARY KEY,
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
    print("Tabela de Pokémons criada.");
  }

  void _createTeamTableV1(Batch batch) {
    batch.execute('''
    CREATE TABLE ${EquipeDatabaseContract.teamTable} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      ${EquipeDatabaseContract.identificadorApiColumn} INTEGER NOT NULL, 
      ${EquipeDatabaseContract.nameColumn} TEXT NOT NULL
    )
  ''');
    print("Tabela de equipes criada.");
  }
}
