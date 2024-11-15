import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../lang/translation_service.dart';
import '../views/details_page.dart';

class DetailsController extends GetxController {
  final flutterTts = FlutterTts();
  final Rx<AudioState> ttsState = Rx<AudioState>(AudioState.stopped);

  @override
  void onInit() {
    super.onInit();
    flutterTts.setCompletionHandler(() {
      ttsState.value = AudioState.stopped;
    });
  }

  void initDetailsController() {
    log('details controller');
  }

  void onPopInvoked() {
    flutterTts.stop();
    ttsState.value = AudioState.stopped;
  }

  void onAudioButtonClick(String text) async {
    if (ttsState.value == AudioState.playing) {
      await flutterTts.stop();
      ttsState.value = AudioState.stopped;
    } else {
      speak(text);
    }
  }

  void speak(String text) async {
    List<dynamic> languages = await flutterTts.getLanguages;
    await flutterTts.setLanguage(Messages.mapLocale());
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
    ttsState.value = AudioState.playing;
  }
}
