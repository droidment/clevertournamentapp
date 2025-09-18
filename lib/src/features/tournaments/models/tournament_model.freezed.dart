// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tournament_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) {
  return _TournamentModel.fromJson(json);
}

/// @nodoc
mixin _$TournamentModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TournamentSport.other)
  TournamentSport? get sport => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
  TournamentFormat? get format => throw _privateConstructorUsedError;
  @JsonKey(unknownEnumValue: TournamentStatus.draft)
  TournamentStatus? get status => throw _privateConstructorUsedError;
  DateTime? get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get startTime => throw _privateConstructorUsedError;
  String? get endTime => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  String? get venueAddress => throw _privateConstructorUsedError;
  int? get maxTeams => throw _privateConstructorUsedError;
  DateTime? get registrationDeadline => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this TournamentModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TournamentModelCopyWith<TournamentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TournamentModelCopyWith<$Res> {
  factory $TournamentModelCopyWith(
    TournamentModel value,
    $Res Function(TournamentModel) then,
  ) = _$TournamentModelCopyWithImpl<$Res, TournamentModel>;
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(unknownEnumValue: TournamentSport.other) TournamentSport? sport,
    @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
    TournamentFormat? format,
    @JsonKey(unknownEnumValue: TournamentStatus.draft) TournamentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? location,
    String? venueAddress,
    int? maxTeams,
    DateTime? registrationDeadline,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$TournamentModelCopyWithImpl<$Res, $Val extends TournamentModel>
    implements $TournamentModelCopyWith<$Res> {
  _$TournamentModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? sport = freezed,
    Object? format = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? location = freezed,
    Object? venueAddress = freezed,
    Object? maxTeams = freezed,
    Object? registrationDeadline = freezed,
    Object? createdBy = freezed,
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
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            description:
                freezed == description
                    ? _value.description
                    : description // ignore: cast_nullable_to_non_nullable
                        as String?,
            sport:
                freezed == sport
                    ? _value.sport
                    : sport // ignore: cast_nullable_to_non_nullable
                        as TournamentSport?,
            format:
                freezed == format
                    ? _value.format
                    : format // ignore: cast_nullable_to_non_nullable
                        as TournamentFormat?,
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as TournamentStatus?,
            startDate:
                freezed == startDate
                    ? _value.startDate
                    : startDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            endDate:
                freezed == endDate
                    ? _value.endDate
                    : endDate // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            startTime:
                freezed == startTime
                    ? _value.startTime
                    : startTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            endTime:
                freezed == endTime
                    ? _value.endTime
                    : endTime // ignore: cast_nullable_to_non_nullable
                        as String?,
            location:
                freezed == location
                    ? _value.location
                    : location // ignore: cast_nullable_to_non_nullable
                        as String?,
            venueAddress:
                freezed == venueAddress
                    ? _value.venueAddress
                    : venueAddress // ignore: cast_nullable_to_non_nullable
                        as String?,
            maxTeams:
                freezed == maxTeams
                    ? _value.maxTeams
                    : maxTeams // ignore: cast_nullable_to_non_nullable
                        as int?,
            registrationDeadline:
                freezed == registrationDeadline
                    ? _value.registrationDeadline
                    : registrationDeadline // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
            createdBy:
                freezed == createdBy
                    ? _value.createdBy
                    : createdBy // ignore: cast_nullable_to_non_nullable
                        as String?,
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
abstract class _$$TournamentModelImplCopyWith<$Res>
    implements $TournamentModelCopyWith<$Res> {
  factory _$$TournamentModelImplCopyWith(
    _$TournamentModelImpl value,
    $Res Function(_$TournamentModelImpl) then,
  ) = __$$TournamentModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String? description,
    @JsonKey(unknownEnumValue: TournamentSport.other) TournamentSport? sport,
    @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
    TournamentFormat? format,
    @JsonKey(unknownEnumValue: TournamentStatus.draft) TournamentStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    String? startTime,
    String? endTime,
    String? location,
    String? venueAddress,
    int? maxTeams,
    DateTime? registrationDeadline,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$TournamentModelImplCopyWithImpl<$Res>
    extends _$TournamentModelCopyWithImpl<$Res, _$TournamentModelImpl>
    implements _$$TournamentModelImplCopyWith<$Res> {
  __$$TournamentModelImplCopyWithImpl(
    _$TournamentModelImpl _value,
    $Res Function(_$TournamentModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? sport = freezed,
    Object? format = freezed,
    Object? status = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? location = freezed,
    Object? venueAddress = freezed,
    Object? maxTeams = freezed,
    Object? registrationDeadline = freezed,
    Object? createdBy = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$TournamentModelImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        description:
            freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                    as String?,
        sport:
            freezed == sport
                ? _value.sport
                : sport // ignore: cast_nullable_to_non_nullable
                    as TournamentSport?,
        format:
            freezed == format
                ? _value.format
                : format // ignore: cast_nullable_to_non_nullable
                    as TournamentFormat?,
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as TournamentStatus?,
        startDate:
            freezed == startDate
                ? _value.startDate
                : startDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        endDate:
            freezed == endDate
                ? _value.endDate
                : endDate // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        startTime:
            freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        endTime:
            freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                    as String?,
        location:
            freezed == location
                ? _value.location
                : location // ignore: cast_nullable_to_non_nullable
                    as String?,
        venueAddress:
            freezed == venueAddress
                ? _value.venueAddress
                : venueAddress // ignore: cast_nullable_to_non_nullable
                    as String?,
        maxTeams:
            freezed == maxTeams
                ? _value.maxTeams
                : maxTeams // ignore: cast_nullable_to_non_nullable
                    as int?,
        registrationDeadline:
            freezed == registrationDeadline
                ? _value.registrationDeadline
                : registrationDeadline // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
        createdBy:
            freezed == createdBy
                ? _value.createdBy
                : createdBy // ignore: cast_nullable_to_non_nullable
                    as String?,
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
class _$TournamentModelImpl implements _TournamentModel {
  const _$TournamentModelImpl({
    required this.id,
    required this.name,
    this.description,
    @JsonKey(unknownEnumValue: TournamentSport.other) this.sport,
    @JsonKey(unknownEnumValue: TournamentFormat.roundRobin) this.format,
    @JsonKey(unknownEnumValue: TournamentStatus.draft) this.status,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.venueAddress,
    this.maxTeams,
    this.registrationDeadline,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  factory _$TournamentModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TournamentModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  @JsonKey(unknownEnumValue: TournamentSport.other)
  final TournamentSport? sport;
  @override
  @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
  final TournamentFormat? format;
  @override
  @JsonKey(unknownEnumValue: TournamentStatus.draft)
  final TournamentStatus? status;
  @override
  final DateTime? startDate;
  @override
  final DateTime? endDate;
  @override
  final String? startTime;
  @override
  final String? endTime;
  @override
  final String? location;
  @override
  final String? venueAddress;
  @override
  final int? maxTeams;
  @override
  final DateTime? registrationDeadline;
  @override
  final String? createdBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'TournamentModel(id: $id, name: $name, description: $description, sport: $sport, format: $format, status: $status, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, location: $location, venueAddress: $venueAddress, maxTeams: $maxTeams, registrationDeadline: $registrationDeadline, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TournamentModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.sport, sport) || other.sport == sport) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.venueAddress, venueAddress) ||
                other.venueAddress == venueAddress) &&
            (identical(other.maxTeams, maxTeams) ||
                other.maxTeams == maxTeams) &&
            (identical(other.registrationDeadline, registrationDeadline) ||
                other.registrationDeadline == registrationDeadline) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
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
    name,
    description,
    sport,
    format,
    status,
    startDate,
    endDate,
    startTime,
    endTime,
    location,
    venueAddress,
    maxTeams,
    registrationDeadline,
    createdBy,
    createdAt,
    updatedAt,
  );

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TournamentModelImplCopyWith<_$TournamentModelImpl> get copyWith =>
      __$$TournamentModelImplCopyWithImpl<_$TournamentModelImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TournamentModelImplToJson(this);
  }
}

abstract class _TournamentModel implements TournamentModel {
  const factory _TournamentModel({
    required final String id,
    required final String name,
    final String? description,
    @JsonKey(unknownEnumValue: TournamentSport.other)
    final TournamentSport? sport,
    @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
    final TournamentFormat? format,
    @JsonKey(unknownEnumValue: TournamentStatus.draft)
    final TournamentStatus? status,
    final DateTime? startDate,
    final DateTime? endDate,
    final String? startTime,
    final String? endTime,
    final String? location,
    final String? venueAddress,
    final int? maxTeams,
    final DateTime? registrationDeadline,
    final String? createdBy,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) = _$TournamentModelImpl;

  factory _TournamentModel.fromJson(Map<String, dynamic> json) =
      _$TournamentModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(unknownEnumValue: TournamentSport.other)
  TournamentSport? get sport;
  @override
  @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
  TournamentFormat? get format;
  @override
  @JsonKey(unknownEnumValue: TournamentStatus.draft)
  TournamentStatus? get status;
  @override
  DateTime? get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get startTime;
  @override
  String? get endTime;
  @override
  String? get location;
  @override
  String? get venueAddress;
  @override
  int? get maxTeams;
  @override
  DateTime? get registrationDeadline;
  @override
  String? get createdBy;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of TournamentModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TournamentModelImplCopyWith<_$TournamentModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
