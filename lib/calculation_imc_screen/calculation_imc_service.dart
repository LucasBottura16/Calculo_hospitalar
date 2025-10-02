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
      'FRESUBIN CREME',
      'FRESUBIN JUCY',
      'FRESUBIN LP',
      'FRESUBIN PROT ENERGY',
      'IMPACT',
      'NOVASOURCE PROLINE',
      'NUTREN CONTROL',
      'NUTREN SENIOR',
      'WHEY PROTEIN',
    ];
  }

  static List<String> listDiets() {
    return [
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

  /// Calcula as necessidades calóricas e proteicas baseadas no peso
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

  /// Valida se os campos básicos necessários para o cálculo estão preenchidos
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

  /// Valida todos os campos obrigatórios antes de gerar o relatório
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

  /// Gerencia a seleção de botões (Triagem/Revisita)
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

  /// Preparação dos dados para limpeza do formulário
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

/// Classe para resultado de validação
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  ValidationResult({required this.isValid, this.errorMessage});
}

/// Classe para dados de limpeza de formulário
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
