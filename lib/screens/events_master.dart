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
  late Future<List<Event>> currentEvent;
  late Future<List<Map<String, dynamic>>> futureCategories;
  int? selectedCategorieId;
  String? currentSearch;

  @override
  void initState(){
    super.initState();
    futureEvent = fetchEvents();
    futureCategories = fetchCategories();
    selectedCategorieId = null;
    currentSearch = null;
    currentEvent = futureEvent;
  }

  Future<void> filterByCategorie(int? categorieId) async {
    final List<Event> events = await futureEvent;
    final filtered = categorieId == null
        ? events
        : events.where((event) => event.categorieId == categorieId).toList();
    setState(() {
      selectedCategorieId = categorieId;
      currentEvent = Future.value(filtered);
    });
    if(currentSearch != null && currentSearch!.isNotEmpty) {
      searchedEvent(currentSearch!);
    }
  }

  Future<void> searchedEvent(String mot) async{
    final List<Event> events;
    if(selectedCategorieId != null){
      events = await currentEvent;
    }else {
      events = await futureEvent;
    }
    final filtered = events.where((event) => event.titre.toLowerCase().contains(mot.toLowerCase())).toList();
    setState(() {
      currentSearch = mot;
      currentEvent = Future.value(filtered);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureEvent = fetchEvents();
            futureCategories = fetchCategories();
            selectedCategorieId = null;
            currentSearch = null;
            currentEvent = futureEvent;
          });
        },
        child: Scaffold(
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
            future: currentEvent,
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
      ),
    );
  }
}