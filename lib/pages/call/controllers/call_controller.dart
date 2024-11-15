import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';

import '../../../lang/translation_service.dart';
import '../../details/views/details_page.dart';

class CallController extends GetxController {
  final ringPlayer = AudioPlayer();
  final Rx<AudioState> ttsState = Rx<AudioState>(AudioState.stopped);
  final flutterTts = FlutterTts();

  @override
  void onInit() {
    super.onInit();
    initRing();
    flutterTts.setCompletionHandler(() {
      ttsState.value = AudioState.stopped;
    });
  }

  void initRing() async {
    await ringPlayer.stop();
    await ringPlayer.play(AssetSource('audios/vintage_ringtone.wav'));
  }

  void onPopInvoked() {
    ringPlayer.stop();
    flutterTts.stop();
    ttsState.value = AudioState.stopped;
  }

  void initCallController() {
    log('Call Appeared');
  }

  void speak(String text) async {
    List<dynamic> languages = await flutterTts.getLanguages;
    await flutterTts.setLanguage(Messages.mapLocale());
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    ttsState.value = AudioState.playing;
  }

  onCallAccept(String description) async {
    await ringPlayer.stop();

    if (ttsState.value == AudioState.playing) {
      await flutterTts.stop();
      ttsState.value = AudioState.stopped;
    } else {
      speak(description);
    }
  }

  onCallDecline() async {
    await ringPlayer.stop();
    Get.back();
  }
}
