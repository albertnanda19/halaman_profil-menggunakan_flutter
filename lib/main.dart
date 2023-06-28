import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const HalamanProfil());
}

class HalamanProfil extends StatefulWidget {
  const HalamanProfil({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HalamanProfilState createState() => _HalamanProfilState();
}

class _HalamanProfilState extends State<HalamanProfil>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController videoPlayerController;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    videoPlayerController =
        VideoPlayerController.asset('../assets/video/background_video.mp4');
    videoPlayerController.initialize().then((_) {
      setState(() {});
    });

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    animationController.dispose();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Halaman Profil',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: videoPlayerController.value.size.width,
                  height: videoPlayerController.value.size.height,
                  child: Chewie(
                    controller: ChewieController(
                      videoPlayerController: videoPlayerController,
                      autoInitialize: true,
                      looping: true,
                      allowedScreenSleep: false,
                      autoPlay: true,
                      showControls: false,
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return Transform.translate(
                    offset: Offset(0.0, 5.0 * (1.0 - animationController.value)),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 550),
                      child: Container(
                        width: 300,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2183f1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: const Color(0xFF0a55aa),
                            width: 5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage('../assets/img/foto_profile.jpg'),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'A.Albert Mangiri',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey[800],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Mahasiswa Unsrat',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Flexible(
                              child: SingleChildScrollView(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 18),
                                  child: const Text(
                                    'Saya seorang mahasiswa Universitas Sam Ratulangi dan sedang belajar di Unity Divisi Mobile Development',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _launchURL('https://www.facebook.com/your_facebook_page');
                                  },
                                  child: Image.asset(
                                    '../assets/img/logo_fb.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    _launchURL('https://www.instagram.com/your_instagram_page');
                                  },
                                  child: Image.asset(
                                    '../assets/img/logo_instagram.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                InkWell(
                                  onTap: () {
                                    _launchURL('https://www.github.com/your_github_page');
                                  },
                                  child: Image.asset(
                                    '../assets/img/logo_github.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
