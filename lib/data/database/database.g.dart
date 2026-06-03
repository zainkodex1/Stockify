// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    passwordHash,
    role,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passwordHashMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final int id;
  final String username;
  final String passwordHash;
  final String role;
  final bool isActive;
  const User({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.role,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password_hash'] = Variable<String>(passwordHash);
    map['role'] = Variable<String>(role);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      username: Value(username),
      passwordHash: Value(passwordHash),
      role: Value(role),
      isActive: Value(isActive),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      passwordHash: serializer.fromJson<String>(json['passwordHash']),
      role: serializer.fromJson<String>(json['role']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'passwordHash': serializer.toJson<String>(passwordHash),
      'role': serializer.toJson<String>(role),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? passwordHash,
    String? role,
    bool? isActive,
  }) => User(
    id: id ?? this.id,
    username: username ?? this.username,
    passwordHash: passwordHash ?? this.passwordHash,
    role: role ?? this.role,
    isActive: isActive ?? this.isActive,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      role: data.role.present ? data.role.value : this.role,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, username, passwordHash, role, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.username == this.username &&
          other.passwordHash == this.passwordHash &&
          other.role == this.role &&
          other.isActive == this.isActive);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> passwordHash;
  final Value<String> role;
  final Value<bool> isActive;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.role = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  UsersCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String passwordHash,
    required String role,
    this.isActive = const Value.absent(),
  }) : username = Value(username),
       passwordHash = Value(passwordHash),
       role = Value(role);
  static Insertable<User> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? passwordHash,
    Expression<String>? role,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (role != null) 'role': role,
      if (isActive != null) 'is_active': isActive,
    });
  }

  UsersCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? passwordHash,
    Value<String>? role,
    Value<bool>? isActive,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('role: $role, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String value;
  const Setting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? key, String? value}) =>
      Setting(key: key ?? this.key, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    description,
    imageUrl,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int? parentId;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  const Category({
    required this.id,
    required this.name,
    this.parentId,
    this.description,
    this.imageUrl,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      createdAt: Value(createdAt),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      description: serializer.fromJson<String?>(json['description']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<int?>(parentId),
      'description': serializer.toJson<String?>(description),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    Value<int?> parentId = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<String?> imageUrl = const Value.absent(),
    DateTime? createdAt,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    description: description.present ? description.value : this.description,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    createdAt: createdAt ?? this.createdAt,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      description: data.description.present
          ? data.description.value
          : this.description,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, parentId, description, imageUrl, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.description == this.description &&
          other.imageUrl == this.imageUrl &&
          other.createdAt == this.createdAt);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> parentId;
  final Value<String?> description;
  final Value<String?> imageUrl;
  final Value<DateTime> createdAt;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.parentId = const Value.absent(),
    this.description = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? parentId,
    Expression<String>? description,
    Expression<String>? imageUrl,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (description != null) 'description': description,
      if (imageUrl != null) 'image_url': imageUrl,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? parentId,
    Value<String?>? description,
    Value<String?>? imageUrl,
    Value<DateTime>? createdAt,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('description: $description, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MedicinesTable extends Medicines
    with TableInfo<$MedicinesTable, Medicine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MedicinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _mainCategoryMeta = const VerificationMeta(
    'mainCategory',
  );
  @override
  late final GeneratedColumn<String> mainCategory = GeneratedColumn<String>(
    'main_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('General'),
  );
  static const VerificationMeta _subCategoryMeta = const VerificationMeta(
    'subCategory',
  );
  @override
  late final GeneratedColumn<String> subCategory = GeneratedColumn<String>(
    'sub_category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _manufacturerMeta = const VerificationMeta(
    'manufacturer',
  );
  @override
  late final GeneratedColumn<String> manufacturer = GeneratedColumn<String>(
    'manufacturer',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minStockMeta = const VerificationMeta(
    'minStock',
  );
  @override
  late final GeneratedColumn<int> minStock = GeneratedColumn<int>(
    'min_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genericNameMeta = const VerificationMeta(
    'genericName',
  );
  @override
  late final GeneratedColumn<String> genericName = GeneratedColumn<String>(
    'generic_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strengthMeta = const VerificationMeta(
    'strength',
  );
  @override
  late final GeneratedColumn<String> strength = GeneratedColumn<String>(
    'strength',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dosageFormMeta = const VerificationMeta(
    'dosageForm',
  );
  @override
  late final GeneratedColumn<String> dosageForm = GeneratedColumn<String>(
    'dosage_form',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseUnitNameMeta = const VerificationMeta(
    'baseUnitName',
  );
  @override
  late final GeneratedColumn<String> baseUnitName = GeneratedColumn<String>(
    'base_unit_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Unit'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    code,
    mainCategory,
    subCategory,
    manufacturer,
    description,
    minStock,
    brand,
    model,
    genericName,
    strength,
    dosageForm,
    baseUnitName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'medicines';
  @override
  VerificationContext validateIntegrity(
    Insertable<Medicine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('main_category')) {
      context.handle(
        _mainCategoryMeta,
        mainCategory.isAcceptableOrUnknown(
          data['main_category']!,
          _mainCategoryMeta,
        ),
      );
    }
    if (data.containsKey('sub_category')) {
      context.handle(
        _subCategoryMeta,
        subCategory.isAcceptableOrUnknown(
          data['sub_category']!,
          _subCategoryMeta,
        ),
      );
    }
    if (data.containsKey('manufacturer')) {
      context.handle(
        _manufacturerMeta,
        manufacturer.isAcceptableOrUnknown(
          data['manufacturer']!,
          _manufacturerMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('min_stock')) {
      context.handle(
        _minStockMeta,
        minStock.isAcceptableOrUnknown(data['min_stock']!, _minStockMeta),
      );
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('generic_name')) {
      context.handle(
        _genericNameMeta,
        genericName.isAcceptableOrUnknown(
          data['generic_name']!,
          _genericNameMeta,
        ),
      );
    }
    if (data.containsKey('strength')) {
      context.handle(
        _strengthMeta,
        strength.isAcceptableOrUnknown(data['strength']!, _strengthMeta),
      );
    }
    if (data.containsKey('dosage_form')) {
      context.handle(
        _dosageFormMeta,
        dosageForm.isAcceptableOrUnknown(data['dosage_form']!, _dosageFormMeta),
      );
    }
    if (data.containsKey('base_unit_name')) {
      context.handle(
        _baseUnitNameMeta,
        baseUnitName.isAcceptableOrUnknown(
          data['base_unit_name']!,
          _baseUnitNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Medicine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Medicine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      mainCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}main_category'],
      )!,
      subCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category'],
      ),
      manufacturer: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}manufacturer'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      minStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_stock'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      genericName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}generic_name'],
      ),
      strength: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}strength'],
      ),
      dosageForm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dosage_form'],
      ),
      baseUnitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_unit_name'],
      )!,
    );
  }

  @override
  $MedicinesTable createAlias(String alias) {
    return $MedicinesTable(attachedDatabase, alias);
  }
}

class Medicine extends DataClass implements Insertable<Medicine> {
  final int id;
  final String name;
  final String code;
  final String mainCategory;
  final String? subCategory;
  final String? manufacturer;
  final String? description;
  final int minStock;
  final String? brand;
  final String? model;
  final String? genericName;
  final String? strength;
  final String? dosageForm;
  final String baseUnitName;
  const Medicine({
    required this.id,
    required this.name,
    required this.code,
    required this.mainCategory,
    this.subCategory,
    this.manufacturer,
    this.description,
    required this.minStock,
    this.brand,
    this.model,
    this.genericName,
    this.strength,
    this.dosageForm,
    required this.baseUnitName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['code'] = Variable<String>(code);
    map['main_category'] = Variable<String>(mainCategory);
    if (!nullToAbsent || subCategory != null) {
      map['sub_category'] = Variable<String>(subCategory);
    }
    if (!nullToAbsent || manufacturer != null) {
      map['manufacturer'] = Variable<String>(manufacturer);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['min_stock'] = Variable<int>(minStock);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || genericName != null) {
      map['generic_name'] = Variable<String>(genericName);
    }
    if (!nullToAbsent || strength != null) {
      map['strength'] = Variable<String>(strength);
    }
    if (!nullToAbsent || dosageForm != null) {
      map['dosage_form'] = Variable<String>(dosageForm);
    }
    map['base_unit_name'] = Variable<String>(baseUnitName);
    return map;
  }

  MedicinesCompanion toCompanion(bool nullToAbsent) {
    return MedicinesCompanion(
      id: Value(id),
      name: Value(name),
      code: Value(code),
      mainCategory: Value(mainCategory),
      subCategory: subCategory == null && nullToAbsent
          ? const Value.absent()
          : Value(subCategory),
      manufacturer: manufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(manufacturer),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      minStock: Value(minStock),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      genericName: genericName == null && nullToAbsent
          ? const Value.absent()
          : Value(genericName),
      strength: strength == null && nullToAbsent
          ? const Value.absent()
          : Value(strength),
      dosageForm: dosageForm == null && nullToAbsent
          ? const Value.absent()
          : Value(dosageForm),
      baseUnitName: Value(baseUnitName),
    );
  }

  factory Medicine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Medicine(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      code: serializer.fromJson<String>(json['code']),
      mainCategory: serializer.fromJson<String>(json['mainCategory']),
      subCategory: serializer.fromJson<String?>(json['subCategory']),
      manufacturer: serializer.fromJson<String?>(json['manufacturer']),
      description: serializer.fromJson<String?>(json['description']),
      minStock: serializer.fromJson<int>(json['minStock']),
      brand: serializer.fromJson<String?>(json['brand']),
      model: serializer.fromJson<String?>(json['model']),
      genericName: serializer.fromJson<String?>(json['genericName']),
      strength: serializer.fromJson<String?>(json['strength']),
      dosageForm: serializer.fromJson<String?>(json['dosageForm']),
      baseUnitName: serializer.fromJson<String>(json['baseUnitName']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'code': serializer.toJson<String>(code),
      'mainCategory': serializer.toJson<String>(mainCategory),
      'subCategory': serializer.toJson<String?>(subCategory),
      'manufacturer': serializer.toJson<String?>(manufacturer),
      'description': serializer.toJson<String?>(description),
      'minStock': serializer.toJson<int>(minStock),
      'brand': serializer.toJson<String?>(brand),
      'model': serializer.toJson<String?>(model),
      'genericName': serializer.toJson<String?>(genericName),
      'strength': serializer.toJson<String?>(strength),
      'dosageForm': serializer.toJson<String?>(dosageForm),
      'baseUnitName': serializer.toJson<String>(baseUnitName),
    };
  }

  Medicine copyWith({
    int? id,
    String? name,
    String? code,
    String? mainCategory,
    Value<String?> subCategory = const Value.absent(),
    Value<String?> manufacturer = const Value.absent(),
    Value<String?> description = const Value.absent(),
    int? minStock,
    Value<String?> brand = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> genericName = const Value.absent(),
    Value<String?> strength = const Value.absent(),
    Value<String?> dosageForm = const Value.absent(),
    String? baseUnitName,
  }) => Medicine(
    id: id ?? this.id,
    name: name ?? this.name,
    code: code ?? this.code,
    mainCategory: mainCategory ?? this.mainCategory,
    subCategory: subCategory.present ? subCategory.value : this.subCategory,
    manufacturer: manufacturer.present ? manufacturer.value : this.manufacturer,
    description: description.present ? description.value : this.description,
    minStock: minStock ?? this.minStock,
    brand: brand.present ? brand.value : this.brand,
    model: model.present ? model.value : this.model,
    genericName: genericName.present ? genericName.value : this.genericName,
    strength: strength.present ? strength.value : this.strength,
    dosageForm: dosageForm.present ? dosageForm.value : this.dosageForm,
    baseUnitName: baseUnitName ?? this.baseUnitName,
  );
  Medicine copyWithCompanion(MedicinesCompanion data) {
    return Medicine(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      code: data.code.present ? data.code.value : this.code,
      mainCategory: data.mainCategory.present
          ? data.mainCategory.value
          : this.mainCategory,
      subCategory: data.subCategory.present
          ? data.subCategory.value
          : this.subCategory,
      manufacturer: data.manufacturer.present
          ? data.manufacturer.value
          : this.manufacturer,
      description: data.description.present
          ? data.description.value
          : this.description,
      minStock: data.minStock.present ? data.minStock.value : this.minStock,
      brand: data.brand.present ? data.brand.value : this.brand,
      model: data.model.present ? data.model.value : this.model,
      genericName: data.genericName.present
          ? data.genericName.value
          : this.genericName,
      strength: data.strength.present ? data.strength.value : this.strength,
      dosageForm: data.dosageForm.present
          ? data.dosageForm.value
          : this.dosageForm,
      baseUnitName: data.baseUnitName.present
          ? data.baseUnitName.value
          : this.baseUnitName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Medicine(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('mainCategory: $mainCategory, ')
          ..write('subCategory: $subCategory, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('description: $description, ')
          ..write('minStock: $minStock, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('genericName: $genericName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('baseUnitName: $baseUnitName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    code,
    mainCategory,
    subCategory,
    manufacturer,
    description,
    minStock,
    brand,
    model,
    genericName,
    strength,
    dosageForm,
    baseUnitName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Medicine &&
          other.id == this.id &&
          other.name == this.name &&
          other.code == this.code &&
          other.mainCategory == this.mainCategory &&
          other.subCategory == this.subCategory &&
          other.manufacturer == this.manufacturer &&
          other.description == this.description &&
          other.minStock == this.minStock &&
          other.brand == this.brand &&
          other.model == this.model &&
          other.genericName == this.genericName &&
          other.strength == this.strength &&
          other.dosageForm == this.dosageForm &&
          other.baseUnitName == this.baseUnitName);
}

class MedicinesCompanion extends UpdateCompanion<Medicine> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> code;
  final Value<String> mainCategory;
  final Value<String?> subCategory;
  final Value<String?> manufacturer;
  final Value<String?> description;
  final Value<int> minStock;
  final Value<String?> brand;
  final Value<String?> model;
  final Value<String?> genericName;
  final Value<String?> strength;
  final Value<String?> dosageForm;
  final Value<String> baseUnitName;
  const MedicinesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.code = const Value.absent(),
    this.mainCategory = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.description = const Value.absent(),
    this.minStock = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.genericName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.baseUnitName = const Value.absent(),
  });
  MedicinesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String code,
    this.mainCategory = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.manufacturer = const Value.absent(),
    this.description = const Value.absent(),
    this.minStock = const Value.absent(),
    this.brand = const Value.absent(),
    this.model = const Value.absent(),
    this.genericName = const Value.absent(),
    this.strength = const Value.absent(),
    this.dosageForm = const Value.absent(),
    this.baseUnitName = const Value.absent(),
  }) : name = Value(name),
       code = Value(code);
  static Insertable<Medicine> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? code,
    Expression<String>? mainCategory,
    Expression<String>? subCategory,
    Expression<String>? manufacturer,
    Expression<String>? description,
    Expression<int>? minStock,
    Expression<String>? brand,
    Expression<String>? model,
    Expression<String>? genericName,
    Expression<String>? strength,
    Expression<String>? dosageForm,
    Expression<String>? baseUnitName,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (code != null) 'code': code,
      if (mainCategory != null) 'main_category': mainCategory,
      if (subCategory != null) 'sub_category': subCategory,
      if (manufacturer != null) 'manufacturer': manufacturer,
      if (description != null) 'description': description,
      if (minStock != null) 'min_stock': minStock,
      if (brand != null) 'brand': brand,
      if (model != null) 'model': model,
      if (genericName != null) 'generic_name': genericName,
      if (strength != null) 'strength': strength,
      if (dosageForm != null) 'dosage_form': dosageForm,
      if (baseUnitName != null) 'base_unit_name': baseUnitName,
    });
  }

  MedicinesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? code,
    Value<String>? mainCategory,
    Value<String?>? subCategory,
    Value<String?>? manufacturer,
    Value<String?>? description,
    Value<int>? minStock,
    Value<String?>? brand,
    Value<String?>? model,
    Value<String?>? genericName,
    Value<String?>? strength,
    Value<String?>? dosageForm,
    Value<String>? baseUnitName,
  }) {
    return MedicinesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      mainCategory: mainCategory ?? this.mainCategory,
      subCategory: subCategory ?? this.subCategory,
      manufacturer: manufacturer ?? this.manufacturer,
      description: description ?? this.description,
      minStock: minStock ?? this.minStock,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      genericName: genericName ?? this.genericName,
      strength: strength ?? this.strength,
      dosageForm: dosageForm ?? this.dosageForm,
      baseUnitName: baseUnitName ?? this.baseUnitName,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (mainCategory.present) {
      map['main_category'] = Variable<String>(mainCategory.value);
    }
    if (subCategory.present) {
      map['sub_category'] = Variable<String>(subCategory.value);
    }
    if (manufacturer.present) {
      map['manufacturer'] = Variable<String>(manufacturer.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (minStock.present) {
      map['min_stock'] = Variable<int>(minStock.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (genericName.present) {
      map['generic_name'] = Variable<String>(genericName.value);
    }
    if (strength.present) {
      map['strength'] = Variable<String>(strength.value);
    }
    if (dosageForm.present) {
      map['dosage_form'] = Variable<String>(dosageForm.value);
    }
    if (baseUnitName.present) {
      map['base_unit_name'] = Variable<String>(baseUnitName.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MedicinesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('code: $code, ')
          ..write('mainCategory: $mainCategory, ')
          ..write('subCategory: $subCategory, ')
          ..write('manufacturer: $manufacturer, ')
          ..write('description: $description, ')
          ..write('minStock: $minStock, ')
          ..write('brand: $brand, ')
          ..write('model: $model, ')
          ..write('genericName: $genericName, ')
          ..write('strength: $strength, ')
          ..write('dosageForm: $dosageForm, ')
          ..write('baseUnitName: $baseUnitName')
          ..write(')'))
        .toString();
  }
}

class $BatchesTable extends Batches with TableInfo<$BatchesTable, Batch> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id)',
    ),
  );
  static const VerificationMeta _batchNumberMeta = const VerificationMeta(
    'batchNumber',
  );
  @override
  late final GeneratedColumn<String> batchNumber = GeneratedColumn<String>(
    'batch_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiryDateMeta = const VerificationMeta(
    'expiryDate',
  );
  @override
  late final GeneratedColumn<DateTime> expiryDate = GeneratedColumn<DateTime>(
    'expiry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchasePriceMeta = const VerificationMeta(
    'purchasePrice',
  );
  @override
  late final GeneratedColumn<double> purchasePrice = GeneratedColumn<double>(
    'purchase_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _packSizeMeta = const VerificationMeta(
    'packSize',
  );
  @override
  late final GeneratedColumn<int> packSize = GeneratedColumn<int>(
    'pack_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineId,
    batchNumber,
    expiryDate,
    purchasePrice,
    salePrice,
    quantity,
    packSize,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'batches';
  @override
  VerificationContext validateIntegrity(
    Insertable<Batch> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('batch_number')) {
      context.handle(
        _batchNumberMeta,
        batchNumber.isAcceptableOrUnknown(
          data['batch_number']!,
          _batchNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batchNumberMeta);
    }
    if (data.containsKey('expiry_date')) {
      context.handle(
        _expiryDateMeta,
        expiryDate.isAcceptableOrUnknown(data['expiry_date']!, _expiryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_expiryDateMeta);
    }
    if (data.containsKey('purchase_price')) {
      context.handle(
        _purchasePriceMeta,
        purchasePrice.isAcceptableOrUnknown(
          data['purchase_price']!,
          _purchasePriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchasePriceMeta);
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('pack_size')) {
      context.handle(
        _packSizeMeta,
        packSize.isAcceptableOrUnknown(data['pack_size']!, _packSizeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Batch map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Batch(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medicine_id'],
      )!,
      batchNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}batch_number'],
      )!,
      expiryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expiry_date'],
      )!,
      purchasePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}purchase_price'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      packSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pack_size'],
      )!,
    );
  }

  @override
  $BatchesTable createAlias(String alias) {
    return $BatchesTable(attachedDatabase, alias);
  }
}

