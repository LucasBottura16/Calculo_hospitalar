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
}
