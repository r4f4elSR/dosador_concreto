import 'package:dosador_concreto/pag_legal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:dosador_concreto/dialog.dart';
import 'package:dosador_concreto/pag_unitscreate.dart';
import 'package:dosador_concreto/lists.dart';

class PagSettings extends StatefulWidget {
  const PagSettings({super.key});

  @override
  State<PagSettings> createState() => _PagSettingsState();
}

class _PagSettingsState extends State<PagSettings> {
  String? selectedValue = 'azul';

  final box = Hive.box('boxDados');

  @override
  void initState() {
    super.initState();

    final settings = box.get('settings', defaultValue: mySettings);

    mySettings = List<String?>.from(settings);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        context.go('/');
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go('/'),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Aparência',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              SwitchListTile(
                title: const Text('Tema escuro'),
                visualDensity: VisualDensity.standard,
                value: mySettings[1] == 'dark',
                onChanged: (value) async {
                  setState(() {
                    mySettings[1] = value ? 'dark' : 'light';
                  });
                  await box.put('settings', mySettings);
                },
              ),
              ListTile(
                title: const Text('Cor do tema'),
                visualDensity: VisualDensity.standard,
                trailing: SizedBox(
                  width: 140,
                  child: DropdownMenu<String>(
                    initialSelection: mySettings[0],
                    onSelected: (value) async {
                      setState(() {
                        mySettings[0] = value;
                      });
                      await box.put('settings', mySettings);
                    },
                    dropdownMenuEntries: [
                      DropdownMenuEntry(
                        value: 'azul',
                        label: 'Azul',
                        leadingIcon: Icon(
                          Icons.circle,
                          color: Color(0xFF00639B),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'roxo',
                        label: 'Roxo',
                        leadingIcon: Icon(
                          Icons.circle,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'laranja',
                        label: 'Laranja',
                        leadingIcon: Icon(
                          Icons.circle,
                          color: Color(0xFFB35C00),
                        ),
                      ),
                      DropdownMenuEntry(
                        value: 'verde',
                        label: 'Verde',
                        leadingIcon: Icon(
                          Icons.circle,
                          color: Color(0xFF006A6A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Unidades',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: const Text('Unidades personalizadas'),
                visualDensity: VisualDensity.standard,
                onTap: () {
                  showFullscreenDialog(
                    context: context,
                    child: const PagUnitsCreate(),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Sobre',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                title: const Text('Termos de Uso'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 800,
                        height: 700,
                        child: PagLegal(
                          title: 'Termos de Uso',
                          assetPath: 'assets/texts/terms_of_use.md',
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Política de Privacidade'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      clipBehavior: Clip.antiAlias,
                      child: SizedBox(
                        width: 800,
                        height: 700,
                        child: PagLegal(
                          title: 'Política de Privacidade',
                          assetPath: 'assets/texts/privacy_policy.md',
                        ),
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Text('Licenças'),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Your App Name',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
