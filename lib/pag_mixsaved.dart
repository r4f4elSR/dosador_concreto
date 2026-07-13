import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:dosador_concreto/my_classes.dart';
import 'package:dosador_concreto/lists.dart';

final uuid = Uuid();

class PagMixSaved extends StatefulWidget {
  const PagMixSaved({super.key});

  @override
  State<PagMixSaved> createState() => _PagMixSavedState();
}

class _PagMixSavedState extends State<PagMixSaved> {
  final Map<String, Unidades> unidadesView = {};

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('boxDados');

    return ValueListenableBuilder(
      valueListenable: box.listenable(),
      builder: (context, box, child) {
        final myMixes = box.get('mixes') ?? [];

        Units myUnits = box.get('units', defaultValue: customUnits) as Units;

        if (myMixes.isEmpty) {
          return const Center(
            child: Text('Aperte em "+" para criar um traço.'),
          );
        } else {
          return ListView.builder(
            itemCount: myMixes.length,
            padding: const EdgeInsets.fromLTRB(
              16.0,
              8.0,
              16.0,
              80.0, // espaço para o FloatingActionButton
            ),
            itemBuilder: (BuildContext context, int index) {
              final unidade = unidadesView.putIfAbsent(
                myMixes[index].id,
                () => Unidades.massa,
              );

              List traco = switch (unidadesView[myMixes[index].id]) {
                .massa => [
                  '1 kg',
                  '${myMixes[index].mix.aStrg} kg',
                  '${myMixes[index].mix.pStrg} kg',
                  '${myMixes[index].mix.acStrg} kg',
                ],
                .custom => [
                  '1 ${myUnits.unc.un}',
                  '${double.parse((((myMixes[index].mix.aAr) * (myUnits.unc.fac)) / myUnits.una.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.una.un}',
                  '${double.parse((((myMixes[index].mix.pAr) * (myUnits.unc.fac)) / myUnits.unp.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.unp.un}',
                  '${double.parse((((myMixes[index].mix.acAr) * (myUnits.unc.fac)) / myUnits.unac.fac).toStringAsFixed(2)).toString().replaceAll('.', ',')} ${myUnits.unac.un}',
                ],
                _ => [
                  '1 kg',
                  '${myMixes[index].mix.aStrg} kg',
                  '${myMixes[index].mix.pStrg} kg',
                  '${myMixes[index].mix.acStrg} kg',
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
                  key: ValueKey(myMixes[index].id),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerLow,
                  title: Text(myMixes[index].nom),
                  subtitle: Text(myMixes[index].mix.toString()),
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
                                '${myMixes[index].cim.cimStrg}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                'fck: ${myMixes[index].res.toString().replaceAll('.', ',')} MPa  |  \u03b1: ${myMixes[index].argStr}%  |  Slump: ${myMixes[index].abt} mm',
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
                                unidadesView[myMixes[index].id] =
                                    selection.first;
                              });
                            },
                          ),
                          OutlinedButton(
                            onPressed: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Apagar traço?'),
                                content: const Text(
                                  'Essa ação irá apagar completamente o traço salvo. Tem certeza que deseja apagar o traço permanentemente?',
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
                                            '${myMixes[index].nom} foi apagado',
                                          ),
                                          behavior: .floating,
                                        ),
                                      );
                                      myMixes.removeAt(index);
                                      await box.put('mixes', myMixes);
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
