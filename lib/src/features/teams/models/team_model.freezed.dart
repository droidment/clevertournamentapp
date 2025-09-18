// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TeamModel _$TeamModelFromJson(Map<String, dynamic> json) {
  return _TeamModel.fromJson(json);
}

/// @nodoc
mixin _$TeamModel {
  String get id => throw _privateConstructorUsedError;
  String get tournamentId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get captainId => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  int? get seed => throw _privateConstructorUsedError;
  String? get poolId => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
  TeamRegistrationStatus? get registrationStatus =>
      throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TeamModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TeamModelCopyWith<TeamModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamModelCopyWith<$Res> {
  factory $TeamModelCopyWith(TeamModel value, $Res Function(TeamModel) then) =
      _$TeamModelCopyWithImpl<$Res, TeamModel>;
  @useResult
  $Res call({
    String id,
    String tournamentId,
    String name,
    String? captainId,
    String? contactEmail,
    String? contactPhone,
    int? seed,
    String? poolId,
    @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
    TeamRegistrationStatus? registrationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$TeamModelCopyWithImpl<$Res, $Val extends TeamModel>
    implements $TeamModelCopyWith<$Res> {
  _$TeamModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? name = null,
    Object? captainId = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? seed = freezed,
    Object? poolId = freezed,
    Object? registrationStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            tournamentId:
                null == tournamentId
                    ? _value.tournamentId
                    : tournamentId // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            captainId:
                freezed == captainId
                    ? _value.captainId
                    : captainId // ignore: cast_nullable_to_non_nullable
                        as String?,
            contactEmail:
                freezed == contactEmail
                    ? _value.contactEmail
                    : contactEmail // ignore: cast_nullable_to_non_nullable
                        as String?,
            contactPhone:
                freezed == contactPhone
                    ? _value.contactPhone
                    : contactPhone // ignore: cast_nullable_to_non_nullable
                        as String?,
            seed:
                freezed == seed
                    ? _value.seed
                    : seed // ignore: cast_nullable_to_non_nullable
                        as int?,
            poolId:
                freezed == poolId
                    ? _value.poolId
                    : poolId // ignore: cast_nullable_to_non_nullable
                        as String?,
            registrationStatus:
                freezed == registrationStatus
                    ? _value.registrationStatus
                    : registrationStatus // ignore: cast_nullable_to_non_nullable
                        as TeamRegistrationStatus?,
            createdAt:
                freezed == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            updatedAt:
                freezed == updatedAt
                    ? _value.updatedAt
                    : updatedAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TeamModelImplCopyWith<$Res>
    implements $TeamModelCopyWith<$Res> {
  factory _$$TeamModelImplCopyWith(
    _$TeamModelImpl value,
    $Res Function(_$TeamModelImpl) then,
  ) = __$$TeamModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String tournamentId,
    String name,
    String? captainId,
    String? contactEmail,
    String? contactPhone,
    int? seed,
    String? poolId,
    @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
    TeamRegistrationStatus? registrationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TeamModelImplCopyWithImpl<$Res>
    extends _$TeamModelCopyWithImpl<$Res, _$TeamModelImpl>
    implements _$$TeamModelImplCopyWith<$Res> {
  __$$TeamModelImplCopyWithImpl(
    _$TeamModelImpl _value,
    $Res Function(_$TeamModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tournamentId = null,
    Object? name = null,
    Object? captainId = freezed,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? seed = freezed,
    Object? poolId = freezed,
    Object? registrationStatus = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$TeamModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        tournamentId:
            null == tournamentId
                ? _value.tournamentId
                : tournamentId // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        captainId:
            freezed == captainId
                ? _value.captainId
                : captainId // ignore: cast_nullable_to_non_nullable
                    as String?,
        contactEmail:
            freezed == contactEmail
                ? _value.contactEmail
                : contactEmail // ignore: cast_nullable_to_non_nullable
                    as String?,
        contactPhone:
            freezed == contactPhone
                ? _value.contactPhone
                : contactPhone // ignore: cast_nullable_to_non_nullable
                    as String?,
        seed:
            freezed == seed
                ? _value.seed
                : seed // ignore: cast_nullable_to_non_nullable
                    as int?,
        poolId:
            freezed == poolId
                ? _value.poolId
                : poolId // ignore: cast_nullable_to_non_nullable
                    as String?,
        registrationStatus:
            freezed == registrationStatus
                ? _value.registrationStatus
                : registrationStatus // ignore: cast_nullable_to_non_nullable
                    as TeamRegistrationStatus?,
        createdAt:
            freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        updatedAt:
            freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$TeamModelImpl implements _TeamModel {
  const _$TeamModelImpl({
    required this.id,
    required this.tournamentId,
    required this.name,
    this.captainId,
    this.contactEmail,
    this.contactPhone,
    this.seed,
    this.poolId,
    @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
    this.registrationStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory _$TeamModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamModelImplFromJson(json);

  @override
  final String id;
  @override
  final String tournamentId;
  @override
  final String name;
  @override
  final String? captainId;
  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final int? seed;
  @override
  final String? poolId;
  @override
  @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
  final TeamRegistrationStatus? registrationStatus;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TeamModel(id: $id, tournamentId: $tournamentId, name: $name, captainId: $captainId, contactEmail: $contactEmail, contactPhone: $contactPhone, seed: $seed, poolId: $poolId, registrationStatus: $registrationStatus, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tournamentId, tournamentId) ||
                other.tournamentId == tournamentId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.captainId, captainId) ||
                other.captainId == captainId) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.seed, seed) || other.seed == seed) &&
            (identical(other.poolId, poolId) || other.poolId == poolId) &&
            (identical(other.registrationStatus, registrationStatus) ||
                other.registrationStatus == registrationStatus) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tournamentId,
    name,
    captainId,
    contactEmail,
    contactPhone,
    seed,
    poolId,
    registrationStatus,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      __$$TeamModelImplCopyWithImpl<_$TeamModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamModelImplToJson(this);
  }
}

abstract class _TeamModel implements TeamModel {
  const factory _TeamModel({
    required final String id,
    required final String tournamentId,
    required final String name,
    final String? captainId,
    final String? contactEmail,
    final String? contactPhone,
    final int? seed,
    final String? poolId,
    @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
    final TeamRegistrationStatus? registrationStatus,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$TeamModelImpl;

  factory _TeamModel.fromJson(Map<String, dynamic> json) =
      _$TeamModelImpl.fromJson;

  @override
  String get id;
  @override
  String get tournamentId;
  @override
  String get name;
  @override
  String? get captainId;
  @override
  String? get contactEmail;
  @override
  String? get contactPhone;
  @override
  int? get seed;
  @override
  String? get poolId;
  @override
  @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
  TeamRegistrationStatus? get registrationStatus;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of TeamModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TeamModelImplCopyWith<_$TeamModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
