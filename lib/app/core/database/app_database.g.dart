// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SubmissionsTable extends Submissions
    with TableInfo<$SubmissionsTable, Submission> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _milestoneIdMeta = const VerificationMeta(
    'milestoneId',
  );
  @override
  late final GeneratedColumn<String> milestoneId = GeneratedColumn<String>(
    'milestone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    projectId,
    milestoneId,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submissions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Submission> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('milestone_id')) {
      context.handle(
        _milestoneIdMeta,
        milestoneId.isAcceptableOrUnknown(
          data['milestone_id']!,
          _milestoneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_milestoneIdMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
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
  Submission map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Submission(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      milestoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}milestone_id'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $SubmissionsTable createAlias(String alias) {
    return $SubmissionsTable(attachedDatabase, alias);
  }
}

class Submission extends DataClass implements Insertable<Submission> {
  final int id;
  final String projectId;
  final String milestoneId;
  final bool isSynced;
  final DateTime createdAt;
  const Submission({
    required this.id,
    required this.projectId,
    required this.milestoneId,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<String>(projectId);
    map['milestone_id'] = Variable<String>(milestoneId);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SubmissionsCompanion toCompanion(bool nullToAbsent) {
    return SubmissionsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      milestoneId: Value(milestoneId),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory Submission.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Submission(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      milestoneId: serializer.fromJson<String>(json['milestoneId']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<String>(projectId),
      'milestoneId': serializer.toJson<String>(milestoneId),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Submission copyWith({
    int? id,
    String? projectId,
    String? milestoneId,
    bool? isSynced,
    DateTime? createdAt,
  }) => Submission(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    milestoneId: milestoneId ?? this.milestoneId,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  Submission copyWithCompanion(SubmissionsCompanion data) {
    return Submission(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      milestoneId:
          data.milestoneId.present ? data.milestoneId.value : this.milestoneId,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Submission(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, milestoneId, isSynced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Submission &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.milestoneId == this.milestoneId &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class SubmissionsCompanion extends UpdateCompanion<Submission> {
  final Value<int> id;
  final Value<String> projectId;
  final Value<String> milestoneId;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const SubmissionsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SubmissionsCompanion.insert({
    this.id = const Value.absent(),
    required String projectId,
    required String milestoneId,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       milestoneId = Value(milestoneId);
  static Insertable<Submission> custom({
    Expression<int>? id,
    Expression<String>? projectId,
    Expression<String>? milestoneId,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (milestoneId != null) 'milestone_id': milestoneId,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SubmissionsCompanion copyWith({
    Value<int>? id,
    Value<String>? projectId,
    Value<String>? milestoneId,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return SubmissionsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      milestoneId: milestoneId ?? this.milestoneId,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (milestoneId.present) {
      map['milestone_id'] = Variable<String>(milestoneId.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SubmissionImagesTable extends SubmissionImages
    with TableInfo<$SubmissionImagesTable, SubmissionImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionImagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<int> submissionId = GeneratedColumn<int>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submissions (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, submissionId, filePath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_submissionIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubmissionImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionImage(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      submissionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}submission_id'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
    );
  }

  @override
  $SubmissionImagesTable createAlias(String alias) {
    return $SubmissionImagesTable(attachedDatabase, alias);
  }
}

class SubmissionImage extends DataClass implements Insertable<SubmissionImage> {
  final int id;
  final int submissionId;
  final String filePath;
  const SubmissionImage({
    required this.id,
    required this.submissionId,
    required this.filePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['submission_id'] = Variable<int>(submissionId);
    map['file_path'] = Variable<String>(filePath);
    return map;
  }

  SubmissionImagesCompanion toCompanion(bool nullToAbsent) {
    return SubmissionImagesCompanion(
      id: Value(id),
      submissionId: Value(submissionId),
      filePath: Value(filePath),
    );
  }

  factory SubmissionImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionImage(
      id: serializer.fromJson<int>(json['id']),
      submissionId: serializer.fromJson<int>(json['submissionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'submissionId': serializer.toJson<int>(submissionId),
      'filePath': serializer.toJson<String>(filePath),
    };
  }

  SubmissionImage copyWith({int? id, int? submissionId, String? filePath}) =>
      SubmissionImage(
        id: id ?? this.id,
        submissionId: submissionId ?? this.submissionId,
        filePath: filePath ?? this.filePath,
      );
  SubmissionImage copyWithCompanion(SubmissionImagesCompanion data) {
    return SubmissionImage(
      id: data.id.present ? data.id.value : this.id,
      submissionId:
          data.submissionId.present
              ? data.submissionId.value
              : this.submissionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionImage(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, submissionId, filePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionImage &&
          other.id == this.id &&
          other.submissionId == this.submissionId &&
          other.filePath == this.filePath);
}

class SubmissionImagesCompanion extends UpdateCompanion<SubmissionImage> {
  final Value<int> id;
  final Value<int> submissionId;
  final Value<String> filePath;
  const SubmissionImagesCompanion({
    this.id = const Value.absent(),
    this.submissionId = const Value.absent(),
    this.filePath = const Value.absent(),
  });
  SubmissionImagesCompanion.insert({
    this.id = const Value.absent(),
    required int submissionId,
    required String filePath,
  }) : submissionId = Value(submissionId),
       filePath = Value(filePath);
  static Insertable<SubmissionImage> custom({
    Expression<int>? id,
    Expression<int>? submissionId,
    Expression<String>? filePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (submissionId != null) 'submission_id': submissionId,
      if (filePath != null) 'file_path': filePath,
    });
  }

  SubmissionImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? submissionId,
    Value<String>? filePath,
  }) {
    return SubmissionImagesCompanion(
      id: id ?? this.id,
      submissionId: submissionId ?? this.submissionId,
      filePath: filePath ?? this.filePath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (submissionId.present) {
      map['submission_id'] = Variable<int>(submissionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionImagesCompanion(')
          ..write('id: $id, ')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath')
          ..write(')'))
        .toString();
  }
}

class $SubmissionAudioTable extends SubmissionAudio
    with TableInfo<$SubmissionAudioTable, SubmissionAudioData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionAudioTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<int> submissionId = GeneratedColumn<int>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submissions (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [submissionId, filePath, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_audio';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionAudioData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {submissionId};
  @override
  SubmissionAudioData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionAudioData(
      submissionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}submission_id'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
      durationMs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}duration_ms'],
          )!,
    );
  }

  @override
  $SubmissionAudioTable createAlias(String alias) {
    return $SubmissionAudioTable(attachedDatabase, alias);
  }
}

class SubmissionAudioData extends DataClass
    implements Insertable<SubmissionAudioData> {
  final int submissionId;
  final String filePath;
  final int durationMs;
  const SubmissionAudioData({
    required this.submissionId,
    required this.filePath,
    required this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['submission_id'] = Variable<int>(submissionId);
    map['file_path'] = Variable<String>(filePath);
    map['duration_ms'] = Variable<int>(durationMs);
    return map;
  }

  SubmissionAudioCompanion toCompanion(bool nullToAbsent) {
    return SubmissionAudioCompanion(
      submissionId: Value(submissionId),
      filePath: Value(filePath),
      durationMs: Value(durationMs),
    );
  }

  factory SubmissionAudioData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionAudioData(
      submissionId: serializer.fromJson<int>(json['submissionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'submissionId': serializer.toJson<int>(submissionId),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int>(durationMs),
    };
  }

  SubmissionAudioData copyWith({
    int? submissionId,
    String? filePath,
    int? durationMs,
  }) => SubmissionAudioData(
    submissionId: submissionId ?? this.submissionId,
    filePath: filePath ?? this.filePath,
    durationMs: durationMs ?? this.durationMs,
  );
  SubmissionAudioData copyWithCompanion(SubmissionAudioCompanion data) {
    return SubmissionAudioData(
      submissionId:
          data.submissionId.present
              ? data.submissionId.value
              : this.submissionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionAudioData(')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(submissionId, filePath, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionAudioData &&
          other.submissionId == this.submissionId &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs);
}

class SubmissionAudioCompanion extends UpdateCompanion<SubmissionAudioData> {
  final Value<int> submissionId;
  final Value<String> filePath;
  final Value<int> durationMs;
  const SubmissionAudioCompanion({
    this.submissionId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  SubmissionAudioCompanion.insert({
    this.submissionId = const Value.absent(),
    required String filePath,
    required int durationMs,
  }) : filePath = Value(filePath),
       durationMs = Value(durationMs);
  static Insertable<SubmissionAudioData> custom({
    Expression<int>? submissionId,
    Expression<String>? filePath,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (submissionId != null) 'submission_id': submissionId,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  SubmissionAudioCompanion copyWith({
    Value<int>? submissionId,
    Value<String>? filePath,
    Value<int>? durationMs,
  }) {
    return SubmissionAudioCompanion(
      submissionId: submissionId ?? this.submissionId,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (submissionId.present) {
      map['submission_id'] = Variable<int>(submissionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionAudioCompanion(')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $SubmissionVideoTable extends SubmissionVideo
    with TableInfo<$SubmissionVideoTable, SubmissionVideoData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionVideoTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<int> submissionId = GeneratedColumn<int>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submissions (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [submissionId, filePath, durationMs];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_video';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionVideoData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {submissionId};
  @override
  SubmissionVideoData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionVideoData(
      submissionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}submission_id'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
    );
  }

  @override
  $SubmissionVideoTable createAlias(String alias) {
    return $SubmissionVideoTable(attachedDatabase, alias);
  }
}

class SubmissionVideoData extends DataClass
    implements Insertable<SubmissionVideoData> {
  final int submissionId;
  final String filePath;
  final int? durationMs;
  const SubmissionVideoData({
    required this.submissionId,
    required this.filePath,
    this.durationMs,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['submission_id'] = Variable<int>(submissionId);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    return map;
  }

  SubmissionVideoCompanion toCompanion(bool nullToAbsent) {
    return SubmissionVideoCompanion(
      submissionId: Value(submissionId),
      filePath: Value(filePath),
      durationMs:
          durationMs == null && nullToAbsent
              ? const Value.absent()
              : Value(durationMs),
    );
  }

  factory SubmissionVideoData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionVideoData(
      submissionId: serializer.fromJson<int>(json['submissionId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'submissionId': serializer.toJson<int>(submissionId),
      'filePath': serializer.toJson<String>(filePath),
      'durationMs': serializer.toJson<int?>(durationMs),
    };
  }

  SubmissionVideoData copyWith({
    int? submissionId,
    String? filePath,
    Value<int?> durationMs = const Value.absent(),
  }) => SubmissionVideoData(
    submissionId: submissionId ?? this.submissionId,
    filePath: filePath ?? this.filePath,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
  );
  SubmissionVideoData copyWithCompanion(SubmissionVideoCompanion data) {
    return SubmissionVideoData(
      submissionId:
          data.submissionId.present
              ? data.submissionId.value
              : this.submissionId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      durationMs:
          data.durationMs.present ? data.durationMs.value : this.durationMs,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionVideoData(')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(submissionId, filePath, durationMs);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionVideoData &&
          other.submissionId == this.submissionId &&
          other.filePath == this.filePath &&
          other.durationMs == this.durationMs);
}

class SubmissionVideoCompanion extends UpdateCompanion<SubmissionVideoData> {
  final Value<int> submissionId;
  final Value<String> filePath;
  final Value<int?> durationMs;
  const SubmissionVideoCompanion({
    this.submissionId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.durationMs = const Value.absent(),
  });
  SubmissionVideoCompanion.insert({
    this.submissionId = const Value.absent(),
    required String filePath,
    this.durationMs = const Value.absent(),
  }) : filePath = Value(filePath);
  static Insertable<SubmissionVideoData> custom({
    Expression<int>? submissionId,
    Expression<String>? filePath,
    Expression<int>? durationMs,
  }) {
    return RawValuesInsertable({
      if (submissionId != null) 'submission_id': submissionId,
      if (filePath != null) 'file_path': filePath,
      if (durationMs != null) 'duration_ms': durationMs,
    });
  }

  SubmissionVideoCompanion copyWith({
    Value<int>? submissionId,
    Value<String>? filePath,
    Value<int?>? durationMs,
  }) {
    return SubmissionVideoCompanion(
      submissionId: submissionId ?? this.submissionId,
      filePath: filePath ?? this.filePath,
      durationMs: durationMs ?? this.durationMs,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (submissionId.present) {
      map['submission_id'] = Variable<int>(submissionId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionVideoCompanion(')
          ..write('submissionId: $submissionId, ')
          ..write('filePath: $filePath, ')
          ..write('durationMs: $durationMs')
          ..write(')'))
        .toString();
  }
}

class $SubmissionRemarksTable extends SubmissionRemarks
    with TableInfo<$SubmissionRemarksTable, SubmissionRemark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubmissionRemarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _submissionIdMeta = const VerificationMeta(
    'submissionId',
  );
  @override
  late final GeneratedColumn<int> submissionId = GeneratedColumn<int>(
    'submission_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES submissions (id)',
    ),
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [submissionId, remarks];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'submission_remarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubmissionRemark> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('submission_id')) {
      context.handle(
        _submissionIdMeta,
        submissionId.isAcceptableOrUnknown(
          data['submission_id']!,
          _submissionIdMeta,
        ),
      );
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {submissionId};
  @override
  SubmissionRemark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubmissionRemark(
      submissionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}submission_id'],
          )!,
      remarks:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}remarks'],
          )!,
    );
  }

  @override
  $SubmissionRemarksTable createAlias(String alias) {
    return $SubmissionRemarksTable(attachedDatabase, alias);
  }
}

class SubmissionRemark extends DataClass
    implements Insertable<SubmissionRemark> {
  final int submissionId;
  final String remarks;
  const SubmissionRemark({required this.submissionId, required this.remarks});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['submission_id'] = Variable<int>(submissionId);
    map['remarks'] = Variable<String>(remarks);
    return map;
  }

  SubmissionRemarksCompanion toCompanion(bool nullToAbsent) {
    return SubmissionRemarksCompanion(
      submissionId: Value(submissionId),
      remarks: Value(remarks),
    );
  }

  factory SubmissionRemark.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubmissionRemark(
      submissionId: serializer.fromJson<int>(json['submissionId']),
      remarks: serializer.fromJson<String>(json['remarks']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'submissionId': serializer.toJson<int>(submissionId),
      'remarks': serializer.toJson<String>(remarks),
    };
  }

  SubmissionRemark copyWith({int? submissionId, String? remarks}) =>
      SubmissionRemark(
        submissionId: submissionId ?? this.submissionId,
        remarks: remarks ?? this.remarks,
      );
  SubmissionRemark copyWithCompanion(SubmissionRemarksCompanion data) {
    return SubmissionRemark(
      submissionId:
          data.submissionId.present
              ? data.submissionId.value
              : this.submissionId,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionRemark(')
          ..write('submissionId: $submissionId, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(submissionId, remarks);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubmissionRemark &&
          other.submissionId == this.submissionId &&
          other.remarks == this.remarks);
}

class SubmissionRemarksCompanion extends UpdateCompanion<SubmissionRemark> {
  final Value<int> submissionId;
  final Value<String> remarks;
  const SubmissionRemarksCompanion({
    this.submissionId = const Value.absent(),
    this.remarks = const Value.absent(),
  });
  SubmissionRemarksCompanion.insert({
    this.submissionId = const Value.absent(),
    required String remarks,
  }) : remarks = Value(remarks);
  static Insertable<SubmissionRemark> custom({
    Expression<int>? submissionId,
    Expression<String>? remarks,
  }) {
    return RawValuesInsertable({
      if (submissionId != null) 'submission_id': submissionId,
      if (remarks != null) 'remarks': remarks,
    });
  }

  SubmissionRemarksCompanion copyWith({
    Value<int>? submissionId,
    Value<String>? remarks,
  }) {
    return SubmissionRemarksCompanion(
      submissionId: submissionId ?? this.submissionId,
      remarks: remarks ?? this.remarks,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (submissionId.present) {
      map['submission_id'] = Variable<int>(submissionId.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubmissionRemarksCompanion(')
          ..write('submissionId: $submissionId, ')
          ..write('remarks: $remarks')
          ..write(')'))
        .toString();
  }
}

class $LocalProjectsTable extends LocalProjects
    with TableInfo<$LocalProjectsTable, LocalProject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalProjectsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectNameMeta = const VerificationMeta(
    'projectName',
  );
  @override
  late final GeneratedColumn<String> projectName = GeneratedColumn<String>(
    'project_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latMeta = const VerificationMeta('lat');
  @override
  late final GeneratedColumn<double> lat = GeneratedColumn<double>(
    'lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lngMeta = const VerificationMeta('lng');
  @override
  late final GeneratedColumn<double> lng = GeneratedColumn<double>(
    'lng',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    projectName,
    status,
    lat,
    lng,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalProject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('project_name')) {
      context.handle(
        _projectNameMeta,
        projectName.isAcceptableOrUnknown(
          data['project_name']!,
          _projectNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_projectNameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('lat')) {
      context.handle(
        _latMeta,
        lat.isAcceptableOrUnknown(data['lat']!, _latMeta),
      );
    }
    if (data.containsKey('lng')) {
      context.handle(
        _lngMeta,
        lng.isAcceptableOrUnknown(data['lng']!, _lngMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalProject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalProject(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      projectName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_name'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
      lat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lat'],
      ),
      lng: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}lng'],
      ),
    );
  }

  @override
  $LocalProjectsTable createAlias(String alias) {
    return $LocalProjectsTable(attachedDatabase, alias);
  }
}

class LocalProject extends DataClass implements Insertable<LocalProject> {
  final int id;
  final String projectId;
  final String projectName;
  final String status;
  final double? lat;
  final double? lng;
  const LocalProject({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.status,
    this.lat,
    this.lng,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<String>(projectId);
    map['project_name'] = Variable<String>(projectName);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || lat != null) {
      map['lat'] = Variable<double>(lat);
    }
    if (!nullToAbsent || lng != null) {
      map['lng'] = Variable<double>(lng);
    }
    return map;
  }

  LocalProjectsCompanion toCompanion(bool nullToAbsent) {
    return LocalProjectsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      projectName: Value(projectName),
      status: Value(status),
      lat: lat == null && nullToAbsent ? const Value.absent() : Value(lat),
      lng: lng == null && nullToAbsent ? const Value.absent() : Value(lng),
    );
  }

  factory LocalProject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalProject(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      projectName: serializer.fromJson<String>(json['projectName']),
      status: serializer.fromJson<String>(json['status']),
      lat: serializer.fromJson<double?>(json['lat']),
      lng: serializer.fromJson<double?>(json['lng']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<String>(projectId),
      'projectName': serializer.toJson<String>(projectName),
      'status': serializer.toJson<String>(status),
      'lat': serializer.toJson<double?>(lat),
      'lng': serializer.toJson<double?>(lng),
    };
  }

  LocalProject copyWith({
    int? id,
    String? projectId,
    String? projectName,
    String? status,
    Value<double?> lat = const Value.absent(),
    Value<double?> lng = const Value.absent(),
  }) => LocalProject(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    projectName: projectName ?? this.projectName,
    status: status ?? this.status,
    lat: lat.present ? lat.value : this.lat,
    lng: lng.present ? lng.value : this.lng,
  );
  LocalProject copyWithCompanion(LocalProjectsCompanion data) {
    return LocalProject(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      projectName:
          data.projectName.present ? data.projectName.value : this.projectName,
      status: data.status.present ? data.status.value : this.status,
      lat: data.lat.present ? data.lat.value : this.lat,
      lng: data.lng.present ? data.lng.value : this.lng,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalProject(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('projectName: $projectName, ')
          ..write('status: $status, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, projectName, status, lat, lng);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalProject &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.projectName == this.projectName &&
          other.status == this.status &&
          other.lat == this.lat &&
          other.lng == this.lng);
}

class LocalProjectsCompanion extends UpdateCompanion<LocalProject> {
  final Value<int> id;
  final Value<String> projectId;
  final Value<String> projectName;
  final Value<String> status;
  final Value<double?> lat;
  final Value<double?> lng;
  const LocalProjectsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.projectName = const Value.absent(),
    this.status = const Value.absent(),
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
  });
  LocalProjectsCompanion.insert({
    this.id = const Value.absent(),
    required String projectId,
    required String projectName,
    required String status,
    this.lat = const Value.absent(),
    this.lng = const Value.absent(),
  }) : projectId = Value(projectId),
       projectName = Value(projectName),
       status = Value(status);
  static Insertable<LocalProject> custom({
    Expression<int>? id,
    Expression<String>? projectId,
    Expression<String>? projectName,
    Expression<String>? status,
    Expression<double>? lat,
    Expression<double>? lng,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (projectName != null) 'project_name': projectName,
      if (status != null) 'status': status,
      if (lat != null) 'lat': lat,
      if (lng != null) 'lng': lng,
    });
  }

  LocalProjectsCompanion copyWith({
    Value<int>? id,
    Value<String>? projectId,
    Value<String>? projectName,
    Value<String>? status,
    Value<double?>? lat,
    Value<double?>? lng,
  }) {
    return LocalProjectsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      projectName: projectName ?? this.projectName,
      status: status ?? this.status,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (projectName.present) {
      map['project_name'] = Variable<String>(projectName.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (lat.present) {
      map['lat'] = Variable<double>(lat.value);
    }
    if (lng.present) {
      map['lng'] = Variable<double>(lng.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalProjectsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('projectName: $projectName, ')
          ..write('status: $status, ')
          ..write('lat: $lat, ')
          ..write('lng: $lng')
          ..write(')'))
        .toString();
  }
}

class $LocalMilestonesTable extends LocalMilestones
    with TableInfo<$LocalMilestonesTable, LocalMilestone> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMilestonesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _milestoneIdMeta = const VerificationMeta(
    'milestoneId',
  );
  @override
  late final GeneratedColumn<String> milestoneId = GeneratedColumn<String>(
    'milestone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
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
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    milestoneId,
    projectId,
    name,
    description,
    status,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_milestones';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMilestone> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('milestone_id')) {
      context.handle(
        _milestoneIdMeta,
        milestoneId.isAcceptableOrUnknown(
          data['milestone_id']!,
          _milestoneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_milestoneIdMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalMilestone map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMilestone(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      milestoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}milestone_id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}description'],
          )!,
      status:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}status'],
          )!,
    );
  }

  @override
  $LocalMilestonesTable createAlias(String alias) {
    return $LocalMilestonesTable(attachedDatabase, alias);
  }
}

class LocalMilestone extends DataClass implements Insertable<LocalMilestone> {
  final int id;
  final String milestoneId;
  final String projectId;
  final String name;
  final String description;
  final String status;
  const LocalMilestone({
    required this.id,
    required this.milestoneId,
    required this.projectId,
    required this.name,
    required this.description,
    required this.status,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['milestone_id'] = Variable<String>(milestoneId);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    return map;
  }

  LocalMilestonesCompanion toCompanion(bool nullToAbsent) {
    return LocalMilestonesCompanion(
      id: Value(id),
      milestoneId: Value(milestoneId),
      projectId: Value(projectId),
      name: Value(name),
      description: Value(description),
      status: Value(status),
    );
  }

  factory LocalMilestone.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMilestone(
      id: serializer.fromJson<int>(json['id']),
      milestoneId: serializer.fromJson<String>(json['milestoneId']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'milestoneId': serializer.toJson<String>(milestoneId),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
    };
  }

  LocalMilestone copyWith({
    int? id,
    String? milestoneId,
    String? projectId,
    String? name,
    String? description,
    String? status,
  }) => LocalMilestone(
    id: id ?? this.id,
    milestoneId: milestoneId ?? this.milestoneId,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    description: description ?? this.description,
    status: status ?? this.status,
  );
  LocalMilestone copyWithCompanion(LocalMilestonesCompanion data) {
    return LocalMilestone(
      id: data.id.present ? data.id.value : this.id,
      milestoneId:
          data.milestoneId.present ? data.milestoneId.value : this.milestoneId,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      status: data.status.present ? data.status.value : this.status,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMilestone(')
          ..write('id: $id, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, milestoneId, projectId, name, description, status);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMilestone &&
          other.id == this.id &&
          other.milestoneId == this.milestoneId &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.description == this.description &&
          other.status == this.status);
}

class LocalMilestonesCompanion extends UpdateCompanion<LocalMilestone> {
  final Value<int> id;
  final Value<String> milestoneId;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String> description;
  final Value<String> status;
  const LocalMilestonesCompanion({
    this.id = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
  });
  LocalMilestonesCompanion.insert({
    this.id = const Value.absent(),
    required String milestoneId,
    required String projectId,
    required String name,
    required String description,
    required String status,
  }) : milestoneId = Value(milestoneId),
       projectId = Value(projectId),
       name = Value(name),
       description = Value(description),
       status = Value(status);
  static Insertable<LocalMilestone> custom({
    Expression<int>? id,
    Expression<String>? milestoneId,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? status,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (milestoneId != null) 'milestone_id': milestoneId,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
    });
  }

  LocalMilestonesCompanion copyWith({
    Value<int>? id,
    Value<String>? milestoneId,
    Value<String>? projectId,
    Value<String>? name,
    Value<String>? description,
    Value<String>? status,
  }) {
    return LocalMilestonesCompanion(
      id: id ?? this.id,
      milestoneId: milestoneId ?? this.milestoneId,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (milestoneId.present) {
      map['milestone_id'] = Variable<String>(milestoneId.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMilestonesCompanion(')
          ..write('id: $id, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('status: $status')
          ..write(')'))
        .toString();
  }
}

class $LocalMilestoneAttachmentsTable extends LocalMilestoneAttachments
    with TableInfo<$LocalMilestoneAttachmentsTable, LocalMilestoneAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalMilestoneAttachmentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _milestoneIdMeta = const VerificationMeta(
    'milestoneId',
  );
  @override
  late final GeneratedColumn<String> milestoneId = GeneratedColumn<String>(
    'milestone_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    projectId,
    milestoneId,
    type,
    filePath,
    isSynced,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_milestone_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalMilestoneAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('milestone_id')) {
      context.handle(
        _milestoneIdMeta,
        milestoneId.isAcceptableOrUnknown(
          data['milestone_id']!,
          _milestoneIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_milestoneIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
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
  LocalMilestoneAttachment map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalMilestoneAttachment(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      projectId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}project_id'],
          )!,
      milestoneId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}milestone_id'],
          )!,
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}type'],
          )!,
      filePath:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}file_path'],
          )!,
      isSynced:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_synced'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $LocalMilestoneAttachmentsTable createAlias(String alias) {
    return $LocalMilestoneAttachmentsTable(attachedDatabase, alias);
  }
}

class LocalMilestoneAttachment extends DataClass
    implements Insertable<LocalMilestoneAttachment> {
  final int id;
  final String projectId;
  final String milestoneId;

  /// image | audio | video
  final String type;

  /// local file path
  final String filePath;

  /// upload sync flag
  final bool isSynced;
  final DateTime createdAt;
  const LocalMilestoneAttachment({
    required this.id,
    required this.projectId,
    required this.milestoneId,
    required this.type,
    required this.filePath,
    required this.isSynced,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['project_id'] = Variable<String>(projectId);
    map['milestone_id'] = Variable<String>(milestoneId);
    map['type'] = Variable<String>(type);
    map['file_path'] = Variable<String>(filePath);
    map['is_synced'] = Variable<bool>(isSynced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  LocalMilestoneAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalMilestoneAttachmentsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      milestoneId: Value(milestoneId),
      type: Value(type),
      filePath: Value(filePath),
      isSynced: Value(isSynced),
      createdAt: Value(createdAt),
    );
  }

  factory LocalMilestoneAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalMilestoneAttachment(
      id: serializer.fromJson<int>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      milestoneId: serializer.fromJson<String>(json['milestoneId']),
      type: serializer.fromJson<String>(json['type']),
      filePath: serializer.fromJson<String>(json['filePath']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectId': serializer.toJson<String>(projectId),
      'milestoneId': serializer.toJson<String>(milestoneId),
      'type': serializer.toJson<String>(type),
      'filePath': serializer.toJson<String>(filePath),
      'isSynced': serializer.toJson<bool>(isSynced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  LocalMilestoneAttachment copyWith({
    int? id,
    String? projectId,
    String? milestoneId,
    String? type,
    String? filePath,
    bool? isSynced,
    DateTime? createdAt,
  }) => LocalMilestoneAttachment(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    milestoneId: milestoneId ?? this.milestoneId,
    type: type ?? this.type,
    filePath: filePath ?? this.filePath,
    isSynced: isSynced ?? this.isSynced,
    createdAt: createdAt ?? this.createdAt,
  );
  LocalMilestoneAttachment copyWithCompanion(
    LocalMilestoneAttachmentsCompanion data,
  ) {
    return LocalMilestoneAttachment(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      milestoneId:
          data.milestoneId.present ? data.milestoneId.value : this.milestoneId,
      type: data.type.present ? data.type.value : this.type,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalMilestoneAttachment(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    milestoneId,
    type,
    filePath,
    isSynced,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalMilestoneAttachment &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.milestoneId == this.milestoneId &&
          other.type == this.type &&
          other.filePath == this.filePath &&
          other.isSynced == this.isSynced &&
          other.createdAt == this.createdAt);
}

class LocalMilestoneAttachmentsCompanion
    extends UpdateCompanion<LocalMilestoneAttachment> {
  final Value<int> id;
  final Value<String> projectId;
  final Value<String> milestoneId;
  final Value<String> type;
  final Value<String> filePath;
  final Value<bool> isSynced;
  final Value<DateTime> createdAt;
  const LocalMilestoneAttachmentsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.milestoneId = const Value.absent(),
    this.type = const Value.absent(),
    this.filePath = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  LocalMilestoneAttachmentsCompanion.insert({
    this.id = const Value.absent(),
    required String projectId,
    required String milestoneId,
    required String type,
    required String filePath,
    this.isSynced = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : projectId = Value(projectId),
       milestoneId = Value(milestoneId),
       type = Value(type),
       filePath = Value(filePath);
  static Insertable<LocalMilestoneAttachment> custom({
    Expression<int>? id,
    Expression<String>? projectId,
    Expression<String>? milestoneId,
    Expression<String>? type,
    Expression<String>? filePath,
    Expression<bool>? isSynced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (milestoneId != null) 'milestone_id': milestoneId,
      if (type != null) 'type': type,
      if (filePath != null) 'file_path': filePath,
      if (isSynced != null) 'is_synced': isSynced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  LocalMilestoneAttachmentsCompanion copyWith({
    Value<int>? id,
    Value<String>? projectId,
    Value<String>? milestoneId,
    Value<String>? type,
    Value<String>? filePath,
    Value<bool>? isSynced,
    Value<DateTime>? createdAt,
  }) {
    return LocalMilestoneAttachmentsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      milestoneId: milestoneId ?? this.milestoneId,
      type: type ?? this.type,
      filePath: filePath ?? this.filePath,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (milestoneId.present) {
      map['milestone_id'] = Variable<String>(milestoneId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalMilestoneAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('milestoneId: $milestoneId, ')
          ..write('type: $type, ')
          ..write('filePath: $filePath, ')
          ..write('isSynced: $isSynced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SubmissionsTable submissions = $SubmissionsTable(this);
  late final $SubmissionImagesTable submissionImages = $SubmissionImagesTable(
    this,
  );
  late final $SubmissionAudioTable submissionAudio = $SubmissionAudioTable(
    this,
  );
  late final $SubmissionVideoTable submissionVideo = $SubmissionVideoTable(
    this,
  );
  late final $SubmissionRemarksTable submissionRemarks =
      $SubmissionRemarksTable(this);
  late final $LocalProjectsTable localProjects = $LocalProjectsTable(this);
  late final $LocalMilestonesTable localMilestones = $LocalMilestonesTable(
    this,
  );
  late final $LocalMilestoneAttachmentsTable localMilestoneAttachments =
      $LocalMilestoneAttachmentsTable(this);
  late final SubmissionDao submissionDao = SubmissionDao(this as AppDatabase);
  late final ProjectDao projectDao = ProjectDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    submissions,
    submissionImages,
    submissionAudio,
    submissionVideo,
    submissionRemarks,
    localProjects,
    localMilestones,
    localMilestoneAttachments,
  ];
}

typedef $$SubmissionsTableCreateCompanionBuilder =
    SubmissionsCompanion Function({
      Value<int> id,
      required String projectId,
      required String milestoneId,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$SubmissionsTableUpdateCompanionBuilder =
    SubmissionsCompanion Function({
      Value<int> id,
      Value<String> projectId,
      Value<String> milestoneId,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

final class $$SubmissionsTableReferences
    extends BaseReferences<_$AppDatabase, $SubmissionsTable, Submission> {
  $$SubmissionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubmissionImagesTable, List<SubmissionImage>>
  _submissionImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.submissionImages,
    aliasName: $_aliasNameGenerator(
      db.submissions.id,
      db.submissionImages.submissionId,
    ),
  );

  $$SubmissionImagesTableProcessedTableManager get submissionImagesRefs {
    final manager = $$SubmissionImagesTableTableManager(
      $_db,
      $_db.submissionImages,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _submissionImagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubmissionAudioTable, List<SubmissionAudioData>>
  _submissionAudioRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.submissionAudio,
    aliasName: $_aliasNameGenerator(
      db.submissions.id,
      db.submissionAudio.submissionId,
    ),
  );

  $$SubmissionAudioTableProcessedTableManager get submissionAudioRefs {
    final manager = $$SubmissionAudioTableTableManager(
      $_db,
      $_db.submissionAudio,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _submissionAudioRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubmissionVideoTable, List<SubmissionVideoData>>
  _submissionVideoRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.submissionVideo,
    aliasName: $_aliasNameGenerator(
      db.submissions.id,
      db.submissionVideo.submissionId,
    ),
  );

  $$SubmissionVideoTableProcessedTableManager get submissionVideoRefs {
    final manager = $$SubmissionVideoTableTableManager(
      $_db,
      $_db.submissionVideo,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _submissionVideoRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SubmissionRemarksTable, List<SubmissionRemark>>
  _submissionRemarksRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.submissionRemarks,
        aliasName: $_aliasNameGenerator(
          db.submissions.id,
          db.submissionRemarks.submissionId,
        ),
      );

  $$SubmissionRemarksTableProcessedTableManager get submissionRemarksRefs {
    final manager = $$SubmissionRemarksTableTableManager(
      $_db,
      $_db.submissionRemarks,
    ).filter((f) => f.submissionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _submissionRemarksRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubmissionsTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableFilterComposer({
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

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> submissionImagesRefs(
    Expression<bool> Function($$SubmissionImagesTableFilterComposer f) f,
  ) {
    final $$SubmissionImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionImages,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionImagesTableFilterComposer(
            $db: $db,
            $table: $db.submissionImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> submissionAudioRefs(
    Expression<bool> Function($$SubmissionAudioTableFilterComposer f) f,
  ) {
    final $$SubmissionAudioTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionAudio,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionAudioTableFilterComposer(
            $db: $db,
            $table: $db.submissionAudio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> submissionVideoRefs(
    Expression<bool> Function($$SubmissionVideoTableFilterComposer f) f,
  ) {
    final $$SubmissionVideoTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionVideo,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionVideoTableFilterComposer(
            $db: $db,
            $table: $db.submissionVideo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> submissionRemarksRefs(
    Expression<bool> Function($$SubmissionRemarksTableFilterComposer f) f,
  ) {
    final $$SubmissionRemarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionRemarks,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionRemarksTableFilterComposer(
            $db: $db,
            $table: $db.submissionRemarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubmissionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableOrderingComposer({
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

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SubmissionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionsTable> {
  $$SubmissionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> submissionImagesRefs<T extends Object>(
    Expression<T> Function($$SubmissionImagesTableAnnotationComposer a) f,
  ) {
    final $$SubmissionImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionImages,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> submissionAudioRefs<T extends Object>(
    Expression<T> Function($$SubmissionAudioTableAnnotationComposer a) f,
  ) {
    final $$SubmissionAudioTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionAudio,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionAudioTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionAudio,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> submissionVideoRefs<T extends Object>(
    Expression<T> Function($$SubmissionVideoTableAnnotationComposer a) f,
  ) {
    final $$SubmissionVideoTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.submissionVideo,
      getReferencedColumn: (t) => t.submissionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionVideoTableAnnotationComposer(
            $db: $db,
            $table: $db.submissionVideo,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> submissionRemarksRefs<T extends Object>(
    Expression<T> Function($$SubmissionRemarksTableAnnotationComposer a) f,
  ) {
    final $$SubmissionRemarksTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.submissionRemarks,
          getReferencedColumn: (t) => t.submissionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SubmissionRemarksTableAnnotationComposer(
                $db: $db,
                $table: $db.submissionRemarks,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SubmissionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionsTable,
          Submission,
          $$SubmissionsTableFilterComposer,
          $$SubmissionsTableOrderingComposer,
          $$SubmissionsTableAnnotationComposer,
          $$SubmissionsTableCreateCompanionBuilder,
          $$SubmissionsTableUpdateCompanionBuilder,
          (Submission, $$SubmissionsTableReferences),
          Submission,
          PrefetchHooks Function({
            bool submissionImagesRefs,
            bool submissionAudioRefs,
            bool submissionVideoRefs,
            bool submissionRemarksRefs,
          })
        > {
  $$SubmissionsTableTableManager(_$AppDatabase db, $SubmissionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubmissionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubmissionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$SubmissionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> milestoneId = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubmissionsCompanion(
                id: id,
                projectId: projectId,
                milestoneId: milestoneId,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String projectId,
                required String milestoneId,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SubmissionsCompanion.insert(
                id: id,
                projectId: projectId,
                milestoneId: milestoneId,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubmissionsTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            submissionImagesRefs = false,
            submissionAudioRefs = false,
            submissionVideoRefs = false,
            submissionRemarksRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (submissionImagesRefs) db.submissionImages,
                if (submissionAudioRefs) db.submissionAudio,
                if (submissionVideoRefs) db.submissionVideo,
                if (submissionRemarksRefs) db.submissionRemarks,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (submissionImagesRefs)
                    await $_getPrefetchedData<
                      Submission,
                      $SubmissionsTable,
                      SubmissionImage
                    >(
                      currentTable: table,
                      referencedTable: $$SubmissionsTableReferences
                          ._submissionImagesRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SubmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).submissionImagesRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.submissionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (submissionAudioRefs)
                    await $_getPrefetchedData<
                      Submission,
                      $SubmissionsTable,
                      SubmissionAudioData
                    >(
                      currentTable: table,
                      referencedTable: $$SubmissionsTableReferences
                          ._submissionAudioRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SubmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).submissionAudioRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.submissionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (submissionVideoRefs)
                    await $_getPrefetchedData<
                      Submission,
                      $SubmissionsTable,
                      SubmissionVideoData
                    >(
                      currentTable: table,
                      referencedTable: $$SubmissionsTableReferences
                          ._submissionVideoRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SubmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).submissionVideoRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.submissionId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (submissionRemarksRefs)
                    await $_getPrefetchedData<
                      Submission,
                      $SubmissionsTable,
                      SubmissionRemark
                    >(
                      currentTable: table,
                      referencedTable: $$SubmissionsTableReferences
                          ._submissionRemarksRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$SubmissionsTableReferences(
                                db,
                                table,
                                p0,
                              ).submissionRemarksRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.submissionId == item.id,
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

typedef $$SubmissionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionsTable,
      Submission,
      $$SubmissionsTableFilterComposer,
      $$SubmissionsTableOrderingComposer,
      $$SubmissionsTableAnnotationComposer,
      $$SubmissionsTableCreateCompanionBuilder,
      $$SubmissionsTableUpdateCompanionBuilder,
      (Submission, $$SubmissionsTableReferences),
      Submission,
      PrefetchHooks Function({
        bool submissionImagesRefs,
        bool submissionAudioRefs,
        bool submissionVideoRefs,
        bool submissionRemarksRefs,
      })
    >;
typedef $$SubmissionImagesTableCreateCompanionBuilder =
    SubmissionImagesCompanion Function({
      Value<int> id,
      required int submissionId,
      required String filePath,
    });
typedef $$SubmissionImagesTableUpdateCompanionBuilder =
    SubmissionImagesCompanion Function({
      Value<int> id,
      Value<int> submissionId,
      Value<String> filePath,
    });

final class $$SubmissionImagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SubmissionImagesTable, SubmissionImage> {
  $$SubmissionImagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubmissionsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissions.createAlias(
        $_aliasNameGenerator(
          db.submissionImages.submissionId,
          db.submissions.id,
        ),
      );

  $$SubmissionsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<int>('submission_id')!;

    final manager = $$SubmissionsTableTableManager(
      $_db,
      $_db.submissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubmissionImagesTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionImagesTable> {
  $$SubmissionImagesTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionsTableFilterComposer get submissionId {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionImagesTable> {
  $$SubmissionImagesTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionsTableOrderingComposer get submissionId {
    final $$SubmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionImagesTable> {
  $$SubmissionImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  $$SubmissionsTableAnnotationComposer get submissionId {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionImagesTable,
          SubmissionImage,
          $$SubmissionImagesTableFilterComposer,
          $$SubmissionImagesTableOrderingComposer,
          $$SubmissionImagesTableAnnotationComposer,
          $$SubmissionImagesTableCreateCompanionBuilder,
          $$SubmissionImagesTableUpdateCompanionBuilder,
          (SubmissionImage, $$SubmissionImagesTableReferences),
          SubmissionImage,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SubmissionImagesTableTableManager(
    _$AppDatabase db,
    $SubmissionImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SubmissionImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubmissionImagesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubmissionImagesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> submissionId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
              }) => SubmissionImagesCompanion(
                id: id,
                submissionId: submissionId,
                filePath: filePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int submissionId,
                required String filePath,
              }) => SubmissionImagesCompanion.insert(
                id: id,
                submissionId: submissionId,
                filePath: filePath,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubmissionImagesTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (submissionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.submissionId,
                            referencedTable: $$SubmissionImagesTableReferences
                                ._submissionIdTable(db),
                            referencedColumn:
                                $$SubmissionImagesTableReferences
                                    ._submissionIdTable(db)
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

typedef $$SubmissionImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionImagesTable,
      SubmissionImage,
      $$SubmissionImagesTableFilterComposer,
      $$SubmissionImagesTableOrderingComposer,
      $$SubmissionImagesTableAnnotationComposer,
      $$SubmissionImagesTableCreateCompanionBuilder,
      $$SubmissionImagesTableUpdateCompanionBuilder,
      (SubmissionImage, $$SubmissionImagesTableReferences),
      SubmissionImage,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$SubmissionAudioTableCreateCompanionBuilder =
    SubmissionAudioCompanion Function({
      Value<int> submissionId,
      required String filePath,
      required int durationMs,
    });
typedef $$SubmissionAudioTableUpdateCompanionBuilder =
    SubmissionAudioCompanion Function({
      Value<int> submissionId,
      Value<String> filePath,
      Value<int> durationMs,
    });

final class $$SubmissionAudioTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubmissionAudioTable,
          SubmissionAudioData
        > {
  $$SubmissionAudioTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubmissionsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissions.createAlias(
        $_aliasNameGenerator(
          db.submissionAudio.submissionId,
          db.submissions.id,
        ),
      );

  $$SubmissionsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<int>('submission_id')!;

    final manager = $$SubmissionsTableTableManager(
      $_db,
      $_db.submissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubmissionAudioTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionAudioTable> {
  $$SubmissionAudioTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionsTableFilterComposer get submissionId {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionAudioTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionAudioTable> {
  $$SubmissionAudioTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionsTableOrderingComposer get submissionId {
    final $$SubmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionAudioTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionAudioTable> {
  $$SubmissionAudioTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  $$SubmissionsTableAnnotationComposer get submissionId {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionAudioTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionAudioTable,
          SubmissionAudioData,
          $$SubmissionAudioTableFilterComposer,
          $$SubmissionAudioTableOrderingComposer,
          $$SubmissionAudioTableAnnotationComposer,
          $$SubmissionAudioTableCreateCompanionBuilder,
          $$SubmissionAudioTableUpdateCompanionBuilder,
          (SubmissionAudioData, $$SubmissionAudioTableReferences),
          SubmissionAudioData,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SubmissionAudioTableTableManager(
    _$AppDatabase db,
    $SubmissionAudioTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SubmissionAudioTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubmissionAudioTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubmissionAudioTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
              }) => SubmissionAudioCompanion(
                submissionId: submissionId,
                filePath: filePath,
                durationMs: durationMs,
              ),
          createCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                required String filePath,
                required int durationMs,
              }) => SubmissionAudioCompanion.insert(
                submissionId: submissionId,
                filePath: filePath,
                durationMs: durationMs,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubmissionAudioTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (submissionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.submissionId,
                            referencedTable: $$SubmissionAudioTableReferences
                                ._submissionIdTable(db),
                            referencedColumn:
                                $$SubmissionAudioTableReferences
                                    ._submissionIdTable(db)
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

typedef $$SubmissionAudioTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionAudioTable,
      SubmissionAudioData,
      $$SubmissionAudioTableFilterComposer,
      $$SubmissionAudioTableOrderingComposer,
      $$SubmissionAudioTableAnnotationComposer,
      $$SubmissionAudioTableCreateCompanionBuilder,
      $$SubmissionAudioTableUpdateCompanionBuilder,
      (SubmissionAudioData, $$SubmissionAudioTableReferences),
      SubmissionAudioData,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$SubmissionVideoTableCreateCompanionBuilder =
    SubmissionVideoCompanion Function({
      Value<int> submissionId,
      required String filePath,
      Value<int?> durationMs,
    });
typedef $$SubmissionVideoTableUpdateCompanionBuilder =
    SubmissionVideoCompanion Function({
      Value<int> submissionId,
      Value<String> filePath,
      Value<int?> durationMs,
    });

final class $$SubmissionVideoTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubmissionVideoTable,
          SubmissionVideoData
        > {
  $$SubmissionVideoTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubmissionsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissions.createAlias(
        $_aliasNameGenerator(
          db.submissionVideo.submissionId,
          db.submissions.id,
        ),
      );

  $$SubmissionsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<int>('submission_id')!;

    final manager = $$SubmissionsTableTableManager(
      $_db,
      $_db.submissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubmissionVideoTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionVideoTable> {
  $$SubmissionVideoTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionsTableFilterComposer get submissionId {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionVideoTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionVideoTable> {
  $$SubmissionVideoTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionsTableOrderingComposer get submissionId {
    final $$SubmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionVideoTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionVideoTable> {
  $$SubmissionVideoTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  $$SubmissionsTableAnnotationComposer get submissionId {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionVideoTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionVideoTable,
          SubmissionVideoData,
          $$SubmissionVideoTableFilterComposer,
          $$SubmissionVideoTableOrderingComposer,
          $$SubmissionVideoTableAnnotationComposer,
          $$SubmissionVideoTableCreateCompanionBuilder,
          $$SubmissionVideoTableUpdateCompanionBuilder,
          (SubmissionVideoData, $$SubmissionVideoTableReferences),
          SubmissionVideoData,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SubmissionVideoTableTableManager(
    _$AppDatabase db,
    $SubmissionVideoTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SubmissionVideoTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SubmissionVideoTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubmissionVideoTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
              }) => SubmissionVideoCompanion(
                submissionId: submissionId,
                filePath: filePath,
                durationMs: durationMs,
              ),
          createCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                required String filePath,
                Value<int?> durationMs = const Value.absent(),
              }) => SubmissionVideoCompanion.insert(
                submissionId: submissionId,
                filePath: filePath,
                durationMs: durationMs,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubmissionVideoTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (submissionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.submissionId,
                            referencedTable: $$SubmissionVideoTableReferences
                                ._submissionIdTable(db),
                            referencedColumn:
                                $$SubmissionVideoTableReferences
                                    ._submissionIdTable(db)
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

typedef $$SubmissionVideoTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionVideoTable,
      SubmissionVideoData,
      $$SubmissionVideoTableFilterComposer,
      $$SubmissionVideoTableOrderingComposer,
      $$SubmissionVideoTableAnnotationComposer,
      $$SubmissionVideoTableCreateCompanionBuilder,
      $$SubmissionVideoTableUpdateCompanionBuilder,
      (SubmissionVideoData, $$SubmissionVideoTableReferences),
      SubmissionVideoData,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$SubmissionRemarksTableCreateCompanionBuilder =
    SubmissionRemarksCompanion Function({
      Value<int> submissionId,
      required String remarks,
    });
typedef $$SubmissionRemarksTableUpdateCompanionBuilder =
    SubmissionRemarksCompanion Function({
      Value<int> submissionId,
      Value<String> remarks,
    });

final class $$SubmissionRemarksTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SubmissionRemarksTable,
          SubmissionRemark
        > {
  $$SubmissionRemarksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SubmissionsTable _submissionIdTable(_$AppDatabase db) =>
      db.submissions.createAlias(
        $_aliasNameGenerator(
          db.submissionRemarks.submissionId,
          db.submissions.id,
        ),
      );

  $$SubmissionsTableProcessedTableManager get submissionId {
    final $_column = $_itemColumn<int>('submission_id')!;

    final manager = $$SubmissionsTableTableManager(
      $_db,
      $_db.submissions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_submissionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SubmissionRemarksTableFilterComposer
    extends Composer<_$AppDatabase, $SubmissionRemarksTable> {
  $$SubmissionRemarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  $$SubmissionsTableFilterComposer get submissionId {
    final $$SubmissionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableFilterComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionRemarksTableOrderingComposer
    extends Composer<_$AppDatabase, $SubmissionRemarksTable> {
  $$SubmissionRemarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  $$SubmissionsTableOrderingComposer get submissionId {
    final $$SubmissionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableOrderingComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionRemarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubmissionRemarksTable> {
  $$SubmissionRemarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  $$SubmissionsTableAnnotationComposer get submissionId {
    final $$SubmissionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.submissionId,
      referencedTable: $db.submissions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubmissionsTableAnnotationComposer(
            $db: $db,
            $table: $db.submissions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubmissionRemarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubmissionRemarksTable,
          SubmissionRemark,
          $$SubmissionRemarksTableFilterComposer,
          $$SubmissionRemarksTableOrderingComposer,
          $$SubmissionRemarksTableAnnotationComposer,
          $$SubmissionRemarksTableCreateCompanionBuilder,
          $$SubmissionRemarksTableUpdateCompanionBuilder,
          (SubmissionRemark, $$SubmissionRemarksTableReferences),
          SubmissionRemark,
          PrefetchHooks Function({bool submissionId})
        > {
  $$SubmissionRemarksTableTableManager(
    _$AppDatabase db,
    $SubmissionRemarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SubmissionRemarksTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$SubmissionRemarksTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SubmissionRemarksTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                Value<String> remarks = const Value.absent(),
              }) => SubmissionRemarksCompanion(
                submissionId: submissionId,
                remarks: remarks,
              ),
          createCompanionCallback:
              ({
                Value<int> submissionId = const Value.absent(),
                required String remarks,
              }) => SubmissionRemarksCompanion.insert(
                submissionId: submissionId,
                remarks: remarks,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$SubmissionRemarksTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({submissionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
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
                if (submissionId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.submissionId,
                            referencedTable: $$SubmissionRemarksTableReferences
                                ._submissionIdTable(db),
                            referencedColumn:
                                $$SubmissionRemarksTableReferences
                                    ._submissionIdTable(db)
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

typedef $$SubmissionRemarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubmissionRemarksTable,
      SubmissionRemark,
      $$SubmissionRemarksTableFilterComposer,
      $$SubmissionRemarksTableOrderingComposer,
      $$SubmissionRemarksTableAnnotationComposer,
      $$SubmissionRemarksTableCreateCompanionBuilder,
      $$SubmissionRemarksTableUpdateCompanionBuilder,
      (SubmissionRemark, $$SubmissionRemarksTableReferences),
      SubmissionRemark,
      PrefetchHooks Function({bool submissionId})
    >;
typedef $$LocalProjectsTableCreateCompanionBuilder =
    LocalProjectsCompanion Function({
      Value<int> id,
      required String projectId,
      required String projectName,
      required String status,
      Value<double?> lat,
      Value<double?> lng,
    });
typedef $$LocalProjectsTableUpdateCompanionBuilder =
    LocalProjectsCompanion Function({
      Value<int> id,
      Value<String> projectId,
      Value<String> projectName,
      Value<String> status,
      Value<double?> lat,
      Value<double?> lng,
    });

class $$LocalProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalProjectsTable> {
  $$LocalProjectsTableFilterComposer({
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

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalProjectsTable> {
  $$LocalProjectsTableOrderingComposer({
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

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lat => $composableBuilder(
    column: $table.lat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lng => $composableBuilder(
    column: $table.lng,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalProjectsTable> {
  $$LocalProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get projectName => $composableBuilder(
    column: $table.projectName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get lat =>
      $composableBuilder(column: $table.lat, builder: (column) => column);

  GeneratedColumn<double> get lng =>
      $composableBuilder(column: $table.lng, builder: (column) => column);
}

class $$LocalProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalProjectsTable,
          LocalProject,
          $$LocalProjectsTableFilterComposer,
          $$LocalProjectsTableOrderingComposer,
          $$LocalProjectsTableAnnotationComposer,
          $$LocalProjectsTableCreateCompanionBuilder,
          $$LocalProjectsTableUpdateCompanionBuilder,
          (
            LocalProject,
            BaseReferences<_$AppDatabase, $LocalProjectsTable, LocalProject>,
          ),
          LocalProject,
          PrefetchHooks Function()
        > {
  $$LocalProjectsTableTableManager(_$AppDatabase db, $LocalProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LocalProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$LocalProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$LocalProjectsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> projectName = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
              }) => LocalProjectsCompanion(
                id: id,
                projectId: projectId,
                projectName: projectName,
                status: status,
                lat: lat,
                lng: lng,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String projectId,
                required String projectName,
                required String status,
                Value<double?> lat = const Value.absent(),
                Value<double?> lng = const Value.absent(),
              }) => LocalProjectsCompanion.insert(
                id: id,
                projectId: projectId,
                projectName: projectName,
                status: status,
                lat: lat,
                lng: lng,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalProjectsTable,
      LocalProject,
      $$LocalProjectsTableFilterComposer,
      $$LocalProjectsTableOrderingComposer,
      $$LocalProjectsTableAnnotationComposer,
      $$LocalProjectsTableCreateCompanionBuilder,
      $$LocalProjectsTableUpdateCompanionBuilder,
      (
        LocalProject,
        BaseReferences<_$AppDatabase, $LocalProjectsTable, LocalProject>,
      ),
      LocalProject,
      PrefetchHooks Function()
    >;
typedef $$LocalMilestonesTableCreateCompanionBuilder =
    LocalMilestonesCompanion Function({
      Value<int> id,
      required String milestoneId,
      required String projectId,
      required String name,
      required String description,
      required String status,
    });
typedef $$LocalMilestonesTableUpdateCompanionBuilder =
    LocalMilestonesCompanion Function({
      Value<int> id,
      Value<String> milestoneId,
      Value<String> projectId,
      Value<String> name,
      Value<String> description,
      Value<String> status,
    });

class $$LocalMilestonesTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMilestonesTable> {
  $$LocalMilestonesTableFilterComposer({
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

  ColumnFilters<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMilestonesTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMilestonesTable> {
  $$LocalMilestonesTableOrderingComposer({
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

  ColumnOrderings<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMilestonesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMilestonesTable> {
  $$LocalMilestonesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);
}

class $$LocalMilestonesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMilestonesTable,
          LocalMilestone,
          $$LocalMilestonesTableFilterComposer,
          $$LocalMilestonesTableOrderingComposer,
          $$LocalMilestonesTableAnnotationComposer,
          $$LocalMilestonesTableCreateCompanionBuilder,
          $$LocalMilestonesTableUpdateCompanionBuilder,
          (
            LocalMilestone,
            BaseReferences<
              _$AppDatabase,
              $LocalMilestonesTable,
              LocalMilestone
            >,
          ),
          LocalMilestone,
          PrefetchHooks Function()
        > {
  $$LocalMilestonesTableTableManager(
    _$AppDatabase db,
    $LocalMilestonesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$LocalMilestonesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$LocalMilestonesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$LocalMilestonesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> milestoneId = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
              }) => LocalMilestonesCompanion(
                id: id,
                milestoneId: milestoneId,
                projectId: projectId,
                name: name,
                description: description,
                status: status,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String milestoneId,
                required String projectId,
                required String name,
                required String description,
                required String status,
              }) => LocalMilestonesCompanion.insert(
                id: id,
                milestoneId: milestoneId,
                projectId: projectId,
                name: name,
                description: description,
                status: status,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMilestonesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMilestonesTable,
      LocalMilestone,
      $$LocalMilestonesTableFilterComposer,
      $$LocalMilestonesTableOrderingComposer,
      $$LocalMilestonesTableAnnotationComposer,
      $$LocalMilestonesTableCreateCompanionBuilder,
      $$LocalMilestonesTableUpdateCompanionBuilder,
      (
        LocalMilestone,
        BaseReferences<_$AppDatabase, $LocalMilestonesTable, LocalMilestone>,
      ),
      LocalMilestone,
      PrefetchHooks Function()
    >;
typedef $$LocalMilestoneAttachmentsTableCreateCompanionBuilder =
    LocalMilestoneAttachmentsCompanion Function({
      Value<int> id,
      required String projectId,
      required String milestoneId,
      required String type,
      required String filePath,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });
typedef $$LocalMilestoneAttachmentsTableUpdateCompanionBuilder =
    LocalMilestoneAttachmentsCompanion Function({
      Value<int> id,
      Value<String> projectId,
      Value<String> milestoneId,
      Value<String> type,
      Value<String> filePath,
      Value<bool> isSynced,
      Value<DateTime> createdAt,
    });

class $$LocalMilestoneAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalMilestoneAttachmentsTable> {
  $$LocalMilestoneAttachmentsTableFilterComposer({
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

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalMilestoneAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalMilestoneAttachmentsTable> {
  $$LocalMilestoneAttachmentsTableOrderingComposer({
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

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalMilestoneAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalMilestoneAttachmentsTable> {
  $$LocalMilestoneAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get milestoneId => $composableBuilder(
    column: $table.milestoneId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$LocalMilestoneAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalMilestoneAttachmentsTable,
          LocalMilestoneAttachment,
          $$LocalMilestoneAttachmentsTableFilterComposer,
          $$LocalMilestoneAttachmentsTableOrderingComposer,
          $$LocalMilestoneAttachmentsTableAnnotationComposer,
          $$LocalMilestoneAttachmentsTableCreateCompanionBuilder,
          $$LocalMilestoneAttachmentsTableUpdateCompanionBuilder,
          (
            LocalMilestoneAttachment,
            BaseReferences<
              _$AppDatabase,
              $LocalMilestoneAttachmentsTable,
              LocalMilestoneAttachment
            >,
          ),
          LocalMilestoneAttachment,
          PrefetchHooks Function()
        > {
  $$LocalMilestoneAttachmentsTableTableManager(
    _$AppDatabase db,
    $LocalMilestoneAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$LocalMilestoneAttachmentsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$LocalMilestoneAttachmentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$LocalMilestoneAttachmentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> milestoneId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LocalMilestoneAttachmentsCompanion(
                id: id,
                projectId: projectId,
                milestoneId: milestoneId,
                type: type,
                filePath: filePath,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String projectId,
                required String milestoneId,
                required String type,
                required String filePath,
                Value<bool> isSynced = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => LocalMilestoneAttachmentsCompanion.insert(
                id: id,
                projectId: projectId,
                milestoneId: milestoneId,
                type: type,
                filePath: filePath,
                isSynced: isSynced,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalMilestoneAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalMilestoneAttachmentsTable,
      LocalMilestoneAttachment,
      $$LocalMilestoneAttachmentsTableFilterComposer,
      $$LocalMilestoneAttachmentsTableOrderingComposer,
      $$LocalMilestoneAttachmentsTableAnnotationComposer,
      $$LocalMilestoneAttachmentsTableCreateCompanionBuilder,
      $$LocalMilestoneAttachmentsTableUpdateCompanionBuilder,
      (
        LocalMilestoneAttachment,
        BaseReferences<
          _$AppDatabase,
          $LocalMilestoneAttachmentsTable,
          LocalMilestoneAttachment
        >,
      ),
      LocalMilestoneAttachment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SubmissionsTableTableManager get submissions =>
      $$SubmissionsTableTableManager(_db, _db.submissions);
  $$SubmissionImagesTableTableManager get submissionImages =>
      $$SubmissionImagesTableTableManager(_db, _db.submissionImages);
  $$SubmissionAudioTableTableManager get submissionAudio =>
      $$SubmissionAudioTableTableManager(_db, _db.submissionAudio);
  $$SubmissionVideoTableTableManager get submissionVideo =>
      $$SubmissionVideoTableTableManager(_db, _db.submissionVideo);
  $$SubmissionRemarksTableTableManager get submissionRemarks =>
      $$SubmissionRemarksTableTableManager(_db, _db.submissionRemarks);
  $$LocalProjectsTableTableManager get localProjects =>
      $$LocalProjectsTableTableManager(_db, _db.localProjects);
  $$LocalMilestonesTableTableManager get localMilestones =>
      $$LocalMilestonesTableTableManager(_db, _db.localMilestones);
  $$LocalMilestoneAttachmentsTableTableManager get localMilestoneAttachments =>
      $$LocalMilestoneAttachmentsTableTableManager(
        _db,
        _db.localMilestoneAttachments,
      );
}
