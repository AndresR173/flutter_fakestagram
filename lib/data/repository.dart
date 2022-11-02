import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../models/unauthorized_exception.dart';
import '../models/user_account.dart';
import 'shared_preferences_keys.dart';

class FakestagramRepository {
  final SharedPreferences _sharedPreferences;
  String? _token;
  UserAccount? _account;

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

  Future<List<String>> getAllPhotos() async {
    final posts = await getPosts();
    final photos = posts.map((post) => post.imageBase64).toList();
    return photos;
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

  Future<bool> postNewEntry({required String imageBase64, required String header}) async {
    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final post = Post(
      imageBase64: imageBase64,
      header: header,
      author: _account!.email!,
    );
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'fields': {
          'author': {'stringValue': post.author},
          'header': {'stringValue': post.header},
          'imageBase64': {'stringValue': post.imageBase64},
        }
      }),
    );
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> postComment(String postId, String comment) async {
    final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post/$postId/comment');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode({
        'fields': {
          'text': {
            'stringValue': comment,
          },
          'author': {
            'stringValue': _account!.email,
          },
        },
      }),
    );

    return response.statusCode == 200;
  }

  Future<void> likePost(Post post) async {
    if (_account?.email?.isEmpty == true) return;
    if (post.likedBy?.contains(_account?.email) == true) {
      post.likedBy?.remove(_account?.email);
    } else {
      post.likedBy?.add(_account?.email ?? '');
    }
    await modifyPost(post);
  }

  Future<bool> modifyPost(Post post) async {
    final url =
        Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post/${post.id}');
    final headers = await _getHeaders();
    final likesList = post.likedBy?.map((e) => {'stringValue': e}).toList();
    final response = await http.patch(
      url,
      body: jsonEncode({
        'fields': {
          'author': {'stringValue': post.author},
          'header': {'stringValue': post.header},
          'imageBase64': {'stringValue': post.imageBase64},
          if (likesList?.isNotEmpty == true)
            'likedBy': {
              'arrayValue': {'values': likesList}
            }
        }
      }),
      headers: headers,
    );

    return response.statusCode == 200;
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
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCXo4VVDGqt0GmuklBvuYHPD3y72LVG4cg');
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
    List<String> likedByList;
    try {
      likedByList =
          (data['fields']['likedBy']['arrayValue']['values'] as List<dynamic>).map((e) => e['stringValue'] as String).toList();
    } catch (e) {
      likedByList = [];
    }
    final isLiked = likedByList.contains(_account!.email);
    Post post = Post(
      id: id,
      author: data['fields']['author']['stringValue'],
      imageBase64: data['fields']['imageBase64']['stringValue'],
      header: data['fields']['header']['stringValue'],
      avatar: 'https://picsum.photos/600?image=${Random().nextInt(80)}',
      isLiked: isLiked,
      likedBy: likedByList,
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
    final user = await getUserAccount();
    _token = token?.idToken;
    _account = user;
    return token != null;
  }

  Future<void> saveUserAccount(UserAccount userAccount) =>
      _sharedPreferences.setString(userAccountPreferenceKey, jsonEncode(userAccount));

  Future<UserAccount?> getUserAccount() async {
    final userAccountJson = _sharedPreferences.getString(userAccountPreferenceKey);
    if (userAccountJson == null) return null;
    return UserAccount.fromJson(jsonDecode(userAccountJson));
  }

  UserAccount? getAccountEmail() => _account;
}
