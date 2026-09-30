import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(package) {
    return MaterialApp(
      title: 'Montador de Perfil de Treino',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const WorkoutProfileScreen(),
    );
  }
}

class WorkoutProfileScreen extends StatefulWidget {
  const WorkoutProfileScreen({super.key});

  @override
  State<WorkoutProfileScreen> createState() => _WorkoutProfileScreenState();
}

class _WorkoutProfileScreenState extends State<WorkoutProfileScreen> {
  String? _selectedObjective;
  String? _selectedLevel;
  final List<String> _selectedDietaryRestrictions = [];
  final List<String> _allergies = [];
  double _dailyTime = 60;
  int? _weeklyFrequency;
  bool _waterNotifications = false;
  bool _acceptedTerms = false;

  final TextEditingController _allergyController = TextEditingController();

  void _addAllergy() {
    final text = _allergyController.text.trim();
    if (text.isEmpty) return;

    final lowerText = text.toLowerCase();
    final alreadyExists = _allergies.any((a) => a.toLowerCase() == lowerText);

    if (!alreadyExists) {
      setState(() {
        _allergies.add(text);
        _allergyController.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Esta alergia já foi adicionada.')),
      );
    }
  }

  void _validateAndSubmit() {
    List<String> errors = [];

    if (_selectedObjective == null) {
      errors.add('Objetivo do treino não selecionado.');
    }
    if (_selectedLevel == null) {
      errors.add('Nível não informado.');
    }
    if (_weeklyFrequency == null) {
      errors.add('Frequência semanal não selecionada.');
    }
    if (!_acceptedTerms) {
      errors.add('Termos não aceitos.');
    }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erros de Validação'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: errors.map((error) => Text('• $error')).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    _showSummaryBottomSheet();
  }

  void _showSummaryBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Seu perfil de treino',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              _buildSummaryItem('Objetivo', _selectedObjective),
              _buildSummaryItem('Nível', _selectedLevel),
              _buildSummaryItem(
                'Restrições alimentares',
                _selectedDietaryRestrictions.isEmpty
                    ? 'Nenhuma'
                    : _selectedDietaryRestrictions.join(', '),
              ),
              _buildSummaryItem(
                'Alergias',
                _allergies.isEmpty ? 'Nenhuma' : _allergies.join(', '),
              ),
              _buildSummaryItem(
                'Tempo diário',
                '${_dailyTime.round()} minutos',
              ),
              _buildSummaryItem(
                'Frequência',
                '$_weeklyFrequency dias por semana',
              ),
              _buildSummaryItem(
                'Notificações de água',
                _waterNotifications ? 'Ativadas' : 'Desativadas',
              ),
              _buildSummaryItem(
                'Termos',
                _acceptedTerms ? 'Aceitos' : 'Não aceitos',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          Text(value ?? '-', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Montador de Perfil de Treino')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OBJETIVO DO TREINO',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            WidthSegmentedButton(
              selectedObjective: _selectedObjective,
              onSelectionChanged: (value) {
                setState(() {
                  _selectedObjective = value;
                });
              },
            ),
            const SizedBox(height: 24),

            Text(
              'NÍVEL DE EXPERIÊNCIA',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Row(
              children: ['Iniciante', 'Intermediário', 'Avançado'].map((level) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ChoiceChip(
                    label: Text(level),
                    selected: _selectedLevel == level,
                    onSelected: (selected) {
                      setState(() {
                        _selectedLevel = selected ? level : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Text(
              'RESTRIÇÕES ALIMENTARES',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children:
                  [
                    'Vegetariano',
                    'Vegano',
                    'Sem lactose',
                    'Sem glúten',
                    'Low Carb',
                  ].map((restriction) {
                    final isSelected = _selectedDietaryRestrictions.contains(
                      restriction,
                    );
                    return FilterChip(
                      label: Text(restriction),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedDietaryRestrictions.add(restriction);
                          } else {
                            _selectedDietaryRestrictions.remove(restriction);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),

            Text('ALERGIAS', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _allergyController,
                    decoration: const InputDecoration(
                      hintText: 'Digite uma alergia...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addAllergy,
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _allergies.map((allergy) {
                return InputChip(
                  label: Text(allergy),
                  onDeleted: () {
                    setState(() {
                      _allergies.remove(allergy);
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            Text('TEMPO DIÁRIO', style: Theme.of(context).textTheme.titleSmall),
            Slider(
              value: _dailyTime,
              min: 15,
              max: 120,
              divisions: 21,
              label: '${_dailyTime.round()} min',
              onChanged: (value) {
                setState(() {
                  _dailyTime = value;
                });
              },
            ),
            Center(
              child: Text(
                '${_dailyTime.round()} minutos',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'FREQUÊNCIA SEMANAL',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Column(
              children: [2, 3, 4, 5, 6].map((days) {
                return RadioListTile<int>(
                  title: Text('$days dias por semana'),
                  value: days,
                  groupValue: _weeklyFrequency,
                  onChanged: (value) {
                    setState(() {
                      _weeklyFrequency = value;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Receber notificações de água'),
              subtitle: const Text('Lembretes durante o dia'),
              secondary: const Icon(Icons.local_drink),
              value: _waterNotifications,
              onChanged: (value) {
                setState(() {
                  _waterNotifications = value;
                });
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text(
                'Aceito os termos e condições para geração do plano de treino.',
              ),
              value: _acceptedTerms,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  _acceptedTerms = value ?? false;
                });
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _validateAndSubmit,
                child: const Text('GERAR PLANO'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _allergyController.dispose();
    super.dispose();
  }
}

class WidthSegmentedButton extends StatelessWidget {
  final String? selectedObjective;
  final ValueChanged<String?> onSelectionChanged;
  const WidthSegmentedButton({
    super.key,
    required this.selectedObjective,
    required this.onSelectionChanged,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ToggleButtons(
          direction: Axis.horizontal,
          onPressed: (index) {
            final options = ['Emagrecimento', 'Hipertrofia', 'Condicionamento'];
            onSelectionChanged(options[index]);
          },
          constraints: BoxConstraints.expand(
            width: (constraints.maxWidth - 4) / 3,
            height: 40,
          ),
          isSelected: [
            selectedObjective == 'Emagrecimento',
            selectedObjective == 'Hipertrofia',
            selectedObjective == 'Condicionamento',
          ],
          borderRadius: BorderRadius.circular(20),
          children: const [
            Text('Emagrec.'),
            Text('Hipertrofia'),
            Text('Condicion.'),
          ],
        );
      },
    );
  }
}
