import 'package:chaudiere_mobile/utils/api_utils.dart';
import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:chaudiere_mobile/screens/event_detail.dart';
import 'package:chaudiere_mobile/utils/api_utils.dart';

class EventPreview extends StatefulWidget {
  final Event event;
  const EventPreview({required this.event, super.key});

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

class _EventPreviewState extends State<EventPreview> {
  @override
  Widget build(BuildContext context) {
    final dateDebut = "${widget.event.dateDebut.day.toString().padLeft(2, '0')}/${widget.event.dateDebut.month.toString().padLeft(2, '0')}/${widget.event.dateDebut.year}";
    return FutureBuilder<String>(
      future: fetchCategorieName(widget.event.categorieId),
      builder: (context, snapshot){
        final categorie = snapshot.data ?? '...';
        return GestureDetector(
          onTap:(){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetails(widget.event.id),
              ),
            );
          },
          child: ListTile(
            title: Text(widget.event.titre),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Catégorie : $categorie"),
                Text("Date : $dateDebut"),
              ],
            ),
          ),
        );
      }
    );
  }
}