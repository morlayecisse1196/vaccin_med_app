import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isVoiceMessage;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.isVoiceMessage = false,
  });
}

enum MessageStatus { sending, sent, error }

class ChatController extends GetxController {
  final RxList<Message> messages = <Message>[].obs;
  final RxBool isTyping = false.obs;
  final RxBool isListening = false.obs;
  final RxBool isSpeaking = false.obs;
  final RxString recognizedText = ''.obs;

  late stt.SpeechToText _speech;
  late FlutterTts _flutterTts;
  final RxBool _speechAvailable = false.obs;

  bool get speechAvailable => _speechAvailable.value;

  @override
  void onInit() {
    super.onInit();
    _initSpeech();
    _initTts();
    _loadInitialMessages();
  }

  @override
  void onClose() {
    _speech.stop();
    _flutterTts.stop();
    super.onClose();
  }

  Future<void> _initSpeech() async {
    _speech = stt.SpeechToText();
    try {
      _speechAvailable.value = await _speech.initialize(
        onStatus: (status) {
          if (status == 'done' || status == 'notListening') {
            isListening.value = false;
          }
        },
        onError: (error) {
          isListening.value = false;
          Get.snackbar(
            'Erreur',
            'Erreur de reconnaissance vocale: ${error.errorMsg}',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );
    } catch (e) {
      _speechAvailable.value = false;
      print('Erreur d\'initialisation speech: $e');
    }
  }

  Future<void> _initTts() async {
    _flutterTts = FlutterTts();
    await _flutterTts.setLanguage('fr-FR');
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      isSpeaking.value = true;
    });

    _flutterTts.setCompletionHandler(() {
      isSpeaking.value = false;
    });

    _flutterTts.setErrorHandler((msg) {
      isSpeaking.value = false;
    });
  }

  void _loadInitialMessages() {
    // Message de bienvenue
    messages.add(
      Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text:
            'Bonjour ! 👋 Je suis votre assistant VACCI-MED. Comment puis-je vous aider aujourd\'hui ?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Ajouter le message de l'utilisateur
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    // Simuler que le bot est en train de taper
    isTyping.value = true;

    // TODO: Appel API au backend
    // POST /api/chat/send
    await Future.delayed(const Duration(seconds: 2));

    isTyping.value = false;

    // Réponse automatique simulée
    final botResponse = _generateBotResponse(text.toLowerCase());
    messages.add(
      Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: botResponse,
        isUser: false,
        timestamp: DateTime.now(),
      ),
    );
  }

  String _generateBotResponse(String userText) {
    // Réponses simulées - à remplacer par l'API backend
    if (userText.contains('rendez-vous') || userText.contains('rdv')) {
      return 'Votre prochain rendez-vous est prévu le 5 Novembre 2025 au Centre de Santé Almadies. Voulez-vous plus de détails ?';
    } else if (userText.contains('vaccination')) {
      return 'Les vaccinations recommandées pendant la grossesse incluent le vaccin contre la grippe et le Tdap. Consultez votre médecin pour un calendrier personnalisé.';
    } else if (userText.contains('alimentation') || userText.contains('manger')) {
      return 'Une alimentation équilibrée est essentielle pendant la grossesse. Privilégiez les fruits, légumes, protéines maigres et produits laitiers. Évitez les aliments crus ou non pasteurisés.';
    } else if (userText.contains('exercice') || userText.contains('sport')) {
      return 'L\'exercice modéré est généralement sûr pendant la grossesse. La marche, la natation et le yoga prénatal sont d\'excellentes options. Consultez votre médecin avant de commencer tout nouveau programme.';
    } else if (userText.contains('symptôme') || userText.contains('douleur')) {
      return 'Si vous ressentez des symptômes inhabituels ou des douleurs, je vous recommande de consulter immédiatement votre médecin. En cas d\'urgence, utilisez le bouton SOS de l\'application.';
    } else if (userText.contains('bonjour') ||
        userText.contains('salut') ||
        userText.contains('hello')) {
      return 'Bonjour ! Comment puis-je vous aider aujourd\'hui ? Vous pouvez me poser des questions sur votre grossesse, vos rendez-vous, la vaccination, ou tout autre sujet de santé.';
    } else if (userText.contains('merci')) {
      return 'Je vous en prie ! N\'hésitez pas si vous avez d\'autres questions. Je suis là pour vous aider. 😊';
    } else {
      return 'Je comprends votre question. Pour des informations plus précises et personnalisées, je vous recommande de consulter votre professionnel de santé. Puis-je vous aider avec autre chose ?';
    }
  }

  void clearChat() {
    messages.clear();
    _loadInitialMessages();
    Get.snackbar(
      'Chat réinitialisé',
      'L\'historique des messages a été effacé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // === Fonctionnalités Audio ===

  Future<void> startListening() async {
    if (!_speechAvailable.value) {
      Get.snackbar(
        'Erreur',
        'La reconnaissance vocale n\'est pas disponible',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    recognizedText.value = '';
    isListening.value = true;

    await _speech.listen(
      onResult: (result) {
        recognizedText.value = result.recognizedWords;
        if (result.finalResult) {
          sendMessage(result.recognizedWords);
          stopListening();
        }
      },
      localeId: 'fr_FR',
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stopListening() async {
    isListening.value = false;
    await _speech.stop();
  }

  Future<void> speakMessage(String text) async {
    if (isSpeaking.value) {
      await _flutterTts.stop();
      isSpeaking.value = false;
    } else {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    isSpeaking.value = false;
  }
}
