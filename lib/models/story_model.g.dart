// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) => Story(
      id: json['id'] as String,
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      mediaUrl: json['mediaUrl'] as String,
      mediaType: json['mediaType'] as String,
      caption: json['caption'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
      isViewed: json['isViewed'] as bool? ?? false,
    );

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'id': instance.id,
      'author': instance.author,
      'mediaUrl': instance.mediaUrl,
      'mediaType': instance.mediaType,
      'caption': instance.caption,
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt.toIso8601String(),
      'isViewed': instance.isViewed,
    };
