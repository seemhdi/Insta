import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'post_model.g.dart';

@JsonSerializable()
class Post {
  final String id;
  final User author;
  final String? caption;
  final List<String> mediaUrls;
  final List<String> mediaTypes; // 'image' or 'video'
  final int likesCount;
  final int commentsCount;
  final bool isLiked;
  final DateTime createdAt;
  final String? location;

  Post({
    required this.id,
    required this.author,
    this.caption,
    required this.mediaUrls,
    required this.mediaTypes,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
  Map<String, dynamic> toJson() => _$PostToJson(this);
}
