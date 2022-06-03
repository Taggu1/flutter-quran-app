import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class VersesButton extends StatefulWidget {
  final Function changeButtonValue;
  int buttonValue;
  VersesButton(
      {Key? key, required this.changeButtonValue, required this.buttonValue})
      : super(key: key);

  @override
  State<VersesButton> createState() => _VersesButtonState();
}

class _VersesButtonState extends State<VersesButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Number of verses",
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
              child: Text("5"),
              value: 5,
            ),
            DropdownMenuItem(
              child: Text("10"),
              value: 10,
            ),
            DropdownMenuItem(
              child: Text("15"),
              value: 15,
            ),
          ],
          onChanged: (value) {
            setState(() {
              widget.changeButtonValue(value);
              widget.buttonValue = value as int;
            });
          },
        )
      ],
    );
  }
}
