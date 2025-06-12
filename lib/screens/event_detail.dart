import 'package:chaudiere_mobile/utils/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class EventDetails extends StatefulWidget {
  final int eventId;
  const EventDetails(this.eventId, {super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  late Future<Event> futureEvent;

  @override
  void initState(){
    super.initState();
    futureEvent = fetchEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Détail de l\'événement')),
      body: FutureBuilder<Event>(
        future: futureEvent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur : ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final event = snapshot.data!;
            final dateDebut = "${event.dateDebut.day.toString().padLeft(2, '0')}/${event.dateDebut.month.toString().padLeft(2, '0')}/${event.dateDebut.year}";
            final dateFin = event.dateFin != null
                ? "${event.dateFin!.day.toString().padLeft(2, '0')}/${event.dateFin!.month.toString().padLeft(2, '0')}/${event.dateFin!.year}"
                : null;
            final horaire = event.horaire != null
                ? "${event.horaire!.hour.toString().padLeft(2, '0')}:${event.horaire!.minute.toString().padLeft(2, '0')}"
                : null;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.titre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  if (event.image.isNotEmpty)
                    Center(
                      child: Image.network(
                        '$url${event.image}',
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
                        height: 200,
                      ),
                    ),
                  const SizedBox(height: 12),
                  MarkdownBody(data: event.description),
                  const SizedBox(height: 12),
                  Text("Tarif : ${event.tarif.isNotEmpty ? event.tarif : 'Non renseigné'}"),
                  const SizedBox(height: 8),
                  Text("Date de début : $dateDebut"),
                  if (dateFin != null) Text("Date de fin : $dateFin"),
                  if (horaire != null) Text("Horaire : $horaire"),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: fetchCategorieName(event.categorieId),
                    builder: (context, catSnapshot) {
                      final cat = catSnapshot.data ?? '...';
                      return Text("Catégorie : $cat");
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Fermer'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Aucun événement trouvé.'));
          }
        },
      ),
    );
  }
}