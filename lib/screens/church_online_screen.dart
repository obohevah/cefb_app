import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';

/// Fully integrated in-app Church Online Platform (https://cefblive.online.church).
///
/// Features:
/// - Real-time countdown to upcoming Sunday and Wednesday services
/// - Live stream player with interactive public & prayer chat
/// - Sermon notes, Bible reader, and service schedule
/// - Clean in-app navigation: top back button, close button, Android system back button,
///   and CEFB bottom navigation bar all work reliably to return to the app.
class ChurchOnlineScreen extends StatefulWidget {
  const ChurchOnlineScreen({super.key});

  static const String churchOnlineUrl = 'https://cefblive.online.church';

  @override
  State<ChurchOnlineScreen> createState() => _ChurchOnlineScreenState();
}

class _ChurchOnlineScreenState extends State<ChurchOnlineScreen> {
  late final WebViewController _controller;
  int _progress = 0;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFF0C091C))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            if (mounted) {
              setState(() {
                _progress = progress;
                if (progress >= 95) _isLoading = false;
              });
            }
          },
          onPageStarted: (_) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _hasError = false;
              });
            }
          },
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _isLoading = false);
            }
          },
          onWebResourceError: (error) {
            debugPrint('ChurchOnline error: ${error.description}');
            if (error.isForMainFrame ?? false) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _errorMessage = error.description;
                  _isLoading = false;
                });
              }
            }
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    _controller.loadRequest(Uri.parse(ChurchOnlineScreen.churchOnlineUrl));
  }

  void _exitScreen() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _openInExternalBrowser() async {
    final uri = Uri.parse(ChurchOnlineScreen.churchOnlineUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _copyLinkToClipboard() {
    Clipboard.setData(const ClipboardData(text: ChurchOnlineScreen.churchOnlineUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Church Online link copied to clipboard!'),
        duration: Duration(seconds: 2),
        backgroundColor: Color(0xFF8628E2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final toolbarBg = isDark ? const Color(0xFF14142B) : const Color(0xFFF1F5F9);
    final textCol = isDark ? Colors.white : const Color(0xFF1E293B);

    return PopScope(
      canPop: true, // Guarantees Android hardware/navigation back button pops cleanly!
      child: ChurchScaffold(
        title: 'CHURCH ONLINE',
        showBackButton: true,
        showBottomNav: true,
        showFab: false,
        body: Column(
          children: [
            // Sub-Toolbar: Live status indicator, reload, copy link, and explicit Close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              color: toolbarBg,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'cefblive.online.church • Live Countdown & Chat',
                      style: GoogleFonts.montserrat(
                        color: textCol,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh, size: 18, color: textCol),
                    tooltip: 'Reload Page',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: () => _controller.reload(),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(Icons.copy, size: 16, color: textCol),
                    tooltip: 'Copy Link',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: _copyLinkToClipboard,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFFE31B23)),
                    tooltip: 'Exit to App',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    onPressed: _exitScreen,
                  ),
                ],
              ),
            ),

            // Loading Progress Bar
            if (_isLoading && _progress < 100)
              LinearProgressIndicator(
                value: _progress / 100.0,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE31B23)),
                minHeight: 2.5,
              ),

            // Main WebView or Error View
            Expanded(
              child: _hasError
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.wifi_off, color: Color(0xFFE31B23), size: 56),
                            const SizedBox(height: 16),
                            Text(
                              'Unable to load Church Online',
                              style: GoogleFonts.montserrat(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _errorMessage.isNotEmpty
                                  ? _errorMessage
                                  : 'Please check your internet connection and try again.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey, fontSize: 13),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _hasError = false;
                                  _isLoading = true;
                                });
                                _controller.loadRequest(Uri.parse(ChurchOnlineScreen.churchOnlineUrl));
                              },
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              label: const TranslatedText(
                                'Retry Loading',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8628E2),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextButton.icon(
                              onPressed: _openInExternalBrowser,
                              icon: const Icon(Icons.open_in_browser, size: 16),
                              label: const Text('Open in external browser'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : WebViewWidget(controller: _controller),
            ),
          ],
        ),
      ),
    );
  }
}
