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
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      final documents = jsonResponse['documents'] as List<dynamic>;
      return documents.map((document) => _getPost(document)).toList();
    }

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
    headers['Authorization'] =
        'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IjVkMzQwZGRiYzNjNWJhY2M0Y2VlMWZiOWQxNmU5ODM3ZWM2MTYzZWIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLXNhbmRib3gyLWU3NjAxIiwiYXVkIjoiZmlyLXNhbmRib3gyLWU3NjAxIiwiYXV0aF90aW1lIjoxNjY1NzcxNzc4LCJ1c2VyX2lkIjoiY1hEeE5Hc1l6bVRvZGF0UFo5cjRTWmRxMGJ2MSIsInN1YiI6ImNYRHhOR3NZem1Ub2RhdFBaOXI0U1pkcTBidjEiLCJpYXQiOjE2NjU3NzE3NzgsImV4cCI6MTY2NTc3NTM3OCwiZW1haWwiOiJhbmRyZXMucm9qYXNAZ21haWwuY29tIiwiZW1haWxfdmVyaWZpZWQiOmZhbHNlLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7ImVtYWlsIjpbImFuZHJlcy5yb2phc0BnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.yLESBnTFp-GJZLQRhyAVpqd1LU6zFUjqSVvoUkwCxnYoO7aHEayaG22sOtgu6xgpl281HeIQSbh6ufRPYaQ0xLlpqcQ9VCR45sAeHHuDVCRSkqBWZqicYNaCZ9G53M0987oTToMeursRy1AsEFej53ZS8Cb5FoqhV_42JjjJKvNaN4x6XSUQfJoSxOcUIMzcPR5ZuW4GRSjlWuwe2eXm2lfZTuDdvjT7WZfREpoEzvHwhZGgwf0QDUMzzwEmyyLAQWDL96108XP_RYWDj0dIkeo0qF8wkLBR3L81fkNwzcVRejbMR-HzO1V8OQXrCTFY5z50IpRFJTaYq7xBaEmVkw';
    if (token != null) {
      headers['Authorization'] = 'Bearer ${token!}';
    }

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
