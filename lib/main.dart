import 'package:flutter/material.dart';

void main() {
  runApp(const FloriculturaApp());
}

class Registro {
  String flor;
  String cor;
  String fornecedor;

  Registro({required this.flor, required this.cor, required this.fornecedor});
}

class FloriculturaApp extends StatelessWidget {
  const FloriculturaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floricultura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const ListaPage(),
    );
  }
}

class ListaPage extends StatefulWidget {
  const ListaPage({super.key});

  @override
  State<ListaPage> createState() => _ListaPageState();
}

class _ListaPageState extends State<ListaPage> {
  final List<Registro> _registros = [
    Registro(flor: 'Rosa', cor: 'Vermelha', fornecedor: 'Jardim Sul'),
  ];

  Future<void> _cadastrar() async {
    final novo = await Navigator.push<Registro>(
      context,
      MaterialPageRoute(builder: (_) => const FormularioPage()),
    );
    if (novo != null) {
      setState(() => _registros.add(novo));
    }
  }

  Future<void> _editar(int index) async {
    final editado = await Navigator.push<Registro>(
      context,
      MaterialPageRoute(
        builder: (_) => FormularioPage(registro: _registros[index]),
      ),
    );
    if (editado != null) {
      setState(() => _registros[index] = editado);
    }
  }

  Future<void> _excluir(int index) async {
    final registro = _registros[index];
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Excluir registro'),
        content: Text('Remover "${registro.flor}" da lista?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmar == true) {
      setState(() => _registros.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floricultura'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: _registros.isEmpty
          ? const Center(child: Text('Nenhum registro cadastrado.'))
          : ListView.builder(
              itemCount: _registros.length,
              itemBuilder: (context, index) {
                final r = _registros[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.local_florist),
                    title: Text(r.flor),
                    subtitle:
                        Text('Cor: ${r.cor}\nFornecedor: ${r.fornecedor}'),
                    isThreeLine: true,
                    onTap: () => _editar(index),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Excluir',
                      onPressed: () => _excluir(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _cadastrar,
        tooltip: 'Novo registro',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormularioPage extends StatefulWidget {
  final Registro? registro;

  const FormularioPage({super.key, this.registro});

  @override
  State<FormularioPage> createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _florCtrl;
  late final TextEditingController _corCtrl;
  late final TextEditingController _fornecedorCtrl;

  bool get _editando => widget.registro != null;

  @override
  void initState() {
    super.initState();
    _florCtrl = TextEditingController(text: widget.registro?.flor ?? '');
    _corCtrl = TextEditingController(text: widget.registro?.cor ?? '');
    _fornecedorCtrl =
        TextEditingController(text: widget.registro?.fornecedor ?? '');
  }

  @override
  void dispose() {
    _florCtrl.dispose();
    _corCtrl.dispose();
    _fornecedorCtrl.dispose();
    super.dispose();
  }

  String? _obrigatorio(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  void _salvar() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Registro(
        flor: _florCtrl.text.trim(),
        cor: _corCtrl.text.trim(),
        fornecedor: _fornecedorCtrl.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar registro' : 'Novo registro'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _florCtrl,
                decoration: const InputDecoration(
                  labelText: 'Flor',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _corCtrl,
                decoration: const InputDecoration(
                  labelText: 'Cor',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _fornecedorCtrl,
                decoration: const InputDecoration(
                  labelText: 'Fornecedor',
                  border: OutlineInputBorder(),
                ),
                validator: _obrigatorio,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _salvar,
                icon: const Icon(Icons.save),
                label: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
