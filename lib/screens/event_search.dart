import 'package:flutter/material.dart';

class EventSearch extends StatefulWidget {
  const EventSearch({super.key});

  @override
  State<EventSearch> createState() => _EventSearchState();
}

class _EventSearchState extends State<EventSearch> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chercher un événement')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            TextFormField(
              controller: _searchController,
              validator: (value) {
                if(value == null || value.isEmpty){
                  return 'veuillez entrer un événement';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
            ),
            Center(
              child: ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    Navigator.pop(context, _searchController.text);
                  }
                },
                child: const Text('Chercher'),
              ),
            ),
            ],
          ),
        )
      ),
    );
  }
}