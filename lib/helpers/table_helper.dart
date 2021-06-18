import 'sql_helper.dart' as sql;
import 'models.dart' show ModelBase;

typedef FnFrom<T extends ModelBase> = T Function(Map<String, dynamic>);

abstract class TableBaseEntity<T extends ModelBase> {
  final FnFrom<T> from;
  TableBaseEntity(this.from);

  Future<List<T>> select({int pageNum = 0, String orderBy = 'id ASC'});

  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy = 'id ASC'});

  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'});

  Future<bool> insert(T item);

  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs);

  Future<bool> delete(String id);
}

class SqlTableEntity<T extends ModelBase> extends TableBaseEntity<T> {
  static const PAGE_LEN = 25;
  final String tableName;
  SqlTableEntity(this.tableName, FnFrom<T> fnFrom) : super(fnFrom);

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy = 'id ASC'}) async =>
      sql.query(tableName, from,
          orderBy: orderBy, limit: PAGE_LEN, offset: pageNum * PAGE_LEN);

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
          {int pageNum = 0, String orderBy = 'id ASC'}) async =>
      sql.query(tableName, from,
          where: _where,
          whereArgs: whereArgs,
          orderBy: orderBy,
          limit: PAGE_LEN,
          offset: pageNum * PAGE_LEN);

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'}) async {
    final res = (await sql.query(tableName, from,
        where: _where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: 1,
        offset: 0));
    return res != null && res.length == 1 ? res.first : null;
  }

  @override
  Future<bool> insert(T item) async => (await sql.insert(tableName, item)) > 0;

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async =>
      (await sql.delete(tableName, _where, whereArgs)) > 0;

  @override
  Future<bool> delete(String id) async => deleteWhere('id = ?', [id]);
}

class SafeTableEntity<T extends ModelBase> extends TableBaseEntity<T> {
  List<Map<String, dynamic>> _itemStore = [];
  SafeTableEntity(FnFrom<T> fnFrom) : super(fnFrom);

  @override
  Future<List<T>> select({int pageNum = 0, String orderBy = 'id ASC'}) async =>
      _itemStore.map((m) => from(m)).toList();

  @override
  Future<List<T>> selectWhere(String _where, List<dynamic> whereArgs,
      {int pageNum = 0, String orderBy = 'id ASC'}) async {
    if (whereArgs.length == 1) {
      final cond = _where.replaceAll('= ?', '').trim();
      final ls = _itemStore.where((m) => m[cond] == whereArgs[0]);
      return ls.map((m) => from(m)).toList();
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<T> single(String _where, List<dynamic> whereArgs,
      {String orderBy = 'id ASC'}) async {
    final ls = await selectWhere(_where, whereArgs, orderBy: orderBy);
    return ls != null && ls.length > 0 ? ls.last : null;
  }

  @override
  Future<bool> insert(T item) async {
    _itemStore.add(item.map);
    return exists('id', item.getId);
  }

  @override
  Future<bool> deleteWhere(String _where, List<dynamic> whereArgs) async {
    if (whereArgs.length == 1) {
      final cond = _where.replaceAll('= ?', '').trim();
      _itemStore.removeWhere((m) => m[cond] == whereArgs[0]);
      return !(await exists(cond, whereArgs[0]));
    } else
      return throw Exception('yorma beni birader!');
  }

  @override
  Future<bool> delete(String id) async => deleteWhere('id = ?', [id]);

  Future<bool> exists(String key, dynamic value) async =>
      _itemStore.any((m) => m[key] == value);
}
