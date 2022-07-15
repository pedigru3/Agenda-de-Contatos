import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/models/contact.dart';
import 'package:agenda_contatos/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions { orderAZ, orderZA }

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper.instance;
  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        centerTitle: true,
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (_) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAZ,
                child: Text("Ordenar de A a Z"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZA,
                child: Text("Ordenar de Z a A"),
              ),
            ],
            onSelected: _orderList,
          )
        ],
        backgroundColor: Colors.red,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemBuilder: itemBuilder,
        itemCount: contactList.length,
      ),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _showOptions(context, index);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: contactList[index].img != null
                          ? FileImage(File(contactList[index].img!))
                          : const AssetImage("images/user.png")
                              as ImageProvider),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contactList[index].name ?? "",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(contactList[index].email ?? ""),
                  Text(contactList[index].phone.toString())
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactPage({Contact? contact}) async {
    final recContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactPage(
          contact: contact,
        ),
      ),
    );

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.readAllContacts().then((list) {
      setState(() {
        contactList = list;
      });
    });
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (_) {
                return Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              launchUrl(
                                  Uri.parse("tel:${contactList[index].phone}"));
                            },
                            child: const Text(
                              "Ligar",
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              _showContactPage(contact: contactList[index]);
                            },
                            child: const Text(
                              "Editar",
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              helper.deleteContact(contactList[index].id!);
                              setState(() {
                                contactList.removeAt(index);
                              });
                            },
                            child: const Text(
                              "Excluir",
                              style: TextStyle(fontSize: 20, color: Colors.red),
                            )),
                      ),
                    ],
                  ),
                );
              });
        });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderAZ:
        contactList.sort((a, b) {
          return a.name!.toLowerCase().compareTo(b.name!.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        contactList.sort((a, b) {
          return b.name!.toLowerCase().compareTo(a.name!.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
