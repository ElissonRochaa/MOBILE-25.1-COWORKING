import 'dart:convert';

class JwtDecoder {
  static Map<String, dynamic> decode(String token) {
    List<String> parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Token JWT inválido');
    }
    String payload = parts[1];
    String decoded = _base64UrlDecode(payload);
    return json.decode(decoded);
  }

  static String _base64UrlDecode(String base64Url) {
    String base64 = base64Url.replaceAll('-', '+').replaceAll('_', '/');

    
    int padding = base64.length % 4;
    if (padding > 0) {
      base64 += '=' * (4 - padding);
    }

    return utf8.decode(base64Decode(base64));
  }
}
