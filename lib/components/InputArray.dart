import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryEntryPage extends StatefulWidget {
  final String title;
  final String hintText;
  final List<String> entries;

  HistoryEntryPage({
    required this.title,
    required this.hintText,
    required this.entries,
  });

  @override
  _HistoryEntryPageState createState() => _HistoryEntryPageState();
}

class _HistoryEntryPageState extends State<HistoryEntryPage> {
  late TextEditingController entryController;

@override
void initState() {
  super.initState();
  entryController = TextEditingController();
}
  void _addEntry(String entry) {
    if (entry.isNotEmpty) {
      setState(() {
        widget.entries.add(entry);
        entryController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 16, 15, 15),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: entryController,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    filled: true,
                    fillColor: Color.fromARGB(255, 162, 224, 238),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 7, 82, 96),
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      borderSide: BorderSide(
                        color: Color.fromARGB(0, 177, 34, 34),
                      ),
                    ),
                    labelStyle: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 16, 15, 15),
                    ),
                    hintStyle: GoogleFonts.roboto(
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _addEntry(entryController.text);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: widget.entries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.entries[index]),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        widget.entries.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
