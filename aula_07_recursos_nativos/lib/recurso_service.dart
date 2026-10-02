import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RecursoService {
  final _picker = ImagePicker();

  Future<XFile?> tirarFoto() => _selecionar(ImageSource.camera);
  Future<XFile?> escolherGaleria() => _selecionar(ImageSource.gallery);

  Future<XFile?> _selecionar(ImageSource origem) => _picker.pickImage(
    source: origem,
    maxWidth: 1200,
    imageQuality: 80,
    requestFullMetadata: false,
  );

  Future<XFile?> recuperarImagem() async {
    if (!Platform.isAndroid) return null;
    final resposta = await _picker.retrieveLostData();
    if (resposta.isEmpty) return null;
    if (resposta.exception != null) throw resposta.exception!;
    final arquivos = resposta.files;
    return arquivos == null || arquivos.isEmpty ? null : arquivos.first;
  }

  String? lerQr(BarcodeCapture captura) {
    for (final codigo in captura.barcodes) {
      final texto = codigo.rawValue;
      if (codigo.format == BarcodeFormat.qrCode &&
          texto != null &&
          texto.trim().isNotEmpty) {
        return texto;
      }
    }
    return null;
  }
}
