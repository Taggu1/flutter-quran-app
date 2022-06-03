import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quran/quran.dart' as quran;

import 'dart:math';

final settingsProvider =
    StateNotifierProvider<SettingsProvider, Settings>((ref) {
  return SettingsProvider(read: ref.read);
});

class MainThing {
  final int surahNumber;
  final int verseNumber;

  MainThing({
    required this.surahNumber,
    required this.verseNumber,
  });
}

class Brain extends StateNotifier<MainThing> {
  Brain(
      {required this.vCount,
      required this.read,
      required this.reciterName,
      required this.time})
      : super(MainThing(
          surahNumber: 1,
          verseNumber: 1,
        ));

  final DateTime time;
  var vCount;
  var reciterName;
  final Reader read;

  String intnumtoString(int givenNumber) {
    var stringNum = givenNumber.toString();
    switch (stringNum.length) {
      case 1:
        {
          stringNum = "00" + stringNum;
          break;
        }
      case 2:
        {
          stringNum = "0" + stringNum;
          break;
        }
      case 3:
        {
          stringNum = stringNum;
          break;
        }
    }
    return stringNum;
  }

  List<String> getVersAndSurahToString() {
    var surah = state.surahNumber;
    final verse = state.verseNumber;
    final surahString = intnumtoString(surah);
    final list = [surahString];
    for (var i = 0; i < vCount; i++) {
      list.add(intnumtoString(verse + i));
    }

    return list;
  }

  void updateSurahAndVerse() {
    final randomSurah = Random().nextInt(114) + 1;
    final int maxVerseCount = quran.getVerseCount(randomSurah);

    var randomVerse = Random().nextInt(maxVerseCount) + 1;

    if (maxVerseCount <= randomVerse + vCount) {
      randomVerse = maxVerseCount - vCount as int;
      if (randomVerse < 0) {
        randomVerse = 1;
        vCount = maxVerseCount;
        read(settingsProvider.notifier).adobtVersesCount(vCount);
      }
    }
    print([randomSurah, randomVerse, vCount, maxVerseCount]);
    read(settingsProvider.notifier).updateTime();
    state = MainThing(
      surahNumber: randomSurah,
      verseNumber: randomVerse,
    );
  }

  Future<AudioPlayer> getVersesAudio(AudioPlayer player) async {
    final stringSurahAndVerse = getVersAndSurahToString();
    try {
      await player.setAudioSource(
        ConcatenatingAudioSource(
          children: [
            for (var i = 0; i < vCount; i++)
              AudioSource.uri(Uri.parse(
                  "https://everyayah.com/data/$reciterName/${stringSurahAndVerse[0]}"
                  "${stringSurahAndVerse[1 + i]}.mp3")),
          ],
        ),
      );
    } on PlayerException catch (e) {
      throw Exception(e.message);
    }
    return player;
  }
}
