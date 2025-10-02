import 'package:calculo_imc/nutritional_assessment_screen/models/nutritional_assessment_data.dart';

class NutritionalAssessmentService {
  static String formatSituation(String situationText) {
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

    return topics.map((topic) => '• $topic').join('\n');
  }

  static String getTriagemDescription(String? score) {
    if (score == null) return 'com risco nutricional';

    switch (score) {
      case '0':
        return 'Primário';
      case '1':
        return 'Secundário';
      case '2':
        return 'Secundário';
      default:
        return 'com risco nutricional';
    }
  }

  static String getNivelAssistencia(String? score) {
    if (score == null) return 'Terciário';

    switch (score) {
      case '0':
        return 'Primário';
      case '1':
        return 'Secundário';
      case '2':
        return 'Secundário';
      default:
        return 'Terciário';
    }
  }

  static String getDiasRevisita(String? score) {
    if (score == null) return '2';

    switch (score) {
      case '0':
        return '7';
      case '1':
        return '4';
      case '2':
        return '4';
      default:
        return '2';
    }
  }

  static String concatenateDietComplements({
    String? complement2,
    String? complement3,
    String? complement4,
  }) {
    final complements = <String>[];

    if (complement2 != null && complement2.isNotEmpty) {
      complements.add(complement2);
    }
    if (complement3 != null && complement3.isNotEmpty) {
      complements.add(complement3);
    }
    if (complement4 != null && complement4.isNotEmpty) {
      complements.add(complement4);
    }

    return complements.isEmpty ? '' : ', ${complements.join(', ')}';
  }

  static String generateNutritionalReport(NutritionalAssessmentData? data) {
    if (data == null) {
      return 'Dados da avaliação nutricional não disponíveis.';
    }

    final hd = data.hdPatient ?? '{HD não informado}';
    final ap = data.apPatient ?? '{AP não informado}';
    final score = data.nrTriagem ?? '{score não informado}';
    final peso = data.peso ?? '{peso não informado}';
    final altura = data.altura ?? '{altura não informada}';
    final imc = data.resultadoIMC ?? '{IMC não calculado}';
    final classificacao =
        data.classificacaoIMC ?? '{classificação não disponível}';
    final imcIdeal = data.imcIdeal ?? '{IMC ideal não informado}';
    final evolucao = data.selectedEvolution ?? '{evolução não selecionada}';

    final situationRaw = data.situationPatient ?? '{situação não informada}';
    final situation = formatSituation(situationRaw);

    final caloriaMin =
        data.calculoCaloricaMin ??
        data.necessidadeCaloricaMin ??
        '{caloria mínima não calculada}';
    final caloriaMax =
        data.calculoCaloricaMax ??
        data.necessidadeCaloricaMax ??
        '{caloria máxima não calculada}';
    final proteinaMin =
        data.calculoProteicaMin ??
        data.necessidadeProteicaMin ??
        '{proteína mínima não calculada}';
    final proteinaMax =
        data.calculoProteicaMax ??
        data.necessidadeProteicaMax ??
        '{proteína máxima não calculada}';

    final dieta = data.selectedDiets ?? '{dieta não selecionada}';
    final dietaComplements = concatenateDietComplements(
      complement2: data.selectedDietsComplements2,
      complement3: data.selectedDietsComplements3,
      complement4: data.selectedDietsComplements4,
    );

    final caloriaDieta =
        data.quantidadeDietaConsumidos ??
        '{valor calórico da dieta não informado}';
    final proteinaDieta =
        data.quantidadeSuplementsConsumidos ??
        '{valor proteico da dieta não informado}';

    final triagemDesc = getTriagemDescription(data.nrTriagem);
    final nivelAssistencia = getNivelAssistencia(data.nrTriagem);
    final diasRevisita = getDiasRevisita(data.nrTriagem);

    return '''
Visita Nutrição - $evolucao

HD: $hd
AP: $ap

$situation

Triagem nutricional segundo NRS 2002, score $score - $triagemDesc.

Peso: $peso Kg (referido)
Estatura: $altura m (referida)  
IMC Atual: $imc Kg/m² - $classificacao
IMC recomendado: $imcIdeal Kg/m²

Meta calórica: $caloriaMin - $caloriaMax Kcals/dia
Meta proteica: $proteinaMin - $proteinaMax g/dia

Dieta prescrita: $dieta$dietaComplements
Valor calórico oferecido: $caloriaDieta Kcals/dia
Valor proteico oferecido: $proteinaDieta g/dia

Evolução: $evolucao

Plano Dietoterápico:
• Atingir meta calórica e proteica.
• Manter estado nutricional.
• Orientar sobre padrão de dieta $dieta$dietaComplements prescrita e hidratação.
• Acompanhar aceitação e tolerância alimentar.
• Adaptar preferências e aversões alimentares relatadas.
• Monitorar função intestinal, dextro, PA e exames bioquímicos.

Planejamento de alta: Estabelecer orientação nutricional para dieta $dieta$dietaComplements.

Nível de Assistência Nutricional: $nivelAssistencia (programação de revisitas a cada $diasRevisita dias).
        ''';
  }
}
