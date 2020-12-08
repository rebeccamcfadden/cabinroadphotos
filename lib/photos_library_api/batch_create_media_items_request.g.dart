// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_create_media_items_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchCreateMediaItemsRequest _$BatchCreateMediaItemsRequestFromJson(
    Map<String, dynamic> json) {
  return BatchCreateMediaItemsRequest(
    json['albumId'] as String,
    (json['newMediaItems'] as List)
        ?.map((e) =>
            e == null ? null : NewMediaItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['albumPosition'] == null
        ? null
        : AlbumPosition.fromJson(json['albumPosition'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BatchCreateMediaItemsRequestToJson(
        BatchCreateMediaItemsRequest instance) =>
    <String, dynamic>{
      'albumId': instance.albumId,
      'newMediaItems': instance.newMediaItems,
      'albumPosition': instance.albumPosition,
    };

NewMediaItem _$NewMediaItemFromJson(Map<String, dynamic> json) {
  return NewMediaItem(
    json['description'] as String,
    json['simpleMediaItem'] == null
        ? null
        : SimpleMediaItem.fromJson(
            json['simpleMediaItem'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$NewMediaItemToJson(NewMediaItem instance) =>
    <String, dynamic>{
      'description': instance.description,
      'simpleMediaItem': instance.simpleMediaItem,
    };

SimpleMediaItem _$SimpleMediaItemFromJson(Map<String, dynamic> json) {
  return SimpleMediaItem(
    json['uploadToken'] as String,
  );
}

Map<String, dynamic> _$SimpleMediaItemToJson(SimpleMediaItem instance) =>
    <String, dynamic>{
      'uploadToken': instance.uploadToken,
    };

AlbumPosition _$AlbumPositionFromJson(Map<String, dynamic> json) {
  return AlbumPosition(
    json['relativeMediaItemId'] as String,
    json['relativeEnrichmentItemId'] as String,
    _$enumDecodeNullable(_$PositionTypeEnumMap, json['position']),
  );
}

Map<String, dynamic> _$AlbumPositionToJson(AlbumPosition instance) =>
    <String, dynamic>{
      'relativeMediaItemId': instance.relativeMediaItemId,
      'relativeEnrichmentItemId': instance.relativeEnrichmentItemId,
      'position': _$PositionTypeEnumMap[instance.position],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$PositionTypeEnumMap = {
  PositionType.POSITION_TYPE_UNSPECIFIED: 'POSITION_TYPE_UNSPECIFIED',
  PositionType.FIRST_IN_ALBUM: 'FIRST_IN_ALBUM',
  PositionType.LAST_IN_ALBUM: 'LAST_IN_ALBUM',
  PositionType.AFTER_MEDIA_ITEM: 'AFTER_MEDIA_ITEM',
  PositionType.AFTER_ENRICHMENT_ITEM: 'AFTER_ENRICHMENT_ITEM',
};
