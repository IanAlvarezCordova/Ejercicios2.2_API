import 'package:app_movil_frameworks/data/datasources/contact_api.dart';
import 'package:app_movil_frameworks/domain/entities/contact.dart';
import 'package:app_movil_frameworks/data/repositories/contact_repository_impl.dart';

class ContactRepositoryImpl {
  final ContactAPI api;
  ContactRepositoryImpl(this.api);

  Future<List<Contact>> getContacts() => api.fetchContacts();
  Future<Contact> create(Contact contact) => api.createContact(contact);
  Future<Contact> update(Contact contact) => api.updateContact(contact);
  Future<void> delete(int id) => api.deleteContact(id);
}
