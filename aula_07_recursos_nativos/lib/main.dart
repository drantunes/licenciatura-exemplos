import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'recurso_service.dart';

void main() => runApp(const MaterialApp(home: RecursosPage()));

class RecursosPage extends StatefulWidget {
  const RecursosPage({super.key});
  @override
  State<RecursosPage> createState() => _RecursosPageState();
}

class _RecursosPageState extends State<RecursosPage> {
  final service = RecursoService();
  XFile? imagem;
  String? qr;
  bool ocupado = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) selecionar(service.recuperarImagem);
    });
  }

  Future<void> selecionar(Future<XFile?> Function() acao) async {
    setState(() => ocupado = true);
    try {
      final arquivo = await acao();
      if (!mounted || arquivo == null) return;
      setState(() => imagem = arquivo);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível obter a imagem. '
            'Verifique a permissão nas configurações do aparelho.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => ocupado = false);
    }
  }

  Future<void> abrirLeitor() async {
    setState(() => ocupado = true);
    try {
      final resultado = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => QrPage(service: service)),
      );
      if (!mounted || resultado == null) return;
      setState(() => qr = resultado);
    } finally {
      if (mounted) setState(() => ocupado = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Recursos nativos')),
    body: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        FilledButton.icon(
          onPressed: ocupado ? null : () => selecionar(service.tirarFoto),
          icon: const Icon(Icons.camera_alt),
          label: const Text('Tirar foto'),
        ),
        FilledButton.icon(
          onPressed: ocupado ? null : () => selecionar(service.escolherGaleria),
          icon: const Icon(Icons.photo_library),
          label: const Text('Galeria'),
        ),
        FilledButton.icon(
          onPressed: ocupado ? null : abrirLeitor,
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Ler QR Code'),
        ),
        if (ocupado) const LinearProgressIndicator(),
        const SizedBox(height: 20),
        if (imagem != null)
          Image.file(
            File(imagem!.path),
            height: 260,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) =>
                const Text('Não foi possível abrir a imagem.'),
          ),
        const SizedBox(height: 20),
        SelectableText(qr == null ? 'Nenhum QR Code lido.' : 'QR Code: $qr'),
      ],
    ),
  );
}

class QrPage extends StatefulWidget {
  final RecursoService service;
  const QrPage({super.key, required this.service});
  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  bool concluido = false;

  void detectar(BarcodeCapture captura) {
    if (concluido || !mounted) return;
    final texto = widget.service.lerQr(captura);
    if (texto == null) return;
    concluido = true;
    Navigator.pop(context, texto);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Aponte para um QR Code')),
    body: MobileScanner(
      // Sem controller externo: o widget administra câmera e ciclo de vida.
      onDetect: detectar,
      errorBuilder: (_, erro) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            erro.errorCode == MobileScannerErrorCode.permissionDenied
                ? 'Câmera sem permissão. Autorize nas configurações do aparelho '
                      'e abra o leitor novamente.'
                : 'Câmera indisponível. Volte e tente abrir o leitor novamente.',
          ),
        ),
      ),
    ),
  );
}
