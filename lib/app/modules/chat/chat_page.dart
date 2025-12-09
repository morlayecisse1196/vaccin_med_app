import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = Get.find<ChatController>();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _textController.text;
    if (text.trim().isNotEmpty) {
      controller.sendMessage(text);
      _textController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 650;
        final double headerHeight = isSmallScreen ? 100 : 120;
        final double iconSize = isSmallScreen ? 20 : 24;
        final double avatarSize = isSmallScreen ? 32 : 40;

        return Scaffold(
          backgroundColor: AppColors.offWhite,
          body: Column(
            children: [
              // Header
              Container(
                height: headerHeight,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primary, AppColors.primary.withAlpha(230)],
                  ),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 16 : 20,
                      vertical: isSmallScreen ? 8 : 12,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: avatarSize / 2,
                          backgroundColor: AppColors.secondary,
                          child: Icon(Icons.support_agent, color: AppColors.white, size: iconSize),
                        ),
                        SizedBox(width: isSmallScreen ? 12 : 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assistant VACCI-MED',
                                style: (isSmallScreen ? AppTextStyles.h3 : AppTextStyles.h2)
                                    .copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'En ligne',
                                    style:
                                        (isSmallScreen
                                                ? AppTextStyles.bodySmall
                                                : AppTextStyles.bodyMedium)
                                            .copyWith(color: AppColors.white.withAlpha(230)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _showChatOptions,
                          icon: Icon(Icons.more_vert, color: AppColors.white, size: iconSize),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Messages List
              Expanded(
                child: Obx(
                  () => controller.messages.isEmpty
                      ? _buildEmptyState(isSmallScreen)
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                          itemCount:
                              controller.messages.length + (controller.isTyping.value ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == controller.messages.length && controller.isTyping.value) {
                              return _buildTypingIndicator(isSmallScreen);
                            }
                            final message = controller.messages[index];
                            return _buildMessageBubble(message, isSmallScreen);
                          },
                        ),
                ),
              ),

              // Quick Suggestions (visible when no messages sent)
              Obx(
                () => controller.messages.length <= 1
                    ? _buildQuickSuggestions(isSmallScreen)
                    : const SizedBox.shrink(),
              ),

              // Listening Indicator
              Obx(
                () => controller.isListening.value
                    ? _buildListeningIndicator(isSmallScreen)
                    : const SizedBox.shrink(),
              ),

              // Input Area
              _buildInputArea(isSmallScreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/empty.json',
            width: isSmallScreen ? 120 : 160,
            height: isSmallScreen ? 120 : 160,
          ),
          SizedBox(height: isSmallScreen ? 16 : 24),
          Text(
            'Aucun message',
            style: (isSmallScreen ? AppTextStyles.h3 : AppTextStyles.h2).copyWith(
              color: AppColors.textGray,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Commencez une conversation avec votre assistant',
              textAlign: TextAlign.center,
              style: (isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium).copyWith(
                color: AppColors.lightGray,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isSmallScreen) {
    final time = DateFormat('HH:mm').format(message.timestamp);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          bottom: isSmallScreen ? 8 : 12,
          left: message.isUser ? 48 : 0,
          right: message.isUser ? 0 : 48,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(message.isUser ? 16 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: (isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium).copyWith(
                color: message.isUser ? AppColors.white : AppColors.textGray,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      time,
                      style: AppTextStyles.caption.copyWith(
                        color: message.isUser
                            ? AppColors.white.withAlpha(204)
                            : AppColors.lightGray,
                      ),
                    ),
                    if (message.isUser) ...[
                      const SizedBox(width: 4),
                      Icon(
                        message.status == MessageStatus.sent
                            ? Icons.done_all
                            : message.status == MessageStatus.sending
                            ? Icons.access_time
                            : Icons.error_outline,
                        size: 14,
                        color: AppColors.white.withAlpha(204),
                      ),
                    ],
                    // Bouton audio pour les messages du bot
                    if (!message.isUser) ...[
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => controller.speakMessage(message.text),
                        child: Obx(
                          () => Icon(
                            controller.isSpeaking.value ? Icons.volume_up : Icons.volume_off,
                            size: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(bool isSmallScreen) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12, right: 48),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTypingDot(0),
            const SizedBox(width: 4),
            _buildTypingDot(1),
            const SizedBox(width: 4),
            _buildTypingDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animValue = ((value - delay).clamp(0.0, 1.0) * 2 - 1).abs();
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppColors.lightGray.withAlpha((153 * (1 - animValue)).toInt()),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        if (mounted) setState(() {});
      },
    );
  }

  Widget _buildQuickSuggestions(bool isSmallScreen) {
    final suggestions = [
      {'icon': Icons.calendar_today, 'text': 'Mes rendez-vous'},
      {'icon': Icons.vaccines, 'text': 'Vaccinations'},
      {'icon': Icons.restaurant, 'text': 'Alimentation'},
      {'icon': Icons.fitness_center, 'text': 'Exercices'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions fréquentes',
            style: (isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium).copyWith(
              color: AppColors.lightGray,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: suggestions.map((suggestion) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      onTap: () {
                        controller.sendMessage(
                          'Je voudrais des informations sur ${suggestion['text']}',
                        );
                        _scrollToBottom();
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 12 : 16,
                          vertical: isSmallScreen ? 8 : 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              suggestion['icon'] as IconData,
                              size: isSmallScreen ? 16 : 18,
                              color: AppColors.secondary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              suggestion['text'] as String,
                              style:
                                  (isSmallScreen
                                          ? AppTextStyles.bodySmall
                                          : AppTextStyles.bodyMedium)
                                      .copyWith(color: AppColors.textGray),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeningIndicator(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 12,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 4 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.danger.withAlpha(26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.mic, color: AppColors.danger, size: isSmallScreen ? 20 : 24),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Écoute en cours...',
                  style: (isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium)
                      .copyWith(color: AppColors.danger, fontWeight: FontWeight.w600),
                ),
                Obx(
                  () => controller.recognizedText.value.isNotEmpty
                      ? Text(
                          controller.recognizedText.value,
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textGray),
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          _buildWaveAnimation(),
        ],
      ),
    );
  }

  Widget _buildWaveAnimation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          builder: (context, value, child) {
            final delay = index * 0.2;
            final animValue = ((value - delay).clamp(0.0, 1.0) * 2 - 1).abs();
            return Container(
              width: 4,
              height: 16 + (8 * (1 - animValue)),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: AppColors.danger,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          },
          onEnd: () {
            if (mounted && controller.isListening.value) setState(() {});
          },
        );
      }),
    );
  }

  Widget _buildInputArea(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Bouton microphone
            Obx(
              () => Material(
                color: controller.isListening.value ? AppColors.danger : AppColors.lightGray,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: () {
                    if (controller.isListening.value) {
                      controller.stopListening();
                    } else {
                      controller.startListening();
                    }
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: isSmallScreen ? 42 : 48,
                    height: isSmallScreen ? 42 : 48,
                    alignment: Alignment.center,
                    child: Icon(
                      controller.isListening.value ? Icons.mic : Icons.mic_none,
                      color: controller.isListening.value ? AppColors.white : AppColors.textGray,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                  style: isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Écrivez votre message...',
                    hintStyle: (isSmallScreen ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium)
                        .copyWith(color: AppColors.lightGray),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 14 : 18,
                      vertical: isSmallScreen ? 10 : 12,
                    ),
                    prefixIcon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppColors.lightGray,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Material(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
              child: InkWell(
                onTap: _sendMessage,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: isSmallScreen ? 42 : 48,
                  height: isSmallScreen ? 42 : 48,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.send_rounded,
                    color: AppColors.white,
                    size: isSmallScreen ? 20 : 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.lightGray.withAlpha(77),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.danger),
                title: const Text('Effacer l\'historique'),
                onTap: () {
                  Get.back();
                  controller.clearChat();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: AppColors.secondary),
                title: const Text('À propos de l\'assistant'),
                onTap: () {
                  Get.back();
                  _showAboutDialog();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.support_agent, color: AppColors.secondary),
            SizedBox(width: 12),
            Text('Assistant VACCI-MED'),
          ],
        ),
        content: Text(
          'Votre assistant virtuel est là pour répondre à vos questions sur la grossesse, '
          'la santé maternelle et infantile, les vaccinations, et bien plus encore.\n\n'
          'Pour des urgences médicales, utilisez le bouton SOS ou contactez directement '
          'votre professionnel de santé.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [TextButton(onPressed: () => Get.back(), child: const Text('Fermer'))],
      ),
    );
  }
}
