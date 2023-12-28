import 'dart:convert';

import 'package:http/http.dart' as http;

import 'auth_service.dart';

class WalletService {
  final String baseUrl = 'https://bwabank.my.id/api';

  Future<void> updatePin(String oldPin, String newPin) async {
    try {
      final String token = await AuthService().getToken();

      final res = await http.put(
        Uri.parse('$baseUrl/wallets'),
        body: {
          'previous_pin': oldPin,
          'new_pin': newPin,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(res.body);

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)['message'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> testUpdatePin(String oldPin, String newPin, String token) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/wallets'),
        body: {
          'previous_pin': oldPin,
          'new_pin': newPin,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(res.body);
      if (res.statusCode == 200) {
        return jsonDecode(res.body)['message'];
      } else {
        throw jsonDecode(res.body)['errors'];
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> testUpdatePinWrongData(String oldPin, String newPin, String token) async {
    try {
      final res = await http.put(
        Uri.parse('$baseUrl/wallets'),
        body: {
          'previous_pin': oldPin,
          'new_pin': newPin,
        },
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print(res.body);

      if (res.statusCode == 200) {
        return jsonDecode(res.body)['message'];
      }

      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
