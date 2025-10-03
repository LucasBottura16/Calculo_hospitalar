class NutritionalAssessmentData {
  // Dados básicos do paciente
  final String? idade;
  final String? peso;
  final String? altura;

  // Resultados do IMC
  final String? resultadoIMC;
  final String? classificacaoIMC;
  final String? faixaDePesoIdeal;
  final String? imcIdeal;

  // Dados de HD e AP
  final String? hdPatient;
  final String? apPatient;
  final String? situationPatient;

  // Triagem e evolução
  final String? nrTriagem;
  final String? selectedEvolution;

  // Necessidades nutricionais
  final String? necessidadeCaloricaMin;
  final String? necessidadeCaloricaMax;
  final String? necessidadeProteicaMin;
  final String? necessidadeProteicaMax;

  // Cálculos nutricionais
  final String? calculoCaloricaMin;
  final String? calculoCaloricaMax;
  final String? calculoProteicaMin;
  final String? calculoProteicaMax;

  // Dietas e suplementos
  final String? selectedDiets;
  final String? selectedSuplements;
  final String? selectedDietsComplements2;
  final String? selectedDietsComplements3;
  final String? selectedDietsComplements4;

  // Quantidades
  final String? quantidadeSuplements;
  final String? quantidadeSuplementsConsumidos;
  final String? quantidadeDietaConsumidos;
  
  // Tipo de avaliação
  final bool? isRevisita;
  
  // Porcentagens de consumo (para revisita)
  final String? porcentagemDieta;
  final String? porcentagemSuplemento;

  const NutritionalAssessmentData({
    this.idade,
    this.peso,
    this.altura,
    this.resultadoIMC,
    this.classificacaoIMC,
    this.faixaDePesoIdeal,
    this.hdPatient,
    this.apPatient,
    this.situationPatient,
    this.nrTriagem,
    this.selectedEvolution,
    this.necessidadeCaloricaMin,
    this.necessidadeCaloricaMax,
    this.necessidadeProteicaMin,
    this.necessidadeProteicaMax,
    this.calculoCaloricaMin,
    this.calculoCaloricaMax,
    this.calculoProteicaMin,
    this.calculoProteicaMax,
    this.selectedDiets,
    this.selectedSuplements,
    this.selectedDietsComplements2,
    this.selectedDietsComplements3,
    this.selectedDietsComplements4,
    this.quantidadeSuplements,
    this.quantidadeSuplementsConsumidos,
    this.quantidadeDietaConsumidos,
    this.isRevisita,
    this.porcentagemDieta,
    this.porcentagemSuplemento,
    this.imcIdeal,
  });

  NutritionalAssessmentData copyWith({
    String? idade,
    String? peso,
    String? altura,
    String? resultadoIMC,
    String? classificacaoIMC,
    String? faixaDePesoIdeal,
    String? hdPatient,
    String? apPatient,
    String? situationPatient,
    String? nrTriagem,
    String? selectedEvolution,
    String? necessidadeCaloricaMin,
    String? necessidadeCaloricaMax,
    String? necessidadeProteicaMin,
    String? necessidadeProteicaMax,
    String? calculoCaloricaMin,
    String? calculoCaloricaMax,
    String? calculoProteicaMin,
    String? calculoProteicaMax,
    String? selectedDiets,
    String? selectedSuplements,
    String? selectedDietsComplements2,
    String? selectedDietsComplements3,
    String? selectedDietsComplements4,
    String? quantidadeSuplements,
    String? quantidadeSuplementsConsumidos,
    String? quantidadeDietaConsumidos,
    String? imcIdeal,
    bool? isRevisita,
    String? porcentagemDieta,
    String? porcentagemSuplemento,
  }) {
    return NutritionalAssessmentData(
      idade: idade ?? this.idade,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      resultadoIMC: resultadoIMC ?? this.resultadoIMC,
      classificacaoIMC: classificacaoIMC ?? this.classificacaoIMC,
      faixaDePesoIdeal: faixaDePesoIdeal ?? this.faixaDePesoIdeal,
      hdPatient: hdPatient ?? this.hdPatient,
      apPatient: apPatient ?? this.apPatient,
      situationPatient: situationPatient ?? this.situationPatient,
      nrTriagem: nrTriagem ?? this.nrTriagem,
      selectedEvolution: selectedEvolution ?? this.selectedEvolution,
      necessidadeCaloricaMin:
          necessidadeCaloricaMin ?? this.necessidadeCaloricaMin,
      necessidadeCaloricaMax:
          necessidadeCaloricaMax ?? this.necessidadeCaloricaMax,
      necessidadeProteicaMin:
          necessidadeProteicaMin ?? this.necessidadeProteicaMin,
      necessidadeProteicaMax:
          necessidadeProteicaMax ?? this.necessidadeProteicaMax,
      calculoCaloricaMin: calculoCaloricaMin ?? this.calculoCaloricaMin,
      calculoCaloricaMax: calculoCaloricaMax ?? this.calculoCaloricaMax,
      calculoProteicaMin: calculoProteicaMin ?? this.calculoProteicaMin,
      calculoProteicaMax: calculoProteicaMax ?? this.calculoProteicaMax,
      selectedDiets: selectedDiets ?? this.selectedDiets,
      selectedSuplements: selectedSuplements ?? this.selectedSuplements,
      selectedDietsComplements2:
          selectedDietsComplements2 ?? this.selectedDietsComplements2,
      selectedDietsComplements3:
          selectedDietsComplements3 ?? this.selectedDietsComplements3,
      selectedDietsComplements4:
          selectedDietsComplements4 ?? this.selectedDietsComplements4,
      quantidadeSuplements: quantidadeSuplements ?? this.quantidadeSuplements,
      quantidadeSuplementsConsumidos:
          quantidadeSuplementsConsumidos ?? this.quantidadeSuplementsConsumidos,
      quantidadeDietaConsumidos:
          quantidadeDietaConsumidos ?? this.quantidadeDietaConsumidos,
      imcIdeal: imcIdeal ?? this.imcIdeal,
      isRevisita: isRevisita ?? this.isRevisita,
      porcentagemDieta: porcentagemDieta ?? this.porcentagemDieta,
      porcentagemSuplemento: porcentagemSuplemento ?? this.porcentagemSuplemento,
    );
  }
}
