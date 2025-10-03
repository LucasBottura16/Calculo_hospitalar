import 'package:calculo_imc/nutritional_assessment_screen/models/nutritional_assessment_data.dart';
import 'package:calculo_imc/nutritional_assessment_screen/nutritional_assessment_service.dart';
import 'package:calculo_imc/utils/colors.dart';
import 'package:calculo_imc/utils/components/app_footer.dart';
import 'package:calculo_imc/utils/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NutritionalAssessmentView extends StatefulWidget {
  final NutritionalAssessmentData? assessmentData;

  const NutritionalAssessmentView({super.key, this.assessmentData});

  @override
  State<NutritionalAssessmentView> createState() =>
      _NutritionalAssessmentViewState();
}

class _NutritionalAssessmentViewState extends State<NutritionalAssessmentView> {
  String sampleReport = '';

  @override
  void initState() {
    super.initState();
    _generateReport();
  }

  void _generateReport() {
    sampleReport = NutritionalAssessmentService.generateNutritionalReport(
      widget.assessmentData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório da Avaliação Nutricional'),
        backgroundColor: MyColors.myPrimary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sampleReport, style: const TextStyle(fontSize: 16.0)),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CustomButton(
                      onPressed: () async {
                        final plainTextReport = sampleReport;
                        final messenger = ScaffoldMessenger.of(context);
                        await Clipboard.setData(
                          ClipboardData(text: plainTextReport),
                        );
                        if (mounted) {
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Relatório copiado para a área de transferência!',
                              ),
                              backgroundColor: MyColors.myPrimary,
                            ),
                          );
                        }
                      },
                      title: "Copiar Relatório",
                      titleColor: Colors.white,
                      buttonColor: MyColors.myPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}
