import 'package:calculo_imc/models/nutritional_assessment_data.dart';
import 'package:calculo_imc/utils/colors.dart';
import 'package:calculo_imc/utils/customs_components/app_footer.dart';
import 'package:calculo_imc/utils/customs_components/custom_button.dart';
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

  String _formatSituation(String situationText) {
    if (situationText == '{situação não informada}' || situationText.isEmpty) {
      return situationText;
    }

    final topics = situationText
        .split('*')
        .map((topic) => topic.trim())
        .where((topic) => topic.isNotEmpty)
        .toList();

    if (topics.isEmpty) {
      return situationText;
    }

    // Formatar como lista com bullets
    return topics.map((topic) => '• $topic').join('\n');
  }

  void _generateReport() {
    final data = widget.assessmentData;

    final hd = data?.hdPatient ?? '{HD não informado}';
    final ap = data?.apPatient ?? '{AP não informado}';
    final score = data?.nrTriagem ?? '{score não informado}';
    final peso = data?.peso ?? '{peso não informado}';
    final altura = data?.altura ?? '{altura não informada}';
    final imc = data?.resultadoIMC ?? '{IMC não calculado}';
    final classificacao =
        data?.classificacaoIMC ?? '{classificação não disponível}';
    final caloriaMin =
        data?.calculoCaloricaMin ??
        data?.necessidadeCaloricaMin ??
        '{caloria mínima não calculada}';
    final caloriaMax =
        data?.calculoCaloricaMax ??
        data?.necessidadeCaloricaMax ??
        '{caloria máxima não calculada}';
    final proteinaMin =
        data?.calculoProteicaMin ??
        data?.necessidadeProteicaMin ??
        '{proteína mínima não calculada}';
    final proteinaMax =
        data?.calculoProteicaMax ??
        data?.necessidadeProteicaMax ??
        '{proteína máxima não calculada}';
    final dieta = data?.selectedDiets ?? '{dieta não selecionada}';
    final dietaCompletar2 =
        data?.selectedDietsComplements2 != null &&
            data!.selectedDietsComplements2!.isNotEmpty
        ? ', ${data.selectedDietsComplements2}'
        : '';
    final dietaCompletar3 =
        data?.selectedDietsComplements3 != null &&
            data!.selectedDietsComplements3!.isNotEmpty
        ? ', ${data.selectedDietsComplements3}'
        : '';
    final dietaCompletar4 =
        data?.selectedDietsComplements4 != null &&
            data!.selectedDietsComplements4!.isNotEmpty
        ? ', ${data.selectedDietsComplements4}'
        : '';
    final caloriaDieta =
        data?.quantidadeDietaConsumidos ??
        '{valor calórico da dieta não informado}';
    final proteinaDieta =
        data?.quantidadeSuplementsConsumidos ??
        '{valor proteico da dieta não informado}';
    final evolucao = data?.selectedEvolution ?? '{evolução não selecionada}';
    final situationRaw = data?.situationPatient ?? '{situação não informada}';
    final imcIdeal = data?.imcIdeal ?? '{IMC ideal não informado}';
    final situation = _formatSituation(situationRaw);

    sampleReport =
        '''
Visita Nutrição - $evolucao

HD: $hd
AP: $ap

$situation

Triagem nutricional segundo NRS 2002, score $score - ${score == '0'
            ? 'Primário'
            : score == '1'
            ? 'Secundário'
            : score == '2'
            ? 'Secundário'
            : 'com risco nutricional'}.

Peso: $peso Kg (referido)
Estatura: $altura m (referida)  
IMC Atual: $imc Kg/m² - $classificacao
IMC recomendado: $imcIdeal Kg/m²

Meta calórica: $caloriaMin - $caloriaMax Kcals/dia
Meta proteica: $proteinaMin - $proteinaMax g/dia

Dieta prescrita: $dieta $dietaCompletar2 $dietaCompletar3 $dietaCompletar4
Valor calórico oferecido: $caloriaDieta Kcals/dia
Valor proteico oferecido: $proteinaDieta g/dia

Evolução: $evolucao

Plano Dietoterápico:
• Atingir meta calórica e proteica.
• Manter estado nutricional.
• Orientar sobre padrão de dieta $dieta $dietaCompletar2 $dietaCompletar3 $dietaCompletar4 prescrita e hidratação.
• Acompanhar aceitação e tolerância alimentar.
• Adaptar preferências e aversões alimentares relatadas.
• Monitorar função intestinal, dextro, PA e exames bioquímicos.

Planejamento de alta: Estabelecer orientação nutricional para dieta $dieta $dietaCompletar2 $dietaCompletar3 $dietaCompletar4.

Nível de Assistência Nutricional: ${score == '0'
            ? 'Primário'
            : score == '1'
            ? 'Secundário'
            : score == '2'
            ? 'Secundário'
            : 'Terciário'} (programação de revisitas a cada ${score == '0'
            ? '7'
            : score == '1'
            ? '4'
            : score == '2'
            ? '4'
            : '2'} dias).
        ''';
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
                  Text(sampleReport),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: CustomButton(
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: sampleReport));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Relatório copiado para a área de transferência!',
                              ),
                              backgroundColor: Colors.green,
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
