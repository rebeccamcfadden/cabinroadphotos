import 'package:json_annotation/json_annotation.dart';
part 'media_metadata.g.dart';

@JsonSerializable()
class MediaMetadata {
  MediaMetadata(this.creationTime, this.video, this.photo);

  factory MediaMetadata.fromJson(Map<String, dynamic> json) =>
      _$MediaMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$MediaMetadataToJson(this);

  String creationTime;
  bool video;
  bool photo;
}
