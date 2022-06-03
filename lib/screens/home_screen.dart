import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_app/screens/settings_screen.dart';
import 'package:quran_app/widgets/home_screen_content.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Widget? _child;
  var player = AudioPlayer();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: HomeScreenContent(player: player),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                heroTag: "btn1",
                child: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(SettingsScreenContent.routeName);
                },
              ),
              FloatingActionButton(
                heroTag: "btn2",
                child: Icon(player.playing ? Icons.pause : Icons.play_arrow),
                onPressed: () async {
                  if (player.playing) {
                    setState(() {
                      player.pause();
                    });
                  } else {
                    setState(() {
                      player.play();
                    });
                  }
                },
              ),
            ],
          )),
    );
  }
}
