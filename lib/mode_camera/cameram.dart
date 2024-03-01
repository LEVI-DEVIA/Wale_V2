import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class CameraM extends StatefulWidget {
  const CameraM({Key? key}) : super(key: key);

  @override
  State<CameraM> createState() => _CameraMState();
}

class _CameraMState extends State<CameraM> {
  late CameraController _controller;
  bool lights = false;
  bool showAudioPlayer = false;
  final double horizontalPadding = 40;
  final double verticalPadding = 25;

  @override
  void initState() {
    super.initState();
    // Initialisation du contrôleur de la caméra
    _initializeCamera();
  }

  @override
  void dispose() {
    // Libération des ressources de la caméra lors de la fermeture de la page
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    // Récupération de la liste des caméras disponibles
    final cameras = await availableCameras();
    // Initialisation du contrôleur de la première caméra de la liste
    _controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
    );

    // Attente de l'initialisation du contrôleur
    await _controller.initialize();
    // Mise à jour de l'état pour reconstruire l'interface utilisateur avec la caméra initialisée
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // menu icon
                  Image.asset(
                    'assets/menu.png',
                    height: 45,
                    color: Colors.grey[800],
                  ),

                  // account icon
                  Icon(
                    Icons.person,
                    size: 45,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                const Text("Mode Texte et Voix"),
                const SizedBox(
                  width: 20,
                ),
                LiteRollingSwitch(
                  value: true,
                  width: 120,
                  textOn: 'Vidéo',
                  textOff: 'Voix',
                  colorOff: Colors.deepOrange,
                  colorOn: Colors.blueGrey,
                  iconOn: Icons.videocam,
                  iconOff: Icons.mic,
                  animationDuration: const Duration(milliseconds: 300),
                  onChanged: (bool state) {
                    setState(() {
                      lights = state;
                    });
                  },
                  onDoubleTap: () {},
                  onSwipe: () {},
                  onTap: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text("Mode Camera"),
              ],
            ),
            Expanded(
              child: Container(
                color: lights ? Colors.blueGrey : Colors.white,
                child: lights ? _buildCameraPreview() : Container(),
              ),
            ),
            showAudioPlayer ? _buildAudioPlayer() : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildAudioPlayer() {
    return Container(
      // Customize the container's color, shape, etc.
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          // Play/pause button (visual only)
          IconButton(
            icon: Icon(
              Icons.play_arrow,
              color: Colors.blue,
            ), // Replace with appropriate icon
            onPressed: () {
              // Functionality cannot be implemented due to restrictions
            },
          ),
          // Seek bar (visual only)
          Slider(
            value: 0.0, // Replace with current playback position (if available)
            min: 0.0,
            max: 1.0, // Assuming duration is 1.0 (if available)
            onChanged: (value) {
              // Seeking functionality cannot be implemented due to restrictions
            },
          ),
          // Optional: Elapsed time and remaining time indicators (visual only)
          Text('00:00'), // Current time (if available)
          const Spacer(),
          Text('-00:00'), // Remaining time (if available)
          // Volume control (visual only)
          IconButton(
            icon: Icon(Icons.volume_up), // Replace with appropriate icon
            onPressed: () {
              // Volume adjustment functionality cannot be implemented due to restrictions
            },
          ),
        ],
      ),
    );
  }
}