class Batch extends DataClass implements Insertable<Batch> {
  final int id;
  final int medicineId;
  final String batchNumber;
  final DateTime expiryDate;
  final double purchasePrice;
  final double salePrice;
  final int quantity;
  final int packSize;
  const Batch({
    required this.id,
    required this.medicineId,
    required this.batchNumber,
    required this.expiryDate,
    required this.purchasePrice,
    required this.salePrice,
    required this.quantity,
    required this.packSize,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    map['batch_number'] = Variable<String>(batchNumber);
    map['expiry_date'] = Variable<DateTime>(expiryDate);
    map['purchase_price'] = Variable<double>(purchasePrice);
    map['sale_price'] = Variable<double>(salePrice);
    map['quantity'] = Variable<int>(quantity);
    map['pack_size'] = Variable<int>(packSize);
    return map;
  }

  BatchesCompanion toCompanion(bool nullToAbsent) {
    return BatchesCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      batchNumber: Value(batchNumber),
      expiryDate: Value(expiryDate),
      purchasePrice: Value(purchasePrice),
      salePrice: Value(salePrice),
      quantity: Value(quantity),
      packSize: Value(packSize),
    );
  }

  factory Batch.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Batch(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      batchNumber: serializer.fromJson<String>(json['batchNumber']),
      expiryDate: serializer.fromJson<DateTime>(json['expiryDate']),
      purchasePrice: serializer.fromJson<double>(json['purchasePrice']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      quantity: serializer.fromJson<int>(json['quantity']),
      packSize: serializer.fromJson<int>(json['packSize']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'batchNumber': serializer.toJson<String>(batchNumber),
      'expiryDate': serializer.toJson<DateTime>(expiryDate),
      'purchasePrice': serializer.toJson<double>(purchasePrice),
      'salePrice': serializer.toJson<double>(salePrice),
      'quantity': serializer.toJson<int>(quantity),
      'packSize': serializer.toJson<int>(packSize),
    };
  }

  Batch copyWith({
    int? id,
    int? medicineId,
    String? batchNumber,
    DateTime? expiryDate,
    double? purchasePrice,
    double? salePrice,
    int? quantity,
    int? packSize,
  }) => Batch(
    id: id ?? this.id,
    medicineId: medicineId ?? this.medicineId,
    batchNumber: batchNumber ?? this.batchNumber,
    expiryDate: expiryDate ?? this.expiryDate,
    purchasePrice: purchasePrice ?? this.purchasePrice,
    salePrice: salePrice ?? this.salePrice,
    quantity: quantity ?? this.quantity,
    packSize: packSize ?? this.packSize,
  );
  Batch copyWithCompanion(BatchesCompanion data) {
    return Batch(
      id: data.id.present ? data.id.value : this.id,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      batchNumber: data.batchNumber.present
          ? data.batchNumber.value
          : this.batchNumber,
      expiryDate: data.expiryDate.present
          ? data.expiryDate.value
          : this.expiryDate,
      purchasePrice: data.purchasePrice.present
          ? data.purchasePrice.value
          : this.purchasePrice,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      packSize: data.packSize.present ? data.packSize.value : this.packSize,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Batch(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('quantity: $quantity, ')
          ..write('packSize: $packSize')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicineId,
    batchNumber,
    expiryDate,
    purchasePrice,
    salePrice,
    quantity,
    packSize,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Batch &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.batchNumber == this.batchNumber &&
          other.expiryDate == this.expiryDate &&
          other.purchasePrice == this.purchasePrice &&
          other.salePrice == this.salePrice &&
          other.quantity == this.quantity &&
          other.packSize == this.packSize);
}

class BatchesCompanion extends UpdateCompanion<Batch> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<String> batchNumber;
  final Value<DateTime> expiryDate;
  final Value<double> purchasePrice;
  final Value<double> salePrice;
  final Value<int> quantity;
  final Value<int> packSize;
  const BatchesCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.batchNumber = const Value.absent(),
    this.expiryDate = const Value.absent(),
    this.purchasePrice = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.quantity = const Value.absent(),
    this.packSize = const Value.absent(),
  });
  BatchesCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required String batchNumber,
    required DateTime expiryDate,
    required double purchasePrice,
    required double salePrice,
    required int quantity,
    this.packSize = const Value.absent(),
  }) : medicineId = Value(medicineId),
       batchNumber = Value(batchNumber),
       expiryDate = Value(expiryDate),
       purchasePrice = Value(purchasePrice),
       salePrice = Value(salePrice),
       quantity = Value(quantity);
  static Insertable<Batch> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<String>? batchNumber,
    Expression<DateTime>? expiryDate,
    Expression<double>? purchasePrice,
    Expression<double>? salePrice,
    Expression<int>? quantity,
    Expression<int>? packSize,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (batchNumber != null) 'batch_number': batchNumber,
      if (expiryDate != null) 'expiry_date': expiryDate,
      if (purchasePrice != null) 'purchase_price': purchasePrice,
      if (salePrice != null) 'sale_price': salePrice,
      if (quantity != null) 'quantity': quantity,
      if (packSize != null) 'pack_size': packSize,
    });
  }

  BatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? medicineId,
    Value<String>? batchNumber,
    Value<DateTime>? expiryDate,
    Value<double>? purchasePrice,
    Value<double>? salePrice,
    Value<int>? quantity,
    Value<int>? packSize,
  }) {
    return BatchesCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      salePrice: salePrice ?? this.salePrice,
      quantity: quantity ?? this.quantity,
      packSize: packSize ?? this.packSize,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (batchNumber.present) {
      map['batch_number'] = Variable<String>(batchNumber.value);
    }
    if (expiryDate.present) {
      map['expiry_date'] = Variable<DateTime>(expiryDate.value);
    }
    if (purchasePrice.present) {
      map['purchase_price'] = Variable<double>(purchasePrice.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (packSize.present) {
      map['pack_size'] = Variable<int>(packSize.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BatchesCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('batchNumber: $batchNumber, ')
          ..write('expiryDate: $expiryDate, ')
          ..write('purchasePrice: $purchasePrice, ')
          ..write('salePrice: $salePrice, ')
          ..write('quantity: $quantity, ')
          ..write('packSize: $packSize')
          ..write(')'))
        .toString();
  }
}

class $ProductUnitsTable extends ProductUnits
    with TableInfo<$ProductUnitsTable, ProductUnit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductUnitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _medicineIdMeta = const VerificationMeta(
    'medicineId',
  );
  @override
  late final GeneratedColumn<int> medicineId = GeneratedColumn<int>(
    'medicine_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES medicines (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _salePriceMeta = const VerificationMeta(
    'salePrice',
  );
  @override
  late final GeneratedColumn<double> salePrice = GeneratedColumn<double>(
    'sale_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBaseUnitMeta = const VerificationMeta(
    'isBaseUnit',
  );
  @override
  late final GeneratedColumn<bool> isBaseUnit = GeneratedColumn<bool>(
    'is_base_unit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_base_unit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isDefaultSaleUnitMeta = const VerificationMeta(
    'isDefaultSaleUnit',
  );
  @override
  late final GeneratedColumn<bool> isDefaultSaleUnit = GeneratedColumn<bool>(
    'is_default_sale_unit',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default_sale_unit" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    medicineId,
    name,
    conversionFactor,
    salePrice,
    isBaseUnit,
    isDefaultSaleUnit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_units';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductUnit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('medicine_id')) {
      context.handle(
        _medicineIdMeta,
        medicineId.isAcceptableOrUnknown(data['medicine_id']!, _medicineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    }
    if (data.containsKey('sale_price')) {
      context.handle(
        _salePriceMeta,
        salePrice.isAcceptableOrUnknown(data['sale_price']!, _salePriceMeta),
      );
    } else if (isInserting) {
      context.missing(_salePriceMeta);
    }
    if (data.containsKey('is_base_unit')) {
      context.handle(
        _isBaseUnitMeta,
        isBaseUnit.isAcceptableOrUnknown(
          data['is_base_unit']!,
          _isBaseUnitMeta,
        ),
      );
    }
    if (data.containsKey('is_default_sale_unit')) {
      context.handle(
        _isDefaultSaleUnitMeta,
        isDefaultSaleUnit.isAcceptableOrUnknown(
          data['is_default_sale_unit']!,
          _isDefaultSaleUnitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductUnit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductUnit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      medicineId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}medicine_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      salePrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_price'],
      )!,
      isBaseUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_base_unit'],
      )!,
      isDefaultSaleUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default_sale_unit'],
      )!,
    );
  }

  @override
  $ProductUnitsTable createAlias(String alias) {
    return $ProductUnitsTable(attachedDatabase, alias);
  }
}

