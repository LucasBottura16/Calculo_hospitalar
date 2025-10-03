import 'dart:math';

class CalculationImcService {
  static List<String> listEvolution() {
    return [
      'ADULTO / IDOSO - V.O',
      'ADULTO / IDOSO - ENTERAL',
      'CRIANÇA / ADOLESCENTE',
    ];
  }

  static List<String> listSuplements() {
    return [
      'CANCELAR SELEÇÃO',
      'FRESUBIN CREME',
      'FRESUBIN JUCY',
      'FRESUBIN LP',
      'FRESUBIN PROT ENERGY',
      'IMPACT',
      'NOVASOURCE PROLINE',
      'NUTREN CONTROL',
      'NUTREN SENIOR',
      'WHEY PROTEIN',
      'NUTREN SENIOR DIABETIC PROTEIN',
      'NUTREN DIET CHOCOLATE',
      'NUTREN FIBER',
      'FRESUBIN HP MACH',
      'NOVASOURCE PROTEIN MORANGO',
      'FRESUBIN PROTEIN ENERGY FIBER MORANGO',
      'FRESUBIN PI BAUNILHA',
      'FRESUBIN CREME FRUTAS VERMELHAS',
    ];
  }

  static List<String> listDiets() {
    return [
      'CANCELAR SELEÇÃO',
      'GERAL',
      'BRANDA',
      'LEVE',
      'PASTOSA',
      'PASTOSA BATIDA',
      'LÍQUIDA',
      'ÁGUA, CHÁ E GELATINA',
    ];
  }

  static List<String> listDietsComplements() {
    return [
      'CANCELAR SELEÇÃO',
      'PARA DIABETES',
      'HIPOSSÓDICA',
      'HIPOGORDUROSA',
      'HIPOPROTEICA',
      'HIPOALERGÊNICA',
      'LAXATIVA',
      'SEM RESÍDUOS',
      'PARA NEFROPATA',
      'LÍQ. ESPESSADOS GRAU 1',
      'LÍQ. ESPESSADOS GRAU 2',
      'LÍQ. ESPESSADOS GRAU 3',
    ];
  }

  static Map<String, dynamic> getDietNutritionalValues(String? dietType) {
    if (dietType == null || dietType == 'CANCELAR SELEÇÃO') {
      return {'calories': 0.0, 'protein': 0.0};
    }

    final Map<String, Map<String, double>> dietValues = {
      'GERAL': {'calories': 2162.0, 'protein': 124.4},
      'BRANDA': {'calories': 2158.0, 'protein': 121.1},
      'LEVE': {'calories': 2035.0, 'protein': 124.6},
      'PASTOSA': {'calories': 2176.0, 'protein': 138.5},
      'PASTOSA BATIDA': {'calories': 1834.0, 'protein': 115.7},
      'LÍQUIDA': {'calories': 381.5, 'protein': 8.0},
      'ÁGUA, CHÁ E GELATINA': {'calories': 0.0, 'protein': 0.0},
    };

    return dietValues[dietType] ?? {'calories': 0.0, 'protein': 0.0};
  }

  static Map<String, dynamic> getDietComplementNutritionalValues(
    String? complementType,
  ) {
    if (complementType == null || complementType == 'CANCELAR SELEÇÃO') {
      return {'calories': 0.0, 'protein': 0.0};
    }

    final Map<String, Map<String, double>> complementValues = {
      'PARA DIABETES': {'calories': 2040.8, 'protein': 118.3}, // Para DM
      'HIPOSSÓDICA': {'calories': 2136.0, 'protein': 122.4}, // HAS
      'HIPOGORDUROSA': {'calories': 2051.0, 'protein': 112.3},
      'HIPOPROTEICA': {'calories': 1725.0, 'protein': 106.1},
      'HIPOALERGÊNICA': {'calories': 2100.0, 'protein': 115.0},
      'LAXATIVA': {'calories': 2048.6, 'protein': 116.4},
      'SEM RESÍDUOS': {'calories': 2051.0, 'protein': 112.3},
      'PARA NEFROPATA': {'calories': 1962.5, 'protein': 104.4},
      'LÍQ. ESPESSADOS GRAU 1': {'calories': 381.5, 'protein': 8.0},
      'LÍQ. ESPESSADOS GRAU 2': {'calories': 381.5, 'protein': 8.0},
      'LÍQ. ESPESSADOS GRAU 3': {'calories': 381.5, 'protein': 8.0},
    };

    return complementValues[complementType] ??
        {'calories': 0.0, 'protein': 0.0};
  }

