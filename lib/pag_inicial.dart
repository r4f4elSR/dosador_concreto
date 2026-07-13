import 'package:dosador_concreto/pag_datacreate.dart';
import 'package:dosador_concreto/pag_datasaved.dart';
import 'package:dosador_concreto/pag_mixcreate.dart';
import 'package:dosador_concreto/pag_mixsaved.dart';
import 'package:dosador_concreto/dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PagInicial extends StatefulWidget {
  const PagInicial({super.key});

  @override
  State<PagInicial> createState() => _PagInicialState();
}

class _PagInicialState extends State<PagInicial>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  late final AnimationController _fabController;

  late final Animation<double> _rotation;

  late final Animation<double> _mixOpacity;
  late final Animation<Offset> _mixOffset;

  late final Animation<double> _dataOpacity;
  late final Animation<Offset> _dataOffset;

  bool _isOpen = false;
  int _selectedIndex = 0;

  final List<Widget> _pages = const [PagMixSaved(), PagDataSaved()];

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _rotation = Tween<double>(
      begin: 0,
      end: 0.125, //45°
    ).animate(CurvedAnimation(parent: _fabController, curve: Curves.easeInOut));

    _mixOpacity = CurvedAnimation(
      parent: _fabController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
    );

    _mixOffset = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _dataOpacity = CurvedAnimation(
      parent: _fabController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );

    _dataOffset = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _toggleFab() {
    setState(() => _isOpen = !_isOpen);

    if (_isOpen) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void _closeFab() {
    if (!_isOpen) return;

    setState(() => _isOpen = false);
    _fabController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
      ),
      body: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _closeFab,
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _selectedIndex = index);
              },
              children: _pages,
            ),
          ),
          Positioned(
            bottom: 140,
            right: 15,
            child: FadeTransition(
              opacity: _mixOpacity,
              child: SlideTransition(
                position: _mixOffset,
                child: IgnorePointer(
                  ignoring: !_isOpen,
                  child: FloatingActionButton.extended(
                    shape: StadiumBorder(),
                    elevation: 0,
                    heroTag: 'mix',
                    onPressed: () {
                      _toggleFab();

                      showFullscreenDialog(
                        context: context,
                        child: const PagMixCreate(),
                      );
                    },
                    icon: const Icon(Icons.format_list_bulleted_add),
                    label: const Text('Novo traço'),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 15,
            child: FadeTransition(
              opacity: _dataOpacity,
              child: SlideTransition(
                position: _dataOffset,
                child: IgnorePointer(
                  ignoring: !_isOpen,
                  child: FloatingActionButton.extended(
                    shape: StadiumBorder(),
                    elevation: 0,
                    heroTag: 'data',
                    onPressed: () {
                      _toggleFab();

                      showFullscreenDialog(
                        context: context,
                        child: const PagDataCreate(),
                      );
                    },
                    icon: const Icon(Icons.storage_rounded),
                    label: const Text('Novo dado'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'Traços'),
          NavigationDestination(icon: Icon(Icons.filter_alt), label: 'Dados'),
        ],
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                elevation: 2,
                heroTag: 'settings',
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                shape: const CircleBorder(),
                onPressed: () => context.go('/settings'),
                child: const Icon(Icons.settings),
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                elevation: 2,
                heroTag: 'add',
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: const CircleBorder(),
                onPressed: _toggleFab,
                child: RotationTransition(
                  turns: _rotation,
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
