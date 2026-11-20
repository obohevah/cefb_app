import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cefb_app/widgets/translated_text.dart';
import 'package:cefb_app/screens/new_here_screen.dart';
import 'package:cefb_app/screens/kids_screen.dart';
import 'package:cefb_app/screens/groups_screen.dart';

/// Ministry cards highlighting New Here, Kids, and Life Groups.
class MinistryCardsSection extends StatelessWidget {
  const MinistryCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildMinistryCard(
            context: context,
            imagePath: 'assets/images/13.jpeg',
            labelLine1: 'NEW',
            labelLine2: 'HERE',
            title: 'A PLACE YOU CAN CALL HOME',
            description:
                "If you're looking for a church home online or in-person, you'll love Christ Embassy Farmers Branch. Find out why and plan your experience here.",
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NewHereScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildMinistryCard(
            context: context,
            imagePath: 'assets/images/08.jpeg',
            labelLine1: 'LOVEWORLD',
            labelLine2: 'KIDS',
            title: 'WE LOVE OUR KIDS',
            description:
                'Your kids will love our church! At Christ Embassy Farmers Branch, the entire family can belong and love following Jesus.',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const KidsScreen()),
              );
            },
          ),
          const SizedBox(height: 24),
          _buildMinistryCard(
            context: context,
            imagePath: 'assets/images/12.jpeg',
            labelLine1: 'FIND A',
            labelLine2: 'GROUP',
            title: 'COMMUNITY FOR YOU',
            description:
                'There is a place for you in an online or in-person group. Life Groups are an easy place to belong and meet lifelong friends!',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const GroupsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMinistryCard({
    required BuildContext context,
    required String imagePath,
    required String labelLine1,
    required String labelLine2,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: 240,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 240,
                      color: const Color(0xFF8628E2),
                      child: const Center(
                        child: Icon(Icons.image, color: Colors.white30, size: 60),
                      ),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Color(0xFF8628E2), Color(0xFF5B2EC7)],
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TranslatedText(
                          labelLine1,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        TranslatedText(
                          labelLine2,
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          TranslatedText(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TranslatedText(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              color: Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