  /// Retorna os valores nutricionais dos suplementos
  /// Baseado nas tabelas oficiais de composição nutricional
  static Map<String, dynamic> getSupplementNutritionalValues(
    String? supplementType,
  ) {
    if (supplementType == null || supplementType == 'CANCELAR SELEÇÃO') {
      return {'calories': 0.0, 'protein': 0.0, 'volume': 0.0};
    }

    // Valores baseados nas tabelas oficiais fornecidas
    final Map<String, Map<String, double>> supplementValues = {
      // Suplementos da lista original
      'FRESUBIN CREME': {'calories': 300.0, 'protein': 18.0, 'volume': 200.0},
      'FRESUBIN JUCY': {'calories': 300.0, 'protein': 8.0, 'volume': 200.0},
      'FRESUBIN LP': {
        'calories': 1500.0,
        'protein': 75.0,
        'volume': 1000.0,
      }, // Volume total bolsa
      'FRESUBIN PROT ENERGY': {
        'calories': 300.0,
        'protein': 20.0,
        'volume': 200.0,
      },
      'IMPACT': {
        'calories': 1500.0,
        'protein': 84.0,
        'volume': 1000.0,
      }, // Volume total bolsa
      'NOVASOURCE PROLINE': {
        'calories': 300.0,
        'protein': 20.0,
        'volume': 200.0,
      },
      'NUTREN CONTROL': {'calories': 250.0, 'protein': 14.0, 'volume': 200.0},
      'NUTREN SENIOR': {'calories': 200.0, 'protein': 10.0, 'volume': 200.0},
      'WHEY PROTEIN': {
        'calories': 120.0,
        'protein': 25.0,
        'volume': 30.0,
      }, // Por scoop
      // Novos suplementos baseados nas tabelas
      'NUTREN SENIOR DIABETIC PROTEIN': {
        'calories': 200.0,
        'protein': 10.0,
        'volume': 200.0,
      },
      'NUTREN DIET CHOCOLATE': {
        'calories': 200.0,
        'protein': 14.0,
        'volume': 200.0,
      },
      'NUTREN FIBER': {'calories': 200.0, 'protein': 8.0, 'volume': 200.0},
      'FRESUBIN HP MACH': {'calories': 300.0, 'protein': 18.0, 'volume': 200.0},
      'NOVASOURCE PROTEIN MORANGO': {
        'calories': 300.0,
        'protein': 20.0,
        'volume': 200.0,
      },
      'FRESUBIN PROTEIN ENERGY FIBER MORANGO': {
        'calories': 300.0,
        'protein': 20.0,
        'volume': 200.0,
      },
      'FRESUBIN PI BAUNILHA': {
        'calories': 250.0,
        'protein': 5.8,
        'volume': 125.0,
      },
      'FRESUBIN CREME FRUTAS VERMELHAS': {
        'calories': 250.0,
        'protein': 10.0,
        'volume': 125.0,
      },
      // Suplemento para teste com exatamente 180 kcal
      'SUPLEMENTO TESTE 180': {
        'calories': 180.0,
        'protein': 12.0,
        'volume': 200.0,
      },
    };

    return supplementValues[supplementType] ??
        {'calories': 0.0, 'protein': 0.0, 'volume': 0.0};
  }

  static Map<String, double> calculateTotalNutritionalValues({
    String? diet1,
    String? diet2,
    String? diet3,
    String? diet4,
  }) {
    double totalCalories = 0.0;
    double totalProtein = 0.0;

    // A primeira dieta é a base (dieta principal)
    if (diet1 != null && diet1.isNotEmpty) {
      final baseValues = getDietNutritionalValues(diet1);
      totalCalories = baseValues['calories'] as double;
      totalProtein = baseValues['protein'] as double;
    }

    final complements = [
      diet2,
      diet3,
      diet4,
    ].where((diet) => diet != null && diet.isNotEmpty).cast<String>().toList();

    for (String complement in complements) {
      final complementValues = getDietComplementNutritionalValues(complement);

      if (complementValues['calories'] as double > 0) {
        totalCalories =
            (totalCalories + (complementValues['calories'] as double)) / 2;
        totalProtein =
            (totalProtein + (complementValues['protein'] as double)) / 2;
      }
    }

    return {'totalCalories': totalCalories, 'totalProtein': totalProtein};
  }

