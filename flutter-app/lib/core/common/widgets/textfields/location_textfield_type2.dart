import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../modules/location/model/location_address.dart';
import '../../../../modules/location/controller/location_picker_controller.dart';
import '../../../../modules/location/ui/widget/search_place_suggestions.dart';

class LocationTextfieldType2 extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Function(LocationAdress) onselect;
  final bool readOnly;

  const LocationTextfieldType2({
    super.key, 
    this.readOnly = true,
    required this.label,
    required this.hint,
    this.controller,
    required this.onselect
  });

  @override
  State<LocationTextfieldType2> createState() => _LocationTextfieldType2State();
}

class _LocationTextfieldType2State extends State<LocationTextfieldType2> {
  late final TextEditingController controller;
  late final LocationPickerController locationPickerController;

  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? TextEditingController();
    locationPickerController = LocationPickerController((placeData) {
      controller.text = placeData.address ?? controller.text;
      widget.onselect(placeData);
    }, null);

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _showOverlay();
      } else {
        _removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    if (widget.controller == null) controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _showOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          width: _textFieldSize().width,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: Offset(0, _textFieldSize().height),
            showWhenUnlinked: false,
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.circular(12),
              child: SearchPlaceSuggestions(
                predictions: locationPickerController.predictions,
                onselect: (place) {
                  //controller.text = place.description;
                  _focusNode.unfocus();
                  locationPickerController.selectPrediction(place);
                  //widget.onselect(place);
                  _removeOverlay();
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Size _textFieldSize() {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            TextField(
              onTapOutside: (event) {
                Future.delayed(
                  Durations.medium3,
                  () => _focusNode.unfocus(),
                );
              },
              focusNode: _focusNode,
              controller: controller,
              onChanged: (value) => locationPickerController.onSearchChanged(value),
              decoration: InputDecoration(
                //hintText:  
                hint: Text(widget.hint.tr(), style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
                hintStyle: TextStyle(color: Colors.grey.shade500),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),

          ],
        ),
      )
    
    );
  }
}
