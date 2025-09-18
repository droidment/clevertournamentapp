// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TeamModelImpl _$$TeamModelImplFromJson(Map<String, dynamic> json) =>
    _$TeamModelImpl(
      id: json['id'] as String,
      tournamentId: json['tournament_id'] as String,
      name: json['name'] as String,
      captainId: json['captain_id'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      jerseyColor: json['jersey_color'] as String?,
      seed: (json['seed'] as num?)?.toInt(),
      poolId: json['pool_id'] as String?,
      registrationStatus: $enumDecodeNullable(
        _$TeamRegistrationStatusEnumMap,
        json['registration_status'],
        unknownValue: TeamRegistrationStatus.pending,
      ),
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$TeamModelImplToJson(_$TeamModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tournament_id': instance.tournamentId,
      'name': instance.name,
      'captain_id': instance.captainId,
      'city': instance.city,
      'state': instance.state,
      'jersey_color': instance.jerseyColor,
      'seed': instance.seed,
      'pool_id': instance.poolId,
      'registration_status':
          _$TeamRegistrationStatusEnumMap[instance.registrationStatus],
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

const _$TeamRegistrationStatusEnumMap = {
  TeamRegistrationStatus.pending: 'pending',
  TeamRegistrationStatus.approved: 'approved',
  TeamRegistrationStatus.rejected: 'rejected',
};
