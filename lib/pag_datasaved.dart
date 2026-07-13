import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/lists.dart';

final uuid = Uuid();

class PagDataSaved extends StatefulWidget {
  const PagDataSaved({super.key});

  @override
  State<PagDataSaved> createState() => _PagDataSavedState();
}

class _PagDataSavedState extends State<PagDataSaved> {
  final Map<String, Unidades> unidadesView = {};

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('boxDados');
    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, child) {
        final myDatas = box.get('datas') ?? [];

        Units myUnits = box.get('units', defaultValue: customUnits) as Units;

        if (myDatas.isEmpty) {
          return const Center(
            child: Text('Aperte em "+" para adicionar um dado.'),
          );
        } else {
          return ListView.builder(
            itemCount: myDatas.length,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 80.0),
            itemBuilder: (BuildContext context, int index) {
              final unidade = unidadesView.putIfAbsent(
                myDatas[index].id,
                () => Unidades.massa,
              );

              List traco = switch (unidadesView[myDatas[index].id]) {
                .massa => [
                  '1 kg',
                  '${myDatas[index].mix.aStrg} kg',
                  '${myDatas[index].mix.pStrg} kg',
                  '${myDatas[index].mix.acStrg} kg',
                ],
                .custom => [
                  '1 ${myUnits.unc.un}',
                  '${double.parse((((myDatas[index].mix.aAr) * (myUnits.unc.fac)) / myUnits.una.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.una.un}',
                  '${double.parse((((myDatas[index].mix.pAr) * (myUnits.unc.fac)) / myUnits.unp.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.unp.un}',
                  '${double.parse((((myDatas[index].mix.acAr) * (myUnits.unc.fac)) / myUnits.unac.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.unac.un}',
                ],
                _ => [
                  '1 kg',
                  '${myDatas[index].mix.aStrg} kg',
                  '${myDatas[index].mix.pStrg} kg',
                  '${myDatas[index].mix.acStrg} kg',
                ],
              };

              return Card(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                elevation: 0,
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0), // Rounded corners
                ),
                child: ExpansionTile(
                  key: ValueKey(myDatas[index].id),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow,
                  leading: Switch(
                    value: myDatas[index].ativo,
                    onChanged: (value) async {
                      myDatas[index].ativo = value;
                      await box.put('datas', myDatas);
                    },
                  ),
                  title: Text(myDatas[index].nom),
                  subtitle: Text(myDatas[index].mix.toString()),
                  children: <Widget>[
                    Divider(
                      height: 1.5,
                      thickness: 1.5,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        elevation: 0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 8.0,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${myDatas[index].cim.cimStrg}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'fck: ${myDatas[index].res.toString().replaceAll('.', ',')} MPa  |  \u03b1: ${myDatas[index].argArStr}%  |  Slump: ${myDatas[index].abt} mm',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      elevation: 0,
                      margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 8.0,
                        ),
                        child: Row(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [Text('${traco[0]}'), Text('Cimento')],
                            ),
                            Text(':'),
                            Column(
                              children: [Text('${traco[1]}'), Text('Miúdo')],
                            ),
                            Text(':'),
                            Column(
                              children: [Text('${traco[2]}'), Text('Graúdo')],
                            ),
                            Text(':'),
                            Column(
                              children: [Text('${traco[3]}'), Text('Água')],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                      child: OverflowBar(
                        alignment: MainAxisAlignment.end,
                        spacing: 8.0,
                        children: [
                          SegmentedButton<Unidades>(
                            segments: const [
                              ButtonSegment(
                                value: Unidades.massa,
                                label: Text('Massa'),
                              ),
                              ButtonSegment(
                                value: Unidades.custom,
                                label: Text('Outro'),
                              ),
                            ],
                            selected: {unidade},
                            onSelectionChanged: (selection) {
                              setState(() {
                                unidadesView[myDatas[index].id] =
                                    selection.first;
                              });
                            },
                          ),
                          OutlinedButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Apagar dado?'),
                                content: const Text(
                                  'Essa ação irá apagar completamente o dado salvo. Tem certeza que deseja apagar o dado permanentemente?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancelar'),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context, 'Sim');
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${myDatas[index].nom} foi apagado',
                                          ),
                                          behavior: .floating,
                                        ),
                                      );
                                      myDatas.removeAt(index);
                                      await box.put('datas', myDatas);
                                    },
                                    child: const Text('Sim'),
                                  ),
                                ],
                              ),
                            ),
                            child: const Text('Apagar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
