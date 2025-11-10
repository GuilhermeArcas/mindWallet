import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mindwallet/routes/app_routes.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => isLastPage = index == 2);
              },
              children: [
                // --- Página 1 ---
                buildPage(
                  color: Colors.white,
                  title: "MindWallet",
                  subtitle: "A mente por trás do dinheiro.",
                  image: "assets/images/mindwallet_intro.png",
                ),

                // --- Página 2 ---
                buildPage(
                  color: Colors.white,
                  title: "Defina seu foco",
                  subtitle:
                      "Qual é sua principal meta financeira?\nEx: economizar, quitar dívidas, investir.",
                  image: "assets/images/goal.png",
                ),

                // --- Página 3 ---
                buildPage(
                  color: Colors.white,
                  title: "Como você se sente ao lidar com dinheiro?",
                  subtitle:
                      "Ansioso? Controlado? Impulsivo? \nVamos te ajudar a entender melhor isso.",
                  image: "assets/images/emotions.png",
                ),
              ],
            ),

            // --- Indicador e Botões ---
            Container(
              alignment: const Alignment(0, 0.8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 3,
                    effect: const WormEffect(
                      spacing: 12,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (isLastPage) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.dashboard,
                        );
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 14,
                      ),
                    ),
                    child: Text(
                      isLastPage ? "Começar jornada" : "Próximo",
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required Color color,
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 260),
          const SizedBox(height: 40),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal[700],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
