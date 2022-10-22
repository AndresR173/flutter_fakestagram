import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/auth_token.dart';
import '../models/post.dart';
import 'shared_preferences_keys.dart';

class FakestagramRepository {
  final SharedPreferences _sharedPreferences;

  FakestagramRepository(this._sharedPreferences);

  Future<List<Post>> getPosts() async {
    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.get(url, headers: _getHeaders());
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final documents = jsonResponse['documents'] as List<dynamic>;
      return documents.map((document) => _getPost(document)).toList();
    }

    return [];
  }

  Future<void> saveAccessToken(AuthToken token) => _sharedPreferences.setString(tokenPreferenceKey, jsonEncode(token));
  Future<AuthToken?> getAccessToken() async {
    final token = _sharedPreferences.getString(tokenPreferenceKey);
    if (token == null) return null;
    return AuthToken.fromJson(jsonDecode(token));
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
        authToken = AuthToken();
        authToken.idToken = idToken;
        authToken.refreshToken = refreshToken;
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
        'returnSecureToken': true,
      },
    );

    return true;
  }

  Future<bool> addPost(Map<String, dynamic> params) async {
    final url = Uri.parse('https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.post(url, body: params, headers: _getHeaders());

    return response.statusCode == 200;
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {};

    return headers;
  }

  Post _getPost(Map data) {
    Post post = Post(
      image: data['fields']['imageBase64']['stringValue'],
      header: data['fields']['header']['stringValue'],
      isLiked: data['fields']['isLiked']['booleanValue'],
      avatar: 'https://picsum.photos/600?image=${Random().nextInt(80)}',
    );

    return post;
  }
}
