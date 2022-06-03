import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ReciterButton extends StatefulWidget {
  final Function changeButtonValue;
  String buttonValue;
  ReciterButton(
      {Key? key, required this.changeButtonValue, required this.buttonValue})
      : super(key: key);

  @override
  State<ReciterButton> createState() => _ReciterButtonState();
}

class _ReciterButtonState extends State<ReciterButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Reciter",
            style: GoogleFonts.getFont("Cairo"),
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        DropdownButton(
          value: widget.buttonValue,
          items: const [
            DropdownMenuItem(
              child: Text("Al Afasy"),
              value: "Alafasy_128kbps",
            ),
            DropdownMenuItem(
              child: Text("Al Husary"),
              value: "Husary_128kbps",
            ),
            DropdownMenuItem(
              child: Text("Al Menshawi"),
              value: "Minshawy_Mujawwad_64kbps",
            ),
            DropdownMenuItem(
              child: Text("Abu Bakr Ash Shaatree"),
              value: "Abu_Bakr_Ash-Shaatree_128kbps",
            ),
            DropdownMenuItem(
              child: Text("Basfar Walk"),
              value: "MultiLanguage/Basfar_Walk_192kbps",
            ),
          ],
          onChanged: (value) {
            setState(() {
              widget.changeButtonValue(value);
              widget.buttonValue = value as String;
            });
          },
        )
      ],
    );
  }
}
