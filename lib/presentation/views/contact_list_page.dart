import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_api_contact/domain/entities/contact.dart';
import 'package:movil_api_contact/presentation/providers/contact_provider.dart';
import 'package:movil_api_contact/presentation/widgets/contact_tile.dart';

class ContactListPage extends ConsumerStatefulWidget {
  const ContactListPage({super.key});

  @override
  ConsumerState<ContactListPage> createState() => _ContactListPageState();
}

class _ContactListPageState extends ConsumerState<ContactListPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      ref.read(contactProvider.notifier).resetToAllContacts(); // Restablece si el campo está vacío
    } else {
      ref.read(contactProvider.notifier).fetchSearchedContacts(query);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(contactProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Contacts"),
        backgroundColor: Colors.blue.shade700,
        elevation: 2,
        actions: [
          IconButton(
            onPressed: () => _performSearch(_searchController.text),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      labelText: 'Buscar contacto',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => _performSearch(value), // Busca en tiempo real
                    onSubmitted: (value) => _performSearch(value), // Busca al presionar Enter
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(contactProvider.notifier).resetToAllContacts(); // Restablece al limpiar
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text("Error: $e")),
              data: (contactos) {
                final agrupados = agruparPorInicial(contactos);
                return ListView.builder(
                  itemCount: agrupados.length,
                  itemBuilder: (context, index) {
                    final letra = agrupados.keys.elementAt(index);
                    final lista = agrupados[letra]!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.grey.shade200,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Text(letra, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black54)),
                        ),
                        ...lista.map((c) => ContactTile(contact: c)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade400,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, '/form');
        },
      ),
    );
  }

  Map<String, List<Contact>> agruparPorInicial(List<Contact> contactos) {
    final Map<String, List<Contact>> grouped = {};
    for (var c in contactos) {
      final letra = c.nombre[0].toUpperCase();
      grouped.putIfAbsent(letra, () => []).add(c);
    }
    final sorted = Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
    return sorted;
  }
}