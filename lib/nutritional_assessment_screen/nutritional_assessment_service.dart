import 'package:calculo_imc/nutritional_assessment_screen/models/nutritional_assessment_data.dart';
import 'package:calculo_imc/calculation_imc_screen/calculation_imc_service.dart';

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

  /// Calcula os valores consumidos para revisita baseado nas porcentagens
  /// Usa os campos quantidadeDietaConsumidos e quantidadeSuplementsConsumidos como porcentagens
  static Map<String, dynamic> calculateConsumedValuesForRevisita({
    required String? valorCaloricoOfertado,
    required String? valorProteicoOfertado,
    required String? porcentagemDieta, // Campo quantidadeDietaConsumidos usado como %
    required String? porcentagemSuplemento, // Campo quantidadeSuplementsConsumidos usado como %
    String? selectedSupplement,
  }) {
    // Porcentagens consumidas (dos campos de entrada do usuário)
    final percentDieta = double.tryParse(porcentagemDieta ?? '0') ?? 0.0;
    final percentSuplemento = double.tryParse(porcentagemSuplemento ?? '0') ?? 0.0;
    
    // LÓGICA CORRIGIDA: Primeiro precisamos obter os valores TOTAIS oferecidos
    // Para a dieta, usamos os valores calculados no sistema (valorCaloricoOfertado e valorProteicoOfertado)
    final caloriaDietaOfertada = double.tryParse(valorCaloricoOfertado ?? '0') ?? 0.0;
    final proteinaDietaOfertada = double.tryParse(valorProteicoOfertado ?? '0') ?? 0.0;
    
    // Cálculo do consumo da dieta: Valor total × (porcentagem ÷ 100)
    // Exemplo: 2130 kcal × (50% ÷ 100) = 1065 kcal
    final caloriaDietaConsumida = caloriaDietaOfertada * (percentDieta / 100);
    final proteinaDietaConsumida = proteinaDietaOfertada * (percentDieta / 100);
    
    // Cálculo do consumo do suplemento (se houver)
    double caloriaSuplemento = 0.0;
    double proteinaSuplemento = 0.0;
    double caloriaSupplementoOfertada = 0.0;
    double proteinaSupplementoOfertada = 0.0;
    
    if (selectedSupplement != null && selectedSupplement.isNotEmpty && selectedSupplement != 'CANCELAR SELEÇÃO') {
      final supplementValues = _getSupplementEstimatedValues(selectedSupplement);
      
      // Valores totais do suplemento oferecido
      caloriaSupplementoOfertada = supplementValues['calories']!;
      proteinaSupplementoOfertada = supplementValues['protein']!;
      
      // Valores consumidos baseado na porcentagem: Valor total × (porcentagem ÷ 100)
      // Exemplo: 180 kcal × (50% ÷ 100) = 180 × 0.5 = 90 kcal
      caloriaSuplemento = caloriaSupplementoOfertada * (percentSuplemento / 100);
      proteinaSuplemento = proteinaSupplementoOfertada * (percentSuplemento / 100);
    }
    
    // Valores totais consumidos
    final totalCaloriasConsumidas = caloriaDietaConsumida + caloriaSuplemento;
    final totalProteinaConsumida = proteinaDietaConsumida + proteinaSuplemento;
    
    return {
      'caloriaDietaConsumida': caloriaDietaConsumida,
      'proteinaDietaConsumida': proteinaDietaConsumida,
      'caloriaSuplemento': caloriaSuplemento,
      'proteinaSuplemento': proteinaSuplemento,
      'totalCaloriasConsumidas': totalCaloriasConsumidas,
      'totalProteinaConsumida': totalProteinaConsumida,
      'porcentagemDieta': percentDieta,
      'porcentagemSuplemento': percentSuplemento,
      // Valores oferecidos para referência
      'caloriaDietaOfertada': caloriaDietaOfertada,
      'proteinaDietaOfertada': proteinaDietaOfertada,
      'caloriaSupplementoOfertada': caloriaSupplementoOfertada,
      'proteinaSupplementoOfertada': proteinaSupplementoOfertada,
    };
  }

  /// Valores de suplementos - USANDO OS MESMOS VALORES DO CALCULATIONIMCSERVICE
  /// Para garantir consistência entre os sistemas
  static Map<String, double> _getSupplementEstimatedValues(String supplementName) {
    // VALORES IDÊNTICOS AOS DO CalculationImcService.getSupplementNutritionalValues()
    final Map<String, Map<String, double>> supplementValues = {
      'FRESUBIN CREME': {'calories': 300.0, 'protein': 18.0},
      'FRESUBIN JUCY': {'calories': 300.0, 'protein': 8.0},
      'FRESUBIN LP': {'calories': 1500.0, 'protein': 75.0}, // Volume total bolsa
      'FRESUBIN PROT ENERGY': {'calories': 300.0, 'protein': 20.0},
      'IMPACT': {'calories': 1500.0, 'protein': 84.0}, // Volume total bolsa
      'NOVASOURCE PROLINE': {'calories': 300.0, 'protein': 20.0},
      'NUTREN CONTROL': {'calories': 250.0, 'protein': 14.0},
      'NUTREN SENIOR': {'calories': 200.0, 'protein': 10.0},
      'WHEY PROTEIN': {'calories': 120.0, 'protein': 25.0},
      // Novos suplementos baseados nas tabelas
      'NUTREN SENIOR DIABETIC PROTEIN': {'calories': 200.0, 'protein': 10.0},
      'NUTREN DIET CHOCOLATE': {'calories': 200.0, 'protein': 14.0},
      'NUTREN FIBER': {'calories': 200.0, 'protein': 8.0},
      'FRESUBIN HP MACH': {'calories': 300.0, 'protein': 18.0},
      'NOVASOURCE PROTEIN MORANGO': {'calories': 300.0, 'protein': 20.0},
      'FRESUBIN PROTEIN ENERGY FIBER MORANGO': {'calories': 300.0, 'protein': 20.0},
      'FRESUBIN PI BAUNILHA': {'calories': 250.0, 'protein': 5.8},
      'FRESUBIN CREME FRUTAS VERMELHAS': {'calories': 250.0, 'protein': 10.0},
      // Adicionando exemplo com 180 kcal para o seu teste
      'SUPLEMENTO TESTE 180': {'calories': 180.0, 'protein': 12.0},
    };
    
    return supplementValues[supplementName] ?? {'calories': 250.0, 'protein': 15.0};
  }

  /// Função de debug para verificar os cálculos de consumo
  static String debugConsumedValues({
    required String? valorCaloricoOfertado,
    required String? valorProteicoOfertado,
    required String? porcentagemDieta,
    required String? porcentagemSuplemento,
    String? selectedSupplement,
  }) {
    final values = calculateConsumedValuesForRevisita(
      valorCaloricoOfertado: valorCaloricoOfertado,
      valorProteicoOfertado: valorProteicoOfertado,
      porcentagemDieta: porcentagemDieta,
      porcentagemSuplemento: porcentagemSuplemento,
      selectedSupplement: selectedSupplement,
    );

    return '''
DEBUG - Cálculos de Consumo:

DIETA:
- Oferecida: ${values['caloriaDietaOfertada']} kcal, ${values['proteinaDietaOfertada']} g
- Porcentagem consumida: ${values['porcentagemDieta']}%
- Consumida: ${values['caloriaDietaConsumida']} kcal, ${values['proteinaDietaConsumida']} g
- Cálculo: ${values['caloriaDietaOfertada']} × ${values['porcentagemDieta']}% = ${values['caloriaDietaConsumida']}

SUPLEMENTO ($selectedSupplement):
- Oferecido: ${values['caloriaSupplementoOfertada']} kcal, ${values['proteinaSupplementoOfertada']} g
- Porcentagem consumida: ${values['porcentagemSuplemento']}%
- Consumido: ${values['caloriaSuplemento']} kcal, ${values['proteinaSuplemento']} g
- Cálculo: ${values['caloriaSupplementoOfertada']} × ${values['porcentagemSuplemento']}% = ${values['caloriaSuplemento']}

TOTAL CONSUMIDO:
- Calorias: ${values['caloriaDietaConsumida']} + ${values['caloriaSuplemento']} = ${values['totalCaloriasConsumidas']} kcal
- Proteínas: ${values['proteinaDietaConsumida']} + ${values['proteinaSuplemento']} = ${values['totalProteinaConsumida']} g
''';
  }

  /// Determina o texto de aceitação baseado no score
  static String getAcceptanceText(double percentage) {
    if (percentage >= 80) {
      return 'boa';
    } else if (percentage >= 60) {
      return 'regular';
    } else if (percentage >= 40) {
      return 'baixa';
    } else {
      return 'muito baixa';
    }
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

    // Adicionar suplemento se selecionado
    final suplemento = data.selectedSuplements;
    final suplementoText = (suplemento != null && suplemento.isNotEmpty) 
        ? ' + $suplemento' 
        : '';

    // Calcular valores totais oferecidos (dieta + suplemento) usando o serviço do CalculationImcService
    final totalValues = CalculationImcService.calculateTotalNutritionalValuesWithSupplements(
      diet1: data.selectedDiets,
      diet2: data.selectedDietsComplements2,
      diet3: data.selectedDietsComplements3,
      diet4: data.selectedDietsComplements4,
      supplement: data.selectedSuplements,
    );
    
    final caloriaDieta = totalValues['totalCalories']?.toStringAsFixed(0) ?? '{valor calórico não calculado}';
    final proteinaDieta = totalValues['totalProtein']?.toStringAsFixed(1) ?? '{valor proteico não calculado}';

    final triagemDesc = getTriagemDescription(data.nrTriagem);
    final nivelAssistencia = getNivelAssistencia(data.nrTriagem);
    final diasRevisita = getDiasRevisita(data.nrTriagem);

    // Seção específica para revisita
    String revisitaSection = '';
    if (data.isRevisita == true) {
      final consumedValues = calculateConsumedValuesForRevisita(
        valorCaloricoOfertado: caloriaDieta,
        valorProteicoOfertado: proteinaDieta,
        porcentagemDieta: data.quantidadeDietaConsumidos, // Campo usado como porcentagem de consumo
        porcentagemSuplemento: data.quantidadeSuplementsConsumidos, // Campo usado como porcentagem de consumo
        selectedSupplement: data.selectedSuplements,
      );
      
      final aceiteDieta = getAcceptanceText(consumedValues['porcentagemDieta']);
      final aceiteSuplemento = getAcceptanceText(consumedValues['porcentagemSuplemento']);
      
      revisitaSection = '''

Refere $aceiteDieta aceitação alimentar, em torno de ${consumedValues['porcentagemDieta'].toStringAsFixed(0)}% da dieta ofertada, ontem.
Refere também, $aceiteSuplemento aceitação do suplemento, consumindo em torno de ${consumedValues['porcentagemSuplemento'].toStringAsFixed(0)}% do total, ontem.
Valor calórico total ingerido: ${consumedValues['totalCaloriasConsumidas'].toStringAsFixed(0)} Kcals
Valor proteico total ingerido: ${consumedValues['totalProteinaConsumida'].toStringAsFixed(1)} g
''';
    }

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

Dieta prescrita: $dieta$dietaComplements$suplementoText
Valor calórico oferecido: $caloriaDieta Kcals/dia
Valor proteico oferecido: $proteinaDieta g/dia

Evolução: $evolucao$revisitaSection

Plano Dietoterápico:
• Atingir meta calórica e proteica.
• Manter estado nutricional.
• Orientar sobre padrão de dieta $dieta$dietaComplements$suplementoText prescrita e hidratação.
• Acompanhar aceitação e tolerância alimentar.
• Adaptar preferências e aversões alimentares relatadas.
• Monitorar função intestinal, dextro, PA e exames bioquímicos.

Planejamento de alta: Estabelecer orientação nutricional para dieta $dieta$dietaComplements$suplementoText.

Nível de Assistência Nutricional: $nivelAssistencia (programação de revisitas a cada $diasRevisita dias).
        ''';
  }
}
