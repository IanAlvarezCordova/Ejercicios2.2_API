import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_movil_frameworks/domain/entities/contact.dart';

class ContactAPI {
  //http://10.0.2.2:3000/api/contactos celular
  //http://192.168.100.25:3000/api/contactos
  final String baseUrl = 'http://192.168.100.25:3000/api/contactos';

  Future<List<Contact>> fetchContacts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Contact.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar contactos');
    }
  }

  Future<Contact> createContact(Contact contact) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()..remove('id')),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear contacto');
    }
  }

  Future<Contact> updateContact(Contact contact) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${contact.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(contact.toJson()),
    );
    if (response.statusCode == 200) {
      return Contact.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al actualizar contacto');
    }
  }

  Future<void> deleteContact(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 204) {
      throw Exception('Error al eliminar contacto');
    }
  }
}
