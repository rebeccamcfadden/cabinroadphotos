// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contributor_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContributorData _$ContributorDataFromJson(Map<String, dynamic> json) {
  return ContributorData(
    json['profilePictureBaseUrl'] as String,
    json['displayName'] as String,
  );
}

Map<String, dynamic> _$ContributorDataToJson(ContributorData instance) =>
    <String, dynamic>{
      'profilePictureBaseUrl': instance.profilePictureBaseUrl,
      'displayName': instance.displayName,
    };
