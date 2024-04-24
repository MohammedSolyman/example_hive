import 'package:flutter/material.dart';
import 'package:my_hive/models/person.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box<Person> box;

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(PersonAdapter());
  box = await Hive.openBox<Person>('myBox');

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  TextEditingController nameCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            children: [
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: TextFormField(controller: nameCont)),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: TextFormField(controller: ageCont)),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        save(nameCont.text, int.parse(ageCont.text));
                      },
                      child: const Text("save")),
                  ElevatedButton(
                      onPressed: printData, child: const Text('print data'))
                ],
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (context, index) {
                        Person p = getByIndex(index)!;
                        return ListTile(
                          leading: IconButton(
                              onPressed: () async {
                                await deleteByIndex(index);
                              },
                              icon: const Icon(Icons.remove)),
                          title: Text(p.name),
                          subtitle: Text(p.age.toString()),
                        );
                      })),
              ElevatedButton(
                  onPressed: () async {
                    await deleteAll();
                  },
                  child: const Text("delete all"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> save(String name, int age) async {
    Person p = Person(name: name, age: age);
    await box.put(p.name, p);

    setState(() {});
  }

  Future<void> deleteAll() async {
    await box.clear();
    setState(() {});
  }

  Person? getByIndex(int index) {
    return box.getAt(index);
  }

  Future<void> deleteByIndex(int index) async {
    await box.deleteAt(index);
    setState(() {});
  }

  void printData() {
    print("---------------------------");
    print('length: ${box.length}');
    print('isEmpty: ${box.isEmpty}');
    print('isNotEmpty: ${box.isNotEmpty}');
    print('isOpen: ${box.isOpen}');
    print('values: ${box.values}');
    print('keys: ${box.keys}');
    print('name: ${box.name}');
    print('path: ${box.path}');
  }
}
