import 'package:calculo_imc/calculation_imc_screen/calculation_imc_service.dart';
import 'package:calculo_imc/nutritional_assessment_screen/models/nutritional_assessment_data.dart';
import 'package:calculo_imc/route_generator.dart';
import 'package:calculo_imc/utils/colors.dart';
import 'package:calculo_imc/utils/components/app_footer.dart';
import 'package:calculo_imc/utils/components/custom_button.dart';
import 'package:calculo_imc/utils/components/custom_dropdown.dart';
import 'package:calculo_imc/utils/components/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CalculationImcView extends StatefulWidget {
  const CalculationImcView({super.key});

  @override
  State<CalculationImcView> createState() => _CalculationImcViewState();
}

class _CalculationImcViewState extends State<CalculationImcView> {
  final _formKeyImc = GlobalKey<FormState>();
  final _formKeyPatient = GlobalKey<FormState>();
  final _formKeyDiet = GlobalKey<FormState>();
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();
  final _idadeController = TextEditingController();
  final _imcIdealController = TextEditingController();
  final _necessidadeCaloricaMinController = TextEditingController();
  final _necessidadeCaloricaMaxController = TextEditingController();
  final _necessidadeProteicaMinController = TextEditingController();
  final _necessidadeProteicaMaxController = TextEditingController();
  final _quantidadeSuplementsController = TextEditingController();
  final _quantidadeSuplementsConsumidosController = TextEditingController();
  final _quantidadeDietaConsumidosController = TextEditingController();
  final _hdPatientController = TextEditingController();
  final _apPatientController = TextEditingController();
  final _situationPatientController = TextEditingController();

  String? _resultadoIMC;
  String? _classificacaoIMC;
  String? _faixaDePesoIdeal;

  String? _selectedEvolution;
  String? _nrTriagem;
  String? _selectedSuplements;
  String? _selectedDiets;
  String? _selectedDietsComplements2;
  String? _selectedDietsComplements3;
  String? _selectedDietsComplements4;

  String? _calculoCaloricaMin;
  String? _calculoCaloricaMax;
  String? _calculoProteicaMin;
  String? _calculoProteicaMax;

  bool isButtonSelectedTraigem = false;
  bool isButtonSelectedRevisita = false;

  void _calcularCalorias() {
    final peso =
        double.tryParse(_pesoController.text.replaceAll(',', '.')) ?? 0;

    double calculoCaloricaMin =
        double.tryParse(_necessidadeCaloricaMinController.text)! * peso;
    double calculoCaloricaMax =
        double.tryParse(_necessidadeCaloricaMaxController.text)! * peso;
    double calculoProteicaMin =
        double.tryParse(_necessidadeProteicaMinController.text)! * peso;
    double calculoProteicaMax =
        double.tryParse(_necessidadeProteicaMaxController.text)! * peso;

    setState(() {
      _calculoCaloricaMin = calculoCaloricaMin.toString();
      _calculoCaloricaMax = calculoCaloricaMax.toString();
      _calculoProteicaMin = calculoProteicaMin.toString();
      _calculoProteicaMax = calculoProteicaMax.toString();
    });
  }

