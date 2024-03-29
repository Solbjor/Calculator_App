import 'package:flutter/material.dart';
import 'package:test_app/button_values.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; //always has values of . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

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
                    "$number1$operand$number2".isEmpty
                        //check if any of these variables are empty
                        ? "0" //if empty display 0
                        : "$number1$operand$number2", //if not empty display the values of the variables
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
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                      height: screenSize.width / 5,
                      child: buildButton(value)))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  //###############################
  Widget buildButton(value) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        //material lets us give it styling and splash effects on tap.
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(
                100)), //Makes the shape of the button and establishes the radius of the circle.
        child: InkWell(
          //Ink well makes the button tappable, so we wrap this all in an inkwell widget.
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  //#############################
  void onBtnTap(String value) {
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  //#############################
  //calculates the result
  void calculate() {
    if (number1.isEmpty) {
      return;
    }
    if (operand.isEmpty) {
      return;
    }
    if (number2.isEmpty) {
      return;
    }

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {
      number1 = "$result";

      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = "";
      number2 = "";
    });
  }

  //#############################
  //converts output to percentage

  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      //calculate before conversion
      calculate();
      //final res = number1 operand number2;
      //number1 = res;
    }

    if (operand.isNotEmpty) {
      //cannot be converted
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  //#############################
  //clears all output
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  //#############################
  //delete one value
  void delete() {
    if (number2.isNotEmpty) {
      //ex: 12323 looks at last number => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  //#############################
  //appends value to the end
  void appendValue(String value) {
    //number1 operand number2 selection criteria
    // 234      +       5343

    if (value != Btn.dot && int.tryParse(value) == null) {
      //if is operand and not dot
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //calculate the equation before assigning new values
        calculate();
      }
      operand = value;
      //asign value to number1 variable
    } else if (number1.isEmpty || operand.isEmpty) {
      //check if value is ". | ex: number1 = "1.2
      if (value == Btn.dot && number1.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.dot)) {
        //ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
      //asign value to number2 variable
    } else if (number2.isEmpty || operand.isNotEmpty) {
      //check if number 2 is empty or if operand is not empty
      if (value == Btn.dot && number2.contains(Btn.dot)) {
        return;
      }
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.dot)) {
        //ex: number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  //#############################
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? Colors.blueGrey
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? Colors.orange
            : Colors.black87;
  }
}
