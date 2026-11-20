import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../widgets/church_footer.dart';
import '../widgets/church_scaffold.dart';
import '../widgets/translated_text.dart';
import '../widgets/vimeo/vimeo_embed.dart';

/// Single item representing a message from https://christembassyfarmersbranch.org/i-believe-god/
class _BelieveGodItem {
  final int id;
  final String title;
  final String description;
  final String? videoFilename; // If direct MP4
  final String? vimeoId; // If Vimeo

  const _BelieveGodItem({
    required this.id,
    required this.title,
    required this.description,
    this.videoFilename,
    this.vimeoId,
  });

  bool get isVimeo => vimeoId != null;

  String get videoUrl => isVimeo
      ? 'https://player.vimeo.com/video/$vimeoId'
      : 'https://christembassyfarmersbranch.org/i-believe-god/videos/${Uri.encodeComponent(videoFilename!)}';
}

/// Unified I Believe God Screen replicating https://christembassyfarmersbranch.org/i-believe-god/
/// Displays all 25 faith declarations and short video messages in one sequential list.
class BelieveGodScreen extends StatelessWidget {
  const BelieveGodScreen({super.key});

  static const List<_BelieveGodItem> _allItems = [
    // 1-8: Vimeo declarations
    _BelieveGodItem(
      id: 1,
      vimeoId: '1107304430',
      title: 'For I believe God.',
      description: 'He said there shall be no loss of life, It shall be unto me as he has told me',
    ),
    _BelieveGodItem(
      id: 2,
      vimeoId: '1107304616',
      title: 'God is not mad at you',
      description: 'He has forgiven all your iniquity, it is not God desire for you to be in sickness. He has healed you',
    ),
    _BelieveGodItem(
      id: 3,
      vimeoId: '1107306255',
      title: 'You have overcome the world',
      description:
          'It does not matter what comes your way, you have over the world, for you have been born again with an incorruptable seed. Greater is he that is in you than he that is in the world',
    ),
    _BelieveGodItem(
      id: 4,
      vimeoId: '1107306747',
      title: 'Greater is he that is in you than he that is in the world',
      description:
          'Be of good cheer, your sins are forgiven you, God is faithful. We have an advocate with the father. He loves you unconditionally',
    ),
    _BelieveGodItem(
      id: 5,
      vimeoId: '1110597892',
      title: 'Competence without waste',
      description:
          'You can achieve all things because the holy spirit is your efficiency, the holy spirit has made you competent.',
    ),
    _BelieveGodItem(
      id: 6,
      vimeoId: '1113402393',
      title: 'You are satisfied early',
      description: 'He is our sufficiency. The Holyghost is our sufficiency, competence without age',
    ),
    _BelieveGodItem(
      id: 7,
      vimeoId: '1116010147',
      title: 'Your Faith Grows Exceedinly',
      description:
          'Faith has attitude. What have you been saying in the last seven days, pay attention to the confession of your faith. Do you talk lack, do you talk fear. The bible says the lord is my shephard and therefore i do not lack. Faith speaks',
    ),
    _BelieveGodItem(
      id: 8,
      vimeoId: '1116010491',
      title: 'You are of God',
      description:
          'The holy spirit is your accuracy. Competence without errors, there is no error in your life. You will make no mistake, the holy ghost your efficiency, your sufficiency, your accuracy. You would archieve things early.',
    ),

    // 9-25: Direct MP4 short faith video messages
    _BelieveGodItem(
      id: 9,
      videoFilename: '01.mp4',
      title: 'Be Ready To Give An Answer',
      description:
          'Be ready to give an answer, because you are an answer to people\'s cry. The bible says when men are cast down, you shall say there is a lifting up',
    ),
    _BelieveGodItem(
      id: 10,
      videoFilename: '02.mp4',
      title: 'He Loved Them Unto The End',
      description:
          'In the midst of him being in pain, he had compassion, Your love for people should lead to conversation, Your love should produce care ',
    ),
    _BelieveGodItem(
      id: 11,
      videoFilename: '03.mp4',
      title: 'Jesus Love Was Tested',
      description:
          'Your love should not be selective, If God care for you, you should care for others. By the power of God\'s spirit you would love them unto the end.',
    ),
    _BelieveGodItem(
      id: 12,
      videoFilename: 'Video 01.mp4',
      title: 'Motivated by his word',
      description:
          'What is the lord rewarding us for. He said don\'t cry, He said he would reward you. There is a reward for your giving, He would reward you openly.',
    ),
    _BelieveGodItem(
      id: 13,
      videoFilename: 'Video 02.mp4',
      title: 'What is the lord rewarding you for',
      description:
          'Reward For Praise, Reward for your fasting, Reward from the prophet, Reward from distribution, Reward for your work',
    ),
    _BelieveGodItem(
      id: 14,
      videoFilename: 'Video 03.mp4',
      title: 'Reward for your identification for Jesus',
      description: 'Reward for your help, Reward for your good works, Reward for your service',
    ),
    _BelieveGodItem(
      id: 15,
      videoFilename: 'Boldness Episode 01.mp4',
      title: 'Walking With Boldness',
      description:
          'Don\'t be afraid, remember his said that your life have been programmed from grace to grace, from glory to glory',
    ),
    _BelieveGodItem(
      id: 16,
      videoFilename: 'Boldness Episode 02.mp4',
      title: 'The lord is bold, therefore i am bold',
      description:
          'I am bold like a lion, he said as he is so i am in this world, the lord has not given me the spirit of fear but of power, love and of a sound mind',
    ),
    _BelieveGodItem(
      id: 17,
      videoFilename: 'Now I\'m Full Episode.mp4',
      title: 'Now I Am Full',
      description:
          'I am full with the maximum load, full with capacity. We are full; number one, Now i am full, I am full of divine health, i am full of the beauty of God. I am full of strength, I am full of life!!',
    ),
    _BelieveGodItem(
      id: 18,
      videoFilename: 'Now I\'m Full Episode 02(1).mp4',
      title: 'Now I Am Rich',
      description:
          'He didn\'t say next year, you would be rich. Say i am rich, Now i reign, I am reigning now. I am reigning as a king',
    ),
    _BelieveGodItem(
      id: 19,
      videoFilename: 'Now I\'m Full Episode 03.mp4',
      title: 'I Am Spectacle',
      description:
          'I am a spectacle to the world, To angels and to men. For we are made a spectacle, A spectacle refer to a public display such as a show; the lord has made me an icon, People wants to enjoy life, they look at me!',
    ),
    _BelieveGodItem(
      id: 20,
      videoFilename: 'Episode One.mp4',
      title: 'You Must Have One Mind',
      description:
          'Have the mind of your boss. You must have one mind. Be on the same page with your spouse, With your boss, with your pastor. ',
    ),
    _BelieveGodItem(
      id: 21,
      videoFilename: 'Episode Two.mp4',
      title: 'Lift Someone Up With Your Words',
      description:
          'Let\'s someone be excited of meeting you, thrive for unity, study God\'s word to renew your mind. ',
    ),
    _BelieveGodItem(
      id: 22,
      videoFilename: 'video5879727077657156924.mp4',
      title: 'Choose that good path',
      description:
          'Our mind is made up on the decision we made years ago. we are guided and based on desicions; one word from God can change your life forever. Number 2, Choose to Serve the lord, no matter what comes your way. Number 3, Choose a good name. Number 4, Choose to hear God\'s word. Let\'s God\'s word gladens your heart',
    ),
    _BelieveGodItem(
      id: 23,
      videoFilename: 'video5879727077657156923.mp4',
      title: 'Choose the fear of the Lord',
      description:
          'Don\'t pollute what is sacred, choose the reverential fear, the fear of the lord is wisdom',
    ),
    _BelieveGodItem(
      id: 24,
      videoFilename: 'Wednesday Service Live With Pastor Mj(360P) 02(1).mp4',
      title: 'Focus on any good things',
      description:
          'There are good things inside of you, If christ be in you where would that sickness come from. Christ in you is the hope of glory. Christ is your life, in him you live, you move, you have your being',
    ),
    _BelieveGodItem(
      id: 25,
      videoFilename: 'Wednesday Service Live With Pastor Mj(360P)(1).mp4',
      title: 'Focus on yourself',
      description:
          'Blessed who have not seen but yet believe, To be broke is the state of the mind. Don\'t let your bank account define your personality',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ChurchScaffold(
      title: 'I BELIEVE GOD',
      showBackButton: true,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Header Hero Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
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
                  'I Believe God',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const TranslatedText(
                  '"For I believe God, that it shall be even as it was told me."\n— Acts 27:25',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '25 Faith Video Declarations',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),

          // Unified Video List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._allItems.map((item) => _BelieveGodCard(item: item)),
              ],
            ),
          ),

