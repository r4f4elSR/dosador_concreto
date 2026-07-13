import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/lists.dart';

class PagUnitsCreate extends StatefulWidget {
  const PagUnitsCreate({super.key});

  @override
  State<PagUnitsCreate> createState() => _PagUnitsCreateState();
}

class _PagUnitsCreateState extends State<PagUnitsCreate> {
  List<String> comp = ['Cimento', 'Miúdo', 'Graúdo', 'Água'];

  final _formKey = GlobalKey<FormState>();

  final box = Hive.box('boxDados');

  late List<TextEditingController> unitControllers;
  late List<TextEditingController> factorControllers;

  @override
  void dispose() {
    for (final controller in unitControllers) {
      controller.dispose();
    }

    for (final controller in factorControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    customUnits = box.get('units', defaultValue: customUnits) as Units;

    unitControllers = List.generate(
      customUnits.uList.length,
      (index) => TextEditingController(text: customUnits.uList[index].un),
    );

    factorControllers = List.generate(
      customUnits.uList.length,
      (index) =>
          TextEditingController(text: customUnits.uList[index].fac.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Unidades'),
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
                  Units customUnits = Units(
                    unc: Unit(
                      un: unitControllers[0].text,
                      fac: double.parse(
                        factorControllers[0].text.replaceAll(',', '.'),
                      ),
                    ),
                    una: Unit(
                      un: unitControllers[1].text,
                      fac: double.parse(
                        factorControllers[1].text.replaceAll(',', '.'),
                      ),
                    ),
                    unp: Unit(
                      un: unitControllers[2].text,
                      fac: double.parse(
                        factorControllers[2].text.replaceAll(',', '.'),
                      ),
                    ),
                    unac: Unit(
                      un: unitControllers[3].text,
                      fac: double.parse(
                        factorControllers[3].text.replaceAll(',', '.'),
                      ),
                    ),
                  );
                  await box.put('units', customUnits);
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) {
            return const SizedBox(height: 24.0);
          },
          itemCount: customUnits.uList.length + 1,
          padding: const EdgeInsets.all(24),
          itemBuilder: (BuildContext context, int index) {
            if (index < customUnits.uList.length) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  SizedBox(
                    height: 50,
                    width: 80,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        comp[index],
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      maxLength: 3,
                      textCapitalization: TextCapitalization.none,
                      controller: unitControllers[index],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Unidade',
                        hintText: 'Nome da unidade',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                        LengthLimitingTextInputFormatter(3),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(
                            text: newValue.text.toLowerCase(),
                          );
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe um nome.';
                        }
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: factorControllers[index],
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        labelText: 'Conversão',
                        hintText: 'Fator de conversão',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*([.,]\d*)?$'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe um fator';
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
              );
            }
            return Text(
              'O fator de conversão é a quantidade de unidades de massa que corresponde a 1 unidade personalizada. Por exemplo, no valor padrão de cimento o fator de conversão é 50 porque 1 saco corresponde a 50 kg de cimento.',
              //style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.justify,
            );
          },
        ),
      ),
    );
  }
}
