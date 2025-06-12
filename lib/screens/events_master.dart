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
  String sortCriteria = '';
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

  List<Event> sortEvents(List<Event> events, List<Map<String, dynamic>>? categories) {
    switch (sortCriteria){
      case 'date_asc':
        events.sort((a, b) => a.dateDebut.compareTo(b.dateDebut));
        break;
      case 'date_desc':
        events.sort((a, b) => b.dateDebut.compareTo(a.dateDebut));
        break;
      case 'titre':
        events.sort((a, b) => a.titre.toLowerCase().compareTo(b.titre.toLowerCase()));
        break;
      case 'categorie':
        if (categories != null) {
          Map<int, String> catMap = {
            for (var cat in categories) cat['id'] as int: cat['libelle'] as String
          };
          events.sort((a, b) {
            final catA = catMap[a.categorieId] ?? '';
            final catB = catMap[b.categorieId] ?? '';
            return catA.toLowerCase().compareTo(catB.toLowerCase());
          });
        }
        break;
      default:
    }
    return events;
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
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: futureCategories,
                  builder: (context, catSnapshot) {
                    final sortedEvents = sortEvents(
                      List<Event>.from(events),
                      catSnapshot.data,
                    );
                    return ListView.builder(
                      itemCount: sortedEvents.length,
                      itemBuilder: (context, index) {
                        return EventPreview(event: sortedEvents[index]);
                      },
                    );
                  }
                );

              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              return const CircularProgressIndicator();
            },
          ),
        ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sort),
        onPressed: () async {
          final selected = await showModalBottomSheet<String>(
            context: context,
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.arrow_upward),
                  title: const Text('Date croissante'),
                  onTap: () => Navigator.pop(context, 'date_asc'),
                ),
                ListTile(
                  leading: const Icon(Icons.arrow_downward),
                  title: const Text('Date décroissante'),
                  onTap: () => Navigator.pop(context, 'date_desc'),
                ),
                ListTile(
                  leading: const Icon(Icons.sort_by_alpha),
                  title: const Text('Titre (A-Z)'),
                  onTap: () => Navigator.pop(context, 'titre'),
                ),
                ListTile(
                  leading: const Icon(Icons.category),
                  title: const Text('Catégorie (A-Z)'),
                  onTap: () => Navigator.pop(context, 'categorie'),
                ),
              ],
            ),
          );
          if (selected != null) {
            setState(() {
              sortCriteria = selected;
            });
          }
        },
      ),
    );
  }
}