import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_model.freezed.dart';
part 'tournament_model.g.dart';

// ignore_for_file: invalid_annotation_target

@JsonEnum()
enum TournamentSport {
  @JsonValue('volleyball')
  volleyball,
  @JsonValue('pickleball')
  pickleball,
  @JsonValue('other')
  other,
}

@JsonEnum()
enum TournamentFormat {
  @JsonValue('round_robin')
  roundRobin,
  @JsonValue('single_elimination')
  singleElimination,
  @JsonValue('double_elimination')
  doubleElimination,
  @JsonValue('swiss_system')
  swissSystem,
  @JsonValue('hybrid_pool_playoff')
  hybridPoolPlayoff,
}

@JsonEnum()
enum TournamentStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('registration_open')
  registrationOpen,
  @JsonValue('registration_closed')
  registrationClosed,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

@freezed
class TournamentModel with _$TournamentModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TournamentModel({
    required String id,
    required String name,
    String? description,
    @JsonKey(unknownEnumValue: TournamentSport.other)
    TournamentSport? sport,
    @JsonKey(unknownEnumValue: TournamentFormat.roundRobin)
    TournamentFormat? format,
    @JsonKey(unknownEnumValue: TournamentStatus.draft)
    TournamentStatus? status,
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
  }) = _TournamentModel;

  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);
}
