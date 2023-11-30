import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class SendDocumentEncryptedDto {
  final String documentName;
  final File document;

  SendDocumentEncryptedDto(this.documentName, this.document);
  toJson() async {
    Uint8List filebytes = await document.readAsBytes();
    String bsr4str = base64Encode(filebytes);
    return {
      "document_name": documentName,
      "document": bsr4str,
    };
  }
}
