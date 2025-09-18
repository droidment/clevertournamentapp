import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_model.freezed.dart';
part 'profile_model.g.dart';

@freezed
class ProfileModel with _$ProfileModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory ProfileModel({
    required String id,
    required String email,
    String? fullName,
    String? avatarUrl,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ProfileModel;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
}
