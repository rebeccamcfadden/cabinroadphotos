// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaItem _$MediaItemFromJson(Map<String, dynamic> json) {
  // print("MediaMetadata: " + json['mediaMetadata'].toString());
  return MediaItem(
    json['id'] as String,
    json['description'] as String,
    json['productUrl'] as String,
    json['baseUrl'] as String,
    json['mediaMetadata'] == null
        ? null
        : MediaMetadata.fromJson(json['mediaMetadata'] as Map<String, dynamic>),
    json['contributorInfo'] == null
        ? null
        : ContributorData.fromJson(
            json['contributorInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MediaItemToJson(MediaItem instance) => <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'productUrl': instance.productUrl,
      'baseUrl': instance.baseUrl,
      'mediaMetadata': instance.mediaMetadata,
      'contributorInfo': instance.contributorInfo,
    };
