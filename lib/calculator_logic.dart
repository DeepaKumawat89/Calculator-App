import 'package:math_expressions/math_expressions.dart';

class Calculator {
  String _expression = '';
  String _result = '';

  String get expression => _expression;
  String get result => _result;

  void append(String value) {
    if (value == 'AC') {
      _expression = '';
      _result = '';
    } else if (value == '=') {
      if (_result.isNotEmpty) {
        _expression = _result;
        _result = '';
      }
    } else if (value == '⌫') {
      if (_expression.isNotEmpty) {
        _expression = _expression.substring(0, _expression.length - 1);
      }
      _calculateLiveResult();
    } else {
      _expression += value;
      _calculateLiveResult();
    }
  }

  void _calculateLiveResult() {
    if (_expression.isEmpty) {
      _result = '';
      return;
    }

    if (double.tryParse(_expression) != null) {
      _result = ''; // Keep the result blank for single numbers
      return;
    }

    try {
      String tempExpression = _expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Handle percentage calculations before evaluation
      if (tempExpression.endsWith('%')) {
        String baseExp = tempExpression.substring(0, tempExpression.length - 1);

        // Handle simple percentage: e.g., "200%" -> "200 / 100"
        RegExp simplePercentage = RegExp(r'^\d+(\.\d*)?%?$');
        if (simplePercentage.hasMatch(tempExpression)) {
          double value = double.parse(baseExp);
          _result = (value / 100).toString();
          return;
        }

        // Handle complex percentage: e.g., "622000-20%" -> "622000 - (622000 * 0.20)"
        RegExp complexPercentage = RegExp(r'([\d\.]+)\s*([\+\-×÷])\s*([\d\.]+)%$');

        if (complexPercentage.hasMatch(tempExpression)) {
          RegExpMatch match = complexPercentage.firstMatch(tempExpression)!;
          double firstNum = double.parse(match.group(1)!);
          String operator = match.group(2)!;
          double secondNum = double.parse(match.group(3)!);

          double percentageValue = firstNum * (secondNum / 100);

          String finalExpression = '$firstNum$operator$percentageValue';

          Parser p = Parser();
          Expression exp = p.parse(finalExpression);
          ContextModel cm = ContextModel();

          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toString();
          return;
        }
      }

      // If no percentage logic is applied, proceed with standard evaluation
      Parser p = Parser();
      Expression exp = p.parse(tempExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      // Format result to be an integer if it's a whole number
      if (eval == eval.toInt()) {
        _result = eval.toInt().toString();
      } else {
        // Limit decimal places to 6
        _result = eval.toStringAsFixed(6);
        // Remove trailing zeros and decimal point if not needed
        _result = _result.replaceFirst(RegExp(r'(\.\d*?)0+\n?$'), r'\1').replaceFirst(RegExp(r'\.$'), '');
      }
    } catch (e) {
      // If the expression is incomplete or invalid, keep the result blank
      _result = '';
    }
  }
}