class ProductUnit extends DataClass implements Insertable<ProductUnit> {
  final int id;
  final int medicineId;
  final String name;
  final double conversionFactor;
  final double salePrice;
  final bool isBaseUnit;
  final bool isDefaultSaleUnit;
  const ProductUnit({
    required this.id,
    required this.medicineId,
    required this.name,
    required this.conversionFactor,
    required this.salePrice,
    required this.isBaseUnit,
    required this.isDefaultSaleUnit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['medicine_id'] = Variable<int>(medicineId);
    map['name'] = Variable<String>(name);
    map['conversion_factor'] = Variable<double>(conversionFactor);
    map['sale_price'] = Variable<double>(salePrice);
    map['is_base_unit'] = Variable<bool>(isBaseUnit);
    map['is_default_sale_unit'] = Variable<bool>(isDefaultSaleUnit);
    return map;
  }

  ProductUnitsCompanion toCompanion(bool nullToAbsent) {
    return ProductUnitsCompanion(
      id: Value(id),
      medicineId: Value(medicineId),
      name: Value(name),
      conversionFactor: Value(conversionFactor),
      salePrice: Value(salePrice),
      isBaseUnit: Value(isBaseUnit),
      isDefaultSaleUnit: Value(isDefaultSaleUnit),
    );
  }

  factory ProductUnit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductUnit(
      id: serializer.fromJson<int>(json['id']),
      medicineId: serializer.fromJson<int>(json['medicineId']),
      name: serializer.fromJson<String>(json['name']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      salePrice: serializer.fromJson<double>(json['salePrice']),
      isBaseUnit: serializer.fromJson<bool>(json['isBaseUnit']),
      isDefaultSaleUnit: serializer.fromJson<bool>(json['isDefaultSaleUnit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'medicineId': serializer.toJson<int>(medicineId),
      'name': serializer.toJson<String>(name),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'salePrice': serializer.toJson<double>(salePrice),
      'isBaseUnit': serializer.toJson<bool>(isBaseUnit),
      'isDefaultSaleUnit': serializer.toJson<bool>(isDefaultSaleUnit),
    };
  }

  ProductUnit copyWith({
    int? id,
    int? medicineId,
    String? name,
    double? conversionFactor,
    double? salePrice,
    bool? isBaseUnit,
    bool? isDefaultSaleUnit,
  }) => ProductUnit(
    id: id ?? this.id,
    medicineId: medicineId ?? this.medicineId,
    name: name ?? this.name,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    salePrice: salePrice ?? this.salePrice,
    isBaseUnit: isBaseUnit ?? this.isBaseUnit,
    isDefaultSaleUnit: isDefaultSaleUnit ?? this.isDefaultSaleUnit,
  );
  ProductUnit copyWithCompanion(ProductUnitsCompanion data) {
    return ProductUnit(
      id: data.id.present ? data.id.value : this.id,
      medicineId: data.medicineId.present
          ? data.medicineId.value
          : this.medicineId,
      name: data.name.present ? data.name.value : this.name,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      salePrice: data.salePrice.present ? data.salePrice.value : this.salePrice,
      isBaseUnit: data.isBaseUnit.present
          ? data.isBaseUnit.value
          : this.isBaseUnit,
      isDefaultSaleUnit: data.isDefaultSaleUnit.present
          ? data.isDefaultSaleUnit.value
          : this.isDefaultSaleUnit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnit(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('name: $name, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('salePrice: $salePrice, ')
          ..write('isBaseUnit: $isBaseUnit, ')
          ..write('isDefaultSaleUnit: $isDefaultSaleUnit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    medicineId,
    name,
    conversionFactor,
    salePrice,
    isBaseUnit,
    isDefaultSaleUnit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductUnit &&
          other.id == this.id &&
          other.medicineId == this.medicineId &&
          other.name == this.name &&
          other.conversionFactor == this.conversionFactor &&
          other.salePrice == this.salePrice &&
          other.isBaseUnit == this.isBaseUnit &&
          other.isDefaultSaleUnit == this.isDefaultSaleUnit);
}

class ProductUnitsCompanion extends UpdateCompanion<ProductUnit> {
  final Value<int> id;
  final Value<int> medicineId;
  final Value<String> name;
  final Value<double> conversionFactor;
  final Value<double> salePrice;
  final Value<bool> isBaseUnit;
  final Value<bool> isDefaultSaleUnit;
  const ProductUnitsCompanion({
    this.id = const Value.absent(),
    this.medicineId = const Value.absent(),
    this.name = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.salePrice = const Value.absent(),
    this.isBaseUnit = const Value.absent(),
    this.isDefaultSaleUnit = const Value.absent(),
  });
  ProductUnitsCompanion.insert({
    this.id = const Value.absent(),
    required int medicineId,
    required String name,
    this.conversionFactor = const Value.absent(),
    required double salePrice,
    this.isBaseUnit = const Value.absent(),
    this.isDefaultSaleUnit = const Value.absent(),
  }) : medicineId = Value(medicineId),
       name = Value(name),
       salePrice = Value(salePrice);
  static Insertable<ProductUnit> custom({
    Expression<int>? id,
    Expression<int>? medicineId,
    Expression<String>? name,
    Expression<double>? conversionFactor,
    Expression<double>? salePrice,
    Expression<bool>? isBaseUnit,
    Expression<bool>? isDefaultSaleUnit,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (medicineId != null) 'medicine_id': medicineId,
      if (name != null) 'name': name,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (salePrice != null) 'sale_price': salePrice,
      if (isBaseUnit != null) 'is_base_unit': isBaseUnit,
      if (isDefaultSaleUnit != null) 'is_default_sale_unit': isDefaultSaleUnit,
    });
  }

  ProductUnitsCompanion copyWith({
    Value<int>? id,
    Value<int>? medicineId,
    Value<String>? name,
    Value<double>? conversionFactor,
    Value<double>? salePrice,
    Value<bool>? isBaseUnit,
    Value<bool>? isDefaultSaleUnit,
  }) {
    return ProductUnitsCompanion(
      id: id ?? this.id,
      medicineId: medicineId ?? this.medicineId,
      name: name ?? this.name,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      salePrice: salePrice ?? this.salePrice,
      isBaseUnit: isBaseUnit ?? this.isBaseUnit,
      isDefaultSaleUnit: isDefaultSaleUnit ?? this.isDefaultSaleUnit,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (medicineId.present) {
      map['medicine_id'] = Variable<int>(medicineId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (salePrice.present) {
      map['sale_price'] = Variable<double>(salePrice.value);
    }
    if (isBaseUnit.present) {
      map['is_base_unit'] = Variable<bool>(isBaseUnit.value);
    }
    if (isDefaultSaleUnit.present) {
      map['is_default_sale_unit'] = Variable<bool>(isDefaultSaleUnit.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductUnitsCompanion(')
          ..write('id: $id, ')
          ..write('medicineId: $medicineId, ')
          ..write('name: $name, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('salePrice: $salePrice, ')
          ..write('isBaseUnit: $isBaseUnit, ')
          ..write('isDefaultSaleUnit: $isDefaultSaleUnit')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, phoneNumber, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final int id;
  final String name;
  final String? phoneNumber;
  final DateTime createdAt;
  const Customer({
    required this.id,
    required this.name,
    this.phoneNumber,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      createdAt: Value(createdAt),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Customer copyWith({
    int? id,
    String? name,
    Value<String?> phoneNumber = const Value.absent(),
    DateTime? createdAt,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    createdAt: createdAt ?? this.createdAt,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, phoneNumber, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phoneNumber == this.phoneNumber &&
          other.createdAt == this.createdAt);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> phoneNumber;
  final Value<DateTime> createdAt;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.phoneNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Customer> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? phoneNumber,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? phoneNumber,
    Value<DateTime>? createdAt,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _invoiceNumberMeta = const VerificationMeta(
    'invoiceNumber',
  );
  @override
  late final GeneratedColumn<String> invoiceNumber = GeneratedColumn<String>(
    'invoice_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<int> customerId = GeneratedColumn<int>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subTotalMeta = const VerificationMeta(
    'subTotal',
  );
  @override
  late final GeneratedColumn<double> subTotal = GeneratedColumn<double>(
    'sub_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _posFeeMeta = const VerificationMeta('posFee');
  @override
  late final GeneratedColumn<double> posFee = GeneratedColumn<double>(
    'pos_fee',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _grandTotalMeta = const VerificationMeta(
    'grandTotal',
  );
  @override
  late final GeneratedColumn<double> grandTotal = GeneratedColumn<double>(
    'grand_total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Cash'),
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES users (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    invoiceNumber,
    customerId,
    date,
    subTotal,
    discount,
    tax,
    posFee,
    grandTotal,
    paymentMethod,
    userId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('invoice_number')) {
      context.handle(
        _invoiceNumberMeta,
        invoiceNumber.isAcceptableOrUnknown(
          data['invoice_number']!,
          _invoiceNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_invoiceNumberMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('sub_total')) {
      context.handle(
        _subTotalMeta,
        subTotal.isAcceptableOrUnknown(data['sub_total']!, _subTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subTotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    }
    if (data.containsKey('pos_fee')) {
      context.handle(
        _posFeeMeta,
        posFee.isAcceptableOrUnknown(data['pos_fee']!, _posFeeMeta),
      );
    }
    if (data.containsKey('grand_total')) {
      context.handle(
        _grandTotalMeta,
        grandTotal.isAcceptableOrUnknown(data['grand_total']!, _grandTotalMeta),
      );
    } else if (isInserting) {
      context.missing(_grandTotalMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      invoiceNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_number'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}customer_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      subTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sub_total'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}discount'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}tax'],
      )!,
      posFee: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pos_fee'],
      )!,
      grandTotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}grand_total'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final String invoiceNumber;
  final int? customerId;
  final DateTime date;
  final double subTotal;
  final double discount;
  final double tax;
  final double posFee;
  final double grandTotal;
  final String paymentMethod;
  final int? userId;
  const Sale({
    required this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.date,
    required this.subTotal,
    required this.discount,
    required this.tax,
    required this.posFee,
    required this.grandTotal,
    required this.paymentMethod,
    this.userId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['invoice_number'] = Variable<String>(invoiceNumber);
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<int>(customerId);
    }
    map['date'] = Variable<DateTime>(date);
    map['sub_total'] = Variable<double>(subTotal);
    map['discount'] = Variable<double>(discount);
    map['tax'] = Variable<double>(tax);
    map['pos_fee'] = Variable<double>(posFee);
    map['grand_total'] = Variable<double>(grandTotal);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      invoiceNumber: Value(invoiceNumber),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      date: Value(date),
      subTotal: Value(subTotal),
      discount: Value(discount),
      tax: Value(tax),
      posFee: Value(posFee),
      grandTotal: Value(grandTotal),
      paymentMethod: Value(paymentMethod),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      invoiceNumber: serializer.fromJson<String>(json['invoiceNumber']),
      customerId: serializer.fromJson<int?>(json['customerId']),
      date: serializer.fromJson<DateTime>(json['date']),
      subTotal: serializer.fromJson<double>(json['subTotal']),
      discount: serializer.fromJson<double>(json['discount']),
      tax: serializer.fromJson<double>(json['tax']),
      posFee: serializer.fromJson<double>(json['posFee']),
      grandTotal: serializer.fromJson<double>(json['grandTotal']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      userId: serializer.fromJson<int?>(json['userId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'invoiceNumber': serializer.toJson<String>(invoiceNumber),
      'customerId': serializer.toJson<int?>(customerId),
      'date': serializer.toJson<DateTime>(date),
      'subTotal': serializer.toJson<double>(subTotal),
      'discount': serializer.toJson<double>(discount),
      'tax': serializer.toJson<double>(tax),
      'posFee': serializer.toJson<double>(posFee),
      'grandTotal': serializer.toJson<double>(grandTotal),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'userId': serializer.toJson<int?>(userId),
    };
  }

  Sale copyWith({
    int? id,
    String? invoiceNumber,
    Value<int?> customerId = const Value.absent(),
    DateTime? date,
    double? subTotal,
    double? discount,
    double? tax,
    double? posFee,
    double? grandTotal,
    String? paymentMethod,
    Value<int?> userId = const Value.absent(),
  }) => Sale(
    id: id ?? this.id,
    invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    customerId: customerId.present ? customerId.value : this.customerId,
    date: date ?? this.date,
    subTotal: subTotal ?? this.subTotal,
    discount: discount ?? this.discount,
    tax: tax ?? this.tax,
    posFee: posFee ?? this.posFee,
    grandTotal: grandTotal ?? this.grandTotal,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    userId: userId.present ? userId.value : this.userId,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      invoiceNumber: data.invoiceNumber.present
          ? data.invoiceNumber.value
          : this.invoiceNumber,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      date: data.date.present ? data.date.value : this.date,
      subTotal: data.subTotal.present ? data.subTotal.value : this.subTotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      posFee: data.posFee.present ? data.posFee.value : this.posFee,
      grandTotal: data.grandTotal.present
          ? data.grandTotal.value
          : this.grandTotal,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      userId: data.userId.present ? data.userId.value : this.userId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('subTotal: $subTotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('posFee: $posFee, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    invoiceNumber,
    customerId,
    date,
    subTotal,
    discount,
    tax,
    posFee,
    grandTotal,
    paymentMethod,
    userId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.invoiceNumber == this.invoiceNumber &&
          other.customerId == this.customerId &&
          other.date == this.date &&
          other.subTotal == this.subTotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.posFee == this.posFee &&
          other.grandTotal == this.grandTotal &&
          other.paymentMethod == this.paymentMethod &&
          other.userId == this.userId);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<String> invoiceNumber;
  final Value<int?> customerId;
  final Value<DateTime> date;
  final Value<double> subTotal;
  final Value<double> discount;
  final Value<double> tax;
  final Value<double> posFee;
  final Value<double> grandTotal;
  final Value<String> paymentMethod;
  final Value<int?> userId;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.invoiceNumber = const Value.absent(),
    this.customerId = const Value.absent(),
    this.date = const Value.absent(),
    this.subTotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.posFee = const Value.absent(),
    this.grandTotal = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.userId = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required String invoiceNumber,
    this.customerId = const Value.absent(),
    required DateTime date,
    required double subTotal,
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.posFee = const Value.absent(),
    required double grandTotal,
    this.paymentMethod = const Value.absent(),
    this.userId = const Value.absent(),
  }) : invoiceNumber = Value(invoiceNumber),
       date = Value(date),
       subTotal = Value(subTotal),
       grandTotal = Value(grandTotal);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<String>? invoiceNumber,
    Expression<int>? customerId,
    Expression<DateTime>? date,
    Expression<double>? subTotal,
    Expression<double>? discount,
    Expression<double>? tax,
    Expression<double>? posFee,
    Expression<double>? grandTotal,
    Expression<String>? paymentMethod,
    Expression<int>? userId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (invoiceNumber != null) 'invoice_number': invoiceNumber,
      if (customerId != null) 'customer_id': customerId,
      if (date != null) 'date': date,
      if (subTotal != null) 'sub_total': subTotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (posFee != null) 'pos_fee': posFee,
      if (grandTotal != null) 'grand_total': grandTotal,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (userId != null) 'user_id': userId,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<String>? invoiceNumber,
    Value<int?>? customerId,
    Value<DateTime>? date,
    Value<double>? subTotal,
    Value<double>? discount,
    Value<double>? tax,
    Value<double>? posFee,
    Value<double>? grandTotal,
    Value<String>? paymentMethod,
    Value<int?>? userId,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      customerId: customerId ?? this.customerId,
      date: date ?? this.date,
      subTotal: subTotal ?? this.subTotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      posFee: posFee ?? this.posFee,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      userId: userId ?? this.userId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (invoiceNumber.present) {
      map['invoice_number'] = Variable<String>(invoiceNumber.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<int>(customerId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (subTotal.present) {
      map['sub_total'] = Variable<double>(subTotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (posFee.present) {
      map['pos_fee'] = Variable<double>(posFee.value);
    }
    if (grandTotal.present) {
      map['grand_total'] = Variable<double>(grandTotal.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('invoiceNumber: $invoiceNumber, ')
          ..write('customerId: $customerId, ')
          ..write('date: $date, ')
          ..write('subTotal: $subTotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('posFee: $posFee, ')
          ..write('grandTotal: $grandTotal, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('userId: $userId')
          ..write(')'))
        .toString();
  }
}

class $SaleItemsTable extends SaleItems
    with TableInfo<$SaleItemsTable, SaleItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<int> saleId = GeneratedColumn<int>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _batchIdMeta = const VerificationMeta(
    'batchId',
  );
  @override
  late final GeneratedColumn<int> batchId = GeneratedColumn<int>(
    'batch_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES batches (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitNameMeta = const VerificationMeta(
    'unitName',
  );
  @override
  late final GeneratedColumn<String> unitName = GeneratedColumn<String>(
    'unit_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _conversionFactorMeta = const VerificationMeta(
    'conversionFactor',
  );
  @override
  late final GeneratedColumn<double> conversionFactor = GeneratedColumn<double>(
    'conversion_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _customFieldsJsonMeta = const VerificationMeta(
    'customFieldsJson',
  );
  @override
  late final GeneratedColumn<String> customFieldsJson = GeneratedColumn<String>(
    'custom_fields_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    batchId,
    quantity,
    price,
    total,
    unitName,
    conversionFactor,
    customFieldsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('batch_id')) {
      context.handle(
        _batchIdMeta,
        batchId.isAcceptableOrUnknown(data['batch_id']!, _batchIdMeta),
      );
    } else if (isInserting) {
      context.missing(_batchIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('unit_name')) {
      context.handle(
        _unitNameMeta,
        unitName.isAcceptableOrUnknown(data['unit_name']!, _unitNameMeta),
      );
    }
    if (data.containsKey('conversion_factor')) {
      context.handle(
        _conversionFactorMeta,
        conversionFactor.isAcceptableOrUnknown(
          data['conversion_factor']!,
          _conversionFactorMeta,
        ),
      );
    }
    if (data.containsKey('custom_fields_json')) {
      context.handle(
        _customFieldsJsonMeta,
        customFieldsJson.isAcceptableOrUnknown(
          data['custom_fields_json']!,
          _customFieldsJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_id'],
      )!,
      batchId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total'],
      )!,
      unitName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit_name'],
      ),
      conversionFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}conversion_factor'],
      )!,
      customFieldsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_fields_json'],
      ),
    );
  }

  @override
  $SaleItemsTable createAlias(String alias) {
    return $SaleItemsTable(attachedDatabase, alias);
  }
}

class SaleItem extends DataClass implements Insertable<SaleItem> {
  final int id;
  final int saleId;
  final int batchId;
  final int quantity;
  final double price;
  final double total;
  final String? unitName;
  final double conversionFactor;
  final String? customFieldsJson;
  const SaleItem({
    required this.id,
    required this.saleId,
    required this.batchId,
    required this.quantity,
    required this.price,
    required this.total,
    this.unitName,
    required this.conversionFactor,
    this.customFieldsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sale_id'] = Variable<int>(saleId);
    map['batch_id'] = Variable<int>(batchId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    map['total'] = Variable<double>(total);
    if (!nullToAbsent || unitName != null) {
      map['unit_name'] = Variable<String>(unitName);
    }
    map['conversion_factor'] = Variable<double>(conversionFactor);
    if (!nullToAbsent || customFieldsJson != null) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson);
    }
    return map;
  }

  SaleItemsCompanion toCompanion(bool nullToAbsent) {
    return SaleItemsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      batchId: Value(batchId),
      quantity: Value(quantity),
      price: Value(price),
      total: Value(total),
      unitName: unitName == null && nullToAbsent
          ? const Value.absent()
          : Value(unitName),
      conversionFactor: Value(conversionFactor),
      customFieldsJson: customFieldsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(customFieldsJson),
    );
  }

  factory SaleItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleItem(
      id: serializer.fromJson<int>(json['id']),
      saleId: serializer.fromJson<int>(json['saleId']),
      batchId: serializer.fromJson<int>(json['batchId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      total: serializer.fromJson<double>(json['total']),
      unitName: serializer.fromJson<String?>(json['unitName']),
      conversionFactor: serializer.fromJson<double>(json['conversionFactor']),
      customFieldsJson: serializer.fromJson<String?>(json['customFieldsJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'saleId': serializer.toJson<int>(saleId),
      'batchId': serializer.toJson<int>(batchId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'total': serializer.toJson<double>(total),
      'unitName': serializer.toJson<String?>(unitName),
      'conversionFactor': serializer.toJson<double>(conversionFactor),
      'customFieldsJson': serializer.toJson<String?>(customFieldsJson),
    };
  }

  SaleItem copyWith({
    int? id,
    int? saleId,
    int? batchId,
    int? quantity,
    double? price,
    double? total,
    Value<String?> unitName = const Value.absent(),
    double? conversionFactor,
    Value<String?> customFieldsJson = const Value.absent(),
  }) => SaleItem(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    batchId: batchId ?? this.batchId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
    total: total ?? this.total,
    unitName: unitName.present ? unitName.value : this.unitName,
    conversionFactor: conversionFactor ?? this.conversionFactor,
    customFieldsJson: customFieldsJson.present
        ? customFieldsJson.value
        : this.customFieldsJson,
  );
  SaleItem copyWithCompanion(SaleItemsCompanion data) {
    return SaleItem(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      batchId: data.batchId.present ? data.batchId.value : this.batchId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      total: data.total.present ? data.total.value : this.total,
      unitName: data.unitName.present ? data.unitName.value : this.unitName,
      conversionFactor: data.conversionFactor.present
          ? data.conversionFactor.value
          : this.conversionFactor,
      customFieldsJson: data.customFieldsJson.present
          ? data.customFieldsJson.value
          : this.customFieldsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleItem(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('unitName: $unitName, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('customFieldsJson: $customFieldsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    batchId,
    quantity,
    price,
    total,
    unitName,
    conversionFactor,
    customFieldsJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleItem &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.batchId == this.batchId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.total == this.total &&
          other.unitName == this.unitName &&
          other.conversionFactor == this.conversionFactor &&
          other.customFieldsJson == this.customFieldsJson);
}

class SaleItemsCompanion extends UpdateCompanion<SaleItem> {
  final Value<int> id;
  final Value<int> saleId;
  final Value<int> batchId;
  final Value<int> quantity;
  final Value<double> price;
  final Value<double> total;
  final Value<String?> unitName;
  final Value<double> conversionFactor;
  final Value<String?> customFieldsJson;
  const SaleItemsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.batchId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.total = const Value.absent(),
    this.unitName = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
  });
  SaleItemsCompanion.insert({
    this.id = const Value.absent(),
    required int saleId,
    required int batchId,
    required int quantity,
    required double price,
    required double total,
    this.unitName = const Value.absent(),
    this.conversionFactor = const Value.absent(),
    this.customFieldsJson = const Value.absent(),
  }) : saleId = Value(saleId),
       batchId = Value(batchId),
       quantity = Value(quantity),
       price = Value(price),
       total = Value(total);
  static Insertable<SaleItem> custom({
    Expression<int>? id,
    Expression<int>? saleId,
    Expression<int>? batchId,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<double>? total,
    Expression<String>? unitName,
    Expression<double>? conversionFactor,
    Expression<String>? customFieldsJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (batchId != null) 'batch_id': batchId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (total != null) 'total': total,
      if (unitName != null) 'unit_name': unitName,
      if (conversionFactor != null) 'conversion_factor': conversionFactor,
      if (customFieldsJson != null) 'custom_fields_json': customFieldsJson,
    });
  }

  SaleItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? saleId,
    Value<int>? batchId,
    Value<int>? quantity,
    Value<double>? price,
    Value<double>? total,
    Value<String?>? unitName,
    Value<double>? conversionFactor,
    Value<String?>? customFieldsJson,
  }) {
    return SaleItemsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      batchId: batchId ?? this.batchId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      total: total ?? this.total,
      unitName: unitName ?? this.unitName,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      customFieldsJson: customFieldsJson ?? this.customFieldsJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<int>(saleId.value);
    }
    if (batchId.present) {
      map['batch_id'] = Variable<int>(batchId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (unitName.present) {
      map['unit_name'] = Variable<String>(unitName.value);
    }
    if (conversionFactor.present) {
      map['conversion_factor'] = Variable<double>(conversionFactor.value);
    }
    if (customFieldsJson.present) {
      map['custom_fields_json'] = Variable<String>(customFieldsJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleItemsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('batchId: $batchId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('total: $total, ')
          ..write('unitName: $unitName, ')
          ..write('conversionFactor: $conversionFactor, ')
          ..write('customFieldsJson: $customFieldsJson')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldDefinitionsTable extends CustomFieldDefinitions
    with TableInfo<$CustomFieldDefinitionsTable, CustomFieldDefinition> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldDefinitionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _securityKeyMeta = const VerificationMeta(
    'securityKey',
  );
  @override
  late final GeneratedColumn<String> securityKey = GeneratedColumn<String>(
    'security_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessTypeMeta = const VerificationMeta(
    'businessType',
  );
  @override
  late final GeneratedColumn<String> businessType = GeneratedColumn<String>(
    'business_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldKeyMeta = const VerificationMeta(
    'fieldKey',
  );
  @override
  late final GeneratedColumn<String> fieldKey = GeneratedColumn<String>(
    'field_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldLabelMeta = const VerificationMeta(
    'fieldLabel',
  );
  @override
  late final GeneratedColumn<String> fieldLabel = GeneratedColumn<String>(
    'field_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fieldTypeMeta = const VerificationMeta(
    'fieldType',
  );
  @override
  late final GeneratedColumn<String> fieldType = GeneratedColumn<String>(
    'field_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _defaultValueMeta = const VerificationMeta(
    'defaultValue',
  );
  @override
  late final GeneratedColumn<String> defaultValue = GeneratedColumn<String>(
    'default_value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isRequiredMeta = const VerificationMeta(
    'isRequired',
  );
  @override
  late final GeneratedColumn<bool> isRequired = GeneratedColumn<bool>(
    'is_required',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_required" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showInProductFormMeta = const VerificationMeta(
    'showInProductForm',
  );
  @override
  late final GeneratedColumn<bool> showInProductForm = GeneratedColumn<bool>(
    'show_in_product_form',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_product_form" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInPOSMeta = const VerificationMeta(
    'showInPOS',
  );
  @override
  late final GeneratedColumn<bool> showInPOS = GeneratedColumn<bool>(
    'show_in_p_o_s',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_p_o_s" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInCartMeta = const VerificationMeta(
    'showInCart',
  );
  @override
  late final GeneratedColumn<bool> showInCart = GeneratedColumn<bool>(
    'show_in_cart',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_cart" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInInvoiceMeta = const VerificationMeta(
    'showInInvoice',
  );
  @override
  late final GeneratedColumn<bool> showInInvoice = GeneratedColumn<bool>(
    'show_in_invoice',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_invoice" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInSearchMeta = const VerificationMeta(
    'showInSearch',
  );
  @override
  late final GeneratedColumn<bool> showInSearch = GeneratedColumn<bool>(
    'show_in_search',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_search" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _showInReportsMeta = const VerificationMeta(
    'showInReports',
  );
  @override
  late final GeneratedColumn<bool> showInReports = GeneratedColumn<bool>(
    'show_in_reports',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_in_reports" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    securityKey,
    businessType,
    entityType,
    fieldKey,
    fieldLabel,
    fieldType,
    optionsJson,
    defaultValue,
    isRequired,
    isActive,
    showInProductForm,
    showInPOS,
    showInCart,
    showInInvoice,
    showInSearch,
    showInReports,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_field_definitions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFieldDefinition> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('security_key')) {
      context.handle(
        _securityKeyMeta,
        securityKey.isAcceptableOrUnknown(
          data['security_key']!,
          _securityKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_securityKeyMeta);
    }
    if (data.containsKey('business_type')) {
      context.handle(
        _businessTypeMeta,
        businessType.isAcceptableOrUnknown(
          data['business_type']!,
          _businessTypeMeta,
        ),
      );
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('field_key')) {
      context.handle(
        _fieldKeyMeta,
        fieldKey.isAcceptableOrUnknown(data['field_key']!, _fieldKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldKeyMeta);
    }
    if (data.containsKey('field_label')) {
      context.handle(
        _fieldLabelMeta,
        fieldLabel.isAcceptableOrUnknown(data['field_label']!, _fieldLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldLabelMeta);
    }
    if (data.containsKey('field_type')) {
      context.handle(
        _fieldTypeMeta,
        fieldType.isAcceptableOrUnknown(data['field_type']!, _fieldTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_fieldTypeMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('default_value')) {
      context.handle(
        _defaultValueMeta,
        defaultValue.isAcceptableOrUnknown(
          data['default_value']!,
          _defaultValueMeta,
        ),
      );
    }
    if (data.containsKey('is_required')) {
      context.handle(
        _isRequiredMeta,
        isRequired.isAcceptableOrUnknown(data['is_required']!, _isRequiredMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('show_in_product_form')) {
      context.handle(
        _showInProductFormMeta,
        showInProductForm.isAcceptableOrUnknown(
          data['show_in_product_form']!,
          _showInProductFormMeta,
        ),
      );
    }
    if (data.containsKey('show_in_p_o_s')) {
      context.handle(
        _showInPOSMeta,
        showInPOS.isAcceptableOrUnknown(data['show_in_p_o_s']!, _showInPOSMeta),
      );
    }
    if (data.containsKey('show_in_cart')) {
      context.handle(
        _showInCartMeta,
        showInCart.isAcceptableOrUnknown(
          data['show_in_cart']!,
          _showInCartMeta,
        ),
      );
    }
    if (data.containsKey('show_in_invoice')) {
      context.handle(
        _showInInvoiceMeta,
        showInInvoice.isAcceptableOrUnknown(
          data['show_in_invoice']!,
          _showInInvoiceMeta,
        ),
      );
    }
    if (data.containsKey('show_in_search')) {
      context.handle(
        _showInSearchMeta,
        showInSearch.isAcceptableOrUnknown(
          data['show_in_search']!,
          _showInSearchMeta,
        ),
      );
    }
    if (data.containsKey('show_in_reports')) {
      context.handle(
        _showInReportsMeta,
        showInReports.isAcceptableOrUnknown(
          data['show_in_reports']!,
          _showInReportsMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFieldDefinition map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFieldDefinition(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      securityKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}security_key'],
      )!,
      businessType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_type'],
      ),
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      fieldKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_key'],
      )!,
      fieldLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_label'],
      )!,
      fieldType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}field_type'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      ),
      defaultValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_value'],
      ),
      isRequired: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_required'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      showInProductForm: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_product_form'],
      )!,
      showInPOS: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_p_o_s'],
      )!,
      showInCart: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_cart'],
      )!,
      showInInvoice: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_invoice'],
      )!,
      showInSearch: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_search'],
      )!,
      showInReports: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_in_reports'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomFieldDefinitionsTable createAlias(String alias) {
    return $CustomFieldDefinitionsTable(attachedDatabase, alias);
  }
}

class CustomFieldDefinition extends DataClass
    implements Insertable<CustomFieldDefinition> {
  final int id;
  final String securityKey;
  final String? businessType;
  final String entityType;
  final String fieldKey;
  final String fieldLabel;
  final String fieldType;
  final String? optionsJson;
  final String? defaultValue;
  final bool isRequired;
  final bool isActive;
  final bool showInProductForm;
  final bool showInPOS;
  final bool showInCart;
  final bool showInInvoice;
  final bool showInSearch;
  final bool showInReports;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CustomFieldDefinition({
    required this.id,
    required this.securityKey,
    this.businessType,
    required this.entityType,
    required this.fieldKey,
    required this.fieldLabel,
    required this.fieldType,
    this.optionsJson,
    this.defaultValue,
    required this.isRequired,
    required this.isActive,
    required this.showInProductForm,
    required this.showInPOS,
    required this.showInCart,
    required this.showInInvoice,
    required this.showInSearch,
    required this.showInReports,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['security_key'] = Variable<String>(securityKey);
    if (!nullToAbsent || businessType != null) {
      map['business_type'] = Variable<String>(businessType);
    }
    map['entity_type'] = Variable<String>(entityType);
    map['field_key'] = Variable<String>(fieldKey);
    map['field_label'] = Variable<String>(fieldLabel);
    map['field_type'] = Variable<String>(fieldType);
    if (!nullToAbsent || optionsJson != null) {
      map['options_json'] = Variable<String>(optionsJson);
    }
    if (!nullToAbsent || defaultValue != null) {
      map['default_value'] = Variable<String>(defaultValue);
    }
    map['is_required'] = Variable<bool>(isRequired);
    map['is_active'] = Variable<bool>(isActive);
    map['show_in_product_form'] = Variable<bool>(showInProductForm);
    map['show_in_p_o_s'] = Variable<bool>(showInPOS);
    map['show_in_cart'] = Variable<bool>(showInCart);
    map['show_in_invoice'] = Variable<bool>(showInInvoice);
    map['show_in_search'] = Variable<bool>(showInSearch);
    map['show_in_reports'] = Variable<bool>(showInReports);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomFieldDefinitionsCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldDefinitionsCompanion(
      id: Value(id),
      securityKey: Value(securityKey),
      businessType: businessType == null && nullToAbsent
          ? const Value.absent()
          : Value(businessType),
      entityType: Value(entityType),
      fieldKey: Value(fieldKey),
      fieldLabel: Value(fieldLabel),
      fieldType: Value(fieldType),
      optionsJson: optionsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(optionsJson),
      defaultValue: defaultValue == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultValue),
      isRequired: Value(isRequired),
      isActive: Value(isActive),
      showInProductForm: Value(showInProductForm),
      showInPOS: Value(showInPOS),
      showInCart: Value(showInCart),
      showInInvoice: Value(showInInvoice),
      showInSearch: Value(showInSearch),
      showInReports: Value(showInReports),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomFieldDefinition.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFieldDefinition(
      id: serializer.fromJson<int>(json['id']),
      securityKey: serializer.fromJson<String>(json['securityKey']),
      businessType: serializer.fromJson<String?>(json['businessType']),
      entityType: serializer.fromJson<String>(json['entityType']),
      fieldKey: serializer.fromJson<String>(json['fieldKey']),
      fieldLabel: serializer.fromJson<String>(json['fieldLabel']),
      fieldType: serializer.fromJson<String>(json['fieldType']),
      optionsJson: serializer.fromJson<String?>(json['optionsJson']),
      defaultValue: serializer.fromJson<String?>(json['defaultValue']),
      isRequired: serializer.fromJson<bool>(json['isRequired']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      showInProductForm: serializer.fromJson<bool>(json['showInProductForm']),
      showInPOS: serializer.fromJson<bool>(json['showInPOS']),
      showInCart: serializer.fromJson<bool>(json['showInCart']),
      showInInvoice: serializer.fromJson<bool>(json['showInInvoice']),
      showInSearch: serializer.fromJson<bool>(json['showInSearch']),
      showInReports: serializer.fromJson<bool>(json['showInReports']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'securityKey': serializer.toJson<String>(securityKey),
      'businessType': serializer.toJson<String?>(businessType),
      'entityType': serializer.toJson<String>(entityType),
      'fieldKey': serializer.toJson<String>(fieldKey),
      'fieldLabel': serializer.toJson<String>(fieldLabel),
      'fieldType': serializer.toJson<String>(fieldType),
      'optionsJson': serializer.toJson<String?>(optionsJson),
      'defaultValue': serializer.toJson<String?>(defaultValue),
      'isRequired': serializer.toJson<bool>(isRequired),
      'isActive': serializer.toJson<bool>(isActive),
      'showInProductForm': serializer.toJson<bool>(showInProductForm),
      'showInPOS': serializer.toJson<bool>(showInPOS),
      'showInCart': serializer.toJson<bool>(showInCart),
      'showInInvoice': serializer.toJson<bool>(showInInvoice),
      'showInSearch': serializer.toJson<bool>(showInSearch),
      'showInReports': serializer.toJson<bool>(showInReports),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CustomFieldDefinition copyWith({
    int? id,
    String? securityKey,
    Value<String?> businessType = const Value.absent(),
    String? entityType,
    String? fieldKey,
    String? fieldLabel,
    String? fieldType,
    Value<String?> optionsJson = const Value.absent(),
    Value<String?> defaultValue = const Value.absent(),
    bool? isRequired,
    bool? isActive,
    bool? showInProductForm,
    bool? showInPOS,
    bool? showInCart,
    bool? showInInvoice,
    bool? showInSearch,
    bool? showInReports,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomFieldDefinition(
    id: id ?? this.id,
    securityKey: securityKey ?? this.securityKey,
    businessType: businessType.present ? businessType.value : this.businessType,
    entityType: entityType ?? this.entityType,
    fieldKey: fieldKey ?? this.fieldKey,
    fieldLabel: fieldLabel ?? this.fieldLabel,
    fieldType: fieldType ?? this.fieldType,
    optionsJson: optionsJson.present ? optionsJson.value : this.optionsJson,
    defaultValue: defaultValue.present ? defaultValue.value : this.defaultValue,
    isRequired: isRequired ?? this.isRequired,
    isActive: isActive ?? this.isActive,
    showInProductForm: showInProductForm ?? this.showInProductForm,
    showInPOS: showInPOS ?? this.showInPOS,
    showInCart: showInCart ?? this.showInCart,
    showInInvoice: showInInvoice ?? this.showInInvoice,
    showInSearch: showInSearch ?? this.showInSearch,
    showInReports: showInReports ?? this.showInReports,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CustomFieldDefinition copyWithCompanion(
    CustomFieldDefinitionsCompanion data,
  ) {
    return CustomFieldDefinition(
      id: data.id.present ? data.id.value : this.id,
      securityKey: data.securityKey.present
          ? data.securityKey.value
          : this.securityKey,
      businessType: data.businessType.present
          ? data.businessType.value
          : this.businessType,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      fieldKey: data.fieldKey.present ? data.fieldKey.value : this.fieldKey,
      fieldLabel: data.fieldLabel.present
          ? data.fieldLabel.value
          : this.fieldLabel,
      fieldType: data.fieldType.present ? data.fieldType.value : this.fieldType,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      defaultValue: data.defaultValue.present
          ? data.defaultValue.value
          : this.defaultValue,
      isRequired: data.isRequired.present
          ? data.isRequired.value
          : this.isRequired,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      showInProductForm: data.showInProductForm.present
          ? data.showInProductForm.value
          : this.showInProductForm,
      showInPOS: data.showInPOS.present ? data.showInPOS.value : this.showInPOS,
      showInCart: data.showInCart.present
          ? data.showInCart.value
          : this.showInCart,
      showInInvoice: data.showInInvoice.present
          ? data.showInInvoice.value
          : this.showInInvoice,
      showInSearch: data.showInSearch.present
          ? data.showInSearch.value
          : this.showInSearch,
      showInReports: data.showInReports.present
          ? data.showInReports.value
          : this.showInReports,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldDefinition(')
          ..write('id: $id, ')
          ..write('securityKey: $securityKey, ')
          ..write('businessType: $businessType, ')
          ..write('entityType: $entityType, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('fieldLabel: $fieldLabel, ')
          ..write('fieldType: $fieldType, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('isRequired: $isRequired, ')
          ..write('isActive: $isActive, ')
          ..write('showInProductForm: $showInProductForm, ')
          ..write('showInPOS: $showInPOS, ')
          ..write('showInCart: $showInCart, ')
          ..write('showInInvoice: $showInInvoice, ')
          ..write('showInSearch: $showInSearch, ')
          ..write('showInReports: $showInReports, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    securityKey,
    businessType,
    entityType,
    fieldKey,
    fieldLabel,
    fieldType,
    optionsJson,
    defaultValue,
    isRequired,
    isActive,
    showInProductForm,
    showInPOS,
    showInCart,
    showInInvoice,
    showInSearch,
    showInReports,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFieldDefinition &&
          other.id == this.id &&
          other.securityKey == this.securityKey &&
          other.businessType == this.businessType &&
          other.entityType == this.entityType &&
          other.fieldKey == this.fieldKey &&
          other.fieldLabel == this.fieldLabel &&
          other.fieldType == this.fieldType &&
          other.optionsJson == this.optionsJson &&
          other.defaultValue == this.defaultValue &&
          other.isRequired == this.isRequired &&
          other.isActive == this.isActive &&
          other.showInProductForm == this.showInProductForm &&
          other.showInPOS == this.showInPOS &&
          other.showInCart == this.showInCart &&
          other.showInInvoice == this.showInInvoice &&
          other.showInSearch == this.showInSearch &&
          other.showInReports == this.showInReports &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomFieldDefinitionsCompanion
    extends UpdateCompanion<CustomFieldDefinition> {
  final Value<int> id;
  final Value<String> securityKey;
  final Value<String?> businessType;
  final Value<String> entityType;
  final Value<String> fieldKey;
  final Value<String> fieldLabel;
  final Value<String> fieldType;
  final Value<String?> optionsJson;
  final Value<String?> defaultValue;
  final Value<bool> isRequired;
  final Value<bool> isActive;
  final Value<bool> showInProductForm;
  final Value<bool> showInPOS;
  final Value<bool> showInCart;
  final Value<bool> showInInvoice;
  final Value<bool> showInSearch;
  final Value<bool> showInReports;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomFieldDefinitionsCompanion({
    this.id = const Value.absent(),
    this.securityKey = const Value.absent(),
    this.businessType = const Value.absent(),
    this.entityType = const Value.absent(),
    this.fieldKey = const Value.absent(),
    this.fieldLabel = const Value.absent(),
    this.fieldType = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.isActive = const Value.absent(),
    this.showInProductForm = const Value.absent(),
    this.showInPOS = const Value.absent(),
    this.showInCart = const Value.absent(),
    this.showInInvoice = const Value.absent(),
    this.showInSearch = const Value.absent(),
    this.showInReports = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomFieldDefinitionsCompanion.insert({
    this.id = const Value.absent(),
    required String securityKey,
    this.businessType = const Value.absent(),
    required String entityType,
    required String fieldKey,
    required String fieldLabel,
    required String fieldType,
    this.optionsJson = const Value.absent(),
    this.defaultValue = const Value.absent(),
    this.isRequired = const Value.absent(),
    this.isActive = const Value.absent(),
    this.showInProductForm = const Value.absent(),
    this.showInPOS = const Value.absent(),
    this.showInCart = const Value.absent(),
    this.showInInvoice = const Value.absent(),
    this.showInSearch = const Value.absent(),
    this.showInReports = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : securityKey = Value(securityKey),
       entityType = Value(entityType),
       fieldKey = Value(fieldKey),
       fieldLabel = Value(fieldLabel),
       fieldType = Value(fieldType);
  static Insertable<CustomFieldDefinition> custom({
    Expression<int>? id,
    Expression<String>? securityKey,
    Expression<String>? businessType,
    Expression<String>? entityType,
    Expression<String>? fieldKey,
    Expression<String>? fieldLabel,
    Expression<String>? fieldType,
    Expression<String>? optionsJson,
    Expression<String>? defaultValue,
    Expression<bool>? isRequired,
    Expression<bool>? isActive,
    Expression<bool>? showInProductForm,
    Expression<bool>? showInPOS,
    Expression<bool>? showInCart,
    Expression<bool>? showInInvoice,
    Expression<bool>? showInSearch,
    Expression<bool>? showInReports,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (securityKey != null) 'security_key': securityKey,
      if (businessType != null) 'business_type': businessType,
      if (entityType != null) 'entity_type': entityType,
      if (fieldKey != null) 'field_key': fieldKey,
      if (fieldLabel != null) 'field_label': fieldLabel,
      if (fieldType != null) 'field_type': fieldType,
      if (optionsJson != null) 'options_json': optionsJson,
      if (defaultValue != null) 'default_value': defaultValue,
      if (isRequired != null) 'is_required': isRequired,
      if (isActive != null) 'is_active': isActive,
      if (showInProductForm != null) 'show_in_product_form': showInProductForm,
      if (showInPOS != null) 'show_in_p_o_s': showInPOS,
      if (showInCart != null) 'show_in_cart': showInCart,
      if (showInInvoice != null) 'show_in_invoice': showInInvoice,
      if (showInSearch != null) 'show_in_search': showInSearch,
      if (showInReports != null) 'show_in_reports': showInReports,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomFieldDefinitionsCompanion copyWith({
    Value<int>? id,
    Value<String>? securityKey,
    Value<String?>? businessType,
    Value<String>? entityType,
    Value<String>? fieldKey,
    Value<String>? fieldLabel,
    Value<String>? fieldType,
    Value<String?>? optionsJson,
    Value<String?>? defaultValue,
    Value<bool>? isRequired,
    Value<bool>? isActive,
    Value<bool>? showInProductForm,
    Value<bool>? showInPOS,
    Value<bool>? showInCart,
    Value<bool>? showInInvoice,
    Value<bool>? showInSearch,
    Value<bool>? showInReports,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomFieldDefinitionsCompanion(
      id: id ?? this.id,
      securityKey: securityKey ?? this.securityKey,
      businessType: businessType ?? this.businessType,
      entityType: entityType ?? this.entityType,
      fieldKey: fieldKey ?? this.fieldKey,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldType: fieldType ?? this.fieldType,
      optionsJson: optionsJson ?? this.optionsJson,
      defaultValue: defaultValue ?? this.defaultValue,
      isRequired: isRequired ?? this.isRequired,
      isActive: isActive ?? this.isActive,
      showInProductForm: showInProductForm ?? this.showInProductForm,
      showInPOS: showInPOS ?? this.showInPOS,
      showInCart: showInCart ?? this.showInCart,
      showInInvoice: showInInvoice ?? this.showInInvoice,
      showInSearch: showInSearch ?? this.showInSearch,
      showInReports: showInReports ?? this.showInReports,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (securityKey.present) {
      map['security_key'] = Variable<String>(securityKey.value);
    }
    if (businessType.present) {
      map['business_type'] = Variable<String>(businessType.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (fieldKey.present) {
      map['field_key'] = Variable<String>(fieldKey.value);
    }
    if (fieldLabel.present) {
      map['field_label'] = Variable<String>(fieldLabel.value);
    }
    if (fieldType.present) {
      map['field_type'] = Variable<String>(fieldType.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (defaultValue.present) {
      map['default_value'] = Variable<String>(defaultValue.value);
    }
    if (isRequired.present) {
      map['is_required'] = Variable<bool>(isRequired.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (showInProductForm.present) {
      map['show_in_product_form'] = Variable<bool>(showInProductForm.value);
    }
    if (showInPOS.present) {
      map['show_in_p_o_s'] = Variable<bool>(showInPOS.value);
    }
    if (showInCart.present) {
      map['show_in_cart'] = Variable<bool>(showInCart.value);
    }
    if (showInInvoice.present) {
      map['show_in_invoice'] = Variable<bool>(showInInvoice.value);
    }
    if (showInSearch.present) {
      map['show_in_search'] = Variable<bool>(showInSearch.value);
    }
    if (showInReports.present) {
      map['show_in_reports'] = Variable<bool>(showInReports.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldDefinitionsCompanion(')
          ..write('id: $id, ')
          ..write('securityKey: $securityKey, ')
          ..write('businessType: $businessType, ')
          ..write('entityType: $entityType, ')
          ..write('fieldKey: $fieldKey, ')
          ..write('fieldLabel: $fieldLabel, ')
          ..write('fieldType: $fieldType, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('defaultValue: $defaultValue, ')
          ..write('isRequired: $isRequired, ')
          ..write('isActive: $isActive, ')
          ..write('showInProductForm: $showInProductForm, ')
          ..write('showInPOS: $showInPOS, ')
          ..write('showInCart: $showInCart, ')
          ..write('showInInvoice: $showInInvoice, ')
          ..write('showInSearch: $showInSearch, ')
          ..write('showInReports: $showInReports, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomFieldValuesTable extends CustomFieldValues
    with TableInfo<$CustomFieldValuesTable, CustomFieldValue> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomFieldValuesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _definitionIdMeta = const VerificationMeta(
    'definitionId',
  );
  @override
  late final GeneratedColumn<int> definitionId = GeneratedColumn<int>(
    'definition_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_field_definitions (id)',
    ),
  );
  static const VerificationMeta _securityKeyMeta = const VerificationMeta(
    'securityKey',
  );
  @override
  late final GeneratedColumn<String> securityKey = GeneratedColumn<String>(
    'security_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueTextMeta = const VerificationMeta(
    'valueText',
  );
  @override
  late final GeneratedColumn<String> valueText = GeneratedColumn<String>(
    'value_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueNumberMeta = const VerificationMeta(
    'valueNumber',
  );
  @override
  late final GeneratedColumn<double> valueNumber = GeneratedColumn<double>(
    'value_number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueDateMeta = const VerificationMeta(
    'valueDate',
  );
  @override
  late final GeneratedColumn<DateTime> valueDate = GeneratedColumn<DateTime>(
    'value_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _valueBoolMeta = const VerificationMeta(
    'valueBool',
  );
  @override
  late final GeneratedColumn<bool> valueBool = GeneratedColumn<bool>(
    'value_bool',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("value_bool" IN (0, 1))',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    definitionId,
    securityKey,
    entityType,
    entityId,
    valueText,
    valueNumber,
    valueDate,
    valueBool,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_field_values';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomFieldValue> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('definition_id')) {
      context.handle(
        _definitionIdMeta,
        definitionId.isAcceptableOrUnknown(
          data['definition_id']!,
          _definitionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_definitionIdMeta);
    }
    if (data.containsKey('security_key')) {
      context.handle(
        _securityKeyMeta,
        securityKey.isAcceptableOrUnknown(
          data['security_key']!,
          _securityKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_securityKeyMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('value_text')) {
      context.handle(
        _valueTextMeta,
        valueText.isAcceptableOrUnknown(data['value_text']!, _valueTextMeta),
      );
    }
    if (data.containsKey('value_number')) {
      context.handle(
        _valueNumberMeta,
        valueNumber.isAcceptableOrUnknown(
          data['value_number']!,
          _valueNumberMeta,
        ),
      );
    }
    if (data.containsKey('value_date')) {
      context.handle(
        _valueDateMeta,
        valueDate.isAcceptableOrUnknown(data['value_date']!, _valueDateMeta),
      );
    }
    if (data.containsKey('value_bool')) {
      context.handle(
        _valueBoolMeta,
        valueBool.isAcceptableOrUnknown(data['value_bool']!, _valueBoolMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomFieldValue map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomFieldValue(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      definitionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}definition_id'],
      )!,
      securityKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}security_key'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entity_id'],
      )!,
      valueText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_text'],
      ),
      valueNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value_number'],
      ),
      valueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}value_date'],
      ),
      valueBool: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}value_bool'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CustomFieldValuesTable createAlias(String alias) {
    return $CustomFieldValuesTable(attachedDatabase, alias);
  }
}

class CustomFieldValue extends DataClass
    implements Insertable<CustomFieldValue> {
  final int id;
  final int definitionId;
  final String securityKey;
  final String entityType;
  final int entityId;
  final String? valueText;
  final double? valueNumber;
  final DateTime? valueDate;
  final bool? valueBool;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CustomFieldValue({
    required this.id,
    required this.definitionId,
    required this.securityKey,
    required this.entityType,
    required this.entityId,
    this.valueText,
    this.valueNumber,
    this.valueDate,
    this.valueBool,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['definition_id'] = Variable<int>(definitionId);
    map['security_key'] = Variable<String>(securityKey);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<int>(entityId);
    if (!nullToAbsent || valueText != null) {
      map['value_text'] = Variable<String>(valueText);
    }
    if (!nullToAbsent || valueNumber != null) {
      map['value_number'] = Variable<double>(valueNumber);
    }
    if (!nullToAbsent || valueDate != null) {
      map['value_date'] = Variable<DateTime>(valueDate);
    }
    if (!nullToAbsent || valueBool != null) {
      map['value_bool'] = Variable<bool>(valueBool);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CustomFieldValuesCompanion toCompanion(bool nullToAbsent) {
    return CustomFieldValuesCompanion(
      id: Value(id),
      definitionId: Value(definitionId),
      securityKey: Value(securityKey),
      entityType: Value(entityType),
      entityId: Value(entityId),
      valueText: valueText == null && nullToAbsent
          ? const Value.absent()
          : Value(valueText),
      valueNumber: valueNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(valueNumber),
      valueDate: valueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(valueDate),
      valueBool: valueBool == null && nullToAbsent
          ? const Value.absent()
          : Value(valueBool),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CustomFieldValue.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomFieldValue(
      id: serializer.fromJson<int>(json['id']),
      definitionId: serializer.fromJson<int>(json['definitionId']),
      securityKey: serializer.fromJson<String>(json['securityKey']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<int>(json['entityId']),
      valueText: serializer.fromJson<String?>(json['valueText']),
      valueNumber: serializer.fromJson<double?>(json['valueNumber']),
      valueDate: serializer.fromJson<DateTime?>(json['valueDate']),
      valueBool: serializer.fromJson<bool?>(json['valueBool']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'definitionId': serializer.toJson<int>(definitionId),
      'securityKey': serializer.toJson<String>(securityKey),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<int>(entityId),
      'valueText': serializer.toJson<String?>(valueText),
      'valueNumber': serializer.toJson<double?>(valueNumber),
      'valueDate': serializer.toJson<DateTime?>(valueDate),
      'valueBool': serializer.toJson<bool?>(valueBool),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CustomFieldValue copyWith({
    int? id,
    int? definitionId,
    String? securityKey,
    String? entityType,
    int? entityId,
    Value<String?> valueText = const Value.absent(),
    Value<double?> valueNumber = const Value.absent(),
    Value<DateTime?> valueDate = const Value.absent(),
    Value<bool?> valueBool = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CustomFieldValue(
    id: id ?? this.id,
    definitionId: definitionId ?? this.definitionId,
    securityKey: securityKey ?? this.securityKey,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    valueText: valueText.present ? valueText.value : this.valueText,
    valueNumber: valueNumber.present ? valueNumber.value : this.valueNumber,
    valueDate: valueDate.present ? valueDate.value : this.valueDate,
    valueBool: valueBool.present ? valueBool.value : this.valueBool,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CustomFieldValue copyWithCompanion(CustomFieldValuesCompanion data) {
    return CustomFieldValue(
      id: data.id.present ? data.id.value : this.id,
      definitionId: data.definitionId.present
          ? data.definitionId.value
          : this.definitionId,
      securityKey: data.securityKey.present
          ? data.securityKey.value
          : this.securityKey,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      valueText: data.valueText.present ? data.valueText.value : this.valueText,
      valueNumber: data.valueNumber.present
          ? data.valueNumber.value
          : this.valueNumber,
      valueDate: data.valueDate.present ? data.valueDate.value : this.valueDate,
      valueBool: data.valueBool.present ? data.valueBool.value : this.valueBool,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldValue(')
          ..write('id: $id, ')
          ..write('definitionId: $definitionId, ')
          ..write('securityKey: $securityKey, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('valueText: $valueText, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueDate: $valueDate, ')
          ..write('valueBool: $valueBool, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    definitionId,
    securityKey,
    entityType,
    entityId,
    valueText,
    valueNumber,
    valueDate,
    valueBool,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomFieldValue &&
          other.id == this.id &&
          other.definitionId == this.definitionId &&
          other.securityKey == this.securityKey &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.valueText == this.valueText &&
          other.valueNumber == this.valueNumber &&
          other.valueDate == this.valueDate &&
          other.valueBool == this.valueBool &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CustomFieldValuesCompanion extends UpdateCompanion<CustomFieldValue> {
  final Value<int> id;
  final Value<int> definitionId;
  final Value<String> securityKey;
  final Value<String> entityType;
  final Value<int> entityId;
  final Value<String?> valueText;
  final Value<double?> valueNumber;
  final Value<DateTime?> valueDate;
  final Value<bool?> valueBool;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const CustomFieldValuesCompanion({
    this.id = const Value.absent(),
    this.definitionId = const Value.absent(),
    this.securityKey = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.valueText = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.valueBool = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CustomFieldValuesCompanion.insert({
    this.id = const Value.absent(),
    required int definitionId,
    required String securityKey,
    required String entityType,
    required int entityId,
    this.valueText = const Value.absent(),
    this.valueNumber = const Value.absent(),
    this.valueDate = const Value.absent(),
    this.valueBool = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : definitionId = Value(definitionId),
       securityKey = Value(securityKey),
       entityType = Value(entityType),
       entityId = Value(entityId);
  static Insertable<CustomFieldValue> custom({
    Expression<int>? id,
    Expression<int>? definitionId,
    Expression<String>? securityKey,
    Expression<String>? entityType,
    Expression<int>? entityId,
    Expression<String>? valueText,
    Expression<double>? valueNumber,
    Expression<DateTime>? valueDate,
    Expression<bool>? valueBool,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (definitionId != null) 'definition_id': definitionId,
      if (securityKey != null) 'security_key': securityKey,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (valueText != null) 'value_text': valueText,
      if (valueNumber != null) 'value_number': valueNumber,
      if (valueDate != null) 'value_date': valueDate,
      if (valueBool != null) 'value_bool': valueBool,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CustomFieldValuesCompanion copyWith({
    Value<int>? id,
    Value<int>? definitionId,
    Value<String>? securityKey,
    Value<String>? entityType,
    Value<int>? entityId,
    Value<String?>? valueText,
    Value<double?>? valueNumber,
    Value<DateTime?>? valueDate,
    Value<bool?>? valueBool,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return CustomFieldValuesCompanion(
      id: id ?? this.id,
      definitionId: definitionId ?? this.definitionId,
      securityKey: securityKey ?? this.securityKey,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      valueText: valueText ?? this.valueText,
      valueNumber: valueNumber ?? this.valueNumber,
      valueDate: valueDate ?? this.valueDate,
      valueBool: valueBool ?? this.valueBool,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (definitionId.present) {
      map['definition_id'] = Variable<int>(definitionId.value);
    }
    if (securityKey.present) {
      map['security_key'] = Variable<String>(securityKey.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (valueText.present) {
      map['value_text'] = Variable<String>(valueText.value);
    }
    if (valueNumber.present) {
      map['value_number'] = Variable<double>(valueNumber.value);
    }
    if (valueDate.present) {
      map['value_date'] = Variable<DateTime>(valueDate.value);
    }
    if (valueBool.present) {
      map['value_bool'] = Variable<bool>(valueBool.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomFieldValuesCompanion(')
          ..write('id: $id, ')
          ..write('definitionId: $definitionId, ')
          ..write('securityKey: $securityKey, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('valueText: $valueText, ')
          ..write('valueNumber: $valueNumber, ')
          ..write('valueDate: $valueDate, ')
          ..write('valueBool: $valueBool, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $MedicinesTable medicines = $MedicinesTable(this);
  late final $BatchesTable batches = $BatchesTable(this);
  late final $ProductUnitsTable productUnits = $ProductUnitsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleItemsTable saleItems = $SaleItemsTable(this);
  late final $CustomFieldDefinitionsTable customFieldDefinitions =
      $CustomFieldDefinitionsTable(this);
  late final $CustomFieldValuesTable customFieldValues =
      $CustomFieldValuesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    settings,
    categories,
    medicines,
    batches,
    productUnits,
    customers,
    sales,
    saleItems,
    customFieldDefinitions,
    customFieldValues,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      required String username,
      required String passwordHash,
      required String role,
      Value<bool> isActive,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> passwordHash,
      Value<String> role,
      Value<bool> isActive,
    });

final class $$UsersTableReferences
    extends BaseReferences<_$AppDatabase, $UsersTable, User> {
  $$UsersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.users.id, db.sales.userId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.userId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.userId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, $$UsersTableReferences),
          User,
          PrefetchHooks Function({bool salesRefs})
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> passwordHash = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String passwordHash,
                required String role,
                Value<bool> isActive = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                username: username,
                passwordHash: passwordHash,
                role: role,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$UsersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<User, $UsersTable, Sale>(
                      currentTable: table,
                      referencedTable: $$UsersTableReferences._salesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$UsersTableReferences(db, table, p0).salesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.userId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, $$UsersTableReferences),
      User,
      PrefetchHooks Function({bool salesRefs})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<int?> parentId,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<DateTime> createdAt,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int?> parentId,
      Value<String?> description,
      Value<String?> imageUrl,
      Value<DateTime> createdAt,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> parentId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                parentId: parentId,
                description: description,
                imageUrl: imageUrl,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> parentId = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                description: description,
                imageUrl: imageUrl,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$MedicinesTableCreateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      required String name,
      required String code,
      Value<String> mainCategory,
      Value<String?> subCategory,
      Value<String?> manufacturer,
      Value<String?> description,
      Value<int> minStock,
      Value<String?> brand,
      Value<String?> model,
      Value<String?> genericName,
      Value<String?> strength,
      Value<String?> dosageForm,
      Value<String> baseUnitName,
    });
typedef $$MedicinesTableUpdateCompanionBuilder =
    MedicinesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> code,
      Value<String> mainCategory,
      Value<String?> subCategory,
      Value<String?> manufacturer,
      Value<String?> description,
      Value<int> minStock,
      Value<String?> brand,
      Value<String?> model,
      Value<String?> genericName,
      Value<String?> strength,
      Value<String?> dosageForm,
      Value<String> baseUnitName,
    });

final class $$MedicinesTableReferences
    extends BaseReferences<_$AppDatabase, $MedicinesTable, Medicine> {
  $$MedicinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BatchesTable, List<Batch>> _batchesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.batches,
    aliasName: $_aliasNameGenerator(db.medicines.id, db.batches.medicineId),
  );

  $$BatchesTableProcessedTableManager get batchesRefs {
    final manager = $$BatchesTableTableManager(
      $_db,
      $_db.batches,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_batchesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProductUnitsTable, List<ProductUnit>>
  _productUnitsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productUnits,
    aliasName: $_aliasNameGenerator(
      db.medicines.id,
      db.productUnits.medicineId,
    ),
  );

  $$ProductUnitsTableProcessedTableManager get productUnitsRefs {
    final manager = $$ProductUnitsTableTableManager(
      $_db,
      $_db.productUnits,
    ).filter((f) => f.medicineId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_productUnitsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MedicinesTableFilterComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mainCategory => $composableBuilder(
    column: $table.mainCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseUnitName => $composableBuilder(
    column: $table.baseUnitName,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> batchesRefs(
    Expression<bool> Function($$BatchesTableFilterComposer f) f,
  ) {
    final $$BatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batches,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatchesTableFilterComposer(
            $db: $db,
            $table: $db.batches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> productUnitsRefs(
    Expression<bool> Function($$ProductUnitsTableFilterComposer f) f,
  ) {
    final $$ProductUnitsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUnits,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUnitsTableFilterComposer(
            $db: $db,
            $table: $db.productUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableOrderingComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mainCategory => $composableBuilder(
    column: $table.mainCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minStock => $composableBuilder(
    column: $table.minStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strength => $composableBuilder(
    column: $table.strength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseUnitName => $composableBuilder(
    column: $table.baseUnitName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MedicinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MedicinesTable> {
  $$MedicinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get mainCategory => $composableBuilder(
    column: $table.mainCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get manufacturer => $composableBuilder(
    column: $table.manufacturer,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minStock =>
      $composableBuilder(column: $table.minStock, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get genericName => $composableBuilder(
    column: $table.genericName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get strength =>
      $composableBuilder(column: $table.strength, builder: (column) => column);

  GeneratedColumn<String> get dosageForm => $composableBuilder(
    column: $table.dosageForm,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseUnitName => $composableBuilder(
    column: $table.baseUnitName,
    builder: (column) => column,
  );

  Expression<T> batchesRefs<T extends Object>(
    Expression<T> Function($$BatchesTableAnnotationComposer a) f,
  ) {
    final $$BatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.batches,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.batches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> productUnitsRefs<T extends Object>(
    Expression<T> Function($$ProductUnitsTableAnnotationComposer a) f,
  ) {
    final $$ProductUnitsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productUnits,
      getReferencedColumn: (t) => t.medicineId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductUnitsTableAnnotationComposer(
            $db: $db,
            $table: $db.productUnits,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MedicinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MedicinesTable,
          Medicine,
          $$MedicinesTableFilterComposer,
          $$MedicinesTableOrderingComposer,
          $$MedicinesTableAnnotationComposer,
          $$MedicinesTableCreateCompanionBuilder,
          $$MedicinesTableUpdateCompanionBuilder,
          (Medicine, $$MedicinesTableReferences),
          Medicine,
          PrefetchHooks Function({bool batchesRefs, bool productUnitsRefs})
        > {
  $$MedicinesTableTableManager(_$AppDatabase db, $MedicinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MedicinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MedicinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MedicinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> mainCategory = const Value.absent(),
                Value<String?> subCategory = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> minStock = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> genericName = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                Value<String> baseUnitName = const Value.absent(),
              }) => MedicinesCompanion(
                id: id,
                name: name,
                code: code,
                mainCategory: mainCategory,
                subCategory: subCategory,
                manufacturer: manufacturer,
                description: description,
                minStock: minStock,
                brand: brand,
                model: model,
                genericName: genericName,
                strength: strength,
                dosageForm: dosageForm,
                baseUnitName: baseUnitName,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String code,
                Value<String> mainCategory = const Value.absent(),
                Value<String?> subCategory = const Value.absent(),
                Value<String?> manufacturer = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> minStock = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> genericName = const Value.absent(),
                Value<String?> strength = const Value.absent(),
                Value<String?> dosageForm = const Value.absent(),
                Value<String> baseUnitName = const Value.absent(),
              }) => MedicinesCompanion.insert(
                id: id,
                name: name,
                code: code,
                mainCategory: mainCategory,
                subCategory: subCategory,
                manufacturer: manufacturer,
                description: description,
                minStock: minStock,
                brand: brand,
                model: model,
                genericName: genericName,
                strength: strength,
                dosageForm: dosageForm,
                baseUnitName: baseUnitName,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MedicinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({batchesRefs = false, productUnitsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (batchesRefs) db.batches,
                    if (productUnitsRefs) db.productUnits,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (batchesRefs)
                        await $_getPrefetchedData<
                          Medicine,
                          $MedicinesTable,
                          Batch
                        >(
                          currentTable: table,
                          referencedTable: $$MedicinesTableReferences
                              ._batchesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicinesTableReferences(
                                db,
                                table,
                                p0,
                              ).batchesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicineId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (productUnitsRefs)
                        await $_getPrefetchedData<
                          Medicine,
                          $MedicinesTable,
                          ProductUnit
                        >(
                          currentTable: table,
                          referencedTable: $$MedicinesTableReferences
                              ._productUnitsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MedicinesTableReferences(
                                db,
                                table,
                                p0,
                              ).productUnitsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.medicineId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$MedicinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MedicinesTable,
      Medicine,
      $$MedicinesTableFilterComposer,
      $$MedicinesTableOrderingComposer,
      $$MedicinesTableAnnotationComposer,
      $$MedicinesTableCreateCompanionBuilder,
      $$MedicinesTableUpdateCompanionBuilder,
      (Medicine, $$MedicinesTableReferences),
      Medicine,
      PrefetchHooks Function({bool batchesRefs, bool productUnitsRefs})
    >;
typedef $$BatchesTableCreateCompanionBuilder =
    BatchesCompanion Function({
      Value<int> id,
      required int medicineId,
      required String batchNumber,
      required DateTime expiryDate,
      required double purchasePrice,
      required double salePrice,
      required int quantity,
      Value<int> packSize,
    });
typedef $$BatchesTableUpdateCompanionBuilder =
    BatchesCompanion Function({
      Value<int> id,
      Value<int> medicineId,
      Value<String> batchNumber,
      Value<DateTime> expiryDate,
      Value<double> purchasePrice,
      Value<double> salePrice,
      Value<int> quantity,
      Value<int> packSize,
    });

final class $$BatchesTableReferences
    extends BaseReferences<_$AppDatabase, $BatchesTable, Batch> {
  $$BatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
        $_aliasNameGenerator(db.batches.medicineId, db.medicines.id),
      );

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
  _saleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleItems,
    aliasName: $_aliasNameGenerator(db.batches.id, db.saleItems.batchId),
  );

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager(
      $_db,
      $_db.saleItems,
    ).filter((f) => f.batchId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BatchesTableFilterComposer
    extends Composer<_$AppDatabase, $BatchesTable> {
  $$BatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> saleItemsRefs(
    Expression<bool> Function($$SaleItemsTableFilterComposer f) f,
  ) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableFilterComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $BatchesTable> {
  $$BatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get packSize => $composableBuilder(
    column: $table.packSize,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BatchesTable> {
  $$BatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get batchNumber => $composableBuilder(
    column: $table.batchNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiryDate => $composableBuilder(
    column: $table.expiryDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get purchasePrice => $composableBuilder(
    column: $table.purchasePrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get packSize =>
      $composableBuilder(column: $table.packSize, builder: (column) => column);

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
    Expression<T> Function($$SaleItemsTableAnnotationComposer a) f,
  ) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.batchId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BatchesTable,
          Batch,
          $$BatchesTableFilterComposer,
          $$BatchesTableOrderingComposer,
          $$BatchesTableAnnotationComposer,
          $$BatchesTableCreateCompanionBuilder,
          $$BatchesTableUpdateCompanionBuilder,
          (Batch, $$BatchesTableReferences),
          Batch,
          PrefetchHooks Function({bool medicineId, bool saleItemsRefs})
        > {
  $$BatchesTableTableManager(_$AppDatabase db, $BatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicineId = const Value.absent(),
                Value<String> batchNumber = const Value.absent(),
                Value<DateTime> expiryDate = const Value.absent(),
                Value<double> purchasePrice = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> packSize = const Value.absent(),
              }) => BatchesCompanion(
                id: id,
                medicineId: medicineId,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                quantity: quantity,
                packSize: packSize,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicineId,
                required String batchNumber,
                required DateTime expiryDate,
                required double purchasePrice,
                required double salePrice,
                required int quantity,
                Value<int> packSize = const Value.absent(),
              }) => BatchesCompanion.insert(
                id: id,
                medicineId: medicineId,
                batchNumber: batchNumber,
                expiryDate: expiryDate,
                purchasePrice: purchasePrice,
                salePrice: salePrice,
                quantity: quantity,
                packSize: packSize,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineId = false, saleItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (saleItemsRefs) db.saleItems],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicineId,
                                referencedTable: $$BatchesTableReferences
                                    ._medicineIdTable(db),
                                referencedColumn: $$BatchesTableReferences
                                    ._medicineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (saleItemsRefs)
                    await $_getPrefetchedData<Batch, $BatchesTable, SaleItem>(
                      currentTable: table,
                      referencedTable: $$BatchesTableReferences
                          ._saleItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BatchesTableReferences(db, table, p0).saleItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.batchId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BatchesTable,
      Batch,
      $$BatchesTableFilterComposer,
      $$BatchesTableOrderingComposer,
      $$BatchesTableAnnotationComposer,
      $$BatchesTableCreateCompanionBuilder,
      $$BatchesTableUpdateCompanionBuilder,
      (Batch, $$BatchesTableReferences),
      Batch,
      PrefetchHooks Function({bool medicineId, bool saleItemsRefs})
    >;
typedef $$ProductUnitsTableCreateCompanionBuilder =
    ProductUnitsCompanion Function({
      Value<int> id,
      required int medicineId,
      required String name,
      Value<double> conversionFactor,
      required double salePrice,
      Value<bool> isBaseUnit,
      Value<bool> isDefaultSaleUnit,
    });
typedef $$ProductUnitsTableUpdateCompanionBuilder =
    ProductUnitsCompanion Function({
      Value<int> id,
      Value<int> medicineId,
      Value<String> name,
      Value<double> conversionFactor,
      Value<double> salePrice,
      Value<bool> isBaseUnit,
      Value<bool> isDefaultSaleUnit,
    });

final class $$ProductUnitsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductUnitsTable, ProductUnit> {
  $$ProductUnitsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MedicinesTable _medicineIdTable(_$AppDatabase db) =>
      db.medicines.createAlias(
        $_aliasNameGenerator(db.productUnits.medicineId, db.medicines.id),
      );

  $$MedicinesTableProcessedTableManager get medicineId {
    final $_column = $_itemColumn<int>('medicine_id')!;

    final manager = $$MedicinesTableTableManager(
      $_db,
      $_db.medicines,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_medicineIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductUnitsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBaseUnit => $composableBuilder(
    column: $table.isBaseUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefaultSaleUnit => $composableBuilder(
    column: $table.isDefaultSaleUnit,
    builder: (column) => ColumnFilters(column),
  );

  $$MedicinesTableFilterComposer get medicineId {
    final $$MedicinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableFilterComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUnitsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get salePrice => $composableBuilder(
    column: $table.salePrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBaseUnit => $composableBuilder(
    column: $table.isBaseUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefaultSaleUnit => $composableBuilder(
    column: $table.isDefaultSaleUnit,
    builder: (column) => ColumnOrderings(column),
  );

  $$MedicinesTableOrderingComposer get medicineId {
    final $$MedicinesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableOrderingComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUnitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductUnitsTable> {
  $$ProductUnitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<double> get salePrice =>
      $composableBuilder(column: $table.salePrice, builder: (column) => column);

  GeneratedColumn<bool> get isBaseUnit => $composableBuilder(
    column: $table.isBaseUnit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefaultSaleUnit => $composableBuilder(
    column: $table.isDefaultSaleUnit,
    builder: (column) => column,
  );

  $$MedicinesTableAnnotationComposer get medicineId {
    final $$MedicinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.medicineId,
      referencedTable: $db.medicines,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MedicinesTableAnnotationComposer(
            $db: $db,
            $table: $db.medicines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductUnitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductUnitsTable,
          ProductUnit,
          $$ProductUnitsTableFilterComposer,
          $$ProductUnitsTableOrderingComposer,
          $$ProductUnitsTableAnnotationComposer,
          $$ProductUnitsTableCreateCompanionBuilder,
          $$ProductUnitsTableUpdateCompanionBuilder,
          (ProductUnit, $$ProductUnitsTableReferences),
          ProductUnit,
          PrefetchHooks Function({bool medicineId})
        > {
  $$ProductUnitsTableTableManager(_$AppDatabase db, $ProductUnitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductUnitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductUnitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductUnitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> medicineId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<double> salePrice = const Value.absent(),
                Value<bool> isBaseUnit = const Value.absent(),
                Value<bool> isDefaultSaleUnit = const Value.absent(),
              }) => ProductUnitsCompanion(
                id: id,
                medicineId: medicineId,
                name: name,
                conversionFactor: conversionFactor,
                salePrice: salePrice,
                isBaseUnit: isBaseUnit,
                isDefaultSaleUnit: isDefaultSaleUnit,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int medicineId,
                required String name,
                Value<double> conversionFactor = const Value.absent(),
                required double salePrice,
                Value<bool> isBaseUnit = const Value.absent(),
                Value<bool> isDefaultSaleUnit = const Value.absent(),
              }) => ProductUnitsCompanion.insert(
                id: id,
                medicineId: medicineId,
                name: name,
                conversionFactor: conversionFactor,
                salePrice: salePrice,
                isBaseUnit: isBaseUnit,
                isDefaultSaleUnit: isDefaultSaleUnit,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductUnitsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({medicineId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (medicineId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.medicineId,
                                referencedTable: $$ProductUnitsTableReferences
                                    ._medicineIdTable(db),
                                referencedColumn: $$ProductUnitsTableReferences
                                    ._medicineIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductUnitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductUnitsTable,
      ProductUnit,
      $$ProductUnitsTableFilterComposer,
      $$ProductUnitsTableOrderingComposer,
      $$ProductUnitsTableAnnotationComposer,
      $$ProductUnitsTableCreateCompanionBuilder,
      $$ProductUnitsTableUpdateCompanionBuilder,
      (ProductUnit, $$ProductUnitsTableReferences),
      ProductUnit,
      PrefetchHooks Function({bool medicineId})
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> phoneNumber,
      Value<DateTime> createdAt,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> phoneNumber,
      Value<DateTime> createdAt,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.customers.id, db.sales.customerId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool salesRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> phoneNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phoneNumber: phoneNumber,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Sale>(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._salesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(db, table, p0).salesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool salesRefs})
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required String invoiceNumber,
      Value<int?> customerId,
      required DateTime date,
      required double subTotal,
      Value<double> discount,
      Value<double> tax,
      Value<double> posFee,
      required double grandTotal,
      Value<String> paymentMethod,
      Value<int?> userId,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<String> invoiceNumber,
      Value<int?> customerId,
      Value<DateTime> date,
      Value<double> subTotal,
      Value<double> discount,
      Value<double> tax,
      Value<double> posFee,
      Value<double> grandTotal,
      Value<String> paymentMethod,
      Value<int?> userId,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias($_aliasNameGenerator(db.sales.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<int>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UsersTable _userIdTable(_$AppDatabase db) =>
      db.users.createAlias($_aliasNameGenerator(db.sales.userId, db.users.id));

  $$UsersTableProcessedTableManager? get userId {
    final $_column = $_itemColumn<int>('user_id');
    if ($_column == null) return null;
    final manager = $$UsersTableTableManager(
      $_db,
      $_db.users,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_userIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SaleItemsTable, List<SaleItem>>
  _saleItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleItems,
    aliasName: $_aliasNameGenerator(db.sales.id, db.saleItems.saleId),
  );

  $$SaleItemsTableProcessedTableManager get saleItemsRefs {
    final manager = $$SaleItemsTableTableManager(
      $_db,
      $_db.saleItems,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get posFee => $composableBuilder(
    column: $table.posFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableFilterComposer get userId {
    final $$UsersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableFilterComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> saleItemsRefs(
    Expression<bool> Function($$SaleItemsTableFilterComposer f) f,
  ) {
    final $$SaleItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableFilterComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subTotal => $composableBuilder(
    column: $table.subTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get posFee => $composableBuilder(
    column: $table.posFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableOrderingComposer get userId {
    final $$UsersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableOrderingComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get invoiceNumber => $composableBuilder(
    column: $table.invoiceNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get subTotal =>
      $composableBuilder(column: $table.subTotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<double> get posFee =>
      $composableBuilder(column: $table.posFee, builder: (column) => column);

  GeneratedColumn<double> get grandTotal => $composableBuilder(
    column: $table.grandTotal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UsersTableAnnotationComposer get userId {
    final $$UsersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.userId,
      referencedTable: $db.users,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UsersTableAnnotationComposer(
            $db: $db,
            $table: $db.users,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> saleItemsRefs<T extends Object>(
    Expression<T> Function($$SaleItemsTableAnnotationComposer a) f,
  ) {
    final $$SaleItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleItems,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.saleItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({
            bool customerId,
            bool userId,
            bool saleItemsRefs,
          })
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> invoiceNumber = const Value.absent(),
                Value<int?> customerId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> subTotal = const Value.absent(),
                Value<double> discount = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<double> posFee = const Value.absent(),
                Value<double> grandTotal = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> userId = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                invoiceNumber: invoiceNumber,
                customerId: customerId,
                date: date,
                subTotal: subTotal,
                discount: discount,
                tax: tax,
                posFee: posFee,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                userId: userId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String invoiceNumber,
                Value<int?> customerId = const Value.absent(),
                required DateTime date,
                required double subTotal,
                Value<double> discount = const Value.absent(),
                Value<double> tax = const Value.absent(),
                Value<double> posFee = const Value.absent(),
                required double grandTotal,
                Value<String> paymentMethod = const Value.absent(),
                Value<int?> userId = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                invoiceNumber: invoiceNumber,
                customerId: customerId,
                date: date,
                subTotal: subTotal,
                discount: discount,
                tax: tax,
                posFee: posFee,
                grandTotal: grandTotal,
                paymentMethod: paymentMethod,
                userId: userId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerId = false, userId = false, saleItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (saleItemsRefs) db.saleItems],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$SalesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (userId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.userId,
                                    referencedTable: $$SalesTableReferences
                                        ._userIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._userIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleItemsRefs)
                        await $_getPrefetchedData<Sale, $SalesTable, SaleItem>(
                          currentTable: table,
                          referencedTable: $$SalesTableReferences
                              ._saleItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SalesTableReferences(
                                db,
                                table,
                                p0,
                              ).saleItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({bool customerId, bool userId, bool saleItemsRefs})
    >;
typedef $$SaleItemsTableCreateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      required int saleId,
      required int batchId,
      required int quantity,
      required double price,
      required double total,
      Value<String?> unitName,
      Value<double> conversionFactor,
      Value<String?> customFieldsJson,
    });
typedef $$SaleItemsTableUpdateCompanionBuilder =
    SaleItemsCompanion Function({
      Value<int> id,
      Value<int> saleId,
      Value<int> batchId,
      Value<int> quantity,
      Value<double> price,
      Value<double> total,
      Value<String?> unitName,
      Value<double> conversionFactor,
      Value<String?> customFieldsJson,
    });

final class $$SaleItemsTableReferences
    extends BaseReferences<_$AppDatabase, $SaleItemsTable, SaleItem> {
  $$SaleItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales.createAlias(
    $_aliasNameGenerator(db.saleItems.saleId, db.sales.id),
  );

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<int>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BatchesTable _batchIdTable(_$AppDatabase db) => db.batches
      .createAlias($_aliasNameGenerator(db.saleItems.batchId, db.batches.id));

  $$BatchesTableProcessedTableManager get batchId {
    final $_column = $_itemColumn<int>('batch_id')!;

    final manager = $$BatchesTableTableManager(
      $_db,
      $_db.batches,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_batchIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BatchesTableFilterComposer get batchId {
    final $$BatchesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.batches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatchesTableFilterComposer(
            $db: $db,
            $table: $db.batches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unitName => $composableBuilder(
    column: $table.unitName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BatchesTableOrderingComposer get batchId {
    final $$BatchesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.batches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatchesTableOrderingComposer(
            $db: $db,
            $table: $db.batches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleItemsTable> {
  $$SaleItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get unitName =>
      $composableBuilder(column: $table.unitName, builder: (column) => column);

  GeneratedColumn<double> get conversionFactor => $composableBuilder(
    column: $table.conversionFactor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customFieldsJson => $composableBuilder(
    column: $table.customFieldsJson,
    builder: (column) => column,
  );

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BatchesTableAnnotationComposer get batchId {
    final $$BatchesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.batchId,
      referencedTable: $db.batches,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BatchesTableAnnotationComposer(
            $db: $db,
            $table: $db.batches,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleItemsTable,
          SaleItem,
          $$SaleItemsTableFilterComposer,
          $$SaleItemsTableOrderingComposer,
          $$SaleItemsTableAnnotationComposer,
          $$SaleItemsTableCreateCompanionBuilder,
          $$SaleItemsTableUpdateCompanionBuilder,
          (SaleItem, $$SaleItemsTableReferences),
          SaleItem,
          PrefetchHooks Function({bool saleId, bool batchId})
        > {
  $$SaleItemsTableTableManager(_$AppDatabase db, $SaleItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> saleId = const Value.absent(),
                Value<int> batchId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<double> total = const Value.absent(),
                Value<String?> unitName = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<String?> customFieldsJson = const Value.absent(),
              }) => SaleItemsCompanion(
                id: id,
                saleId: saleId,
                batchId: batchId,
                quantity: quantity,
                price: price,
                total: total,
                unitName: unitName,
                conversionFactor: conversionFactor,
                customFieldsJson: customFieldsJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int saleId,
                required int batchId,
                required int quantity,
                required double price,
                required double total,
                Value<String?> unitName = const Value.absent(),
                Value<double> conversionFactor = const Value.absent(),
                Value<String?> customFieldsJson = const Value.absent(),
              }) => SaleItemsCompanion.insert(
                id: id,
                saleId: saleId,
                batchId: batchId,
                quantity: quantity,
                price: price,
                total: total,
                unitName: unitName,
                conversionFactor: conversionFactor,
                customFieldsJson: customFieldsJson,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false, batchId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$SaleItemsTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$SaleItemsTableReferences
                                    ._saleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (batchId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.batchId,
                                referencedTable: $$SaleItemsTableReferences
                                    ._batchIdTable(db),
                                referencedColumn: $$SaleItemsTableReferences
                                    ._batchIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SaleItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleItemsTable,
      SaleItem,
      $$SaleItemsTableFilterComposer,
      $$SaleItemsTableOrderingComposer,
      $$SaleItemsTableAnnotationComposer,
      $$SaleItemsTableCreateCompanionBuilder,
      $$SaleItemsTableUpdateCompanionBuilder,
      (SaleItem, $$SaleItemsTableReferences),
      SaleItem,
      PrefetchHooks Function({bool saleId, bool batchId})
    >;
typedef $$CustomFieldDefinitionsTableCreateCompanionBuilder =
    CustomFieldDefinitionsCompanion Function({
      Value<int> id,
      required String securityKey,
      Value<String?> businessType,
      required String entityType,
      required String fieldKey,
      required String fieldLabel,
      required String fieldType,
      Value<String?> optionsJson,
      Value<String?> defaultValue,
      Value<bool> isRequired,
      Value<bool> isActive,
      Value<bool> showInProductForm,
      Value<bool> showInPOS,
      Value<bool> showInCart,
      Value<bool> showInInvoice,
      Value<bool> showInSearch,
      Value<bool> showInReports,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CustomFieldDefinitionsTableUpdateCompanionBuilder =
    CustomFieldDefinitionsCompanion Function({
      Value<int> id,
      Value<String> securityKey,
      Value<String?> businessType,
      Value<String> entityType,
      Value<String> fieldKey,
      Value<String> fieldLabel,
      Value<String> fieldType,
      Value<String?> optionsJson,
      Value<String?> defaultValue,
      Value<bool> isRequired,
      Value<bool> isActive,
      Value<bool> showInProductForm,
      Value<bool> showInPOS,
      Value<bool> showInCart,
      Value<bool> showInInvoice,
      Value<bool> showInSearch,
      Value<bool> showInReports,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CustomFieldDefinitionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomFieldDefinitionsTable,
          CustomFieldDefinition
        > {
  $$CustomFieldDefinitionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$CustomFieldValuesTable, List<CustomFieldValue>>
  _customFieldValuesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.customFieldValues,
        aliasName: $_aliasNameGenerator(
          db.customFieldDefinitions.id,
          db.customFieldValues.definitionId,
        ),
      );

  $$CustomFieldValuesTableProcessedTableManager get customFieldValuesRefs {
    final manager = $$CustomFieldValuesTableTableManager(
      $_db,
      $_db.customFieldValues,
    ).filter((f) => f.definitionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customFieldValuesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomFieldDefinitionsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldDefinitionsTable> {
  $$CustomFieldDefinitionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldLabel => $composableBuilder(
    column: $table.fieldLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInProductForm => $composableBuilder(
    column: $table.showInProductForm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInPOS => $composableBuilder(
    column: $table.showInPOS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInCart => $composableBuilder(
    column: $table.showInCart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInInvoice => $composableBuilder(
    column: $table.showInInvoice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInSearch => $composableBuilder(
    column: $table.showInSearch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showInReports => $composableBuilder(
    column: $table.showInReports,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customFieldValuesRefs(
    Expression<bool> Function($$CustomFieldValuesTableFilterComposer f) f,
  ) {
    final $$CustomFieldValuesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customFieldValues,
      getReferencedColumn: (t) => t.definitionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomFieldValuesTableFilterComposer(
            $db: $db,
            $table: $db.customFieldValues,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomFieldDefinitionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldDefinitionsTable> {
  $$CustomFieldDefinitionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldKey => $composableBuilder(
    column: $table.fieldKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldLabel => $composableBuilder(
    column: $table.fieldLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldType => $composableBuilder(
    column: $table.fieldType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInProductForm => $composableBuilder(
    column: $table.showInProductForm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInPOS => $composableBuilder(
    column: $table.showInPOS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInCart => $composableBuilder(
    column: $table.showInCart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInInvoice => $composableBuilder(
    column: $table.showInInvoice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInSearch => $composableBuilder(
    column: $table.showInSearch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showInReports => $composableBuilder(
    column: $table.showInReports,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomFieldDefinitionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldDefinitionsTable> {
  $$CustomFieldDefinitionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get businessType => $composableBuilder(
    column: $table.businessType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldKey =>
      $composableBuilder(column: $table.fieldKey, builder: (column) => column);

  GeneratedColumn<String> get fieldLabel => $composableBuilder(
    column: $table.fieldLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fieldType =>
      $composableBuilder(column: $table.fieldType, builder: (column) => column);

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultValue => $composableBuilder(
    column: $table.defaultValue,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isRequired => $composableBuilder(
    column: $table.isRequired,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get showInProductForm => $composableBuilder(
    column: $table.showInProductForm,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInPOS =>
      $composableBuilder(column: $table.showInPOS, builder: (column) => column);

  GeneratedColumn<bool> get showInCart => $composableBuilder(
    column: $table.showInCart,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInInvoice => $composableBuilder(
    column: $table.showInInvoice,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInSearch => $composableBuilder(
    column: $table.showInSearch,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showInReports => $composableBuilder(
    column: $table.showInReports,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> customFieldValuesRefs<T extends Object>(
    Expression<T> Function($$CustomFieldValuesTableAnnotationComposer a) f,
  ) {
    final $$CustomFieldValuesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.customFieldValues,
          getReferencedColumn: (t) => t.definitionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldValuesTableAnnotationComposer(
                $db: $db,
                $table: $db.customFieldValues,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CustomFieldDefinitionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldDefinitionsTable,
          CustomFieldDefinition,
          $$CustomFieldDefinitionsTableFilterComposer,
          $$CustomFieldDefinitionsTableOrderingComposer,
          $$CustomFieldDefinitionsTableAnnotationComposer,
          $$CustomFieldDefinitionsTableCreateCompanionBuilder,
          $$CustomFieldDefinitionsTableUpdateCompanionBuilder,
          (CustomFieldDefinition, $$CustomFieldDefinitionsTableReferences),
          CustomFieldDefinition,
          PrefetchHooks Function({bool customFieldValuesRefs})
        > {
  $$CustomFieldDefinitionsTableTableManager(
    _$AppDatabase db,
    $CustomFieldDefinitionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldDefinitionsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CustomFieldDefinitionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CustomFieldDefinitionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> securityKey = const Value.absent(),
                Value<String?> businessType = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> fieldKey = const Value.absent(),
                Value<String> fieldLabel = const Value.absent(),
                Value<String> fieldType = const Value.absent(),
                Value<String?> optionsJson = const Value.absent(),
                Value<String?> defaultValue = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> showInProductForm = const Value.absent(),
                Value<bool> showInPOS = const Value.absent(),
                Value<bool> showInCart = const Value.absent(),
                Value<bool> showInInvoice = const Value.absent(),
                Value<bool> showInSearch = const Value.absent(),
                Value<bool> showInReports = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomFieldDefinitionsCompanion(
                id: id,
                securityKey: securityKey,
                businessType: businessType,
                entityType: entityType,
                fieldKey: fieldKey,
                fieldLabel: fieldLabel,
                fieldType: fieldType,
                optionsJson: optionsJson,
                defaultValue: defaultValue,
                isRequired: isRequired,
                isActive: isActive,
                showInProductForm: showInProductForm,
                showInPOS: showInPOS,
                showInCart: showInCart,
                showInInvoice: showInInvoice,
                showInSearch: showInSearch,
                showInReports: showInReports,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String securityKey,
                Value<String?> businessType = const Value.absent(),
                required String entityType,
                required String fieldKey,
                required String fieldLabel,
                required String fieldType,
                Value<String?> optionsJson = const Value.absent(),
                Value<String?> defaultValue = const Value.absent(),
                Value<bool> isRequired = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<bool> showInProductForm = const Value.absent(),
                Value<bool> showInPOS = const Value.absent(),
                Value<bool> showInCart = const Value.absent(),
                Value<bool> showInInvoice = const Value.absent(),
                Value<bool> showInSearch = const Value.absent(),
                Value<bool> showInReports = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomFieldDefinitionsCompanion.insert(
                id: id,
                securityKey: securityKey,
                businessType: businessType,
                entityType: entityType,
                fieldKey: fieldKey,
                fieldLabel: fieldLabel,
                fieldType: fieldType,
                optionsJson: optionsJson,
                defaultValue: defaultValue,
                isRequired: isRequired,
                isActive: isActive,
                showInProductForm: showInProductForm,
                showInPOS: showInPOS,
                showInCart: showInCart,
                showInInvoice: showInInvoice,
                showInSearch: showInSearch,
                showInReports: showInReports,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomFieldDefinitionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customFieldValuesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (customFieldValuesRefs) db.customFieldValues,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customFieldValuesRefs)
                    await $_getPrefetchedData<
                      CustomFieldDefinition,
                      $CustomFieldDefinitionsTable,
                      CustomFieldValue
                    >(
                      currentTable: table,
                      referencedTable: $$CustomFieldDefinitionsTableReferences
                          ._customFieldValuesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomFieldDefinitionsTableReferences(
                            db,
                            table,
                            p0,
                          ).customFieldValuesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.definitionId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomFieldDefinitionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldDefinitionsTable,
      CustomFieldDefinition,
      $$CustomFieldDefinitionsTableFilterComposer,
      $$CustomFieldDefinitionsTableOrderingComposer,
      $$CustomFieldDefinitionsTableAnnotationComposer,
      $$CustomFieldDefinitionsTableCreateCompanionBuilder,
      $$CustomFieldDefinitionsTableUpdateCompanionBuilder,
      (CustomFieldDefinition, $$CustomFieldDefinitionsTableReferences),
      CustomFieldDefinition,
      PrefetchHooks Function({bool customFieldValuesRefs})
    >;
typedef $$CustomFieldValuesTableCreateCompanionBuilder =
    CustomFieldValuesCompanion Function({
      Value<int> id,
      required int definitionId,
      required String securityKey,
      required String entityType,
      required int entityId,
      Value<String?> valueText,
      Value<double?> valueNumber,
      Value<DateTime?> valueDate,
      Value<bool?> valueBool,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$CustomFieldValuesTableUpdateCompanionBuilder =
    CustomFieldValuesCompanion Function({
      Value<int> id,
      Value<int> definitionId,
      Value<String> securityKey,
      Value<String> entityType,
      Value<int> entityId,
      Value<String?> valueText,
      Value<double?> valueNumber,
      Value<DateTime?> valueDate,
      Value<bool?> valueBool,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$CustomFieldValuesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CustomFieldValuesTable,
          CustomFieldValue
        > {
  $$CustomFieldValuesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CustomFieldDefinitionsTable _definitionIdTable(_$AppDatabase db) =>
      db.customFieldDefinitions.createAlias(
        $_aliasNameGenerator(
          db.customFieldValues.definitionId,
          db.customFieldDefinitions.id,
        ),
      );

  $$CustomFieldDefinitionsTableProcessedTableManager get definitionId {
    final $_column = $_itemColumn<int>('definition_id')!;

    final manager = $$CustomFieldDefinitionsTableTableManager(
      $_db,
      $_db.customFieldDefinitions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_definitionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomFieldValuesTableFilterComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get valueDate => $composableBuilder(
    column: $table.valueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get valueBool => $composableBuilder(
    column: $table.valueBool,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomFieldDefinitionsTableFilterComposer get definitionId {
    final $$CustomFieldDefinitionsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.definitionId,
          referencedTable: $db.customFieldDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldDefinitionsTableFilterComposer(
                $db: $db,
                $table: $db.customFieldDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CustomFieldValuesTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueText => $composableBuilder(
    column: $table.valueText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get valueDate => $composableBuilder(
    column: $table.valueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get valueBool => $composableBuilder(
    column: $table.valueBool,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomFieldDefinitionsTableOrderingComposer get definitionId {
    final $$CustomFieldDefinitionsTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.definitionId,
          referencedTable: $db.customFieldDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldDefinitionsTableOrderingComposer(
                $db: $db,
                $table: $db.customFieldDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CustomFieldValuesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomFieldValuesTable> {
  $$CustomFieldValuesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get securityKey => $composableBuilder(
    column: $table.securityKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get valueText =>
      $composableBuilder(column: $table.valueText, builder: (column) => column);

  GeneratedColumn<double> get valueNumber => $composableBuilder(
    column: $table.valueNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get valueDate =>
      $composableBuilder(column: $table.valueDate, builder: (column) => column);

  GeneratedColumn<bool> get valueBool =>
      $composableBuilder(column: $table.valueBool, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CustomFieldDefinitionsTableAnnotationComposer get definitionId {
    final $$CustomFieldDefinitionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.definitionId,
          referencedTable: $db.customFieldDefinitions,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CustomFieldDefinitionsTableAnnotationComposer(
                $db: $db,
                $table: $db.customFieldDefinitions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$CustomFieldValuesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomFieldValuesTable,
          CustomFieldValue,
          $$CustomFieldValuesTableFilterComposer,
          $$CustomFieldValuesTableOrderingComposer,
          $$CustomFieldValuesTableAnnotationComposer,
          $$CustomFieldValuesTableCreateCompanionBuilder,
          $$CustomFieldValuesTableUpdateCompanionBuilder,
          (CustomFieldValue, $$CustomFieldValuesTableReferences),
          CustomFieldValue,
          PrefetchHooks Function({bool definitionId})
        > {
  $$CustomFieldValuesTableTableManager(
    _$AppDatabase db,
    $CustomFieldValuesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomFieldValuesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomFieldValuesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomFieldValuesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> definitionId = const Value.absent(),
                Value<String> securityKey = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<int> entityId = const Value.absent(),
                Value<String?> valueText = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<DateTime?> valueDate = const Value.absent(),
                Value<bool?> valueBool = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomFieldValuesCompanion(
                id: id,
                definitionId: definitionId,
                securityKey: securityKey,
                entityType: entityType,
                entityId: entityId,
                valueText: valueText,
                valueNumber: valueNumber,
                valueDate: valueDate,
                valueBool: valueBool,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int definitionId,
                required String securityKey,
                required String entityType,
                required int entityId,
                Value<String?> valueText = const Value.absent(),
                Value<double?> valueNumber = const Value.absent(),
                Value<DateTime?> valueDate = const Value.absent(),
                Value<bool?> valueBool = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => CustomFieldValuesCompanion.insert(
                id: id,
                definitionId: definitionId,
                securityKey: securityKey,
                entityType: entityType,
                entityId: entityId,
                valueText: valueText,
                valueNumber: valueNumber,
                valueDate: valueDate,
                valueBool: valueBool,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomFieldValuesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({definitionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (definitionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.definitionId,
                                referencedTable:
                                    $$CustomFieldValuesTableReferences
                                        ._definitionIdTable(db),
                                referencedColumn:
                                    $$CustomFieldValuesTableReferences
                                        ._definitionIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomFieldValuesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomFieldValuesTable,
      CustomFieldValue,
      $$CustomFieldValuesTableFilterComposer,
      $$CustomFieldValuesTableOrderingComposer,
      $$CustomFieldValuesTableAnnotationComposer,
      $$CustomFieldValuesTableCreateCompanionBuilder,
      $$CustomFieldValuesTableUpdateCompanionBuilder,
      (CustomFieldValue, $$CustomFieldValuesTableReferences),
      CustomFieldValue,
      PrefetchHooks Function({bool definitionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$MedicinesTableTableManager get medicines =>
      $$MedicinesTableTableManager(_db, _db.medicines);
  $$BatchesTableTableManager get batches =>
      $$BatchesTableTableManager(_db, _db.batches);
  $$ProductUnitsTableTableManager get productUnits =>
      $$ProductUnitsTableTableManager(_db, _db.productUnits);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleItemsTableTableManager get saleItems =>
      $$SaleItemsTableTableManager(_db, _db.saleItems);
  $$CustomFieldDefinitionsTableTableManager get customFieldDefinitions =>
      $$CustomFieldDefinitionsTableTableManager(
        _db,
        _db.customFieldDefinitions,
      );
  $$CustomFieldValuesTableTableManager get customFieldValues =>
      $$CustomFieldValuesTableTableManager(_db, _db.customFieldValues);
}
