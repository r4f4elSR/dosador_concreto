import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/lists.dart';

final uuid = Uuid();

class PagDataCreate extends StatefulWidget {
  const PagDataCreate({super.key});

  @override
  State<PagDataCreate> createState() => _PagDataCreateState();
}

class _PagDataCreateState extends State<PagDataCreate> {
  List<Data> myDatas = [];

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _textControllerNom = TextEditingController();
  final TextEditingController _textControllerA = TextEditingController();
  final TextEditingController _textControllerP = TextEditingController();
  final TextEditingController _textControllerAc = TextEditingController();

  String? _selectedMarca;
  String? _selectedResc;
  String? _selectedTipo;
  double? _selectedFcm;
  int? _selectedAbt;

  @override
  void dispose() {
    _textControllerNom.dispose();
    _textControllerA.dispose();
    _textControllerP.dispose();
    _textControllerAc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('boxDados');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, child) {
        myDatas = (box.get('datas') as List?)?.cast<Data>() ?? [];

        return Form(
          key: _formKey,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Novo Dado'),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Closes the dialog
                },
              ),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      myDatas.add(
                        Data(
                          id: uuid.v4(),
                          nom: _textControllerNom.text,
                          cim: Cim(
                            marca: _selectedMarca!,
                            resc: _selectedResc!,
                            tipo: _selectedTipo!,
                          ),
                          res: _selectedFcm!,
                          abt: _selectedAbt,
                          mix: Mix(
                            a: double.parse(
                              _textControllerA.text.replaceAll(',', '.'),
                            ),
                            p: double.parse(
                              _textControllerP.text.replaceAll(',', '.'),
                            ),
                            ac: double.parse(
                              _textControllerAc.text.replaceAll(',', '.'),
                            ),
                          ),
                          ativo: true,
                        ),
                      );
                      await box.put('datas', myDatas);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${myDatas.last.nom} foi criado'),
                          behavior: .floating,
                        ),
                      );
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            ),
            body: ListView(
              padding: EdgeInsets.all(24),
              children: [
                TextFormField(
                  controller: _textControllerNom,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nome do dado',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Escreva um nome para o dado';
                    }
                    return null;
                  },
                ),
                Divider(height: 70),
                Text('Cimento', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 15),
                DropdownMenuTheme(
                  data: DropdownMenuThemeData(
                    inputDecorationTheme: InputDecorationTheme(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  child: DropdownMenuFormField<String>(
                    hintText: 'Fabricante do cimento',
                    label: Text('Marca'),
                    menuHeight: 280,
                    expandedInsets: EdgeInsets.zero,
                    validator: (value) {
                      if (value == null) {
                        return 'Selecione uma marca de cimento';
                      }
                      return null;
                    },
                    onSelected: (value) {
                      setState(() {
                        _selectedMarca = value;
                      });
                    },
                    dropdownMenuEntries: [
                      for (var m in marcasList)
                        DropdownMenuEntry(value: m, label: m),
                    ],
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      flex: 1,
                      child: DropdownMenuTheme(
                        data: DropdownMenuThemeData(
                          inputDecorationTheme: InputDecorationTheme(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        child: DropdownMenuFormField<String>(
                          hintText: 'Tipo de cimento',
                          label: Text('Sigla'),
                          menuHeight: 280,
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um tipo de cimento';
                            }
                            return null;
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedTipo = value;
                            });
                          },
                          dropdownMenuEntries: [
                            for (var s in siglaList)
                              DropdownMenuEntry(value: s, label: s),
                          ],
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
                        child: DropdownMenuFormField<String>(
                          hintText: 'Classe de resistência',
                          label: Text('Classe'),
                          menuHeight: 280,
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um tipo de cimento';
                            }
                            return null;
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedResc = value;
                            });
                          },
                          dropdownMenuEntries: [
                            for (var c in classeList)
                              DropdownMenuEntry(value: c, label: c),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Text('Concreto', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 15),
                Row(
                  spacing: 10,
                  children: [
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
                          hintText: 'fcm do concreto',
                          label: Text('Resistência'),
                          menuHeight: 280,
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um tipo de cimento';
                            }
                            return null;
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedFcm = value;
                            });
                          },
                          dropdownMenuEntries: [
                            for (var i = 10; i <= 65; i++)
                              DropdownMenuEntry(value: i * 1, label: '$i MPa'),
                          ],
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
                        child: DropdownMenuFormField<int>(
                          hintText: 'Abatimento do tronco de cone',
                          label: Text('Abatimento'),
                          menuHeight: 280,
                          expandedInsets: EdgeInsets.zero,
                          validator: (value) {
                            if (value == null) {
                              return 'Selecione um tipo de cimento';
                            }
                            return null;
                          },
                          onSelected: (value) {
                            setState(() {
                              _selectedAbt = value;
                            });
                          },
                          dropdownMenuEntries: [
                            for (var i = 1; i <= 22; i++)
                              DropdownMenuEntry(
                                value: i * 10,
                                label: '${i * 10} mm',
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Text('Traço', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 15),
                Row(
                  spacing: 10,
                  children: [
                    Text('1'),
                    Text(':'),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _textControllerA,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Miúdo',
                          hintText: 'Areia',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*([.,]\d*)?$'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Escreva um nome para o dado';
                          }
                          final numero = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (numero == null) {
                            return 'Valor inválido.';
                          }
                          if (numero <= 0) {
                            return 'O valor deve ser maior que zero.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text(':'),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _textControllerP,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Graúdo',
                          hintText: 'Pedra/brita',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*([.,]\d*)?$'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Escreva um nome para o dado';
                          }
                          final numero = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (numero == null) {
                            return 'Valor inválido.';
                          }
                          if (numero <= 0) {
                            return 'O valor deve ser maior que zero.';
                          }
                          return null;
                        },
                      ),
                    ),
                    Text(':'),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        controller: _textControllerAc,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          labelText: 'Água (a/c)',
                          hintText: 'Água',
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*([.,]\d*)?$'),
                          ),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Escreva um nome para o dado';
                          }
                          final numero = double.tryParse(
                            value.replaceAll(',', '.'),
                          );
                          if (numero == null) {
                            return 'Valor inválido.';
                          }
                          if (numero <= 0) {
                            return 'O valor deve ser maior que zero.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
