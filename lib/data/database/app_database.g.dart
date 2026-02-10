// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TrackersTable extends Trackers with TableInfo<$TrackersTable, Tracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addictionTypeIdMeta = const VerificationMeta(
    'addictionTypeId',
  );
  @override
  late final GeneratedColumn<String> addictionTypeId = GeneratedColumn<String>(
    'addiction_type_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customTypeNameMeta = const VerificationMeta(
    'customTypeName',
  );
  @override
  late final GeneratedColumn<String> customTypeName = GeneratedColumn<String>(
    'custom_type_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quitDateMeta = const VerificationMeta(
    'quitDate',
  );
  @override
  late final GeneratedColumn<DateTime> quitDate = GeneratedColumn<DateTime>(
    'quit_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyCostMeta = const VerificationMeta(
    'dailyCost',
  );
  @override
  late final GeneratedColumn<double> dailyCost = GeneratedColumn<double>(
    'daily_cost',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyFrequencyMeta = const VerificationMeta(
    'dailyFrequency',
  );
  @override
  late final GeneratedColumn<int> dailyFrequency = GeneratedColumn<int>(
    'daily_frequency',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
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
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    addictionTypeId,
    customTypeName,
    quitDate,
    dailyCost,
    dailyFrequency,
    currencyCode,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trackers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tracker> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('addiction_type_id')) {
      context.handle(
        _addictionTypeIdMeta,
        addictionTypeId.isAcceptableOrUnknown(
          data['addiction_type_id']!,
          _addictionTypeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_addictionTypeIdMeta);
    }
    if (data.containsKey('custom_type_name')) {
      context.handle(
        _customTypeNameMeta,
        customTypeName.isAcceptableOrUnknown(
          data['custom_type_name']!,
          _customTypeNameMeta,
        ),
      );
    }
    if (data.containsKey('quit_date')) {
      context.handle(
        _quitDateMeta,
        quitDate.isAcceptableOrUnknown(data['quit_date']!, _quitDateMeta),
      );
    } else if (isInserting) {
      context.missing(_quitDateMeta);
    }
    if (data.containsKey('daily_cost')) {
      context.handle(
        _dailyCostMeta,
        dailyCost.isAcceptableOrUnknown(data['daily_cost']!, _dailyCostMeta),
      );
    }
    if (data.containsKey('daily_frequency')) {
      context.handle(
        _dailyFrequencyMeta,
        dailyFrequency.isAcceptableOrUnknown(
          data['daily_frequency']!,
          _dailyFrequencyMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tracker(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      addictionTypeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}addiction_type_id'],
      )!,
      customTypeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_type_name'],
      ),
      quitDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}quit_date'],
      )!,
      dailyCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_cost'],
      ),
      dailyFrequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_frequency'],
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  $TrackersTable createAlias(String alias) {
    return $TrackersTable(attachedDatabase, alias);
  }
}

