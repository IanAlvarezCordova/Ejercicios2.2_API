import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/contact.dart';
import '../providers/contact_provider.dart';

class ContactTile extends ConsumerWidget {
  final Contact contact;
  const ContactTile({super.key, required this.contact});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avatar = contact.foto.isNotEmpty
        ? CircleAvatar(
      backgroundColor: Colors.transparent,
      child: ClipOval(
        child: Image.network(
          contact.foto,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
        ),
      ),
    )
        : CircleAvatar(
      backgroundColor: Colors.blueGrey.shade100,
      child: Text(contact.nombre[0].toUpperCase(), style: const TextStyle(color: Colors.black)),
    );

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: avatar,
      title: Text(contact.nombre, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("${contact.empresa} - ${contact.numero}"),
      trailing: IconButton(
        icon: const Icon(Icons.delete, color: Colors.redAccent),
        onPressed: () {
          ref.read(contactProvider.notifier).deleteContact(contact.id);
        },
      ),
      onTap: () {
        Navigator.pushNamed(context, '/form', arguments: contact);
      },
    );
  }
}
