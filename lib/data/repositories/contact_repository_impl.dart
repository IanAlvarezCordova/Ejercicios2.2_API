import 'package:movil_api_contact/data/datasources/contact_api.dart';
import 'package:movil_api_contact/domain/entities/contact.dart';

class ContactRepositoryImpl {
  final ContactAPI api;
  ContactRepositoryImpl(this.api);

  Future<List<Contact>> getContacts() => api.fetchContacts();
  Future<Contact> create(Contact contact) => api.createContact(contact);
  Future<Contact> update(Contact contact) => api.updateContact(contact);
  Future<void> delete(int id) => api.deleteContact(id);
}
