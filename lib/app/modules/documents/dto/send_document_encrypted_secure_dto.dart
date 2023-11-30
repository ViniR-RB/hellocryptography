import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class SendDocumentEncryptedSecureDto {
  final String documentName;
  final File document;
  final String aesKey;
  final String ivSpec;
  SendDocumentEncryptedSecureDto(
      this.documentName, this.document, this.aesKey, this.ivSpec);
  toJson() async {
    Uint8List filebytes = await document.readAsBytes();
    String bsr4str = base64Encode(filebytes);
    return {
      "document_name": documentName,
      "encrypted_document": bsr4str,
      "aes_key": aesKey,
      "iv_spec": ivSpec
    };
  }
}
