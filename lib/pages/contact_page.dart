import 'dart:io';

import 'package:flutter/material.dart';

import '../models/contact.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key, this.contact}) : super(key: key);

  final Contact? contact;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late Contact _editedContact;
  bool _userEdited = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromJson(widget.contact!.toJson());
    }

    _nameController.text = _editedContact.name ?? "";
    _emailController.text = _editedContact.email ?? "";
    _phoneController.text =
        _editedContact.phone == null ? "" : _editedContact.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(
            _editedContact.name ?? "Novo Contato",
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null &&
                _editedContact.name!.isNotEmpty &&
                _editedContact.phone != null) {
              Navigator.pop(context, _editedContact);
            } else {
              if (_nameController.text.isEmpty) {
                FocusScope.of(context).requestFocus(_nameFocus);
              } else {
                FocusScope.of(context).requestFocus(_phoneFocus);
              }
            }
          },
          backgroundColor: Colors.red,
          child: const Icon(Icons.save),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(children: [
            GestureDetector(
              onTap: _showOptions,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _editedContact.img != null
                            ? FileImage(File(_editedContact.img!))
                            : const AssetImage("images/user.png")
                                as ImageProvider)),
              ),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Nome"),
              controller: _nameController,
              focusNode: _nameFocus,
              onChanged: (text) {
                _userEdited = true;
                setState(() {
                  _editedContact.name = text;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Email"),
              controller: _emailController,
              onChanged: (text) {
                _userEdited = true;
                _editedContact.email = text;
              },
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _phoneController,
              focusNode: _phoneFocus,
              decoration: const InputDecoration(labelText: "Phone"),
              onChanged: (text) {
                _userEdited = true;
                _editedContact.phone = int.tryParse(text);
              },
              keyboardType: TextInputType.number,
            )
          ]),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Descartar alterações?'),
              content: const Text('Se sair as alterações serão perdidas!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Sim'),
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  void _showOptions() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (_) {
                return Container(
                  child: Row(children: [
                    IconButton(
                      onPressed: () {
                        _picker
                            .pickImage(source: ImageSource.camera)
                            .then((file) {
                          if (file == null) return;
                          _userEdited = true;
                          setState(() {
                            _editedContact.img = file.path;
                          });
                        });
                        Navigator.pop(context);
                      },
                      icon: Image.asset('images/camera.png'),
                      iconSize: 100,
                    ),
                    IconButton(
                      onPressed: () {
                        _picker
                            .pickImage(source: ImageSource.gallery)
                            .then((file) {
                          if (file == null) return;
                          _userEdited = true;
                          setState(() {
                            _editedContact.img = file.path;
                          });
                        });
                        Navigator.pop(context);
                      },
                      icon: Image.asset('images/galeira.png'),
                      iconSize: 100,
                    ),
                  ]),
                );
              });
        });
  }
}