class Tracker extends DataClass implements Insertable<Tracker> {
  final String id;
  final String name;
  final String addictionTypeId;
  final String? customTypeName;
  final DateTime quitDate;
  final double? dailyCost;
  final int? dailyFrequency;
  final String currencyCode;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Tracker({
    required this.id,
    required this.name,
    required this.addictionTypeId,
    this.customTypeName,
    required this.quitDate,
    this.dailyCost,
    this.dailyFrequency,
    required this.currencyCode,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['addiction_type_id'] = Variable<String>(addictionTypeId);
    if (!nullToAbsent || customTypeName != null) {
      map['custom_type_name'] = Variable<String>(customTypeName);
    }
    map['quit_date'] = Variable<DateTime>(quitDate);
    if (!nullToAbsent || dailyCost != null) {
      map['daily_cost'] = Variable<double>(dailyCost);
    }
    if (!nullToAbsent || dailyFrequency != null) {
      map['daily_frequency'] = Variable<int>(dailyFrequency);
    }
    map['currency_code'] = Variable<String>(currencyCode);
    map['is_active'] = Variable<bool>(isActive);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TrackersCompanion toCompanion(bool nullToAbsent) {
    return TrackersCompanion(
      id: Value(id),
      name: Value(name),
      addictionTypeId: Value(addictionTypeId),
      customTypeName: customTypeName == null && nullToAbsent
          ? const Value.absent()
          : Value(customTypeName),
      quitDate: Value(quitDate),
      dailyCost: dailyCost == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyCost),
      dailyFrequency: dailyFrequency == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyFrequency),
      currencyCode: Value(currencyCode),
      isActive: Value(isActive),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Tracker.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tracker(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      addictionTypeId: serializer.fromJson<String>(json['addictionTypeId']),
      customTypeName: serializer.fromJson<String?>(json['customTypeName']),
      quitDate: serializer.fromJson<DateTime>(json['quitDate']),
      dailyCost: serializer.fromJson<double?>(json['dailyCost']),
      dailyFrequency: serializer.fromJson<int?>(json['dailyFrequency']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'addictionTypeId': serializer.toJson<String>(addictionTypeId),
      'customTypeName': serializer.toJson<String?>(customTypeName),
      'quitDate': serializer.toJson<DateTime>(quitDate),
      'dailyCost': serializer.toJson<double?>(dailyCost),
      'dailyFrequency': serializer.toJson<int?>(dailyFrequency),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'isActive': serializer.toJson<bool>(isActive),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Tracker copyWith({
    String? id,
    String? name,
    String? addictionTypeId,
    Value<String?> customTypeName = const Value.absent(),
    DateTime? quitDate,
    Value<double?> dailyCost = const Value.absent(),
    Value<int?> dailyFrequency = const Value.absent(),
    String? currencyCode,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Tracker(
    id: id ?? this.id,
    name: name ?? this.name,
    addictionTypeId: addictionTypeId ?? this.addictionTypeId,
    customTypeName: customTypeName.present
        ? customTypeName.value
        : this.customTypeName,
    quitDate: quitDate ?? this.quitDate,
    dailyCost: dailyCost.present ? dailyCost.value : this.dailyCost,
    dailyFrequency: dailyFrequency.present
        ? dailyFrequency.value
        : this.dailyFrequency,
    currencyCode: currencyCode ?? this.currencyCode,
    isActive: isActive ?? this.isActive,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Tracker copyWithCompanion(TrackersCompanion data) {
    return Tracker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      addictionTypeId: data.addictionTypeId.present
          ? data.addictionTypeId.value
          : this.addictionTypeId,
      customTypeName: data.customTypeName.present
          ? data.customTypeName.value
          : this.customTypeName,
      quitDate: data.quitDate.present ? data.quitDate.value : this.quitDate,
      dailyCost: data.dailyCost.present ? data.dailyCost.value : this.dailyCost,
      dailyFrequency: data.dailyFrequency.present
          ? data.dailyFrequency.value
          : this.dailyFrequency,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tracker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('addictionTypeId: $addictionTypeId, ')
          ..write('customTypeName: $customTypeName, ')
          ..write('quitDate: $quitDate, ')
          ..write('dailyCost: $dailyCost, ')
          ..write('dailyFrequency: $dailyFrequency, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    addictionTypeId,
    customTypeName,
    quitDate,
    dailyCost,
    dailyFrequency,
    currencyCode,
    isActive,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tracker &&
          other.id == this.id &&
          other.name == this.name &&
          other.addictionTypeId == this.addictionTypeId &&
          other.customTypeName == this.customTypeName &&
          other.quitDate == this.quitDate &&
          other.dailyCost == this.dailyCost &&
          other.dailyFrequency == this.dailyFrequency &&
          other.currencyCode == this.currencyCode &&
          other.isActive == this.isActive &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TrackersCompanion extends UpdateCompanion<Tracker> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> addictionTypeId;
  final Value<String?> customTypeName;
  final Value<DateTime> quitDate;
  final Value<double?> dailyCost;
  final Value<int?> dailyFrequency;
  final Value<String> currencyCode;
  final Value<bool> isActive;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TrackersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.addictionTypeId = const Value.absent(),
    this.customTypeName = const Value.absent(),
    this.quitDate = const Value.absent(),
    this.dailyCost = const Value.absent(),
    this.dailyFrequency = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TrackersCompanion.insert({
    required String id,
    required String name,
    required String addictionTypeId,
    this.customTypeName = const Value.absent(),
    required DateTime quitDate,
    this.dailyCost = const Value.absent(),
    this.dailyFrequency = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       addictionTypeId = Value(addictionTypeId),
       quitDate = Value(quitDate),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Tracker> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? addictionTypeId,
    Expression<String>? customTypeName,
    Expression<DateTime>? quitDate,
    Expression<double>? dailyCost,
    Expression<int>? dailyFrequency,
    Expression<String>? currencyCode,
    Expression<bool>? isActive,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (addictionTypeId != null) 'addiction_type_id': addictionTypeId,
      if (customTypeName != null) 'custom_type_name': customTypeName,
      if (quitDate != null) 'quit_date': quitDate,
      if (dailyCost != null) 'daily_cost': dailyCost,
      if (dailyFrequency != null) 'daily_frequency': dailyFrequency,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (isActive != null) 'is_active': isActive,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TrackersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? addictionTypeId,
    Value<String?>? customTypeName,
    Value<DateTime>? quitDate,
    Value<double?>? dailyCost,
    Value<int?>? dailyFrequency,
    Value<String>? currencyCode,
    Value<bool>? isActive,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TrackersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      addictionTypeId: addictionTypeId ?? this.addictionTypeId,
      customTypeName: customTypeName ?? this.customTypeName,
      quitDate: quitDate ?? this.quitDate,
      dailyCost: dailyCost ?? this.dailyCost,
      dailyFrequency: dailyFrequency ?? this.dailyFrequency,
      currencyCode: currencyCode ?? this.currencyCode,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (addictionTypeId.present) {
      map['addiction_type_id'] = Variable<String>(addictionTypeId.value);
    }
    if (customTypeName.present) {
      map['custom_type_name'] = Variable<String>(customTypeName.value);
    }
    if (quitDate.present) {
      map['quit_date'] = Variable<DateTime>(quitDate.value);
    }
    if (dailyCost.present) {
      map['daily_cost'] = Variable<double>(dailyCost.value);
    }
    if (dailyFrequency.present) {
      map['daily_frequency'] = Variable<int>(dailyFrequency.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TrackersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('addictionTypeId: $addictionTypeId, ')
          ..write('customTypeName: $customTypeName, ')
          ..write('quitDate: $quitDate, ')
          ..write('dailyCost: $dailyCost, ')
          ..write('dailyFrequency: $dailyFrequency, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('isActive: $isActive, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CravingsTable extends Cravings with TableInfo<$CravingsTable, Craving> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CravingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _triggerMeta = const VerificationMeta(
    'trigger',
  );
  @override
  late final GeneratedColumn<String> trigger = GeneratedColumn<String>(
    'trigger',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    trackerId,
    timestamp,
    intensity,
    trigger,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cravings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Craving> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    }
    if (data.containsKey('trigger')) {
      context.handle(
        _triggerMeta,
        trigger.isAcceptableOrUnknown(data['trigger']!, _triggerMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Craving map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Craving(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      ),
      trigger: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trigger'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $CravingsTable createAlias(String alias) {
    return $CravingsTable(attachedDatabase, alias);
  }
}

class Craving extends DataClass implements Insertable<Craving> {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final int? intensity;
  final String? trigger;
  final String? note;
  const Craving({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    this.intensity,
    this.trigger,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || intensity != null) {
      map['intensity'] = Variable<int>(intensity);
    }
    if (!nullToAbsent || trigger != null) {
      map['trigger'] = Variable<String>(trigger);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  CravingsCompanion toCompanion(bool nullToAbsent) {
    return CravingsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      timestamp: Value(timestamp),
      intensity: intensity == null && nullToAbsent
          ? const Value.absent()
          : Value(intensity),
      trigger: trigger == null && nullToAbsent
          ? const Value.absent()
          : Value(trigger),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Craving.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Craving(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      intensity: serializer.fromJson<int?>(json['intensity']),
      trigger: serializer.fromJson<String?>(json['trigger']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'intensity': serializer.toJson<int?>(intensity),
      'trigger': serializer.toJson<String?>(trigger),
      'note': serializer.toJson<String?>(note),
    };
  }

  Craving copyWith({
    String? id,
    String? trackerId,
    DateTime? timestamp,
    Value<int?> intensity = const Value.absent(),
    Value<String?> trigger = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => Craving(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    timestamp: timestamp ?? this.timestamp,
    intensity: intensity.present ? intensity.value : this.intensity,
    trigger: trigger.present ? trigger.value : this.trigger,
    note: note.present ? note.value : this.note,
  );
  Craving copyWithCompanion(CravingsCompanion data) {
    return Craving(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      trigger: data.trigger.present ? data.trigger.value : this.trigger,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Craving(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('intensity: $intensity, ')
          ..write('trigger: $trigger, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, trackerId, timestamp, intensity, trigger, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Craving &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.timestamp == this.timestamp &&
          other.intensity == this.intensity &&
          other.trigger == this.trigger &&
          other.note == this.note);
}

class CravingsCompanion extends UpdateCompanion<Craving> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<DateTime> timestamp;
  final Value<int?> intensity;
  final Value<String?> trigger;
  final Value<String?> note;
  final Value<int> rowid;
  const CravingsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.intensity = const Value.absent(),
    this.trigger = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CravingsCompanion.insert({
    required String id,
    required String trackerId,
    required DateTime timestamp,
    this.intensity = const Value.absent(),
    this.trigger = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       timestamp = Value(timestamp);
  static Insertable<Craving> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<DateTime>? timestamp,
    Expression<int>? intensity,
    Expression<String>? trigger,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (timestamp != null) 'timestamp': timestamp,
      if (intensity != null) 'intensity': intensity,
      if (trigger != null) 'trigger': trigger,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CravingsCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<DateTime>? timestamp,
    Value<int?>? intensity,
    Value<String?>? trigger,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return CravingsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      timestamp: timestamp ?? this.timestamp,
      intensity: intensity ?? this.intensity,
      trigger: trigger ?? this.trigger,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (trigger.present) {
      map['trigger'] = Variable<String>(trigger.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CravingsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('intensity: $intensity, ')
          ..write('trigger: $trigger, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlipsTable extends Slips with TableInfo<$SlipsTable, Slip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackerIdMeta = const VerificationMeta(
    'trackerId',
  );
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
    'tracker_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, trackerId, timestamp, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Slip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tracker_id')) {
      context.handle(
        _trackerIdMeta,
        trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Slip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Slip(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      trackerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracker_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SlipsTable createAlias(String alias) {
    return $SlipsTable(attachedDatabase, alias);
  }
}

class Slip extends DataClass implements Insertable<Slip> {
  final String id;
  final String trackerId;
  final DateTime timestamp;
  final String? note;
  const Slip({
    required this.id,
    required this.trackerId,
    required this.timestamp,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SlipsCompanion toCompanion(bool nullToAbsent) {
    return SlipsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      timestamp: Value(timestamp),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Slip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Slip(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'note': serializer.toJson<String?>(note),
    };
  }

  Slip copyWith({
    String? id,
    String? trackerId,
    DateTime? timestamp,
    Value<String?> note = const Value.absent(),
  }) => Slip(
    id: id ?? this.id,
    trackerId: trackerId ?? this.trackerId,
    timestamp: timestamp ?? this.timestamp,
    note: note.present ? note.value : this.note,
  );
  Slip copyWithCompanion(SlipsCompanion data) {
    return Slip(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Slip(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, timestamp, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Slip &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.timestamp == this.timestamp &&
          other.note == this.note);
}

class SlipsCompanion extends UpdateCompanion<Slip> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<DateTime> timestamp;
  final Value<String?> note;
  final Value<int> rowid;
  const SlipsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlipsCompanion.insert({
    required String id,
    required String trackerId,
    required DateTime timestamp,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       trackerId = Value(trackerId),
       timestamp = Value(timestamp);
  static Insertable<Slip> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<DateTime>? timestamp,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (timestamp != null) 'timestamp': timestamp,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlipsCompanion copyWith({
    Value<String>? id,
    Value<String>? trackerId,
    Value<DateTime>? timestamp,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return SlipsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlipsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _selectedPaletteIdMeta = const VerificationMeta(
    'selectedPaletteId',
  );
  @override
  late final GeneratedColumn<String> selectedPaletteId =
      GeneratedColumn<String>(
        'selected_palette_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('classic_bauhaus'),
      );
  static const VerificationMeta _customPrimaryMeta = const VerificationMeta(
    'customPrimary',
  );
  @override
  late final GeneratedColumn<int> customPrimary = GeneratedColumn<int>(
    'custom_primary',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customSecondaryMeta = const VerificationMeta(
    'customSecondary',
  );
  @override
  late final GeneratedColumn<int> customSecondary = GeneratedColumn<int>(
    'custom_secondary',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customAccentMeta = const VerificationMeta(
    'customAccent',
  );
  @override
  late final GeneratedColumn<int> customAccent = GeneratedColumn<int>(
    'custom_accent',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brightnessModeMeta = const VerificationMeta(
    'brightnessMode',
  );
  @override
  late final GeneratedColumn<String> brightnessMode = GeneratedColumn<String>(
    'brightness_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _notificationsEnabledMeta =
      const VerificationMeta('notificationsEnabled');
  @override
  late final GeneratedColumn<bool> notificationsEnabled = GeneratedColumn<bool>(
    'notifications_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notifications_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyMotivationTimeMeta =
      const VerificationMeta('dailyMotivationTime');
  @override
  late final GeneratedColumn<String> dailyMotivationTime =
      GeneratedColumn<String>(
        'daily_motivation_time',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _hasCompletedOnboardingMeta =
      const VerificationMeta('hasCompletedOnboarding');
  @override
  late final GeneratedColumn<bool> hasCompletedOnboarding =
      GeneratedColumn<bool>(
        'has_completed_onboarding',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_completed_onboarding" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    selectedPaletteId,
    customPrimary,
    customSecondary,
    customAccent,
    brightnessMode,
    currencyCode,
    notificationsEnabled,
    dailyMotivationTime,
    hasCompletedOnboarding,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('selected_palette_id')) {
      context.handle(
        _selectedPaletteIdMeta,
        selectedPaletteId.isAcceptableOrUnknown(
          data['selected_palette_id']!,
          _selectedPaletteIdMeta,
        ),
      );
    }
    if (data.containsKey('custom_primary')) {
      context.handle(
        _customPrimaryMeta,
        customPrimary.isAcceptableOrUnknown(
          data['custom_primary']!,
          _customPrimaryMeta,
        ),
      );
    }
    if (data.containsKey('custom_secondary')) {
      context.handle(
        _customSecondaryMeta,
        customSecondary.isAcceptableOrUnknown(
          data['custom_secondary']!,
          _customSecondaryMeta,
        ),
      );
    }
    if (data.containsKey('custom_accent')) {
      context.handle(
        _customAccentMeta,
        customAccent.isAcceptableOrUnknown(
          data['custom_accent']!,
          _customAccentMeta,
        ),
      );
    }
    if (data.containsKey('brightness_mode')) {
      context.handle(
        _brightnessModeMeta,
        brightnessMode.isAcceptableOrUnknown(
          data['brightness_mode']!,
          _brightnessModeMeta,
        ),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('notifications_enabled')) {
      context.handle(
        _notificationsEnabledMeta,
        notificationsEnabled.isAcceptableOrUnknown(
          data['notifications_enabled']!,
          _notificationsEnabledMeta,
        ),
      );
    }
    if (data.containsKey('daily_motivation_time')) {
      context.handle(
        _dailyMotivationTimeMeta,
        dailyMotivationTime.isAcceptableOrUnknown(
          data['daily_motivation_time']!,
          _dailyMotivationTimeMeta,
        ),
      );
    }
    if (data.containsKey('has_completed_onboarding')) {
      context.handle(
        _hasCompletedOnboardingMeta,
        hasCompletedOnboarding.isAcceptableOrUnknown(
          data['has_completed_onboarding']!,
          _hasCompletedOnboardingMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSettingsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      selectedPaletteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_palette_id'],
      )!,
      customPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_primary'],
      ),
      customSecondary: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_secondary'],
      ),
      customAccent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_accent'],
      ),
      brightnessMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brightness_mode'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      notificationsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notifications_enabled'],
      )!,
      dailyMotivationTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}daily_motivation_time'],
      ),
      hasCompletedOnboarding: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_completed_onboarding'],
      )!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsTableData extends DataClass
    implements Insertable<UserSettingsTableData> {
  final int id;
  final String selectedPaletteId;
  final int? customPrimary;
  final int? customSecondary;
  final int? customAccent;
  final String brightnessMode;
  final String currencyCode;
  final bool notificationsEnabled;
  final String? dailyMotivationTime;
  final bool hasCompletedOnboarding;
  const UserSettingsTableData({
    required this.id,
    required this.selectedPaletteId,
    this.customPrimary,
    this.customSecondary,
    this.customAccent,
    required this.brightnessMode,
    required this.currencyCode,
    required this.notificationsEnabled,
    this.dailyMotivationTime,
    required this.hasCompletedOnboarding,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['selected_palette_id'] = Variable<String>(selectedPaletteId);
    if (!nullToAbsent || customPrimary != null) {
      map['custom_primary'] = Variable<int>(customPrimary);
    }
    if (!nullToAbsent || customSecondary != null) {
      map['custom_secondary'] = Variable<int>(customSecondary);
    }
    if (!nullToAbsent || customAccent != null) {
      map['custom_accent'] = Variable<int>(customAccent);
    }
    map['brightness_mode'] = Variable<String>(brightnessMode);
    map['currency_code'] = Variable<String>(currencyCode);
    map['notifications_enabled'] = Variable<bool>(notificationsEnabled);
    if (!nullToAbsent || dailyMotivationTime != null) {
      map['daily_motivation_time'] = Variable<String>(dailyMotivationTime);
    }
    map['has_completed_onboarding'] = Variable<bool>(hasCompletedOnboarding);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      id: Value(id),
      selectedPaletteId: Value(selectedPaletteId),
      customPrimary: customPrimary == null && nullToAbsent
          ? const Value.absent()
          : Value(customPrimary),
      customSecondary: customSecondary == null && nullToAbsent
          ? const Value.absent()
          : Value(customSecondary),
      customAccent: customAccent == null && nullToAbsent
          ? const Value.absent()
          : Value(customAccent),
      brightnessMode: Value(brightnessMode),
      currencyCode: Value(currencyCode),
      notificationsEnabled: Value(notificationsEnabled),
      dailyMotivationTime: dailyMotivationTime == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyMotivationTime),
      hasCompletedOnboarding: Value(hasCompletedOnboarding),
    );
  }

  factory UserSettingsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsTableData(
      id: serializer.fromJson<int>(json['id']),
      selectedPaletteId: serializer.fromJson<String>(json['selectedPaletteId']),
      customPrimary: serializer.fromJson<int?>(json['customPrimary']),
      customSecondary: serializer.fromJson<int?>(json['customSecondary']),
      customAccent: serializer.fromJson<int?>(json['customAccent']),
      brightnessMode: serializer.fromJson<String>(json['brightnessMode']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      notificationsEnabled: serializer.fromJson<bool>(
        json['notificationsEnabled'],
      ),
      dailyMotivationTime: serializer.fromJson<String?>(
        json['dailyMotivationTime'],
      ),
      hasCompletedOnboarding: serializer.fromJson<bool>(
        json['hasCompletedOnboarding'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'selectedPaletteId': serializer.toJson<String>(selectedPaletteId),
      'customPrimary': serializer.toJson<int?>(customPrimary),
      'customSecondary': serializer.toJson<int?>(customSecondary),
      'customAccent': serializer.toJson<int?>(customAccent),
      'brightnessMode': serializer.toJson<String>(brightnessMode),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'notificationsEnabled': serializer.toJson<bool>(notificationsEnabled),
      'dailyMotivationTime': serializer.toJson<String?>(dailyMotivationTime),
      'hasCompletedOnboarding': serializer.toJson<bool>(hasCompletedOnboarding),
    };
  }

  UserSettingsTableData copyWith({
    int? id,
    String? selectedPaletteId,
    Value<int?> customPrimary = const Value.absent(),
    Value<int?> customSecondary = const Value.absent(),
    Value<int?> customAccent = const Value.absent(),
    String? brightnessMode,
    String? currencyCode,
    bool? notificationsEnabled,
    Value<String?> dailyMotivationTime = const Value.absent(),
    bool? hasCompletedOnboarding,
  }) => UserSettingsTableData(
    id: id ?? this.id,
    selectedPaletteId: selectedPaletteId ?? this.selectedPaletteId,
    customPrimary: customPrimary.present
        ? customPrimary.value
        : this.customPrimary,
    customSecondary: customSecondary.present
        ? customSecondary.value
        : this.customSecondary,
    customAccent: customAccent.present ? customAccent.value : this.customAccent,
    brightnessMode: brightnessMode ?? this.brightnessMode,
    currencyCode: currencyCode ?? this.currencyCode,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    dailyMotivationTime: dailyMotivationTime.present
        ? dailyMotivationTime.value
        : this.dailyMotivationTime,
    hasCompletedOnboarding:
        hasCompletedOnboarding ?? this.hasCompletedOnboarding,
  );
  UserSettingsTableData copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsTableData(
      id: data.id.present ? data.id.value : this.id,
      selectedPaletteId: data.selectedPaletteId.present
          ? data.selectedPaletteId.value
          : this.selectedPaletteId,
      customPrimary: data.customPrimary.present
          ? data.customPrimary.value
          : this.customPrimary,
      customSecondary: data.customSecondary.present
          ? data.customSecondary.value
          : this.customSecondary,
      customAccent: data.customAccent.present
          ? data.customAccent.value
          : this.customAccent,
      brightnessMode: data.brightnessMode.present
          ? data.brightnessMode.value
          : this.brightnessMode,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      notificationsEnabled: data.notificationsEnabled.present
          ? data.notificationsEnabled.value
          : this.notificationsEnabled,
      dailyMotivationTime: data.dailyMotivationTime.present
          ? data.dailyMotivationTime.value
          : this.dailyMotivationTime,
      hasCompletedOnboarding: data.hasCompletedOnboarding.present
          ? data.hasCompletedOnboarding.value
          : this.hasCompletedOnboarding,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableData(')
          ..write('id: $id, ')
          ..write('selectedPaletteId: $selectedPaletteId, ')
          ..write('customPrimary: $customPrimary, ')
          ..write('customSecondary: $customSecondary, ')
          ..write('customAccent: $customAccent, ')
          ..write('brightnessMode: $brightnessMode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('dailyMotivationTime: $dailyMotivationTime, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    selectedPaletteId,
    customPrimary,
    customSecondary,
    customAccent,
    brightnessMode,
    currencyCode,
    notificationsEnabled,
    dailyMotivationTime,
    hasCompletedOnboarding,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsTableData &&
          other.id == this.id &&
          other.selectedPaletteId == this.selectedPaletteId &&
          other.customPrimary == this.customPrimary &&
          other.customSecondary == this.customSecondary &&
          other.customAccent == this.customAccent &&
          other.brightnessMode == this.brightnessMode &&
          other.currencyCode == this.currencyCode &&
          other.notificationsEnabled == this.notificationsEnabled &&
          other.dailyMotivationTime == this.dailyMotivationTime &&
          other.hasCompletedOnboarding == this.hasCompletedOnboarding);
}

class UserSettingsTableCompanion
    extends UpdateCompanion<UserSettingsTableData> {
  final Value<int> id;
  final Value<String> selectedPaletteId;
  final Value<int?> customPrimary;
  final Value<int?> customSecondary;
  final Value<int?> customAccent;
  final Value<String> brightnessMode;
  final Value<String> currencyCode;
  final Value<bool> notificationsEnabled;
  final Value<String?> dailyMotivationTime;
  final Value<bool> hasCompletedOnboarding;
  const UserSettingsTableCompanion({
    this.id = const Value.absent(),
    this.selectedPaletteId = const Value.absent(),
    this.customPrimary = const Value.absent(),
    this.customSecondary = const Value.absent(),
    this.customAccent = const Value.absent(),
    this.brightnessMode = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.dailyMotivationTime = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.selectedPaletteId = const Value.absent(),
    this.customPrimary = const Value.absent(),
    this.customSecondary = const Value.absent(),
    this.customAccent = const Value.absent(),
    this.brightnessMode = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.notificationsEnabled = const Value.absent(),
    this.dailyMotivationTime = const Value.absent(),
    this.hasCompletedOnboarding = const Value.absent(),
  });
  static Insertable<UserSettingsTableData> custom({
    Expression<int>? id,
    Expression<String>? selectedPaletteId,
    Expression<int>? customPrimary,
    Expression<int>? customSecondary,
    Expression<int>? customAccent,
    Expression<String>? brightnessMode,
    Expression<String>? currencyCode,
    Expression<bool>? notificationsEnabled,
    Expression<String>? dailyMotivationTime,
    Expression<bool>? hasCompletedOnboarding,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (selectedPaletteId != null) 'selected_palette_id': selectedPaletteId,
      if (customPrimary != null) 'custom_primary': customPrimary,
      if (customSecondary != null) 'custom_secondary': customSecondary,
      if (customAccent != null) 'custom_accent': customAccent,
      if (brightnessMode != null) 'brightness_mode': brightnessMode,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (notificationsEnabled != null)
        'notifications_enabled': notificationsEnabled,
      if (dailyMotivationTime != null)
        'daily_motivation_time': dailyMotivationTime,
      if (hasCompletedOnboarding != null)
        'has_completed_onboarding': hasCompletedOnboarding,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? selectedPaletteId,
    Value<int?>? customPrimary,
    Value<int?>? customSecondary,
    Value<int?>? customAccent,
    Value<String>? brightnessMode,
    Value<String>? currencyCode,
    Value<bool>? notificationsEnabled,
    Value<String?>? dailyMotivationTime,
    Value<bool>? hasCompletedOnboarding,
  }) {
    return UserSettingsTableCompanion(
      id: id ?? this.id,
      selectedPaletteId: selectedPaletteId ?? this.selectedPaletteId,
      customPrimary: customPrimary ?? this.customPrimary,
      customSecondary: customSecondary ?? this.customSecondary,
      customAccent: customAccent ?? this.customAccent,
      brightnessMode: brightnessMode ?? this.brightnessMode,
      currencyCode: currencyCode ?? this.currencyCode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      dailyMotivationTime: dailyMotivationTime ?? this.dailyMotivationTime,
      hasCompletedOnboarding:
          hasCompletedOnboarding ?? this.hasCompletedOnboarding,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (selectedPaletteId.present) {
      map['selected_palette_id'] = Variable<String>(selectedPaletteId.value);
    }
    if (customPrimary.present) {
      map['custom_primary'] = Variable<int>(customPrimary.value);
    }
    if (customSecondary.present) {
      map['custom_secondary'] = Variable<int>(customSecondary.value);
    }
    if (customAccent.present) {
      map['custom_accent'] = Variable<int>(customAccent.value);
    }
    if (brightnessMode.present) {
      map['brightness_mode'] = Variable<String>(brightnessMode.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (notificationsEnabled.present) {
      map['notifications_enabled'] = Variable<bool>(notificationsEnabled.value);
    }
    if (dailyMotivationTime.present) {
      map['daily_motivation_time'] = Variable<String>(
        dailyMotivationTime.value,
      );
    }
    if (hasCompletedOnboarding.present) {
      map['has_completed_onboarding'] = Variable<bool>(
        hasCompletedOnboarding.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('selectedPaletteId: $selectedPaletteId, ')
          ..write('customPrimary: $customPrimary, ')
          ..write('customSecondary: $customSecondary, ')
          ..write('customAccent: $customAccent, ')
          ..write('brightnessMode: $brightnessMode, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('notificationsEnabled: $notificationsEnabled, ')
          ..write('dailyMotivationTime: $dailyMotivationTime, ')
          ..write('hasCompletedOnboarding: $hasCompletedOnboarding')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TrackersTable trackers = $TrackersTable(this);
  late final $CravingsTable cravings = $CravingsTable(this);
  late final $SlipsTable slips = $SlipsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final TrackerDao trackerDao = TrackerDao(this as AppDatabase);
  late final CravingDao cravingDao = CravingDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    trackers,
    cravings,
    slips,
    userSettingsTable,
  ];
}

typedef $$TrackersTableCreateCompanionBuilder =
    TrackersCompanion Function({
      required String id,
      required String name,
      required String addictionTypeId,
      Value<String?> customTypeName,
      required DateTime quitDate,
      Value<double?> dailyCost,
      Value<int?> dailyFrequency,
      Value<String> currencyCode,
      Value<bool> isActive,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TrackersTableUpdateCompanionBuilder =
    TrackersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> addictionTypeId,
      Value<String?> customTypeName,
      Value<DateTime> quitDate,
      Value<double?> dailyCost,
      Value<int?> dailyFrequency,
      Value<String> currencyCode,
      Value<bool> isActive,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TrackersTableFilterComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addictionTypeId => $composableBuilder(
    column: $table.addictionTypeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyCost => $composableBuilder(
    column: $table.dailyCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyFrequency => $composableBuilder(
    column: $table.dailyFrequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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
}

class $$TrackersTableOrderingComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addictionTypeId => $composableBuilder(
    column: $table.addictionTypeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get quitDate => $composableBuilder(
    column: $table.quitDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyCost => $composableBuilder(
    column: $table.dailyCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyFrequency => $composableBuilder(
    column: $table.dailyFrequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

class $$TrackersTableAnnotationComposer
    extends Composer<_$AppDatabase, $TrackersTable> {
  $$TrackersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get addictionTypeId => $composableBuilder(
    column: $table.addictionTypeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customTypeName => $composableBuilder(
    column: $table.customTypeName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get quitDate =>
      $composableBuilder(column: $table.quitDate, builder: (column) => column);

  GeneratedColumn<double> get dailyCost =>
      $composableBuilder(column: $table.dailyCost, builder: (column) => column);

  GeneratedColumn<int> get dailyFrequency => $composableBuilder(
    column: $table.dailyFrequency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TrackersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TrackersTable,
          Tracker,
          $$TrackersTableFilterComposer,
          $$TrackersTableOrderingComposer,
          $$TrackersTableAnnotationComposer,
          $$TrackersTableCreateCompanionBuilder,
          $$TrackersTableUpdateCompanionBuilder,
          (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
          Tracker,
          PrefetchHooks Function()
        > {
  $$TrackersTableTableManager(_$AppDatabase db, $TrackersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> addictionTypeId = const Value.absent(),
                Value<String?> customTypeName = const Value.absent(),
                Value<DateTime> quitDate = const Value.absent(),
                Value<double?> dailyCost = const Value.absent(),
                Value<int?> dailyFrequency = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion(
                id: id,
                name: name,
                addictionTypeId: addictionTypeId,
                customTypeName: customTypeName,
                quitDate: quitDate,
                dailyCost: dailyCost,
                dailyFrequency: dailyFrequency,
                currencyCode: currencyCode,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String addictionTypeId,
                Value<String?> customTypeName = const Value.absent(),
                required DateTime quitDate,
                Value<double?> dailyCost = const Value.absent(),
                Value<int?> dailyFrequency = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TrackersCompanion.insert(
                id: id,
                name: name,
                addictionTypeId: addictionTypeId,
                customTypeName: customTypeName,
                quitDate: quitDate,
                dailyCost: dailyCost,
                dailyFrequency: dailyFrequency,
                currencyCode: currencyCode,
                isActive: isActive,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TrackersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TrackersTable,
      Tracker,
      $$TrackersTableFilterComposer,
      $$TrackersTableOrderingComposer,
      $$TrackersTableAnnotationComposer,
      $$TrackersTableCreateCompanionBuilder,
      $$TrackersTableUpdateCompanionBuilder,
      (Tracker, BaseReferences<_$AppDatabase, $TrackersTable, Tracker>),
      Tracker,
      PrefetchHooks Function()
    >;
typedef $$CravingsTableCreateCompanionBuilder =
    CravingsCompanion Function({
      required String id,
      required String trackerId,
      required DateTime timestamp,
      Value<int?> intensity,
      Value<String?> trigger,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$CravingsTableUpdateCompanionBuilder =
    CravingsCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<DateTime> timestamp,
      Value<int?> intensity,
      Value<String?> trigger,
      Value<String?> note,
      Value<int> rowid,
    });

class $$CravingsTableFilterComposer
    extends Composer<_$AppDatabase, $CravingsTable> {
  $$CravingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CravingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CravingsTable> {
  $$CravingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trigger => $composableBuilder(
    column: $table.trigger,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CravingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CravingsTable> {
  $$CravingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<String> get trigger =>
      $composableBuilder(column: $table.trigger, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$CravingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CravingsTable,
          Craving,
          $$CravingsTableFilterComposer,
          $$CravingsTableOrderingComposer,
          $$CravingsTableAnnotationComposer,
          $$CravingsTableCreateCompanionBuilder,
          $$CravingsTableUpdateCompanionBuilder,
          (Craving, BaseReferences<_$AppDatabase, $CravingsTable, Craving>),
          Craving,
          PrefetchHooks Function()
        > {
  $$CravingsTableTableManager(_$AppDatabase db, $CravingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CravingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CravingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CravingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<int?> intensity = const Value.absent(),
                Value<String?> trigger = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CravingsCompanion(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                intensity: intensity,
                trigger: trigger,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required DateTime timestamp,
                Value<int?> intensity = const Value.absent(),
                Value<String?> trigger = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CravingsCompanion.insert(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                intensity: intensity,
                trigger: trigger,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CravingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CravingsTable,
      Craving,
      $$CravingsTableFilterComposer,
      $$CravingsTableOrderingComposer,
      $$CravingsTableAnnotationComposer,
      $$CravingsTableCreateCompanionBuilder,
      $$CravingsTableUpdateCompanionBuilder,
      (Craving, BaseReferences<_$AppDatabase, $CravingsTable, Craving>),
      Craving,
      PrefetchHooks Function()
    >;
typedef $$SlipsTableCreateCompanionBuilder =
    SlipsCompanion Function({
      required String id,
      required String trackerId,
      required DateTime timestamp,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$SlipsTableUpdateCompanionBuilder =
    SlipsCompanion Function({
      Value<String> id,
      Value<String> trackerId,
      Value<DateTime> timestamp,
      Value<String?> note,
      Value<int> rowid,
    });

class $$SlipsTableFilterComposer extends Composer<_$AppDatabase, $SlipsTable> {
  $$SlipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SlipsTableOrderingComposer
    extends Composer<_$AppDatabase, $SlipsTable> {
  $$SlipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackerId => $composableBuilder(
    column: $table.trackerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SlipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlipsTable> {
  $$SlipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get trackerId =>
      $composableBuilder(column: $table.trackerId, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SlipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlipsTable,
          Slip,
          $$SlipsTableFilterComposer,
          $$SlipsTableOrderingComposer,
          $$SlipsTableAnnotationComposer,
          $$SlipsTableCreateCompanionBuilder,
          $$SlipsTableUpdateCompanionBuilder,
          (Slip, BaseReferences<_$AppDatabase, $SlipsTable, Slip>),
          Slip,
          PrefetchHooks Function()
        > {
  $$SlipsTableTableManager(_$AppDatabase db, $SlipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> trackerId = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlipsCompanion(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String trackerId,
                required DateTime timestamp,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlipsCompanion.insert(
                id: id,
                trackerId: trackerId,
                timestamp: timestamp,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SlipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlipsTable,
      Slip,
      $$SlipsTableFilterComposer,
      $$SlipsTableOrderingComposer,
      $$SlipsTableAnnotationComposer,
      $$SlipsTableCreateCompanionBuilder,
      $$SlipsTableUpdateCompanionBuilder,
      (Slip, BaseReferences<_$AppDatabase, $SlipsTable, Slip>),
      Slip,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String> selectedPaletteId,
      Value<int?> customPrimary,
      Value<int?> customSecondary,
      Value<int?> customAccent,
      Value<String> brightnessMode,
      Value<String> currencyCode,
      Value<bool> notificationsEnabled,
      Value<String?> dailyMotivationTime,
      Value<bool> hasCompletedOnboarding,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<int> id,
      Value<String> selectedPaletteId,
      Value<int?> customPrimary,
      Value<int?> customSecondary,
      Value<int?> customAccent,
      Value<String> brightnessMode,
      Value<String> currencyCode,
      Value<bool> notificationsEnabled,
      Value<String?> dailyMotivationTime,
      Value<bool> hasCompletedOnboarding,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
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

  ColumnFilters<String> get selectedPaletteId => $composableBuilder(
    column: $table.selectedPaletteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customPrimary => $composableBuilder(
    column: $table.customPrimary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customSecondary => $composableBuilder(
    column: $table.customSecondary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dailyMotivationTime => $composableBuilder(
    column: $table.dailyMotivationTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
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

  ColumnOrderings<String> get selectedPaletteId => $composableBuilder(
    column: $table.selectedPaletteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customPrimary => $composableBuilder(
    column: $table.customPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customSecondary => $composableBuilder(
    column: $table.customSecondary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyMotivationTime => $composableBuilder(
    column: $table.dailyMotivationTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get selectedPaletteId => $composableBuilder(
    column: $table.selectedPaletteId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customPrimary => $composableBuilder(
    column: $table.customPrimary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customSecondary => $composableBuilder(
    column: $table.customSecondary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get customAccent => $composableBuilder(
    column: $table.customAccent,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brightnessMode => $composableBuilder(
    column: $table.brightnessMode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notificationsEnabled => $composableBuilder(
    column: $table.notificationsEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dailyMotivationTime => $composableBuilder(
    column: $table.dailyMotivationTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hasCompletedOnboarding => $composableBuilder(
    column: $table.hasCompletedOnboarding,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsTableData,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsTableData
            >,
          ),
          UserSettingsTableData,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> selectedPaletteId = const Value.absent(),
                Value<int?> customPrimary = const Value.absent(),
                Value<int?> customSecondary = const Value.absent(),
                Value<int?> customAccent = const Value.absent(),
                Value<String> brightnessMode = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> dailyMotivationTime = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
              }) => UserSettingsTableCompanion(
                id: id,
                selectedPaletteId: selectedPaletteId,
                customPrimary: customPrimary,
                customSecondary: customSecondary,
                customAccent: customAccent,
                brightnessMode: brightnessMode,
                currencyCode: currencyCode,
                notificationsEnabled: notificationsEnabled,
                dailyMotivationTime: dailyMotivationTime,
                hasCompletedOnboarding: hasCompletedOnboarding,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> selectedPaletteId = const Value.absent(),
                Value<int?> customPrimary = const Value.absent(),
                Value<int?> customSecondary = const Value.absent(),
                Value<int?> customAccent = const Value.absent(),
                Value<String> brightnessMode = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<bool> notificationsEnabled = const Value.absent(),
                Value<String?> dailyMotivationTime = const Value.absent(),
                Value<bool> hasCompletedOnboarding = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                id: id,
                selectedPaletteId: selectedPaletteId,
                customPrimary: customPrimary,
                customSecondary: customSecondary,
                customAccent: customAccent,
                brightnessMode: brightnessMode,
                currencyCode: currencyCode,
                notificationsEnabled: notificationsEnabled,
                dailyMotivationTime: dailyMotivationTime,
                hasCompletedOnboarding: hasCompletedOnboarding,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsTableData,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsTableData,
        BaseReferences<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsTableData
        >,
      ),
      UserSettingsTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TrackersTableTableManager get trackers =>
      $$TrackersTableTableManager(_db, _db.trackers);
  $$CravingsTableTableManager get cravings =>
      $$CravingsTableTableManager(_db, _db.cravings);
  $$SlipsTableTableManager get slips =>
      $$SlipsTableTableManager(_db, _db.slips);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
}
