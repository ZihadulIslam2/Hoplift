import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/modules/location/model/location_address.dart';

import '../../../../modules/location/ui/view/search_location_view.dart';

class LocationTextfield extends StatefulWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final Function(LocationAdress) onselect;
  final bool readOnly;
  const LocationTextfield({super.key, this.readOnly = true, required this.label, required this.hint, this.controller, required this.onselect});

  @override
  State<LocationTextfield> createState() => _LocationTextfieldState();
}

class _LocationTextfieldState extends State<LocationTextfield> {

  late final TextEditingController controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(widget.controller == null){
      controller.dispose();
    }
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              _focusNode.unfocus();
            },
            readOnly: true,
            focusNode: _focusNode,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SearchLocationView(
                      initialAddress: controller.text,
                      key: UniqueKey(),
                      onSelect: (address) {
                        controller.text = address.address ?? "";
                        controller.selection = TextSelection.fromPosition(TextPosition(offset: 0));
                        _focusNode.unfocus();
                        Navigator.pop(context);
                        widget.onselect(address);
                      },
                      hint: "Search Location",
                    );
                  }),
              );
            },
            controller: controller,
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
    );
  }
}
