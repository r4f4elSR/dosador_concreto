import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/calc.dart';

final uuid = Uuid();

enum Conditions { alto, medio, baixo }

class PagMixCreate extends StatefulWidget {
  const PagMixCreate({super.key});

  @override
  State<PagMixCreate> createState() => _PagMixCreateState();
}

class _PagMixCreateState extends State<PagMixCreate> {
  Conditions? _conditionItem = .alto;
  List myMixes = [];
  List<Data> myDatas = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textController = TextEditingController();
  final _cimController = TextEditingController();
  final _argController = TextEditingController();
  final _abtController = TextEditingController();

  double? _selectedFck;
  Cim? _selectedCim;
  double? _selectedArg;
  int? _selectedAbt;

  List<Data> get myDatasFiltrados {
    return myDatas.where((data) {
      if (!data.ativo) return false;

      if (_selectedCim != null && data.cim != _selectedCim) {
        return false;
      }

      if (_selectedArg != null && data.argAr != _selectedArg) {
        return false;
      }

      if (_selectedAbt != null && data.abt != _selectedAbt) {
        return false;
      }

      return true;
    }).toList();
  }

  List<Data> _filtrar({Cim? cim, double? arg, int? abt}) {
    return myDatas.where((data) {
      if (!data.ativo) return false;

      if (cim != null && data.cim != cim) return false;
      if (arg != null && data.argAr != arg) return false;
      if (abt != null && data.abt != abt) return false;

      return true;
    }).toList();
  }

  bool _grupoValido(List<Data> grupo) {
    if (grupo.length < 2) return false;

    return grupo.map((d) => d.mix.ac).toSet().length >= 2;
  }

