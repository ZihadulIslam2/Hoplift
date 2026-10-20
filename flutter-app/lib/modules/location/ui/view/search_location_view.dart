
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/textfields/search_textfield.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/controller/location_picker_controller.dart';

import '../../model/place_prediction.dart';


class SearchLocationView extends StatefulWidget {
  final String? initialAddress;
  final void Function(LocationAdress address) onSelect;
  final String hint;

  const SearchLocationView({
    super.key,
    this.initialAddress,
    required this.onSelect,
    required this.hint,
  });

  @override
  State<SearchLocationView> createState() => _SearchLocationViewState();
}

class _SearchLocationViewState extends State<SearchLocationView> {
  final textEditingcontroller = TextEditingController();
  late final LocationPickerController locationPickerController;
  final searchFieldfocusNode = FocusNode();

  @override
  void initState() {
    locationPickerController =
        LocationPickerController(widget.onSelect, null);
    textEditingcontroller.text = widget.initialAddress ?? '';
    super.initState();
  }

  @override
  dispose(){
    textEditingcontroller.dispose();
    searchFieldfocusNode.dispose();
    locationPickerController.dispose();
    super.dispose();
  }

  _onSelectPrediction(PlacePrediction prediction) {
    locationPickerController.selectPrediction(prediction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            spacing: 4,
            children: [
              SearchTextfield(
                textEditingcontroller: textEditingcontroller,
                focused: true,
                hint: widget.hint,
                prefix: BackButton(),
                onSearchChanged: (text) {
                  locationPickerController.onSearchChanged(text);
                },
              ),
              Obx(() {
                final predictions = locationPickerController.predictions;
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (predictions.isNotEmpty) ...[
                        //const Divider(height: 1, color: Colors.grey),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: predictions.length,
                          itemBuilder: (ctx, i) {
                            final p = predictions[i];
                            return ListTile(
                              leading: const Icon(Icons.location_on),
                              title: Text(p.description),
                              trailing: Icon(Icons.arrow_outward_sharp),
                              onTap: () {
                                textEditingcontroller.text = p.description;
                                setState(() {
                                  
                                });
                                _onSelectPrediction(p);
                              }
                            );
                          },
                        ),
                      ]
                    ],
                  ),
                );
              }),
            
            ],
          ),
        ),
      ),
    );
  }
}