  /// Calcula os valores nutricionais considerando dietas e suplementos
  static Map<String, double> calculateTotalNutritionalValuesWithSupplements({
    String? diet1,
    String? diet2,
    String? diet3,
    String? diet4,
    String? supplement,
  }) {
    // Primeiro calcula os valores das dietas
    final dietValues = calculateTotalNutritionalValues(
      diet1: diet1,
      diet2: diet2,
      diet3: diet3,
      diet4: diet4,
    );

    double totalCalories = dietValues['totalCalories'] ?? 0.0;
    double totalProtein = dietValues['totalProtein'] ?? 0.0;

    // Adiciona os valores do suplemento se selecionado
    if (supplement != null &&
        supplement.isNotEmpty &&
        supplement != 'CANCELAR SELEÇÃO') {
      final supplementValues = getSupplementNutritionalValues(supplement);
      totalCalories += supplementValues['calories'] as double;
      totalProtein += supplementValues['protein'] as double;
    }

    return {'totalCalories': totalCalories, 'totalProtein': totalProtein};
  }

  Map<String, String> calcularIMC({
    required double peso,
    required double altura,
    required int age,
  }) {
    if (altura <= 0) {
      return {
        'resultado': '0.00',
        'classificacao': 'Altura inválida. Use um valor maior que zero.',
      };
    }

    final imc = peso / pow(altura, 2);
    final resultadoFormatado = imc.toStringAsFixed(2);
    final classificacao = _getClassificacao(imc, age);

    return {'resultado': resultadoFormatado, 'classificacao': classificacao};
  }

  Map<String, double> calcularFaixaDePesoIdeal({required double altura}) {
    if (altura <= 0) {
      return {'pesoMinimo': 0.0, 'pesoMaximo': 0.0};
    }

    const double imcMinimoIdeal = 18.5;
    const double imcMaximoIdeal = 24.9;

    final double pesoMinimo = imcMinimoIdeal * pow(altura, 2);
    final double pesoMaximo = imcMaximoIdeal * pow(altura, 2);

    return {'pesoMinimo': pesoMinimo, 'pesoMaximo': pesoMaximo};
  }

  String _getClassificacao(double imc, int age) {
    String classificacao = '';

    if (age >= 60) {
      if (imc < 22) {
        classificacao = 'Abaixo do peso(OPAS, 2002)';
      } else if (imc >= 22 && imc <= 27) {
        classificacao = 'Peso eutrófia (OPAS, 2002)';
      } else if (imc > 27) {
        classificacao = 'Acima do peso (OPAS, 2002)';
      }
    }
    if (age < 60) {
      if (imc < 18.5) {
        classificacao = 'Abaixo do peso (OMS, 1995)';
      } else if (imc >= 18.5 && imc <= 24.9) {
        classificacao = 'Peso normal (OMS, 1995)';
      } else if (imc >= 25.0 && imc <= 29.9) {
        classificacao = 'Sobrepeso (OMS, 1995)';
      } else if (imc >= 30.0 && imc <= 34.9) {
        classificacao = 'Obesidade Grau 1 (OMS, 1995)';
      } else if (imc >= 35.0 && imc <= 39.9) {
        classificacao = 'Obesidade Grau 2 (OMS, 1995)';
      } else {
        classificacao = 'Obesidade Grau 3 (OMS, 1995)';
      }
    }

    return classificacao;
  }

  static Map<String, String> getDefaultValues() {
    return {
      'necessidadeCaloricaMin': '25',
      'necessidadeCaloricaMax': '30',
      'necessidadeProteicaMin': '1.2',
      'necessidadeProteicaMax': '1.5',
      'situationPatient':
          '* Paciente encontra-se em leito, calma e contactuante.\n'
          '* Nega intolerância/alergia alimentar.\n'
          '* Nega restrições/preferências alimentares.\n'
          '* Nega perda de peso nos últimos três meses.\n'
          '* Nega episódios de náuseas, emêse, alteração do apetite.\n'
          '* Habito intestinal normal, com evacuação presente ontem.',
    };
  }

  static Map<String, String> calculateNutritionalNeeds({
    required double peso,
    required double necessidadeCaloricaMin,
    required double necessidadeCaloricaMax,
    required double necessidadeProteicaMin,
    required double necessidadeProteicaMax,
  }) {
    final calculoCaloricaMin = necessidadeCaloricaMin * peso;
    final calculoCaloricaMax = necessidadeCaloricaMax * peso;
    final calculoProteicaMin = necessidadeProteicaMin * peso;
    final calculoProteicaMax = necessidadeProteicaMax * peso;

    return {
      'calculoCaloricaMin': calculoCaloricaMin.toString(),
      'calculoCaloricaMax': calculoCaloricaMax.toString(),
      'calculoProteicaMin': calculoProteicaMin.toString(),
      'calculoProteicaMax': calculoProteicaMax.toString(),
    };
  }

