import 'dart:convert';
import 'dart:math';

import 'package:fakestagram/models/comment.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';
import '../models/post.dart';
import '../models/unauthorized_exception.dart';
import '../models/user_account.dart';
import 'shared_preferences_keys.dart';

class FakestagramRepository {
  final SharedPreferences _sharedPreferences;
  String? _token;

  FakestagramRepository(this._sharedPreferences);

  Future<List<Post>> getPosts() async {
    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );
    final List<Post> posts = [];
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final documents = jsonResponse['documents'] as List<dynamic>;
      for (Map postMap in documents) {
        final idField = postMap['name'] as String;
        final id = idField.split('/').last;
        final post = _getPost(postMap);
        final commentList = await getCommentsByPost(id);
        post.comments = commentList;
        posts.add(post);
      }
    } else if (response.statusCode == 401) {
      throw const UnauthorizedException();
    }

    return posts;
  }

  Future<List<Comment>?> getCommentsByPost(String postId) async {
    final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post/$postId/comment');
    final response = await http.get(
      url,
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      if (jsonResponse.isEmpty) return null;
      final documents = jsonResponse['documents'] as List<dynamic>;
      return documents.map((document) => _getComment(document)).toList();
    }
    return null;
  }

  Future<void> saveAccessToken(AuthToken token) => _sharedPreferences.setString(tokenPreferenceKey, jsonEncode(token));

  Future<AuthToken?> getAccessToken() async {
    final tokenJson = _sharedPreferences.getString(tokenPreferenceKey);
    if (tokenJson == null) return null;
    return AuthToken.fromJson(jsonDecode(tokenJson));
  }

  Future<void> deleteAccessToken() async {
    _token = null;
    await _sharedPreferences.remove(tokenPreferenceKey);
  }

  Future<AuthToken?> authenticate(String email, String password) async {
    AuthToken? authToken;
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCXo4VVDGqt0GmuklBvuYHPD3y72LVG4cg');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'returnSecureToken': 'true',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final String? idToken = jsonResponse['idToken'];
      final String? refreshToken = jsonResponse['refreshToken'];
      if (idToken != null && refreshToken != null) {
        authToken = AuthToken(
          idToken: idToken,
          refreshToken: refreshToken,
        );
      }
    }
    return authToken;
  }

  Future<bool> createAccount(String email, String password) async {
    final url =
        Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCXo4VVDGqt0GmuklBvuYHPD3y72LVG4cg');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'returnSecureToken': 'true',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final String? idToken = jsonResponse['idToken'];
      final String? refreshToken = jsonResponse['refreshToken'];
      if (idToken != null && refreshToken != null) {
        final authToken = AuthToken(
          idToken: idToken,
          refreshToken: refreshToken,
        );
        await saveAccessToken(authToken);
      }
      return true;
    }
    return false;
  }

  Future<bool> addPost(Map<String, dynamic> params) async {
    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.post(
      url,
      body: params,
      headers: await _getHeaders(),
    );

    return response.statusCode == 200;
  }

  Future<Map<String, String>> _getHeaders() async {
    Map<String, String> headers = {};

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    } else {
      final token = await getAccessToken();
      if (token != null) {
        _token = token.idToken;
        headers['Authorization'] = 'Bearer $_token';
      }
    }

    return headers;
  }

  Post _getPost(Map data) {
    final idField = data['name'] as String;
    final id = idField.split('/').last;
    Post post = Post(
      id: id,
      image: data['fields']['imageBase64']['stringValue'],
      header: data['fields']['header']['stringValue'],
      isLiked: data['fields']['isLiked']['booleanValue'],
      avatar: 'https://picsum.photos/600?image=${Random().nextInt(80)}',
    );

    return post;
  }

  Comment _getComment(Map data) {
    final comment = Comment(
      text: data['fields']['text']['stringValue'],
      author: data['fields']['author']['stringValue'],
    );
    return comment;
  }

  Future<bool> isUserLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  Future<void> saveUserAccount(UserAccount userAccount) =>
      _sharedPreferences.setString(userAccountPreferenceKey, jsonEncode(userAccount));

  Future<UserAccount?> getUserAccount() async {
    final userAccountJson = _sharedPreferences.getString(userAccountPreferenceKey);
    if (userAccountJson == null) return null;
    return UserAccount.fromJson(jsonDecode(userAccountJson));
  }
}
