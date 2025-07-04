import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movil_api_contact/domain/entities/contact.dart';
import 'package:movil_api_contact/presentation/providers/contact_provider.dart';

class ContactFormPage extends ConsumerStatefulWidget {
  final Contact? contact;
  const ContactFormPage({this.contact, super.key});

  @override
  ConsumerState<ContactFormPage> createState() => _ContactFormPageState();
}

class _ContactFormPageState extends ConsumerState<ContactFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _empresaCtrl;
  late final TextEditingController _numeroCtrl;
  late final TextEditingController _fotoCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.contact?.nombre ?? '');
    _empresaCtrl = TextEditingController(text: widget.contact?.empresa ?? '');
    _numeroCtrl = TextEditingController(text: widget.contact?.numero ?? '');
    _fotoCtrl = TextEditingController(text: widget.contact?.foto ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _empresaCtrl.dispose();
    _numeroCtrl.dispose();
    _fotoCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (_formKey.currentState!.validate()) {
      final newContact = Contact(
        id: widget.contact?.id ?? 0,
        nombre: _nombreCtrl.text,
        empresa: _empresaCtrl.text,
        numero: _numeroCtrl.text,
        foto: _fotoCtrl.text,
      );

      final notifier = ref.read(contactProvider.notifier);
      try {
        if (widget.contact == null) {
          await notifier.addContact(newContact);
        } else {
          await notifier.updateContact(newContact);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contacto ${widget.contact == null ? 'creado' : 'actualizado'} con éxito')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
      Navigator.pop(context);
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
    labelText: label,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.deepPurple),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text(isEditing ? "Editar Contacto" : "Nuevo Contacto"),
        backgroundColor: Colors.deepPurple,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCtrl,
                decoration: _inputDecoration('Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _empresaCtrl,
                decoration: _inputDecoration('Empresa'),
                validator: (v) => v!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _numeroCtrl,
                decoration: _inputDecoration('Número'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty || !RegExp(r'^\d{9,}$').hasMatch(v) ? 'Número inválido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fotoCtrl,
                decoration: _inputDecoration('URL de foto'),
                keyboardType: TextInputType.url,
                validator: (v) => v!.isEmpty ? null : Uri.tryParse(v)?.hasAbsolutePath != true ? 'URL inválida' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _guardar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(isEditing ? 'Actualizar' : 'Crear',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}