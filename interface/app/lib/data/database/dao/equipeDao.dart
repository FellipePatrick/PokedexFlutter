import 'package:app/data/database/dao/baseDao.dart';
import 'package:app/data/database/entity/equipe_database_entity.dart';
import 'package:sqflite/sqflite.dart';

class TeamDao extends BaseDao {
  Future<List<EquipeDatabaseEntity>> selectAll() async {
    final Database db = await getDb();
    final List<Map<String, dynamic>> maps = await db.query(
      EquipeDatabaseContract.teamTable,
      orderBy: '${EquipeDatabaseContract.idColumn} ASC',
    );

    // Criar uma lista de EquipeDatabaseEntity a partir dos mapas retornados
    return List.generate(maps.length, (i) {
      return EquipeDatabaseEntity(
        id: maps[i][EquipeDatabaseContract.idColumn] as int,
        identificadorApi:
            maps[i][EquipeDatabaseContract.identificadorApiColumn] as int,
        name: maps[i][EquipeDatabaseContract.nameColumn] as String,
      );
    });
  }

  Future<void> insert(EquipeDatabaseEntity entity) async {
    final Database db = await getDb();
    await db.insert(
      EquipeDatabaseContract.teamTable,
      {
        EquipeDatabaseContract.identificadorApiColumn: entity.identificadorApi,
        EquipeDatabaseContract.nameColumn: entity.name,
      },
    );
  }

  Future<void> insertAll(List<EquipeDatabaseEntity> entities) async {
    final Database db = await getDb();
    await db.transaction((transaction) async {
      for (final entity in entities) {
        await transaction.insert(
          EquipeDatabaseContract.teamTable,
          {
            EquipeDatabaseContract.identificadorApiColumn:
                entity.identificadorApi,
            EquipeDatabaseContract.nameColumn: entity.name,
          },
        );
      }
    });
  }

  Future<void> deleteAll() async {
    final Database db = await getDb();
    await db.delete(EquipeDatabaseContract.teamTable);
  }
}
