import 'package:calculo_imc/calculation_imc_screen/calculation_imc_view.dart';
import 'package:calculo_imc/nutritional_assessment_screen/nutritional_assessment_view.dart';
import 'package:calculo_imc/nutritional_assessment_screen/models/nutritional_assessment_data.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String calculationImc = "/calculationImc";
  static const String nutritionalAssessment = "/nutritionalAssessment";

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case calculationImc:
        return MaterialPageRoute(builder: (_) => const CalculationImcView());
      case nutritionalAssessment:
        return MaterialPageRoute(
          builder: (_) => NutritionalAssessmentView(
            assessmentData: settings.arguments as NutritionalAssessmentData?,
          ),
        );
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic>? _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("Tela não encontrada")),
          body: const Center(child: Text("Tela não encontrada")),
        );
      },
    );
  }
}
