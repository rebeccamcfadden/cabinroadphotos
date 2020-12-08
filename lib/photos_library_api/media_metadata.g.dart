// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaMetadata _$MediaMetadataFromJson(Map<String, dynamic> json) {
  return MediaMetadata(
    json['creationTime'] as String,
    json['video'] == null
      ? false
      : true,
    json['photo'] == null
        ? false
        : true,
  );
}

Map<String, dynamic> _$MediaMetadataToJson(MediaMetadata instance) =>
    <String, dynamic>{
      'creationTime': instance.creationTime,
      'video': instance.video,
      'photo': instance.photo,
    };
