import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'api_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VOCR\'S App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primaryColor: const Color(0xFF785FF1),
      ),
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// 1. TELA DE LOGIN
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _mockLogin() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Senha mockada para testes
    if (email == '1' && password == '1') {
      Navigator.pushReplacement(
        context,
        // Alterado de DashboardScreen para UploadScreen para o código compilar
        MaterialPageRoute(builder: (context) => const UploadScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-mail ou senha inválidos.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF785FF1);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 850,
            height: 400,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE9EBED),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 40,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: primaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "VOCR'S",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Acesso ao sistema",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Entre com suas credenciais para validar documentos.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 25),
                        _buildTextField(
                          controller: _emailController,
                          hint: 'teste@vocrs.com',
                          obscure: false,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _passwordController,
                          hint: '123456',
                          obscure: true,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 20,
                                left: 5,
                              ),
                            ),
                            child: const Text(
                              'ESQUECI MINHA SENHA',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _mockLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'ENTRAR',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 25,
                      bottom: 25,
                      right: 25,
                    ),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sistema de Validação Automatizada",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Valide documentos pessoais usando OCR e visão computacional.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[500],
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 11, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. TELA DE UPLOAD
// ==========================================
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? _selectedFileName;
  Uint8List?
  _fileBytes; // <-- Mudamos de String (caminho) para Uint8List (Bytes)

  Future<void> _pickFile() async {
    print('\n[FLUTTER - UPLOAD] Abrindo a janela para selecionar o arquivo...');

    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData:
          true, // <-- MUITO IMPORTANTE PARA A WEB: Pede pro Flutter ler os bytes!
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _fileBytes =
            result.files.single.bytes; // <-- Pegamos os bytes do arquivo
      });
      print('[FLUTTER - UPLOAD] Arquivo selecionado com SUCESSO!');
      print('[FLUTTER - UPLOAD] Nome do Arquivo: $_selectedFileName');
      print('[FLUTTER - UPLOAD] Tamanho em bytes: ${_fileBytes?.length}\n');
    }
  }

  void _goToNextStep() {
    if (_fileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor, selecione um arquivo primeiro."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    print(
      '[FLUTTER - UPLOAD] Passando os BYTES para a tela de processamento...\n',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(
          fileBytes: _fileBytes!, // <-- Passando os bytes
          fileName: _selectedFileName!, // <-- Passando o nome
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF785FF1);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 750,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EBED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Enviar Documento",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Voltar",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 50),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1.5,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.insert_drive_file_outlined,
                        size: 60,
                        color: Colors.grey.shade800,
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Arraste o arquivo ou clique em Selecionar",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              border: Border.all(color: Colors.grey.shade500),
                            ),
                            child: const Text(
                              "Escolher Arquivo",
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _selectedFileName ?? "Nenhum arquivo escolhido",
                            style: TextStyle(
                              fontSize: 12,
                              color: _selectedFileName == null
                                  ? Colors.grey.shade700
                                  : primaryColor,
                              fontWeight: _selectedFileName == null
                                  ? FontWeight.normal
                                  : FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black87),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _goToNextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Próximo",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. TELA DE PROCESSAMENTO
// ==========================================
class ProcessingScreen extends StatefulWidget {
  final Uint8List fileBytes; // <-- Agora recebe os bytes
  final String fileName; // <-- Agora recebe o nome do arquivo

  const ProcessingScreen({
    super.key,
    required this.fileBytes,
    required this.fileName,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  String _statusMensagem = "Enviando arquivo para a IA...";

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    print('\n-----------------------------------------');
    print('[FLUTTER] 1. Preparando para enviar o PDF...');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/extrair/'),
      );

      // Anexando o arquivo usando os BYTES agora!
      request.files.add(
        http.MultipartFile.fromBytes(
          // <-- Mudou para fromBytes
          'file',
          widget.fileBytes,
          filename: widget.fileName,
        ),
      );

      print('[FLUTTER] 2. Arquivo anexado. Disparando para o servidor...');
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      print(
        '[FLUTTER] 3. Ufa, o servidor respondeu! Status Code: ${response.statusCode}',
      );
      print('[FLUTTER] 4. A resposta do Python foi: $responseData');
      // ==========================================
      // TRATATIVA DA RESPOSTA AQUI
      // ==========================================
      if (mounted) {
        if (response.statusCode == 200) {
          // 1. Converte o texto da resposta para um Mapa (JSON)
          var decodedData = jsonDecode(responseData);

          // 2. Navega para a TELA DE RESULTADOS passando os dados!
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultScreen(dados: decodedData),
            ),
          );
        } else {
          // Se o Python der erro (ex: 500)
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Ops! Erro no Servidor ❌"),
              content: Text("Ocorreu um erro: ${response.statusCode}"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context), // Só fecha o erro
                  child: const Text("Tentar novamente"),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('[FLUTTER] ERRO CRÍTICO DE CONEXÃO: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 750,
          padding: const EdgeInsets.all(50),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EBED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Processando documento...",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                _statusMensagem,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 6,
                ),
              ),
              const SizedBox(height: 60),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildStepChip("Pré-processamento"),
                  _buildStepChip("OCR"),
                  _buildStepChip("Validação"),
                  _buildStepChip("Comparação de Selfie"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      ),
    );
  }
}

// ==========================================
// 5. TELA DE RESULTADO
// ==========================================
class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> dados; // Recebe o dicionário vindo do Python

  const ResultScreen({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF785FF1);

    // Extrai as variáveis que vieram do Backend (Lida com nulos por segurança)
    String cpfExtraido = dados['cpf'] ?? "Não encontrado";
    String rgExtraido = dados['rg'] ?? "Não encontrado";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Container(
          width: 750,
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: const Color(0xFFE9EBED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Resultado da Validação",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Resultado final do processamento",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6F5D6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Aprovado",
                      style: TextStyle(
                        color: Color(0xFF007A33),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              // Como o backend ainda não pega o nome, deixei estático por enquanto
              _buildDataRow("Nome: ", "Candidato Identificado"),
              const SizedBox(height: 20),
              // Agora exibe os dados reais do Python!
              _buildDataRow("CPF Extraído: ", cpfExtraido),
              const SizedBox(height: 20),
              _buildDataRow("RG Extraído: ", rgExtraido),
              const SizedBox(height: 50),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UploadScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Validar Novo Documento",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Baixando PDF...")),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(color: Colors.black54),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Baixar Relatório",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  OutlinedButton(
                    onPressed: () {
                      // Alterado para um SnackBar para evitar erro, já que a tela HistoryScreen não existia no código original
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Tela de histórico em desenvolvimento.",
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: const BorderSide(color: Colors.black54),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Ver Histórico",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 18, color: Colors.black87),
        children: [
          TextSpan(
            text: label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }
}
