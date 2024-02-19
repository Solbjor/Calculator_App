import 'package:flutter/material.dart';
import 'package:test_app/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "0",
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            //buttons We wrap the buttons in the widget and assign the values from the other folder.
            Wrap(
              children: Btn.buttonValues
                  //we use a SizedBox to assign all our button's values into seperate boxes and align them according to the screen size.
                  .map((value) => SizedBox(
                      width: screenSize.width / 4,
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    return Material(
      //material lets us give it styling and splash effects on tap.
      clipBehavior: Clip.hardEdge,
      shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(
              100)), //Makes the shape of the button and establishes the radius of the circle.
      child: InkWell(
        //Ink well makes the button tappable, so we wrap this all in an inkwell widget.
        onTap: () {},
        child: Center(
          child: Text(value),
        ),
      ),
    );
  }
}
