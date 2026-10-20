import 'package:flutter/material.dart';

class CustomDistanceSlider extends StatefulWidget {
  const CustomDistanceSlider({super.key});

  @override
  State<CustomDistanceSlider> createState() => _CustomDistanceSliderState();
}

class _CustomDistanceSliderState extends State<CustomDistanceSlider> {
  double sliderValue = 0.0; // Internal value: 0–1

  // Map sliderValue (0–1) to distance in km
  double get mappedDistance {
    if (sliderValue <= 0.5) {
      return sliderValue * 4; // 0–2km
    } else {
      return 2 + (sliderValue - 0.5) * 16; // 2–10km
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text("Custom Distance Slider")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Slider
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 8,
                activeTrackColor: Colors.blue,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: const Color.fromARGB(255, 236, 13, 13),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
              ),
              child: Slider(
                value: sliderValue,
                min: 0,
                max: 1,
                onChanged: (value) {
                  setState(() => sliderValue = value);
                },
              ),
            ),

            // Mapped distance label
            Text(
              mappedDistance < 1
                  ? "${(mappedDistance * 1000).toInt()} m"
                  : "${mappedDistance.toStringAsFixed(1)} km",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}