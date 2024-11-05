import 'package:app/data/database/dao/baseDao.dart';
import 'package:app/data/database/entity/pokemon_database_entity.dart';
import 'package:sqflite/sqflite.dart';

class PokemonDao extends BaseDao {
  Future<List<PokemonDatabaseEntity>> selectAll({
    int? limit,
    int? offset,
  }) async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      PokemonDatabaseContract.pokemonTable,
      limit: limit,
      offset: offset,
      orderBy: '${PokemonDatabaseContract.idColumn} ASC',
    );
    return List.generate(maps.length, (i) {
      return PokemonDatabaseEntity.fromJson(maps[i]);
    });
  }

  Future<int> count() async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM ${PokemonDatabaseContract.pokemonTable}',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> insert(PokemonDatabaseEntity entity) async {
    final Database db = await getDb();
    await db.insert(PokemonDatabaseContract.pokemonTable, entity.toJson());
  }

  Future<void> insertAll(List<PokemonDatabaseEntity> entities) async {
    final Database db = await getDb();
    await db.transaction((transaction) async {
      for (final entity in entities) {
        transaction.insert(
            PokemonDatabaseContract.pokemonTable, entity.toJson());
      }
    });
  }

  Future<void> deleteAll() async {
    final Database db = await getDb();
    await db.delete(PokemonDatabaseContract.pokemonTable);
  }

  Future<PokemonDatabaseEntity?> selectById(int id) async {
    final Database db = await getDb();

    try {
      final List<Map<String, dynamic>> maps = await db.query(
        PokemonDatabaseContract.pokemonTable,
        where: '${PokemonDatabaseContract.idColumn} = ?',
        whereArgs: [id],
      );

      print('Resultado da consulta para ID $id: $maps');

      if (maps.isNotEmpty) {
        return PokemonDatabaseEntity.fromJson(maps.first);
      } else {
        return null;
      }
    } catch (e) {
      print('Erro ao executar selectById para ID $id: $e');
      return null;
    }
  }
}
