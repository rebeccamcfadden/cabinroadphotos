/*
 * Copyright 2019 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:cabinroadphotos2/photos_library_api/media_metadata.dart';
import 'package:cabinroadphotos2/photos_library_api/contributor_data.dart';

part 'media_item.g.dart';

@JsonSerializable(explicitToJson: true)
class MediaItem {
  MediaItem(this.id, this.description, this.productUrl, this.baseUrl, this.mediaMetadata, this.contributorInfo);

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      _$MediaItemFromJson(json);

  Map<String, dynamic> toJson() => _$MediaItemToJson(this);

  String id;
  String description;
  String productUrl;
  String baseUrl;
  MediaMetadata mediaMetadata;
  ContributorData contributorInfo;
}