  static bool areBasicFieldsFilled({
    required String idade,
    required String peso,
    required String altura,
    required String? resultadoIMC,
  }) {
    return idade.isNotEmpty &&
        peso.isNotEmpty &&
        altura.isNotEmpty &&
        resultadoIMC != null;
  }

  static ValidationResult validateRequiredFields({
    required bool isButtonSelectedRevisita,
    required bool isButtonSelectedTraigem,
    required String idade,
    required String peso,
    required String altura,
    required String hdPatient,
    required String apPatient,
    required String situationPatient,
    required String? selectedEvolution,
    required String? nrTriagem,
    required String? selectedDiets,
    required String? resultadoIMC,
    required String necessidadeCaloricaMin,
    required String necessidadeCaloricaMax,
    required String necessidadeProteicaMin,
    required String necessidadeProteicaMax,
    required String quantidadeSuplementsConsumidos,
  }) {
    if (!isButtonSelectedRevisita && !isButtonSelectedTraigem) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'Por favor, selecione o tipo de avaliação: Triagem ou Revisita.',
      );
    }

    if (idade.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a idade do paciente.',
      );
    }

    if (peso.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha o peso do paciente.',
      );
    }

    if (altura.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a altura do paciente.',
      );
    }

    if (hdPatient.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha o campo HD (História da Doença).',
      );
    }

    if (apPatient.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha o campo AP (Antecedentes Pessoais).',
      );
    }

    if (situationPatient.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a situação do paciente.',
      );
    }

    if (selectedEvolution == null) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, selecione uma evolução.',
      );
    }

    if (nrTriagem == null) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha o score da triagem NRS.',
      );
    }

    if (selectedDiets == null) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, selecione uma dieta.',
      );
    }

    if (resultadoIMC == null) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'Por favor, calcule o IMC primeiro clicando em "Calcular".',
      );
    }

    if (necessidadeCaloricaMin.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a necessidade calórica mínima.',
      );
    }

    if (necessidadeCaloricaMax.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a necessidade calórica máxima.',
      );
    }

    if (necessidadeProteicaMin.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a necessidade proteica mínima.',
      );
    }

    if (necessidadeProteicaMax.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'Por favor, preencha a necessidade proteica máxima.',
      );
    }

    if (isButtonSelectedRevisita && quantidadeSuplementsConsumidos.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage:
            'Por favor, preencha a quantidade de suplementos consumidos.',
      );
    }

    return ValidationResult(isValid: true);
  }

  static Map<String, bool> manageButtonSelection({
    required String selected,
    required bool currentTriagemState,
    required bool currentRevisitaState,
  }) {
    if (selected == "TRAIGEM") {
      return {
        'isButtonSelectedTraigem': true,
        'isButtonSelectedRevisita': false,
      };
    } else if (selected == "REVISITA") {
      return {
        'isButtonSelectedTraigem': false,
        'isButtonSelectedRevisita': true,
      };
    }

    return {
      'isButtonSelectedTraigem': currentTriagemState,
      'isButtonSelectedRevisita': currentRevisitaState,
    };
  }

  static FormClearData prepareFormClearData() {
    final defaultValues = getDefaultValues();

    return FormClearData(
      situationPatientText: defaultValues['situationPatient']!,
      necessidadeCaloricaMin: defaultValues['necessidadeCaloricaMin']!,
      necessidadeCaloricaMax: defaultValues['necessidadeCaloricaMax']!,
      necessidadeProteicaMin: defaultValues['necessidadeProteicaMin']!,
      necessidadeProteicaMax: defaultValues['necessidadeProteicaMax']!,
    );
  }
}

class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});
}

class FormClearData {
  final String situationPatientText;
  final String necessidadeCaloricaMin;
  final String necessidadeCaloricaMax;
  final String necessidadeProteicaMin;
  final String necessidadeProteicaMax;

  FormClearData({
    required this.situationPatientText,
    required this.necessidadeCaloricaMin,
    required this.necessidadeCaloricaMax,
    required this.necessidadeProteicaMin,
    required this.necessidadeProteicaMax,
  });
}
