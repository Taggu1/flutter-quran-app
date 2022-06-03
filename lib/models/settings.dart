import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quran_app/widgets/home_screen_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  final String reciterName;
  final int versesCount;
  final DateTime time;
  final key = "appSettings";
  final previousVerse;
  final previousSurah;

  Settings({
    required this.reciterName,
    required this.versesCount,
    required this.time,
    this.previousSurah = 0,
    this.previousVerse = 0,
  });
}

class SettingsProvider extends StateNotifier<Settings> {
  SettingsProvider({required this.read})
      : super(Settings(reciterName: "", versesCount: 10, time: DateTime.now()));
  final Reader read;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settings = prefs.getStringList(state.key);
    if (settings == null) {
      saveSettingsToDevice();
    }
    state = Settings(
        reciterName: settings![0],
        versesCount: int.parse(settings[1]),
        time: DateTime.parse(settings[2]));
  }

  Future<void> saveSettings(String reciterName, int versesCount) async {
    state = Settings(
        reciterName: reciterName,
        versesCount: versesCount,
        time: DateTime.now());
    await saveSettingsToDevice();
  }

  Future<void> saveSettingsToDevice() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(state.key, [
      state.reciterName,
      state.versesCount.toString(),
      DateTime.now().toIso8601String()
    ]);
  }

  void adobtVersesCount(int newVCount) {
    state = Settings(
        reciterName: state.reciterName,
        versesCount: newVCount,
        time: state.time);
  }

  Future<void> updateTime() async {
    state = Settings(
        reciterName: state.reciterName,
        versesCount: state.versesCount,
        time: DateTime.now());
  }
}
