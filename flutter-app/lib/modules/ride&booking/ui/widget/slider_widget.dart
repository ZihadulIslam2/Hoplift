import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../view/filter_rides_view.dart';

class SliderWidget extends StatefulWidget {
  final double initialValue;
  final Function(double) onValueChange;
  const SliderWidget({
    super.key,
    required this.onValueChange,
    required this.initialValue,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double val = 0;

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.onValueChange(val);
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    val = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        activeTrackColor: AppColors.primarybutton,
        inactiveTrackColor: AppColors.progressBg,
        thumbColor: Colors.white,
        thumbShape: CustomThumbShape(),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
        tickMarkShape: SliderTickMarkShape.noTickMark,
      ),
      child: Slider(
        value: val,
        min: 0,
        max: 10,
        onChanged: (v) {
          debugPrint(v.toString());
          widget.onValueChange(v);
          setState(() {
            val = v;
          });
        },
      ),
    );
  }
}
