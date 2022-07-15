import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.red,
        child: const Icon(Icons.save),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Column(
              children: [
                Stack(alignment: AlignmentDirectional.topCenter, children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    height: 280,
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red[200],
                          borderRadius: BorderRadius.circular(30)),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 200,
                    ),
                  ),
                  const Positioned(
                      top: 150,
                      child: SizedBox(
                        width: 200,
                        child: TextField(
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                              hintText: "Nome do Contato",
                              focusedBorder: InputBorder.none,
                              border: InputBorder.none),
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      )),
                  Positioned(
                      top: 190,
                      child: Row(
                        children: const [
                          Text(
                            'Celular:',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 120,
                            child: TextField(
                                style: TextStyle(fontSize: 18),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '11999999995')),
                          )
                        ],
                      )),
                  const CircleAvatar(
                    radius: 70,
                  ),
                ]),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.circular(18)),
                  child: const TextField(
                    decoration: InputDecoration(
                        prefixIcon: Align(
                          widthFactor: 1,
                          heightFactor: 1,
                          alignment: AlignmentDirectional.center,
                          child: Icon(Icons.email),
                        ),
                        border: InputBorder.none,
                        hintText: 'exemple@exemple.com'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
