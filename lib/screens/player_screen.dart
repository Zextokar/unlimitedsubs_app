// lib/screens/player_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Importa el paquete de iOS
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
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://vkvideo.ru/')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      );

    // Corrección: autoplay solo en Android
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

  Uri _buildEmbedUrl() {
    String oid = '';
    String id = '';

    final regex = RegExp(r'video(-?\d+)_(\d+)');
    final match = regex.firstMatch(widget.videoUrl);

    if (match != null && match.groupCount == 2) {
      oid = match.group(1)!;
      id = match.group(2)!;
    } else {
      return Uri.parse('about:blank');
    }

    String embedUrl =
        'https://vkvideo.ru/video_ext.php?oid=$oid&id=$id&autoplay=1';

    if (widget.videoHash != null && widget.videoHash!.isNotEmpty) {
      embedUrl += '&hash=${widget.videoHash}';
    }

    return Uri.parse(embedUrl);
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
