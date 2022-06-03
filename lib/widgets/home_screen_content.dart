import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart' as quran;

import '../models/brain.dart';
import '../models/settings.dart';

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider(read: ref.read);
});

final brainProvider = StateNotifierProvider<Brain, MainThing>((ref) {
  var vCount = ref.watch(settingsProvider).versesCount;
  var rName = ref.watch(settingsProvider).reciterName;
  var time = ref.watch(settingsProvider).time;
  return Brain(vCount: vCount, read: ref.read, reciterName: rName, time: time);
});

class HomeScreenContent extends ConsumerStatefulWidget {
  AudioPlayer player;
  HomeScreenContent({Key? key, required this.player}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _HomeScreenContentState();
}

class _HomeScreenContentState extends ConsumerState<HomeScreenContent> {
  var _isLoaded = false;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isLoaded == false) {
      await ref.read(settingsProvider.notifier).loadSettings();
      ref.read(brainProvider.notifier).updateSurahAndVerse();
      final stringSurahAndVerse =
          ref.read(brainProvider.notifier).getVersAndSurahToString();
      try {
        widget.player = await ref
            .read(brainProvider.notifier)
            .getVersesAudio(widget.player);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Couldn't load audio"),
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
      _isLoaded = true;
    }
  }

  var selectedVurse = 0;

  @override
  Widget build(BuildContext context) {
    widget.player.currentIndexStream.listen((event) {
      if (event != null) {
        setState(() {
          selectedVurse = event + 1;
        });
      }
    });
    final mainData = ref.watch(brainProvider);
    final settingsData = ref.watch(settingsProvider);
    final startingVerse = mainData.verseNumber - 1;
    return _isLoaded
        ? SafeArea(
            minimum: const EdgeInsets.all(15),
            child: ListView(children: [
              RichText(
                textAlign: settingsData.versesCount <= 20
                    ? TextAlign.center
                    : TextAlign.justify,
                text: TextSpan(
                  children: [
                    for (var i = 1; i <= settingsData.versesCount; i++) ...{
                      TextSpan(
                        recognizer: LongPressGestureRecognizer()
                          ..onLongPress = () async {
                            await widget.player.seek(null, index: i - 1);
                            setState(() {});
                          },
                        text: ' ' +
                            quran.getVerse(
                                mainData.surahNumber, startingVerse + i,
                                verseEndSymbol: false) +
                            '  ',
                        style: TextStyle(
                          fontFamily: 'PdmsSaleemQuranFont',
                          fontSize: 30,
                          color:
                              i == selectedVurse ? Colors.amber : Colors.white,
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: CircleAvatar(
                          child: Text(
                            '${(mainData.verseNumber + i) - 1}',
                            textAlign: TextAlign.center,
                            textScaleFactor: i.toString().length <= 2 ? 1 : .8,
                          ),
                          radius: 14,
                        ),
                      ),
                    }
                  ],
                ),
              ),
            ]),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
