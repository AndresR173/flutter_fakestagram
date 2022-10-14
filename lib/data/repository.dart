import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/post.dart';

class FakestagramRepository {
  String? token;

  Future<List<Post>> getPosts() async {
    final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.get(url, headers: _getHeaders());

    return [];
  }

  Future<bool> authenticate(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCXo4VVDGqt0GmuklBvuYHPD3y72LVG4cg');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final String? idToken = jsonResponse['idToken'];
      if (idToken != null) {
        token = idToken;
      }
      return true;
    }
    return false;
  }

  Future<bool> createAccount(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCXo4VVDGqt0GmuklBvuYHPD3y72LVG4cg');
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'returnSecureToken': true,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final String? idToken = jsonResponse['idToken'];
      if (idToken != null) {
        token = idToken;
      }
      return true;
    }
    return false;
  }

  Future<bool> addPost(Map<String, dynamic> params) async {
    final url = Uri.parse(
        'https://firestore.googleapis.com/v1/projects/fir-sandbox2-e7601/databases/(default)/documents/Post');
    final response = await http.post(url, body: params, headers: _getHeaders());

    return response.statusCode == 200;
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {};
    if (token != null) {
      headers['Authorization'] = 'Bearer ${token!}';
    }

    return headers;
  }

  Post getPublication(Map data) {
    Post post = Post()
      ..image = data['fields']['imageBase64']['stringValue']
      ..header = data['fields']['header']['stringValue']
      ..isLiked = data['fields']['isLiked']['booleanValue']
      ..avatar = 'https://picsum.photos/600?image=${Random().nextInt(80)}';
    return post;
  }
}
