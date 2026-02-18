import 'package:flutter/material.dart';
import 'calculator_logic.dart';


class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final Calculator _calculator = Calculator();
  void _onButtonPressed(String buttonText) {
    setState(() {
      _calculator.append(buttonText);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor:Colors.black,
        title:  Text(
          'Calculator',
          style: TextStyle(
            fontSize: screenSize.width*0.09,
            fontFamily: 'Dancing Script',
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding:  EdgeInsets.all(screenSize.width*0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _calculator.expression,
                      style: TextStyle(
                        fontSize: screenSize.width * 0.08,
                        color: Colors.white70,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Text(
                      _calculator.result,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenSize.width * 0.12,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding:  EdgeInsets.only(left: screenSize.width*0.03,right: screenSize.width*0.03,bottom: screenSize.height*0.04),
              child: Column(
                children: [
                  _buildButtonRow(['AC', '%', '÷','⌫']),
                  _buildButtonRow(['7', '8', '9', '×']),
                  _buildButtonRow(['4', '5', '6', '-']),
                  _buildButtonRow(['1', '2', '3', '+']),
                  _buildButtonRow(['00', '0', '.','=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((buttonText) {
          return _buildButton(buttonText);
        }
        ).toList(),
      ),
    );
  }

  Widget _buildButton(String buttonText) {
    final Size screenSize = MediaQuery.of(context).size;
    Color buttonColor = Colors.grey.shade900;
    Color textColor = Colors.white;
    if (buttonText == 'AC' || buttonText == '⌫' || buttonText == '%' || buttonText == '÷' || buttonText == '×' || buttonText == '-' || buttonText == '+') {
      buttonColor = Colors.grey.shade700;
    }
    if (buttonText == '=') {
      buttonColor = Colors.orange;
    }
    return Expanded(
      child: Padding(
        padding:  EdgeInsets.all(screenSize.width*0.01),
        child: Material(
          color: buttonColor,
          shape: const CircleBorder(),
          child: InkWell(
            highlightColor: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(100), // Match the container's shape
            onTap: () => _onButtonPressed(buttonText),
            child: Container(
              alignment: Alignment.center,
              height: double.infinity,
              child: Text(
                buttonText,
                style:  TextStyle(
                  fontSize: screenSize.width*0.09,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}