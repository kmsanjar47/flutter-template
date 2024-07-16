import 'package:flutter/material.dart';

class OTPInputField extends StatefulWidget {
  final int length;
  final TextEditingController controller;

  OTPInputField({required this.length, required this.controller});

  @override
  _OTPInputFieldState createState() => _OTPInputFieldState();
}

class _OTPInputFieldState extends State<OTPInputField> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _textControllers;

  @override
  void initState() {
    super.initState();

    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _textControllers = List.generate(widget.length, (index) => TextEditingController());

    // Add listener to each text controller to move focus to next box when a character is entered
    for (int i = 0; i < widget.length; i++) {
      _textControllers[i].addListener(() {
        if (_textControllers[i].text.isNotEmpty && i < widget.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }

    // Add listener to the main controller to update the text fields
    widget.controller.addListener(() {
      for (int i = 0; i < widget.length; i++) {
        if (i < widget.controller.text.length) {
          _textControllers[i].text = widget.controller.text[i];
        } else {
          _textControllers[i].text = '';
        }
      }
    });

    // Add listener to each text controller to handle backspace
    for (int i = 0; i < widget.length; i++) {
      _textControllers[i].addListener(() {
        if (_textControllers[i].text.isEmpty && i > 0) {
          // If current box is empty and not the first box, move focus to previous box
          _focusNodes[i - 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
            (index) => SizedBox(
          width: 50, // Adjust the width according to your preference
          child: TextFormField(
            controller: _textControllers[index],
            focusNode: _focusNodes[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.all(8),
            ),
            onChanged: (value) {
              if (value.isEmpty && index > 0) {
                // Delete previous character if the current box is empty
                _textControllers[index - 1].clear();
                _focusNodes[index - 1].requestFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
