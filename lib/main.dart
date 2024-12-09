import 'dart:convert';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

void main(){
  runApp(CryptoText());
}
class CryptoText extends StatelessWidget {
  const CryptoText({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CrytoText',
      home: HomeScreen(),
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  //kunci untuk enkripsi dan dekripsi
  final encrypt.Key _key = encrypt.Key.fromLength(32);

  //Initial Vector untuk enkripsi dan dekripsi
  final iv = encrypt.IV.fromLength(16);

  String _encryptedText = ' ';

  String _decryptedText = ' ';

  String? _errorText;

  bool _isDecryptButtonEnabled = false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('CryptoText')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                labelText: 'Input text',
                errorText: _errorText,
                border: const OutlineInputBorder(),
              ),
              onChanged: _onTextChanged,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: (){
                  String inputText = _textEditingController.text;
                  if(inputText.isNotEmpty){
                    _encryptText(inputText);
                  }else{
                    setState(() {
                      _errorText = 'Input cannot be empty';
                    });
                  }
                },
                child: const Text('Encrypt'),
            SizedBox(height: 10),
            Text('Encrypted Text: $_encryptedText',
            style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _isDecryptButtonEnabled && _encryptedText.isNotEmpty?),
              String inputText = _encryptedText;
                final encrypted = encrypt.Encrypted.encrypt.Encrypted.fromBase64(inputText);
            }   : null,
            child : const Text('Decrypt'),
          ],
        ),
      ),
    );
  }
  void _onTextChanged(String text){
    setState(() {
      _isDecryptButtonEnabled = text.isNotEmpty;
      _encryptedText=' ';
      _decryptedText= ' ';
      _errorText = null;
    });
  }
}
void _encrypText(String text){
  try{
    if(text.isNotEmpty){
      final encrypter =
          encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.ecb));
      final encrypted = encrypter.encrypt(text);
      setState((){
        _encryptedText = encrypted.base64;
      });
    }else{
      print('Text to encrypt cannot be empty');
      //Tambahkan pesan yang sesuai jika teks kosong
    }
  }catch(e, stackTrace){
    print('Eror encrypting text: $e, stackTrace: $stackTrace');
    //penanganan kesalahan yang sesuai
  }
}
