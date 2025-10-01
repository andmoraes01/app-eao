import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import '../models/country.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  final _storage = TokenStorage();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  Country _selectedCountry = Countries.defaultCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Formatar telefone com código do país
    String? phoneWithCountryCode;
    if (_phoneController.text.trim().isNotEmpty) {
      final phoneDigits = _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
      phoneWithCountryCode = '${_selectedCountry.dialCode} $phoneDigits';
    }

    final result = await _authService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: phoneWithCountryCode,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result.success && result.authResponse != null) {
      // Salvar token e informações do usuário
      await _storage.saveAuth(
        token: result.authResponse!.token,
        userId: result.authResponse!.userId,
        userName: result.authResponse!.name,
        userEmail: result.authResponse!.email,
      );
      
      // Cadastro bem-sucedido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      // Navegar para a tela principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      // Exibir mensagem de erro específica da API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Erro desconhecido'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: Colors.black,
        foregroundColor: const Color(0xFFFFD700),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              
              // Logo/Título
              const Icon(
                Icons.construction,
                size: 80,
                color: Colors.black,
              ),
              const SizedBox(height: 16),
              const Text(
                'AppEAO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'MÃO DE OBRA',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  letterSpacing: 3,
                ),
              ),
              
              const SizedBox(height: 40),
              
              // Campo Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  if (value.trim().length < 3) {
                    return 'Nome deve ter pelo menos 3 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo Email
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email é obrigatório';
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo Senha
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  if (value.length < 6) {
                    return 'Senha deve ter pelo menos 6 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Seletor de País
              DropdownButtonFormField<Country>(
                initialValue: _selectedCountry,
                decoration: InputDecoration(
                  labelText: 'País',
                  prefixIcon: const Icon(Icons.flag),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: Countries.all.map((country) {
                  return DropdownMenuItem(
                    value: country,
                    child: Text(country.displayName),
                  );
                }).toList(),
                onChanged: (Country? newCountry) {
                  if (newCountry != null) {
                    setState(() => _selectedCountry = newCountry);
                  }
                },
              ),
              
              const SizedBox(height: 16),
              
              // Campo Telefone com validação por país
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_selectedCountry.phoneLength),
                ],
                decoration: InputDecoration(
                  labelText: 'Telefone (opcional)',
                  hintText: _selectedCountry.phoneMask,
                  prefixIcon: const Icon(Icons.phone),
                  prefixText: '${_selectedCountry.dialCode} ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: _selectedCountry.code == 'BR' 
                      ? 'Ex: (11) 99999-9999 → Digite: 11999999999'
                      : 'Apenas números',
                  helperMaxLines: 2,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return null; // Telefone é opcional
                  }
                  
                  final phoneDigits = value.trim().replaceAll(RegExp(r'[^\d]'), '');
                  
                  // Validação específica por país
                  if (_selectedCountry.code == 'BR') {
                    // Brasil: DDD (2 dígitos) + 8 ou 9 dígitos
                    if (phoneDigits.length != 10 && phoneDigits.length != 11) {
                      return 'Telefone brasileiro: DDD + 8 ou 9 dígitos';
                    }
                    
                    // Validar DDD
                    if (phoneDigits.length >= 2) {
                      final ddd = int.tryParse(phoneDigits.substring(0, 2));
                      if (ddd == null || ddd < 11 || ddd > 99) {
                        return 'DDD inválido (11 a 99)';
                      }
                    }
                  } else {
                    // Outros países: validação genérica de tamanho
                    if (phoneDigits.length != _selectedCountry.phoneLength) {
                      return 'Telefone deve ter ${_selectedCountry.phoneLength} dígitos';
                    }
                  }
                  
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Botão Cadastrar
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: const Color(0xFFFFD700),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFFFFD700),
                          ),
                        ),
                      )
                    : const Text(
                        'CADASTRAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
              ),
              
              const SizedBox(height: 16),
              
              // Link para Login
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Já tem uma conta? Faça login',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

