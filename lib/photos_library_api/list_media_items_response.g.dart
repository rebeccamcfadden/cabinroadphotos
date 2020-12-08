// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_media_items_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListMediaItemsResponse _$ListMediaItemsResponseFromJson(
    Map<String, dynamic> json) {
  return ListMediaItemsResponse(
    (json['mediaItems'] as List)
        ?.map((e) =>
    e == null ? null : MediaItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['nextPageToken'] as String,
  );
}

Map<String, dynamic> _$ListMediaItemsResponseToJson(
    ListMediaItemsResponse instance) =>
    <String, dynamic>{
      'mediaItems': instance.mediaItems,
      'nextPageToken': instance.nextPageToken,
    };
