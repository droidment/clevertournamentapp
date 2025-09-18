// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TournamentModelImpl _$$TournamentModelImplFromJson(
  Map<String, dynamic> json,
) => _$TournamentModelImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  sport: $enumDecodeNullable(
    _$TournamentSportEnumMap,
    json['sport'],
    unknownValue: TournamentSport.other,
  ),
  format: $enumDecodeNullable(
    _$TournamentFormatEnumMap,
    json['format'],
    unknownValue: TournamentFormat.roundRobin,
  ),
  status: $enumDecodeNullable(
    _$TournamentStatusEnumMap,
    json['status'],
    unknownValue: TournamentStatus.draft,
  ),
  startDate:
      json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
  endDate:
      json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
  startTime: json['start_time'] as String?,
  endTime: json['end_time'] as String?,
  location: json['location'] as String?,
  venueAddress: json['venue_address'] as String?,
  maxTeams: (json['max_teams'] as num?)?.toInt(),
  registrationDeadline:
      json['registration_deadline'] == null
          ? null
          : DateTime.parse(json['registration_deadline'] as String),
  createdBy: json['created_by'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$TournamentModelImplToJson(
  _$TournamentModelImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'sport': _$TournamentSportEnumMap[instance.sport],
  'format': _$TournamentFormatEnumMap[instance.format],
  'status': _$TournamentStatusEnumMap[instance.status],
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'start_time': instance.startTime,
  'end_time': instance.endTime,
  'location': instance.location,
  'venue_address': instance.venueAddress,
  'max_teams': instance.maxTeams,
  'registration_deadline': instance.registrationDeadline?.toIso8601String(),
  'created_by': instance.createdBy,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

const _$TournamentSportEnumMap = {
  TournamentSport.volleyball: 'volleyball',
  TournamentSport.pickleball: 'pickleball',
  TournamentSport.other: 'other',
};

const _$TournamentFormatEnumMap = {
  TournamentFormat.roundRobin: 'round_robin',
  TournamentFormat.singleElimination: 'single_elimination',
  TournamentFormat.doubleElimination: 'double_elimination',
  TournamentFormat.swissSystem: 'swiss_system',
  TournamentFormat.hybridPoolPlayoff: 'hybrid_pool_playoff',
};

const _$TournamentStatusEnumMap = {
  TournamentStatus.draft: 'draft',
  TournamentStatus.registrationOpen: 'registration_open',
  TournamentStatus.registrationClosed: 'registration_closed',
  TournamentStatus.inProgress: 'in_progress',
  TournamentStatus.completed: 'completed',
  TournamentStatus.cancelled: 'cancelled',
};
