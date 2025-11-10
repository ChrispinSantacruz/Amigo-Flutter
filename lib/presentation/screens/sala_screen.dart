import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/mishi_character.dart';
import '../widgets/action_bubble.dart';
import '../providers/mishi_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/providers.dart';
import '../../domain/entities/message.dart';
import 'chat_screen.dart';

/// Pantalla de la Sala - Chat con MishiGPT y ronroneo
class SalaScreen extends ConsumerStatefulWidget {
  const SalaScreen({super.key});

  @override
  ConsumerState<SalaScreen> createState() => _SalaScreenState();
}

class _SalaScreenState extends ConsumerState<SalaScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState.user != null) {
        ref.read(chatProvider.notifier).setUserId(authState.user!.id);
        final chatRepo = ref.read(chatRepositoryProvider);
        chatRepo.setUserInfo(authState.user!.name, authState.user!.age);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mishiState = ref.watch(mishiProvider);
    final chatState = ref.watch(chatProvider);

    // Scroll al final cuando hay nuevos mensajes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    return Column(
      children: [
        // ÁREA FIJA: MishiGPT + Burbujas de acción (SIN SCROLL)
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mishi Character (siempre visible, sin scroll)
              GestureDetector(
                onTap: () {
                  ref.read(mishiProvider.notifier).purr();
                },
                onLongPress: () {
                  ref.read(mishiProvider.notifier).purr();
                },
                child: MishiCharacter(
                  state: mishiState,
                  onTap: () {
                    ref.read(mishiProvider.notifier).purr();
                  },
                  onLongPress: () {
                    ref.read(mishiProvider.notifier).purr();
                  },
                ),
              ),
              // Burbuja de acción si existe (siempre visible)
              if (mishiState.currentActionMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ActionBubble(
                    message: mishiState.currentActionMessage!,
                  ),
                ),
            ],
          ),
        ),
        
        // ÁREA CON SCROLL: Mensajes del chat
        Expanded(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: chatState.messages.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Toca a Mishi para que ronronee 🐱\nO presiona el botón para chatear',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: chatState.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatState.messages[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _MessageBubble(message: message),
                      );
                    },
                  ),
          ),
        ),
        
        // Botón para abrir chat completo
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline, size: 20),
            label: const Text(
              'Abrir Chat Completo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B35),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Burbuja de mensaje completa para el chat
class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isFromUser
              ? const Color(0xFFFF6B35)
              : const Color(0xFFFFB6C1),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: message.isFromUser
                ? const Radius.circular(20)
                : const Radius.circular(4),
            bottomRight: message.isFromUser
                ? const Radius.circular(4)
                : const Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isFromUser) ...[
              const Text(
                '🐱',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 15,
                  color: message.isFromUser ? Colors.white : const Color(0xFF333333),
                  height: 1.4,
                ),
              ),
            ),
            if (message.isFromUser) ...[
              const SizedBox(width: 8),
              const Text(
                '👤',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

