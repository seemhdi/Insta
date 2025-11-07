import 'package:dio/dio.dart';
import '../models/index.dart';

class InstagramService {
  final Dio _dio = Dio();
  final String baseUrl = 'https://i.instagram.com/api/v1';
  
  String? _sessionId;
  String? _userId;

  InstagramService() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  // Login with username and password
  Future<bool> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '$baseUrl/accounts/login/',
        data: {
          'username': username,
          'password': password,
          'login_attempt_count': 0,
        },
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
            'X-IG-App-ID': '567067343352427',
          },
        ),
      );

      if (response.statusCode == 200) {
        _sessionId = response.data['session_id'];
        _userId = response.data['logged_in_user']['pk'].toString();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Get user profile
  Future<User?> getUserProfile(String username) async {
    try {
      final response = await _dio.get(
        '$baseUrl/users/web_profile_info/',
        queryParameters: {'username': username},
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
          },
        ),
      );

      if (response.statusCode == 200) {
        final userData = response.data['data']['user'];
        return User(
          id: userData['pk'].toString(),
          username: userData['username'],
          fullName: userData['full_name'] ?? '',
          bio: userData['biography'],
          profileImageUrl: userData['profile_pic_url'],
          followersCount: userData['follower_count'] ?? 0,
          followingCount: userData['following_count'] ?? 0,
          postsCount: userData['media_count'] ?? 0,
          isFollowing: userData['friendship_status']['following'] ?? false,
          isPrivate: userData['is_private'] ?? false,
          website: userData['external_url'],
          createdAt: DateTime.now(),
        );
      }
      return null;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  // Get user feed
  Future<List<Post>> getFeed({String? maxId}) async {
    try {
      final params = <String, dynamic>{};
      if (maxId != null) params['max_id'] = maxId;

      final response = await _dio.get(
        '$baseUrl/feed/timeline/',
        queryParameters: params,
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
            'Cookie': 'sessionid=$_sessionId',
          },
        ),
      );

      if (response.statusCode == 200) {
        final posts = <Post>[];
        for (var item in response.data['feed_items']) {
          if (item['media_or_ad'] != null) {
            posts.add(_parsePost(item['media_or_ad']));
          }
        }
        return posts;
      }
      return [];
    } catch (e) {
      print('Get feed error: $e');
      return [];
    }
  }

  // Get user posts
  Future<List<Post>> getUserPosts(String userId, {String? maxId}) async {
    try {
      final params = <String, dynamic>{};
      if (maxId != null) params['max_id'] = maxId;

      final response = await _dio.get(
        '$baseUrl/feed/user/$userId/',
        queryParameters: params,
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
          },
        ),
      );

      if (response.statusCode == 200) {
        final posts = <Post>[];
        for (var item in response.data['items']) {
          posts.add(_parsePost(item));
        }
        return posts;
      }
      return [];
    } catch (e) {
      print('Get user posts error: $e');
      return [];
    }
  }

  // Get user stories
  Future<List<Story>> getUserStories(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/feed/user/$userId/story/',
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
            'Cookie': 'sessionid=$_sessionId',
          },
        ),
      );

      if (response.statusCode == 200) {
        final stories = <Story>[];
        for (var item in response.data['items']) {
          stories.add(_parseStory(item));
        }
        return stories;
      }
      return [];
    } catch (e) {
      print('Get stories error: $e');
      return [];
    }
  }

  // Like post
  Future<bool> likePost(String mediaId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/media/$mediaId/like/',
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
            'Cookie': 'sessionid=$_sessionId',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Like post error: $e');
      return false;
    }
  }

  // Unlike post
  Future<bool> unlikePost(String mediaId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/media/$mediaId/unlike/',
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
            'Cookie': 'sessionid=$_sessionId',
          },
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Unlike post error: $e');
      return false;
    }
  }

  // Get comments
  Future<List<Comment>> getComments(String mediaId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/media/$mediaId/comments/',
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
          },
        ),
      );

      if (response.statusCode == 200) {
        final comments = <Comment>[];
        for (var item in response.data['comments']) {
          comments.add(_parseComment(item));
        }
        return comments;
      }
      return [];
    } catch (e) {
      print('Get comments error: $e');
      return [];
    }
  }

  // Search users
  Future<List<User>> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        '$baseUrl/users/search/',
        queryParameters: {'q': query},
        options: Options(
          headers: {
            'User-Agent': 'Instagram 300.0.0.0.0 Android',
          },
        ),
      );

      if (response.statusCode == 200) {
        final users = <User>[];
        for (var item in response.data['users']) {
          users.add(User(
            id: item['pk'].toString(),
            username: item['username'],
            fullName: item['full_name'] ?? '',
            profileImageUrl: item['profile_pic_url'],
            createdAt: DateTime.now(),
          ));
        }
        return users;
      }
      return [];
    } catch (e) {
      print('Search users error: $e');
      return [];
    }
  }

  // Helper methods
  Post _parsePost(Map<String, dynamic> data) {
    final mediaUrls = <String>[];
    final mediaTypes = <String>[];

    if (data['carousel_media'] != null) {
      for (var item in data['carousel_media']) {
        if (item['image_versions2'] != null) {
          mediaUrls.add(item['image_versions2']['candidates'][0]['url']);
          mediaTypes.add('image');
        } else if (item['video_duration'] != null) {
          mediaUrls.add(item['video_versions'][0]['url']);
          mediaTypes.add('video');
        }
      }
    } else if (data['image_versions2'] != null) {
      mediaUrls.add(data['image_versions2']['candidates'][0]['url']);
      mediaTypes.add('image');
    } else if (data['video_duration'] != null) {
      mediaUrls.add(data['video_versions'][0]['url']);
      mediaTypes.add('video');
    }

    return Post(
      id: data['id'],
      author: User(
        id: data['user']['pk'].toString(),
        username: data['user']['username'],
        fullName: data['user']['full_name'] ?? '',
        profileImageUrl: data['user']['profile_pic_url'],
        createdAt: DateTime.now(),
      ),
      caption: data['caption']?['text'],
      mediaUrls: mediaUrls,
      mediaTypes: mediaTypes,
      likesCount: data['like_count'] ?? 0,
      commentsCount: data['comment_count'] ?? 0,
      isLiked: data['has_liked'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['taken_at'] * 1000),
      location: data['location']?['name'],
    );
  }

  Story _parseStory(Map<String, dynamic> data) {
    String mediaUrl = '';
    String mediaType = 'image';

    if (data['image_versions2'] != null) {
      mediaUrl = data['image_versions2']['candidates'][0]['url'];
      mediaType = 'image';
    } else if (data['video_duration'] != null) {
      mediaUrl = data['video_versions'][0]['url'];
      mediaType = 'video';
    }

    return Story(
      id: data['id'],
      author: User(
        id: data['user']['pk'].toString(),
        username: data['user']['username'],
        fullName: data['user']['full_name'] ?? '',
        profileImageUrl: data['user']['profile_pic_url'],
        createdAt: DateTime.now(),
      ),
      mediaUrl: mediaUrl,
      mediaType: mediaType,
      caption: data['caption']?['text'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['taken_at'] * 1000),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(data['expiring_at'] * 1000),
    );
  }

  Comment _parseComment(Map<String, dynamic> data) {
    return Comment(
      id: data['pk'].toString(),
      author: User(
        id: data['user']['pk'].toString(),
        username: data['user']['username'],
        fullName: data['user']['full_name'] ?? '',
        profileImageUrl: data['user']['profile_pic_url'],
        createdAt: DateTime.now(),
      ),
      text: data['text'],
      likesCount: data['comment_like_count'] ?? 0,
      isLiked: data['user_has_liked'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(data['created_at'] * 1000),
    );
  }
}
