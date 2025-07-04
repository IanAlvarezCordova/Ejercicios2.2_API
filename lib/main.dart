import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_api_contact/presentation/views/contact_list_page.dart';
import 'package:movil_api_contact/presentation/views/contact_form_page.dart';
import 'package:movil_api_contact/domain/entities/contact.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contactos CRUD',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const ContactListPage(),
        '/form': (context) {
          final contact = ModalRoute.of(context)!.settings.arguments as Contact?;
          return ContactFormPage(contact: contact);
        }
      },
    );
  }
}
