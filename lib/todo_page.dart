import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Box? contactsBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    contactsBox = Hive.box('contactsBox'); // Caja Hive para contactos
  }

  // Añadir un nuevo contacto
  void _addContact(String name, String phone, String? email) {
    final newContact = {
      'name': name,
      'phone': phone,
      'email': email ?? '',
    };
    setState(() {
      contactsBox?.add(newContact);
    });
  }

  // Eliminar contacto
  void _deleteContact(int index) {
    setState(() {
      contactsBox?.deleteAt(index);
    });
  }

  // Editar contacto
  void _editContact(int index, String name, String phone, String? email) {
    final updatedContact = {
      'name': name,
      'phone': phone,
      'email': email ?? '',
    };
    setState(() {
      contactsBox?.putAt(index, updatedContact);
    });
  }

  // Mostrar diálogo de edición
  void _showEditDialog(int index, Map<String, dynamic> contact) {
    _nameController.text = contact['name'];
    _phoneController.text = contact['phone'];
    _emailController.text = contact['email'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: _emailController,
                decoration:
                    const InputDecoration(labelText: 'Email (Opcional)'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _editContact(index, _nameController.text, _phoneController.text,
                    _emailController.text);
                Navigator.of(context).pop();
                _nameController.clear();
                _phoneController.clear();
                _emailController.clear();
              },
              child: const Text('Save'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Contact Name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _phoneController.text.isNotEmpty) {
                _addContact(_nameController.text, _phoneController.text,
                    _emailController.text);
                _nameController.clear();
                _phoneController.clear();
                _emailController.clear();
              }
            },
            child: const Text('Add Contact'),
          ),
          Expanded(
            child: contactsBox != null && contactsBox!.isNotEmpty
                ? ListView.builder(
                    itemCount: contactsBox!.length,
                    itemBuilder: (context, index) {
                      final contact = contactsBox!.getAt(index);
                      return ListTile(
                        title: Text(contact['name']),
                        subtitle: Text(
                            'Tel: ${contact['phone']}${contact['email'].isNotEmpty ? '\nEmail: ${contact['email']}' : ''}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(index, contact);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteContact(index);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('There are no contacts yet'),
                  ),
          ),
        ],
      ),
    );
  }
}
