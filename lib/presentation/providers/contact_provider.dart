import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app_movil_frameworks/domain/entities/contact.dart';
import 'package:app_movil_frameworks/data/datasources/contact_api.dart';
import 'package:app_movil_frameworks/data/repositories/contact_repository_impl.dart';
import 'package:app_movil_frameworks/application/usecases/contact_usecase.dart';
import 'package:http/http.dart' as http;

final contactProvider = StateNotifierProvider<ContactNotifier, AsyncValue<List<Contact>>>((ref) {
  return ContactNotifier();
});

class ContactNotifier extends StateNotifier<AsyncValue<List<Contact>>> {
  final ContactUseCases useCases = ContactUseCases(ContactRepositoryImpl(ContactAPI()));
  List<Contact> _allContacts = []; // Almacena la lista completa
  ContactNotifier() : super(const AsyncValue.loading()) {
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    try {
      final contacts = await useCases.fetchAll();
      _allContacts = contacts; // Guarda la lista completa
      state = AsyncValue.data(contacts);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> fetchSearchedContacts(String query) async {
    try {
      if (query.isEmpty) {
        state = AsyncValue.data(_allContacts); // Vuelve a la lista completa si el query está vacío
        return;
      }
      final api = ContactAPI();
      final response = await http.get(Uri.parse('${api.baseUrl}/search?query=$query'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final searchedContacts = jsonList.map((json) => Contact.fromJson(json)).toList();
        state = AsyncValue.data(searchedContacts);
      } else {
        throw Exception('Error al buscar contactos: ${response.statusCode}');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void resetToAllContacts() {
    state = AsyncValue.data(_allContacts); // Restablece a la lista completa
  }

  Future<void> addContact(Contact contact) async {
    await useCases.create(contact);
    await fetchContacts();
  }

  Future<void> updateContact(Contact contact) async {
    await useCases.update(contact);
    await fetchContacts();
  }

  Future<void> deleteContact(int id) async {
    await useCases.delete(id);
    await fetchContacts();
  }
}