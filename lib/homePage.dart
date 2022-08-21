import 'package:flutter/material.dart';
import 'package:flutter_sqlite_crud/models/contact_model.dart';
import 'package:flutter_sqlite_crud/models/database/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  ContactModel _contactModel = ContactModel();
  List<ContactModel> _contactList = [];
  late final DatabaseHelper _dbHelper;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();
  }

  _refreshContactList() async {
    List<ContactModel> x = await _dbHelper.fetchContacts();
    setState(() {
      _contactList = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SQLite CRUD")),
      body: Center(
          child: Column(
        children: [
          _form(),
          Container(
            margin: const EdgeInsets.all(10.0),
            child: MaterialButton(
              onPressed: _onSubmit,
              color: Colors.blue,
              child: const Text("Submit"),
            ),
          ),
          _list(),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Container _form() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                onSaved: (value) {
                  setState(() {
                    _contactModel.name = value;
                  });
                },
                validator: (value) {
                  return value!.isEmpty ? "This field is required" : null;
                },
              ),
              TextFormField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile'),
                onSaved: (value) {
                  setState(() {
                    _contactModel.mobile = value;
                  });
                },
                validator: (value) {
                  return value!.length < 11
                      ? "Atleast 11 character is required"
                      : null;
                },
              ),
            ],
          )),
    );
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
    }
    // This will generate same value of contact list
    // _contactList.add(_contactModel);

    // To avoid duplicate value. Create new instance of this model
    // _contactList.add(ContactModel(
    //     id: null, name: _contactModel.name, mobile: _contactModel.mobile));

    if (_contactModel.id == null) {
      // insert date direct to database
      await _dbHelper.insertContact(_contactModel);
    } else {
      await _dbHelper.updateContact(_contactModel);
    }
    _refreshContactList();
    resetForm();
    print(_contactModel.name);
  }

  resetForm() {
    setState(() {
      _formKey.currentState!.reset();
      nameController.clear();
      mobileController.clear();
      _contactModel.id = null;
    });
  }

  _list() => Expanded(
        child: Card(
          margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: ListView.builder(
              itemCount: _contactList.length,
              itemBuilder: ((context, index) {
                return Column(
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.account_circle,
                        size: 40,
                      ),
                      title: Text(
                        _contactList[index].name!.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        _contactList[index].mobile!,
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        color: Colors.black,
                        onPressed: () async {
                          await _dbHelper
                              .deleteContact(_contactList[index].id!);
                          resetForm();
                          _refreshContactList();
                        },
                      ),
                      onTap: () {
                        setState(() {
                          _contactModel = _contactList[index];
                          nameController.text = _contactList[index].name!;
                          mobileController.text = _contactList[index].mobile!;
                        });
                      },
                    ),
                    const Divider(
                      height: 2.0,
                    ),
                  ],
                );
              })),
        ),
      );
}
