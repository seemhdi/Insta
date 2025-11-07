import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  final String id;
  final User author;
  final String text;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;
  final List<Comment>? replies;

  Comment({
    required this.id,
    required this.author,
    required this.text,
    this.likesCount = 0,
    this.isLiked = false,
    required this.createdAt,
    this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
