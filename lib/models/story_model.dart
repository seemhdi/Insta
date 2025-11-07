import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'story_model.g.dart';

@JsonSerializable()
class Story {
  final String id;
  final User author;
  final String mediaUrl;
  final String mediaType; // 'image' or 'video'
  final String? caption;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isViewed;

  Story({
    required this.id,
    required this.author,
    required this.mediaUrl,
    required this.mediaType,
    this.caption,
    required this.createdAt,
    required this.expiresAt,
    this.isViewed = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}
