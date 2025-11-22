import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../services/history_service.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  final String videoUrl;
  final String videoTitle;
  final String? videoHash;
  final String itemId;

  const PlayerScreen({
    super.key,
    required this.videoUrl,
    required this.videoTitle,
    this.videoHash,
    required this.itemId,
  });

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  late final WebViewController _controller;
  late final Uri _embedUri;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    Future(() {
      ref.read(historyProvider.notifier).addItem(widget.itemId);
    });

    _embedUri = _buildEmbedUrl();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://vkvideo.ru/') ||
                request.url.startsWith('https://vk.com/') ||
                request.url.contains("ok.ru")) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );

    // Solo Android: permitir autoplay
    if (_controller.platform is AndroidWebViewController) {
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller.loadRequest(_embedUri);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  // ---------------------------------------------------------
  // 🔥 convertLink() + toda la lógica de JS integrada aquí
  // ---------------------------------------------------------
  Uri _buildEmbedUrl() {
    final url = widget.videoUrl;
    final hash = widget.videoHash ?? "";

    // Caso 1: vk.com/video
    if (url.contains("vk.com/video")) {
      final parts = url.split("_");
      final oidId = parts[0].split("video")[1];
      final id = parts[1];

      return Uri.parse(
        "https://vk.com/video_ext.php?oid=$oidId&id=$id&hash=$hash",
      );
    }

    // Caso 2: ok.ru/video
    if (url.contains("ok.ru/video")) {
      final videoId = url.split("video/")[1];
      return Uri.parse("https://ok.ru/videoembed/$videoId");
    }

    // Caso 3: vkvideo.ru/video-
    if (url.contains("vkvideo.ru/video-")) {
      final parts = url.split("video-")[1].split("_");
      final oid = "-${parts[0]}";
      final id = parts[1];

      return Uri.parse(
        "https://vkvideo.ru/video_ext.php?oid=$oid&id=$id&hash=$hash",
      );
    }

    // Si no coincide nada → dejar tal cual
    return Uri.parse(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}