          const ChurchFooter(),
        ],
      ),
    );
  }
}

/// Card with direct in-app video playback (no artificial image overlays!)
class _BelieveGodCard extends StatefulWidget {
  final _BelieveGodItem item;

  const _BelieveGodCard({required this.item});

  @override
  State<_BelieveGodCard> createState() => _BelieveGodCardState();
}

class _BelieveGodCardState extends State<_BelieveGodCard> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _isInitialized = false;
  bool _isLoading = false;
  bool _isVimeoStarted = false;

  Future<void> _startDirectPlayback() async {
    if (_isInitialized) return;
    setState(() => _isLoading = true);

    try {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.item.videoUrl),
      );
      await _videoController!.initialize();

      if (!mounted) return;

      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: true,
        looping: false,
        aspectRatio: _videoController!.value.aspectRatio > 0
            ? _videoController!.value.aspectRatio
            : 16 / 9,
        showControls: true,
        allowFullScreen: true,
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFF8628E2),
          handleColor: const Color(0xFF8628E2),
          bufferedColor: const Color(0xFF8628E2).withValues(alpha: 0.3),
          backgroundColor: Colors.white24,
        ),
      );

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading video ${widget.item.title}: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E1E30) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1A1A2E);
    final bodyColor = isDark ? Colors.white70 : const Color(0xFF444444);

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: cardBg,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player Area
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              width: double.infinity,
              height: 220,
              color: Colors.black,
              child: widget.item.isVimeo
                  ? (_isVimeoStarted
                      ? VimeoEmbedPlayer(
                          vimeoId: widget.item.vimeoId!,
                          height: 220,
                        )
                      : InkWell(
                          onTap: () => setState(() => _isVimeoStarted = true),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Color(0xFF1E1A38), Color(0xFF0F0B1A)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8628E2).withValues(alpha: 0.85),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.star, color: Color(0xFFD4AF37), size: 12),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Faith Declaration #${widget.item.id}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8628E2).withValues(alpha: 0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF8628E2).withValues(alpha: 0.5),
                                          blurRadius: 16,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Play Faith Declaration',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                  : (_isInitialized && _chewieController != null
                      ? Chewie(controller: _chewieController!)
                      : Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Color(0xFFE31B23))
                              : InkWell(
                                  onTap: _startDirectPlayback,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 58,
                                        height: 58,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF8628E2).withValues(alpha: 0.9),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF8628E2).withValues(alpha: 0.5),
                                              blurRadius: 16,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Play Video Message',
                                        style: GoogleFonts.montserrat(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        )),
            ),
          ),

          // Message Info
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title,
                  style: GoogleFonts.montserrat(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                TranslatedText(
                  widget.item.description,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
