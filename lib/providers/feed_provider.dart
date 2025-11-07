import 'package:flutter/material.dart';
import '../models/index.dart';
import '../services/index.dart';

class FeedProvider extends ChangeNotifier {
  final InstagramScraperService _instagramService = InstagramScraperService();

  List<Post> _posts = [];
  List<Story> _stories = [];
  bool _isLoading = false;
  String? _error;

  List<Post> get posts => _posts;
  List<Story> get stories => _stories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadFeed() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _instagramService.getFeed();
    } catch (e) {
      _error = 'Error loading feed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserPosts(String username) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _posts = await _instagramService.getUserPosts(username);
    } catch (e) {
      _error = 'Error loading user posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadUserStories(String username) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stories = await _instagramService.getUserStories(username);
    } catch (e) {
      _error = 'Error loading stories: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Comment>> loadPostComments(String postId) async {
    try {
      return await _instagramService.getPostComments(postId);
    } catch (e) {
      _error = 'Error loading comments: $e';
      return [];
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      return await _instagramService.searchUsers(query);
    } catch (e) {
      _error = 'Error searching users: $e';
      return [];
    }
  }

  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void removePost(String postId) {
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }

  void updatePost(Post post) {
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index != -1) {
      _posts[index] = post;
      notifyListeners();
    }
  }
}
