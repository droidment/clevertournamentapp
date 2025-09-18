import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_model.freezed.dart';
part 'team_model.g.dart';

@JsonEnum()
enum TeamRegistrationStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('approved')
  approved,
  @JsonValue('rejected')
  rejected,
}

@freezed
class TeamModel with _$TeamModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TeamModel({
    required String id,
    required String tournamentId,
    required String name,
    String? captainId,
    String? city,
    String? state,
    String? jerseyColor,
    int? seed,
    String? poolId,
    @JsonKey(unknownEnumValue: TeamRegistrationStatus.pending)
    TeamRegistrationStatus? registrationStatus,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _TeamModel;

  factory TeamModel.fromJson(Map<String, dynamic> json) =>
      _$TeamModelFromJson(json);
}
