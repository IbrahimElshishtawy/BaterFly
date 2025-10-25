import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartStorage {
  static const _key = 'cart_items';

  Future<void> saveCart(List<Map<String, dynamic>> items) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(items));
  }

  Future<List<Map<String, dynamic>>> read() async {
    final p = await SharedPreferences.getInstance();
    final s = p.getString(_key);
    if (s == null || s.isEmpty) return [];
    final List list = jsonDecode(s) as List;
    return list.cast<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<List<Map<String, dynamic>>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);
    if (data == null) return [];
    final list = jsonDecode(data) as List;
    return list.map((e) => (e as Map).cast<String, dynamic>()).toList();
  }

  Future<void> write(List<Map<String, dynamic>> items) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, jsonEncode(items));
  }

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }

  Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
