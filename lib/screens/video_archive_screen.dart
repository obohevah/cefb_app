import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/video_item.dart';
import '../services/api_service.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';
import 'live_player_screen.dart';

/// Previous Videos Screen in a 2-Column Grid with smooth Skeleton Shimmer loading
/// and zero-jump pagination.
class VideoArchiveScreen extends StatefulWidget {
  const VideoArchiveScreen({super.key});

  @override
  State<VideoArchiveScreen> createState() => _VideoArchiveScreenState();
}

class _VideoArchiveScreenState extends State<VideoArchiveScreen> {
  final List<VideoItem> _allVideos = [];
  late final ScrollController _scrollController;
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _displayedCount = 8;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadInitialVideos();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 250) {
      if (_displayedCount < _allVideos.length && !_isLoadingMore && !_isLoading) {
        _loadMore();
      }
    }
  }

  Future<void> _loadInitialVideos({bool isUserRefresh = false}) async {
    // Only show full-page loading if we have zero videos
    if (!isUserRefresh && _allVideos.isEmpty) {
      setState(() => _isLoading = true);
    }
    final fetched = await ApiService.fetchPreviousVideos(maxResults: 50);
    if (!mounted) return;
    setState(() {
      _allVideos.clear();
      _allVideos.addAll(fetched);
      _isLoading = false;
    });
  }

  void _loadMore() async {
    if (_displayedCount >= _allVideos.length || _isLoadingMore) return;
    setState(() => _isLoadingMore = true);

    // Provide a smooth skeleton shimmer effect while appending next items
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    setState(() {
      _displayedCount = (_displayedCount + 6).clamp(0, _allVideos.length);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final visibleVideos = _allVideos.take(_displayedCount).toList();
    final hasMore = _displayedCount < _allVideos.length;
    final skeletonCount = _isLoadingMore ? 4 : 0;
    final totalGridItems = visibleVideos.length + skeletonCount;

    return ChurchScaffold(
      currentIndex: 1,
      title: 'PREVIOUS MESSAGES',
      showBackButton: true,
      body: RefreshIndicator(
        color: const Color(0xFFE31B23),
        notificationPredicate: (notification) =>
            notification.depth == 0 && notification.metrics.pixels <= 0,
        onRefresh: () => _loadInitialVideos(isUserRefresh: true),
        child: CustomScrollView(
          key: const PageStorageKey('video_archive_scroll_view'),
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            // ── Header Banner ──
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8628E2), Color(0xFF352C7A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Our Previous Videos',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const TranslatedText(
                      'Watch recorded Sunday Services, Midweek Services, and Special Conferences.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),

            // ── Loading Skeleton / Content ──
            if (_isLoading && _allVideos.isEmpty)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.74,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _VideoCardSkeleton(isDark: isDark),
                    childCount: 6,
                  ),
                ),
              )
            else if (_allVideos.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Center(
                    child: TranslatedText(
                      'No recorded videos found.',
                      style: TextStyle(color: isDark ? Colors.white54 : Colors.black54),
                    ),
                  ),
                ),
              )
            else ...[
              // ── 2-Column Grid with Smooth Append ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 10),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.74,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < visibleVideos.length) {
                        final video = visibleVideos[index];
                        return _VideoGridCard(
                          key: ValueKey('video_${video.id}'),
                          video: video,
                          isDark: isDark,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LivePlayerScreen(
                                  videoId: video.id,
                                  title: _cleanTitle(video.title),
                                  isLive: false,
                                ),
                              ),
                            );
                          },
                        );
                      }
                      // Append Skeleton cards at the end of the grid when loading more
                      return _VideoCardSkeleton(
                        key: ValueKey('skeleton_$index'),
                        isDark: isDark,
                      );
                    },
                    childCount: totalGridItems,
                  ),
                ),
              ),

              // ── Load More Button (if more items available and not auto-loading) ──
              if (hasMore && !_isLoadingMore)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _loadMore,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFE31B23), width: 1.5),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.expand_more, color: Color(0xFFE31B23)),
                            SizedBox(width: 8),
                            TranslatedText(
                              'LOAD MORE VIDEOS',
                              style: TextStyle(
                                color: Color(0xFFE31B23),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],

            const SliverToBoxAdapter(
              child: ChurchFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer Skeleton Video Card for smooth seamless loading
class _VideoCardSkeleton extends StatefulWidget {
  final bool isDark;
  const _VideoCardSkeleton({super.key, required this.isDark});

  @override
  State<_VideoCardSkeleton> createState() => _VideoCardSkeletonState();
}

class _VideoCardSkeletonState extends State<_VideoCardSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final opacity = _animation.value;
        final baseColor = widget.isDark ? const Color(0xFF1E1E34) : Colors.grey.shade200;
        final highlightColor = widget.isDark ? const Color(0xFF2C2C4E) : Colors.grey.shade300;
        final shimmer = Color.lerp(baseColor, highlightColor, opacity)!;

        return Container(
          decoration: BoxDecoration(
            color: widget.isDark ? const Color(0xFF161628) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Shimmer Thumbnail Box with Play Icon
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  color: shimmer,
                  child: Center(
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow, color: Colors.white30, size: 22),
                    ),
                  ),
                ),
              ),

              // Shimmer Text Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 12,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: shimmer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            height: 12,
                            width: 80,
                            decoration: BoxDecoration(
                              color: shimmer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 10,
                        width: 60,
                        decoration: BoxDecoration(
                          color: shimmer,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _VideoGridCard extends StatelessWidget {
  final VideoItem video;
  final bool isDark;
  final VoidCallback onTap;

  const _VideoGridCard({
    super.key,
    required this.video,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail with Play Button
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (_, __) => Container(
                      color: isDark ? const Color(0xFF1E1E34) : Colors.grey.shade200,
                    ),
                    errorWidget: (c, u, e) => Container(
                      color: const Color(0xFF161626),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_outline_rounded,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.28),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE31B23),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  if (video.duration != null && video.duration!.isNotEmpty)
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          video.duration!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Title & Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _cleanTitle(video.title),
                      style: GoogleFonts.montserrat(
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          'Pastor MJ',
                          style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Decode raw HTML entities often returned by YouTube API
String _cleanTitle(String text) {
  return text
      .replaceAll('&#39;', "'")
      .replaceAll('&quot;', '"')
      .replaceAll('&amp;', '&')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&nbsp;', ' ');
}
