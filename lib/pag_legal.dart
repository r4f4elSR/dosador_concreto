import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PagLegal extends StatefulWidget {
  final String title;
  final String assetPath;

  const PagLegal({super.key, required this.title, required this.assetPath});

  @override
  State<PagLegal> createState() => _PagLegalState();
}

class _PagLegalState extends State<PagLegal> {
  String? _markdown;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    try {
      final markdown = await rootBundle.loadString(widget.assetPath);

      if (!mounted) return;

      setState(() {
        _markdown = markdown;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return const Center(
        child: Text('Não foi possível carregar o documento.'),
      );
    }

    if (_markdown == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Markdown(
      data: _markdown!,
      selectable: true,
      padding: const EdgeInsets.all(24),
      styleSheet: _markdownStyle,
    );
  }

  MarkdownStyleSheet get _markdownStyle {
    final theme = Theme.of(context);

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      h1: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      h1Padding: const EdgeInsets.only(bottom: 16),
      h2: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      h2Padding: const EdgeInsets.only(top: 24, bottom: 8),
      p: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
      listBullet: theme.textTheme.bodyMedium,
      blockSpacing: 12,
    );
  }
}
