import 'package:flutter/material.dart';
import 'package:chaudiere_mobile/models/event.dart';
import 'package:chaudiere_mobile/screens/event_detail.dart';

class EventPreview extends StatefulWidget {
  final Event event;
  const EventPreview({required this.event, super.key});

  @override
  State<EventPreview> createState() => _EventPreviewState();
}

class _EventPreviewState extends State<EventPreview> {
  @override
  Widget build(BuildContext context) {
    final categorie = widget.event.getCategorieName();
    final dateDebut = "${widget.event.dateDebut.day.toString().padLeft(2, '0')}/${widget.event.dateDebut.month.toString().padLeft(2, '0')}/${widget.event.dateDebut.year}";
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetails(widget.event),
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
}