  bool _validateRequiredFields() {
    if (isButtonSelectedRevisita == false && isButtonSelectedTraigem == false) {
      _showValidationError(
        'Por favor, selecione o tipo de avaliação: Triagem ou Revisita.',
      );
      return false;
    }

    if (_idadeController.text.isEmpty) {
      _showValidationError('Por favor, preencha a idade do paciente.');
      return false;
    }
    if (_pesoController.text.isEmpty) {
      _showValidationError('Por favor, preencha o peso do paciente.');
      return false;
    }
    if (_alturaController.text.isEmpty) {
      _showValidationError('Por favor, preencha a altura do paciente.');
      return false;
    }
    if (_hdPatientController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha o campo HD (História da Doença).',
      );
      return false;
    }
    if (_apPatientController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha o campo AP (Antecedentes Pessoais).',
      );
      return false;
    }
    if (_situationPatientController.text.isEmpty) {
      _showValidationError('Por favor, preencha a situação do paciente.');
      return false;
    }
    if (_selectedEvolution == null) {
      _showValidationError('Por favor, selecione uma evolução.');
      return false;
    }
    if (_nrTriagem == null) {
      _showValidationError('Por favor, preencha o score da triagem NRS.');
      return false;
    }
    if (_selectedDiets == null) {
      _showValidationError('Por favor, selecione uma dieta.');
      return false;
    }
    if (_resultadoIMC == null) {
      _showValidationError(
        'Por favor, calcule o IMC primeiro clicando em "Calcular".',
      );
      return false;
    }
    if (_necessidadeCaloricaMinController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha a necessidade calórica mínima.',
      );
      return false;
    }
    if (_necessidadeCaloricaMaxController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha a necessidade calórica máxima.',
      );
      return false;
    }
    if (_necessidadeProteicaMinController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha a necessidade proteica mínima.',
      );
      return false;
    }
    if (_necessidadeProteicaMaxController.text.isEmpty) {
      _showValidationError(
        'Por favor, preencha a necessidade proteica máxima.',
      );
      return false;
    }
    if (isButtonSelectedRevisita) {
      if (_quantidadeSuplementsConsumidosController.text.isEmpty) {
        _showValidationError(
          'Por favor, preencha a quantidade de suplementos consumidos.',
        );
        return false;
      }
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  bool _areBasicFieldsFilled() {
    return _idadeController.text.isNotEmpty &&
        _pesoController.text.isNotEmpty &&
        _alturaController.text.isNotEmpty &&
        _resultadoIMC != null;
  }

  void _calcular() {
    FocusScope.of(context).unfocus();

    if (_formKeyImc.currentState?.validate() ?? false) {
      final peso =
          double.tryParse(_pesoController.text.replaceAll(',', '.')) ?? 0;
      final altura =
          double.tryParse(_alturaController.text.replaceAll(',', '.')) ?? 0;

      final resultado = CalculationImcService().calcularIMC(
        peso: peso,
        altura: altura,
        age: int.tryParse(_idadeController.text) ?? 0,
      );

      final faixaIdeal = CalculationImcService().calcularFaixaDePesoIdeal(
        altura: altura,
      );
      final pesoMinFmt = faixaIdeal['pesoMinimo']!.toStringAsFixed(1);
      final pesoMaxFmt = faixaIdeal['pesoMaximo']!.toStringAsFixed(1);

      _calcularCalorias();

      setState(() {
        _resultadoIMC = resultado['resultado']!;
        _classificacaoIMC = resultado['classificacao']!;
        _faixaDePesoIdeal = 'Entre $pesoMinFmt kg e $pesoMaxFmt kg.';
      });
    }
  }

  @override
  void dispose() {
    // Remover listeners antes de fazer dispose
    _idadeController.removeListener(_updateButtonState);
    _pesoController.removeListener(_updateButtonState);
    _alturaController.removeListener(_updateButtonState);

    _pesoController.dispose();
    _alturaController.dispose();
    _idadeController.dispose();
    _necessidadeCaloricaMinController.dispose();
    _necessidadeCaloricaMaxController.dispose();
    _necessidadeProteicaMinController.dispose();
    _necessidadeProteicaMaxController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // Força a atualização da interface para refletir mudanças nos campos
    });
  }

  void _mostrarDialogoLimparFormulario() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              const Text('Confirmar Limpeza'),
            ],
          ),
          content: const Text(
            'Tem certeza que deseja limpar todo o formulário?\n\nTodos os dados preenchidos serão perdidos.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar diálogo
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fechar diálogo
                _limparFormulario(); // Executar limpeza
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Limpar', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  void _limparFormulario() {
    setState(() {
      // Limpar todos os controllers
      _pesoController.clear();
      _alturaController.clear();
      _idadeController.clear();
      _imcIdealController.clear();
      _quantidadeSuplementsController.clear();
      _quantidadeSuplementsConsumidosController.clear();
      _quantidadeDietaConsumidosController.clear();
      _hdPatientController.clear();
      _apPatientController.clear();
      _situationPatientController.text =
          '* Paciente encontra-se em leito, calma e contactuante.\n'
          '* Nega intolerância/alergia alimentar.\n'
          '* Nega restrições/preferências alimentares.\n'
          '* Nega perda de peso nos últimos três meses.\n'
          '* Nega episódios de náuseas, emêse, alteração do apetite.\n'
          '* Habito intestinal normal, com evacuação presente ontem.';

      // Resetar valores padrão dos controllers de necessidades nutricionais
      _necessidadeCaloricaMinController.text = "25";
      _necessidadeCaloricaMaxController.text = "30";
      _necessidadeProteicaMinController.text = "1.2";
      _necessidadeProteicaMaxController.text = "1.5";

      // Limpar variáveis de resultado
      _resultadoIMC = null;
      _classificacaoIMC = null;
      _faixaDePesoIdeal = null;

      // Limpar seleções de dropdowns
      _selectedEvolution = null;
      _nrTriagem = null;
      _selectedSuplements = null;
      _selectedDiets = null;
      _selectedDietsComplements2 = null;
      _selectedDietsComplements3 = null;
      _selectedDietsComplements4 = null;

      // Limpar cálculos
      _calculoCaloricaMin = null;
      _calculoCaloricaMax = null;
      _calculoProteicaMin = null;
      _calculoProteicaMax = null;

      // Resetar botões de seleção
      isButtonSelectedTraigem = false;
      isButtonSelectedRevisita = false;
    });

    // Mostrar confirmação
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Formulário limpo com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Adicionar listeners aos campos obrigatórios para atualizar o botão
    _idadeController.addListener(_updateButtonState);
    _pesoController.addListener(_updateButtonState);
    _alturaController.addListener(_updateButtonState);

    setState(() {
      _necessidadeCaloricaMinController.text = "25".toString();
      _necessidadeCaloricaMaxController.text = "30".toString();
      _necessidadeProteicaMinController.text = "1.2".toString();
      _necessidadeProteicaMaxController.text = "1.5".toString();
      _situationPatientController.text =
          '* Paciente encontra-se em leito, calma e contactuante.\n'
          '* Nega intolerância/alergia alimentar.\n'
          '* Nega restrições/preferências alimentares.\n'
          '* Nega perda de peso nos últimos três meses.\n'
          '* Nega episódios de náuseas, emêse, alteração do apetite.\n'
          '* Habito intestinal normal, com evacuação presente ontem.';
    });
  }

  _selectButton(String selected) {
    setState(() {
      if (selected == "TRAIGEM") {
        isButtonSelectedTraigem = true;
        isButtonSelectedRevisita = false;
      } else if (selected == "REVISITA") {
        isButtonSelectedTraigem = false;
        isButtonSelectedRevisita = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avaliação Nutricional'),
        backgroundColor: MyColors.myPrimary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _mostrarDialogoLimparFormulario,
            icon: const Icon(Icons.refresh),
            iconSize: 30,
            tooltip: 'Limpar Formulário',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      bool isWideScreen = constraints.maxWidth > 800;

                      if (isWideScreen) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: _buildFormColumn(),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: _buildResultColumn(),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildFormColumn(),
                            const SizedBox(height: 16),
                            _buildResultColumn(),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildFormColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomButton(
              onPressed: () {
                _selectButton("TRAIGEM");
              },
              title: "TRAIGEM",
              titleColor: Colors.white,
              buttonColor: isButtonSelectedTraigem
                  ? MyColors.myPrimary
                  : Colors.grey.shade400,
            ),
            const SizedBox(width: 10),
            CustomButton(
              onPressed: () {
                _selectButton("REVISITA");
              },
              title: "REVISITA",
              titleColor: Colors.white,
              buttonColor: isButtonSelectedRevisita
                  ? MyColors.myPrimary
                  : Colors.grey.shade400,
            ),
          ],
        ),
        const SizedBox(height: 20),
        CustomDropdown<String>(
          value: _selectedEvolution,
          hintText: 'Escolha uma Evolução',
          items: CalculationImcService.listEvolution(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedEvolution = newValue;
            });
          },
          labelText: 'Evolução',
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyImc,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Calcule o IMC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _idadeController,
                    labelText: 'Idade do paciente',
                    hintText: 'Ex: 23 anos',
                    suffix: "Anos",
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a idade';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _pesoController,
                    labelText: 'Seu Peso (kg)',
                    hintText: 'Ex: 75.5',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+[\,\.]?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu peso';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _alturaController,
                    labelText: 'Sua Altura (m)',
                    hintText: 'Ex: 1.78',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+[\,\.]?\d{0,2}'),
                      ),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua altura';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    onPressed: _calcular,
                    buttonColor: MyColors.myPrimary,
                    title: 'Calcular',
                    titleColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyPatient,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Dados do paciente',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown<String>(
                    value: _nrTriagem,
                    hintText: 'Numero da Triagem Nutricional',
                    items: ['0', '1', '2', '3'],
                    onChanged: (String? newValue) {
                      setState(() {
                        _nrTriagem = newValue;
                      });
                    },
                    labelText: 'Triagem Nutricional segundo NRS 2002',
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _hdPatientController,
                    labelText: 'HD do paciente',
                    hintText: 'Ex: Colocar o HD aqui',
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _apPatientController,
                    labelText: 'AP do paciente',
                    hintText: 'Ex: Colocar o AP aqui',
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _situationPatientController,
                    labelText: 'Situação do paciente',
                    hintText: 'Ex: Colocar a situação aqui',
                    maxLines: 30,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKeyDiet,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Dados da Dieta',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: MyColors.myPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomDropdown<String>(
                    value: _selectedSuplements,
                    hintText: 'Escolha um suplemento',
                    items: CalculationImcService.listSuplements(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSuplements = newValue;
                      });
                    },
                    labelText: 'Suplementos',
                  ),
                  const SizedBox(height: 16),
                  CustomInputField(
                    controller: _quantidadeSuplementsController,
                    labelText: 'Quantidade de suplementos (unidades)',
                    hintText: 'Ex: 2',
                    suffix: 'Vezes ao dia',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isButtonSelectedRevisita)
                    CustomInputField(
                      controller: _quantidadeSuplementsConsumidosController,
                      labelText: 'Quantidade de suplementos consumidos (%)',
                      hintText: 'Ex: 50%',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                  const SizedBox(height: 16),
                  CustomDropdown<String>(
                    value: _selectedDiets,
                    hintText: 'Escolha uma dieta',
                    items: CalculationImcService.listDiets(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDiets = newValue;
                      });
                    },
                    labelText: 'Dieta',
                  ),
                  const SizedBox(height: 5),
                  CustomDropdown<String>(
                    value: _selectedDietsComplements2,
                    hintText: 'Escolha uma dieta',
                    items: CalculationImcService.listDietsComplements(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDietsComplements2 = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomDropdown<String>(
                    value: _selectedDietsComplements3,
                    hintText: 'Escolha uma dieta',
                    items: CalculationImcService.listDietsComplements(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDietsComplements3 = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  CustomDropdown<String>(
                    value: _selectedDietsComplements4,
                    hintText: 'Escolha uma dieta',
                    items: CalculationImcService.listDietsComplements(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDietsComplements4 = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  if (isButtonSelectedRevisita)
                    CustomInputField(
                      controller: _quantidadeDietaConsumidosController,
                      labelText: 'Quantidade de dieta consumidos (%)',
                      hintText: 'Ex: 50%',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultColumn() {
    if (_resultadoIMC == null) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.calculate, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Resultado aparecerá aqui',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha os campos e clique em "Calcular" para ver o resultado do IMC',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Seu Resultado',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: MyColors.myPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'IMC',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.blue.shade700,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _resultadoIMC!,
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'kg/m²',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        _classificacaoIMC == 'Abaixo do peso (OMS, 1995)' ||
                            _classificacaoIMC == 'Abaixo do peso (OPAS, 2002)'
                        ? Colors.orange.shade50
                        : _classificacaoIMC == 'Peso normal (OMS, 1995)' ||
                              _classificacaoIMC == 'Peso eutrófia (OPAS, 2002)'
                        ? Colors.green.shade50
                        : _classificacaoIMC == 'Sobrepeso (OMS, 1995)' ||
                              _classificacaoIMC == 'Sobrepeso (OPAS, 2002)'
                        ? Colors.orange.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          _classificacaoIMC == 'Abaixo do peso (OMS, 1995)' ||
                              _classificacaoIMC == 'Abaixo do peso (OPAS, 2002)'
                          ? Colors.orange.shade200
                          : _classificacaoIMC == 'Peso normal (OMS, 1995)' ||
                                _classificacaoIMC ==
                                    'Peso eutrófia (OPAS, 2002)'
                          ? Colors.green.shade200
                          : _classificacaoIMC == 'Sobrepeso (OMS, 1995)' ||
                                _classificacaoIMC == 'Sobrepeso (OPAS, 2002)'
                          ? Colors.orange.shade200
                          : Colors.red.shade200,
                    ),
                  ),
                  child: Text(
                    _classificacaoIMC!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color:
                          _classificacaoIMC == 'Abaixo do peso (OMS, 1995)' ||
                              _classificacaoIMC == 'Abaixo do peso (OPAS, 2002)'
                          ? Colors.orange.shade700
                          : _classificacaoIMC == 'Peso normal (OMS, 1995)' ||
                                _classificacaoIMC ==
                                    'Peso eutrófia (OPAS, 2002)'
                          ? Colors.green.shade700
                          : _classificacaoIMC == 'Sobrepeso (OMS, 1995)' ||
                                _classificacaoIMC == 'Sobrepeso (OPAS, 2002)'
                          ? Colors.orange.shade700
                          : Colors.red.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Peso Ideal para sua Altura',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: MyColors.myPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Text(
                    _faixaDePesoIdeal!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.orange.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CustomInputField(
                  controller: _imcIdealController,
                  labelText: 'IMC ideal (kg/m²)',
                  hintText: 'Ex: imc ideal',
                  suffix: 'kg/m²',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _necessidadeCaloricaMinController,
                  labelText: 'Necesidade calorica minima (m)',
                  hintText: 'Ex: necessidade calorica',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                Text(
                  'Calorias Minimas: $_calculoCaloricaMin kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyColors.myPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _necessidadeCaloricaMaxController,
                  labelText: 'Necesidade calorica maxima (m)',
                  hintText: 'Ex: necessidade calorica',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                Text(
                  'Calorias Maximas: $_calculoCaloricaMax kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyColors.myPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _necessidadeProteicaMinController,
                  labelText: 'Necesidade proteica minima (m)',
                  hintText: 'Ex: necessidade proteica',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                Text(
                  'Proteinas Minimas: $_calculoProteicaMin g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyColors.myPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                CustomInputField(
                  controller: _necessidadeProteicaMaxController,
                  labelText: 'Necesidade proteica maxima (m)',
                  hintText: 'Ex: necessidade proteica',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                Text(
                  'Proteinas Maximas: $_calculoProteicaMax g',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyColors.myPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  onPressed: () {
                    _calcularCalorias();
                  },
                  title: 'Recalcular',
                  titleColor: Colors.white,
                  buttonColor: MyColors.myPrimary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 60,
          child: CustomButton(
            onPressed: () {
              if (!_validateRequiredFields()) {
                return;
              }

              final assessmentData = NutritionalAssessmentData(
                idade: _idadeController.text,
                peso: _pesoController.text,
                altura: _alturaController.text,
                resultadoIMC: _resultadoIMC,
                classificacaoIMC: _classificacaoIMC,
                faixaDePesoIdeal: _faixaDePesoIdeal,
                hdPatient: _hdPatientController.text,
                apPatient: _apPatientController.text,
                situationPatient: _situationPatientController.text,
                nrTriagem: _nrTriagem,
                selectedEvolution: _selectedEvolution,
                necessidadeCaloricaMin: _necessidadeCaloricaMinController.text,
                necessidadeCaloricaMax: _necessidadeCaloricaMaxController.text,
                necessidadeProteicaMin: _necessidadeProteicaMinController.text,
                necessidadeProteicaMax: _necessidadeProteicaMaxController.text,
                calculoCaloricaMin: _calculoCaloricaMin,
                calculoCaloricaMax: _calculoCaloricaMax,
                calculoProteicaMin: _calculoProteicaMin,
                calculoProteicaMax: _calculoProteicaMax,
                selectedDiets: _selectedDiets,
                selectedSuplements: _selectedSuplements,
                selectedDietsComplements2: _selectedDietsComplements2,
                selectedDietsComplements3: _selectedDietsComplements3,
                selectedDietsComplements4: _selectedDietsComplements4,
                quantidadeSuplements: _quantidadeSuplementsController.text,
                quantidadeSuplementsConsumidos:
                    _quantidadeSuplementsConsumidosController.text,
                quantidadeDietaConsumidos:
                    _quantidadeDietaConsumidosController.text,
                imcIdeal: _imcIdealController.text,
              );

              Navigator.pushNamed(
                context,
                RouteGenerator.nutritionalAssessment,
                arguments: assessmentData,
              );
            },
            title: "Gerar Avaliação Nutricional",
            titleColor: _areBasicFieldsFilled() ? Colors.white : Colors.grey,
            buttonColor: _areBasicFieldsFilled()
                ? MyColors.myPrimary
                : Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
