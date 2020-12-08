// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_media_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListMediaItemsRequest _$ListMediaItemsRequestFromJson(
    Map<String, dynamic> json) {
  return ListMediaItemsRequest(
    json['pageSize'] as int,
    json['pageToken'] as String,
  );
}

Map<String, dynamic> _$ListMediaItemsRequestToJson(
    ListMediaItemsRequest instance) =>
    <String, dynamic>{
      'pageSize': instance.pageSize,
      'pageToken': instance.pageToken,
    };
