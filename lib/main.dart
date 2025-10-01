import 'package:calculo_imc/calculation_imc_screen/calculation_imc_view.dart';
import 'package:calculo_imc/route_generator.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ;
  runApp(
    const MaterialApp(
      home: Routes(),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Routes extends StatefulWidget {
  const Routes({super.key});

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  @override
  Widget build(BuildContext context) {
    return CalculationImcView();
  }
}
