import 'package:app_movil_frameworks/domain/entities/contact.dart';
import 'package:app_movil_frameworks/data/repositories/contact_repository_impl.dart';

class ContactUseCases {
  final ContactRepositoryImpl repository;
  ContactUseCases(this.repository);

  Future<List<Contact>> fetchAll() => repository.getContacts();
  Future<Contact> create(Contact contact) => repository.create(contact);
  Future<Contact> update(Contact contact) => repository.update(contact);
  Future<void> delete(int id) => repository.delete(id);
}
