// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [username, uuid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(Insertable<User> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String username;
  final String uuid;
  const User({required this.username, required this.uuid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['username'] = Variable<String>(username);
    map['uuid'] = Variable<String>(uuid);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      username: Value(username),
      uuid: Value(uuid),
    );
  }

  factory User.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      username: serializer.fromJson<String>(json['username']),
      uuid: serializer.fromJson<String>(json['uuid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'username': serializer.toJson<String>(username),
      'uuid': serializer.toJson<String>(uuid),
    };
  }

  User copyWith({String? username, String? uuid}) => User(
        username: username ?? this.username,
        uuid: uuid ?? this.uuid,
      );
  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('username: $username, ')
          ..write('uuid: $uuid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(username, uuid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.username == this.username &&
          other.uuid == this.uuid);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> username;
  final Value<String> uuid;
  final Value<int> rowid;
  const UsersCompanion({
    this.username = const Value.absent(),
    this.uuid = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String username,
    required String uuid,
    this.rowid = const Value.absent(),
  })  : username = Value(username),
        uuid = Value(uuid);
  static Insertable<User> custom({
    Expression<String>? username,
    Expression<String>? uuid,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (username != null) 'username': username,
      if (uuid != null) 'uuid': uuid,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith(
      {Value<String>? username, Value<String>? uuid, Value<int>? rowid}) {
    return UsersCompanion(
      username: username ?? this.username,
      uuid: uuid ?? this.uuid,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('username: $username, ')
          ..write('uuid: $uuid, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _usernameMeta =
      const VerificationMeta('username');
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
      'username', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      $customConstraints: 'REFERENCES users(username)');
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datetimeMeta =
      const VerificationMeta('datetime');
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _photoMeta = const VerificationMeta('photo');
  @override
  late final GeneratedColumn<Uint8List> photo = GeneratedColumn<Uint8List>(
      'photo', aliasedName, true,
      type: DriftSqlType.blob, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [username, description, datetime, photo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(Insertable<DiaryEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('username')) {
      context.handle(_usernameMeta,
          username.isAcceptableOrUnknown(data['username']!, _usernameMeta));
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('photo')) {
      context.handle(
          _photoMeta, photo.isAcceptableOrUnknown(data['photo']!, _photoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  DiaryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntry(
      username: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}username'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}datetime'])!,
      photo: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}photo']),
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }
}

class DiaryEntry extends DataClass implements Insertable<DiaryEntry> {
  final String username;
  final String description;
  final DateTime datetime;
  final Uint8List? photo;
  const DiaryEntry(
      {required this.username,
      required this.description,
      required this.datetime,
      this.photo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['username'] = Variable<String>(username);
    map['description'] = Variable<String>(description);
    map['datetime'] = Variable<DateTime>(datetime);
    if (!nullToAbsent || photo != null) {
      map['photo'] = Variable<Uint8List>(photo);
    }
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      username: Value(username),
      description: Value(description),
      datetime: Value(datetime),
      photo:
          photo == null && nullToAbsent ? const Value.absent() : Value(photo),
    );
  }

  factory DiaryEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntry(
      username: serializer.fromJson<String>(json['username']),
      description: serializer.fromJson<String>(json['description']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      photo: serializer.fromJson<Uint8List?>(json['photo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'username': serializer.toJson<String>(username),
      'description': serializer.toJson<String>(description),
      'datetime': serializer.toJson<DateTime>(datetime),
      'photo': serializer.toJson<Uint8List?>(photo),
    };
  }

  DiaryEntry copyWith(
          {String? username,
          String? description,
          DateTime? datetime,
          Value<Uint8List?> photo = const Value.absent()}) =>
      DiaryEntry(
        username: username ?? this.username,
        description: description ?? this.description,
        datetime: datetime ?? this.datetime,
        photo: photo.present ? photo.value : this.photo,
      );
  @override
  String toString() {
    return (StringBuffer('DiaryEntry(')
          ..write('username: $username, ')
          ..write('description: $description, ')
          ..write('datetime: $datetime, ')
          ..write('photo: $photo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      username, description, datetime, $driftBlobEquality.hash(photo));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntry &&
          other.username == this.username &&
          other.description == this.description &&
          other.datetime == this.datetime &&
          $driftBlobEquality.equals(other.photo, this.photo));
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntry> {
  final Value<String> username;
  final Value<String> description;
  final Value<DateTime> datetime;
  final Value<Uint8List?> photo;
  final Value<int> rowid;
  const DiaryEntriesCompanion({
    this.username = const Value.absent(),
    this.description = const Value.absent(),
    this.datetime = const Value.absent(),
    this.photo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    required String username,
    required String description,
    required DateTime datetime,
    this.photo = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : username = Value(username),
        description = Value(description),
        datetime = Value(datetime);
  static Insertable<DiaryEntry> custom({
    Expression<String>? username,
    Expression<String>? description,
    Expression<DateTime>? datetime,
    Expression<Uint8List>? photo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (username != null) 'username': username,
      if (description != null) 'description': description,
      if (datetime != null) 'datetime': datetime,
      if (photo != null) 'photo': photo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryEntriesCompanion copyWith(
      {Value<String>? username,
      Value<String>? description,
      Value<DateTime>? datetime,
      Value<Uint8List?>? photo,
      Value<int>? rowid}) {
    return DiaryEntriesCompanion(
      username: username ?? this.username,
      description: description ?? this.description,
      datetime: datetime ?? this.datetime,
      photo: photo ?? this.photo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (datetime.present) {
      map['datetime'] = Variable<DateTime>(datetime.value);
    }
    if (photo.present) {
      map['photo'] = Variable<Uint8List>(photo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('username: $username, ')
          ..write('description: $description, ')
          ..write('datetime: $datetime, ')
          ..write('photo: $photo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $UsersTable users = $UsersTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [users, diaryEntries];
}
