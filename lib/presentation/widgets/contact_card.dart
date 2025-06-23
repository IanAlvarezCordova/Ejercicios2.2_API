import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/contact.dart';
import '../providers/contact_provider.dart';

class ContactCard extends ConsumerWidget {
  final Contact contact;

  const ContactCard({required this.contact, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: const Color(0xFFF8F5FC),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(contact.foto)),
        title: Text(contact.nombre),
        subtitle: Text('${contact.empresa} - ${contact.numero}'),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            ref.read(contactProvider.notifier).deleteContact(contact.id);
          },
        ),
        onTap: () {
          Navigator.pushNamed(context, '/form', arguments: contact);
        },
      ),
    );
  }
}
