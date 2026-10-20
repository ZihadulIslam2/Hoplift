import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/controller/location_picker_controller.dart';

import '../../model/place_prediction.dart';

class SearchPlaceSuggestions extends StatelessWidget {
  final RxList<PlacePrediction> predictions;
  final void Function(PlacePrediction) onselect;
  const SearchPlaceSuggestions({super.key, required this.predictions, required this.onselect});

  @override
  Widget build(BuildContext context) {
    return ObxValue((newPredictions) {
        if(newPredictions.isEmpty) return Container();
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color.fromARGB(255, 244, 236, 236)),
          ),
          child:  Column(
            mainAxisSize: MainAxisSize.min,
              // shrinkWrap: true,
              // itemCount: predictions.length,
              children: predictions.indexed.map((e) {
                final p = e.$2;
                return InkWell(
                  onTap: () {
                    debugPrint("Selected place >> ${p.description}");
                    onselect(p);
                  },
                  child: ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(p.description),
                    trailing: Icon(Icons.arrow_outward_sharp),
                    
                  ),
                );
              }).toList()
            ),
          
        );
      },
      predictions
    );
  }
}