import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_app/constants.dart';
import 'package:quran_app/widgets/reciters_button.dart';

import '../models/settings.dart';
import '../widgets/versesButton.dart';

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider(read: ref.read);
});

class SettingsScreenContent extends ConsumerStatefulWidget {
  static const routeName = '/settings-screen';
  const SettingsScreenContent({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SettingsScreenContentState();
}

class _SettingsScreenContentState extends ConsumerState<SettingsScreenContent> {
  var _verseCountButtonValue = 5;
  var _reciter = "Alafasy_128kbps";
  var _saving = false;

  void _changeVersesCount(value) {
    _verseCountButtonValue = value;
  }

  void _changeReciter(value) {
    _reciter = value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        _saving == false
            ? IconButton(
                onPressed: () async {
                  setState(() {
                    _saving = true;
                  });
                  await ref
                      .read(settingsProvider.notifier)
                      .saveSettings(_reciter, _verseCountButtonValue);
                  setState(() {
                    _saving = false;
                  });
                },
                icon: const Icon(Icons.save))
            : const CircularProgressIndicator()
      ]),
      body: Column(
        children: [
          VersesButton(
              changeButtonValue: _changeVersesCount,
              buttonValue: _verseCountButtonValue),
          ReciterButton(
              changeButtonValue: _changeReciter, buttonValue: _reciter),
        ],
      ),
    );
  }
}
