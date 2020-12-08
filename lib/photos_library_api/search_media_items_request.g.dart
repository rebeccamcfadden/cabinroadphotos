// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_media_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchMediaItemsRequest _$SearchMediaItemsRequestFromJson(
    Map<String, dynamic> json) {
  return SearchMediaItemsRequest(
    json['albumId'] as String,
    json['pageSize'] as int,
    json['pageToken'] as String,
  );
}

Map<String, dynamic> _$SearchMediaItemsRequestToJson(
        SearchMediaItemsRequest instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'pageSize': instance.pageSize,
      'pageToken': instance.pageToken,
    };
