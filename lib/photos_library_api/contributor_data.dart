import 'package:json_annotation/json_annotation.dart';
part 'contributor_data.g.dart';

@JsonSerializable()
class ContributorData {
  ContributorData(this.profilePictureBaseUrl, this.displayName);

  factory ContributorData.fromJson(Map<String, dynamic> json) =>
      _$ContributorDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContributorDataToJson(this);

  String profilePictureBaseUrl;
  String displayName;
}