  bool _existeGrupoValido({Cim? cim, double? arg, int? abt}) {
    final dados = _filtrar(cim: cim, arg: arg, abt: abt);

    final grupos = <String, List<Data>>{};

    for (final d in dados) {
      final chave = '${d.cim.hashCode}|${d.argAr}|${d.abt}';

      grupos.putIfAbsent(chave, () => []).add(d);
    }

    return grupos.values.any(_grupoValido);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('boxDados');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, child) {
        myMixes = (box.get('mixes') as List?)?.cast<Mixs>() ?? [];
        myDatas = (box.get('datas') as List?)?.cast<Data>() ?? [];

        return Form(
          key: _formKey,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Novo traço'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(
                24.0,
                24.0,
                24.0,
                80.0, // espaço para o FloatingActionButton
              ),
              children: [
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do traço',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Escreva um nome para o traço';
                    }
                    return null;
                  },
                ),
                Divider(height: 70),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 2,
                      child: DropdownMenuTheme(
                        data: DropdownMenuThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        child: DropdownMenuFormField<Cim>(
                          controller: _cimController,
                          menuHeight: 280,
                          hintText: 'Tipo do cimento',
                          label: const Text('Cimento'),
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um cimento';
                            }
                            return null;
                          },
                          dropdownMenuEntries: [
                            for (final cim
                                in myDatas
                                    .map((e) => e.cim)
                                    .whereType<Cim>()
                                    .toSet())
                              DropdownMenuEntry(
                                value: cim,
                                label: cim.cimStrg,
                                enabled: _existeGrupoValido(
                                  cim: cim,
                                  arg: _selectedArg,
                                  abt: _selectedAbt,
                                ),
                              ),
                          ],
                          onSelected: (value) {
                            setState(() {
                              _selectedCim = value;
                            });
                          },
                          trailingIcon: _selectedCim == null
                              ? const Icon(Icons.arrow_drop_down)
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedCim = null;
                                      _cimController.clear();
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.close, size: 20),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: DropdownMenuTheme(
                        data: DropdownMenuThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        child: DropdownMenuFormField<double>(
                          menuHeight: 280,
                          hintText: 'fck',
                          label: Text('Resistência'),
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) =>
                              value == null ? 'Selecione a resistência' : null,
                          dropdownMenuEntries: [
                            for (var i = 10; i <= 50; i++)
                              DropdownMenuEntry(value: i * 1, label: '$i MPa'),
                          ],
                          onSelected: (value) {
                            setState(() {
                              _selectedFck = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: DropdownMenuTheme(
                        data: DropdownMenuThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        child: DropdownMenuFormField<double>(
                          controller: _argController,
                          menuHeight: 280,
                          hintText: 'Porcentagem de argamassa',
                          label: Text('Teor de argamassa'),
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) => value == null
                              ? 'Selecione o teor de argamassa'
                              : null,
                          dropdownMenuEntries: [
                            for (final argAr
                                in myDatas
                                    .map((e) => e.argAr)
                                    .whereType<double>()
                                    .toSet()
                                    .toList()
                                  ..sort())
                              DropdownMenuEntry(
                                value: argAr,
                                label:
                                    '${(argAr * 100).toStringAsFixed(0).replaceAll('.', ',')}%',
                                enabled: _existeGrupoValido(
                                  cim: _selectedCim,
                                  arg: argAr,
                                  abt: _selectedAbt,
                                ),
                              ),
                          ],
                          onSelected: (value) {
                            setState(() {
                              _selectedArg = value;
                            });
                          },
                          trailingIcon: _selectedArg == null
                              ? const Icon(Icons.arrow_drop_down)
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedArg = null;
                                      _argController.clear();
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.close, size: 20),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownMenuTheme(
                        data: DropdownMenuThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        child: DropdownMenuFormField<int>(
                          controller: _abtController,
                          menuHeight: 280,
                          hintText: 'Abatimento do tronco de cone',
                          label: Text('Abatimento'),
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) =>
                              value == null ? 'Selecione o abatimento' : null,
                          dropdownMenuEntries: [
                            for (final abt
                                in myDatas
                                    .map((e) => e.abt)
                                    .whereType<int>()
                                    .toSet()
                                    .toList()
                                  ..sort())
                              DropdownMenuEntry(
                                value: abt,
                                label: '$abt mm',
                                enabled: _existeGrupoValido(
                                  cim: _selectedCim,
                                  arg: _selectedArg,
                                  abt: abt,
                                ),
                              ),
                          ],
                          onSelected: (value) {
                            setState(() {
                              _selectedAbt = value;
                            });
                          },
                          trailingIcon: _selectedAbt == null
                              ? const Icon(Icons.arrow_drop_down)
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedAbt = null;
                                      _abtController.clear();
                                    });
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(0),
                                    child: Icon(Icons.close, size: 20),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Text(
                  'Condições de preparo do concreto',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 15),
                RadioGroup<Conditions>(
                  groupValue: _conditionItem,
                  onChanged: (Conditions? value) {
                    setState(() {
                      _conditionItem = value;
                    });
                  },
                  child: const Column(
                    children: <Widget>[
                      RadioListTile<Conditions>(
                        value: Conditions.alto,
                        title: Text('Alto controle'),
                        subtitle: Text(
                          'Produção em massa, com controle rigoroso da umidade dos agregados e com equipe bem treinada.',
                        ),
                        isThreeLine: true,
                      ),
                      RadioListTile<Conditions>(
                        value: Conditions.medio,
                        title: Text('Médio controle'),
                        subtitle: Text(
                          'Produção em volume, com controle rigoroso da umidade dos agregados e com equipe bem treinada.',
                        ),
                        isThreeLine: true,
                      ),
                      RadioListTile<Conditions>(
                        value: Conditions.baixo,
                        title: Text('Baixo controle'),
                        subtitle: Text(
                          "Produção em volume, com equipe nova em fase de adaptação.",
                        ),
                        isThreeLine: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final fck = _selectedFck!;
                      final cim = _selectedCim!;
                      final arg = _selectedArg!;
                      final abt = _selectedAbt!;
                      final con = _conditionItem!;

                      final k1 = fitAbrams(abramsList(myDatasFiltrados)).k1;
                      final k2 = fitAbrams(abramsList(myDatasFiltrados)).k2;
                      final k3 = fitLyse(lyseList(myDatasFiltrados)).k3;
                      final k4 = fitLyse(lyseList(myDatasFiltrados)).k4;

                      final mix = calcMix(fck, con, k1, k2, k3, k4, arg);
                      myMixes.add(
                        Mixs(
                          id: uuid.v4(),
                          nom: _textController.text,
                          cim: cim,
                          res: fck,
                          arg: arg,
                          abt: abt,
                          mix: mix,
                        ),
                      );
                      await box.put('mixes', myMixes);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${myMixes.last.nom} foi criado'),
                          behavior: .floating,
                        ),
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    textStyle: TextStyle(fontSize: 17),
                  ),
                  child: const Text('Gerar traço'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
