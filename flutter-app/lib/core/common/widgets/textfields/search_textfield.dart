import 'package:flutter/material.dart';

class SearchTextfield extends StatefulWidget {
  final String hint;
  final Widget? prefix;
  final Function(String) onSearchChanged;
  final TextEditingController? textEditingcontroller;
  final FocusNode? focusNode;
  final bool focused;
  const SearchTextfield({super.key, this.focused = false, this.hint = "Search location", this.focusNode, this.prefix, required this.onSearchChanged, this.textEditingcontroller});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  late final TextEditingController textEditingcontroller;
  late final FocusNode focusNode;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if(widget.focused){
        focusNode.requestFocus();
      }
  }

  @override
  void initState() {
    super.initState();
    textEditingcontroller = widget.textEditingcontroller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    // post frame callback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(widget.focused){
        focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if(widget.textEditingcontroller == null){
      textEditingcontroller.dispose();
    }
    if(widget.focusNode == null){
      focusNode.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return TextField(
          controller: textEditingcontroller,
          onChanged: (text) {
            widget.onSearchChanged(text);
            setState(() {
              
            });
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey.shade500),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
            suffixIcon: textEditingcontroller.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        textEditingcontroller.clear();
                      });
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.grey,
                    ),
                  )
                : null,
            
            prefixIcon: widget.prefix,
            filled: true,
            fillColor: Colors.grey.shade200,
            //prefix: BackButton(),
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
        );
      },
    );
  }
}
