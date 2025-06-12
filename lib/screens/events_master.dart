import 'package:chaudiere_mobile/screens/event_preview.dart';
import 'package:chaudiere_mobile/utils/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:chaudiere_mobile/screens/event_search.dart';


class EventsMaster extends StatefulWidget {
  const EventsMaster({super.key});

  @override
  State<EventsMaster> createState() => _EventsMasterState();
}

class _EventsMasterState extends State<EventsMaster> {
  late Future<List<Event>> futureEvent;
  late Future<List<Map<String, dynamic>>> futureCategories;
  int? selectedCategorieId;

  @override
  void initState(){
    super.initState();
    futureEvent = fetchEvents();
    futureCategories = fetchCategories();
    selectedCategorieId = null;
  }

  Future<void> filterByCategorie(int? categorieId) async {
    final events = await fetchEvents();
    final filtered = categorieId == null
        ? events
        : events.where((event) => event.categorieId == categorieId).toList();
    setState(() {
      selectedCategorieId = categorieId;
      futureEvent = Future.value(filtered);
    });
  }

  Future<void> searchedEvent(String mot) async{
    final events = await futureEvent;
    final filtered = events.where((event) => event.titre.toLowerCase().contains(mot.toLowerCase())).toList();
    setState(() {
      futureEvent = Future.value(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Event'),
          actions: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: futureCategories,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<Map<String, dynamic>> categories = [
                    {'id': null, 'libelle': 'Tous les événements'}
                  ];
                  categories.addAll(snapshot.data!);
                  return DropdownButton<int?>(
                    value: selectedCategorieId,
                    underline: Container(),
                    icon: const Icon(Icons.filter_list),
                    items: categories.map((cat) {
                      return DropdownMenuItem<int?>(
                        value: cat['id'] as int?,
                        child: Text(cat['libelle'].toString()),
                      );                    
                    }).toList(),
                    onChanged: (value) {
                      filterByCategorie(value);
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async{
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EventSearch(),
                ),
              );
              if (result != null && result is String){
                searchedEvent(result);
              }
            }),
          ],
        ),
        body: Center(
          child: FutureBuilder<List<Event>>(
            future: futureEvent,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final events = snapshot.data!;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return EventPreview(event: events[index]);
                  },
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}