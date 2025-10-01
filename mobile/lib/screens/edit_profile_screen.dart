import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/auth_service.dart';
import '../services/token_storage.dart';
import '../models/country.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _bioController = TextEditingController();
  final _authService = AuthService();
  final _storage = TokenStorage();
  
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  Country _selectedCountry = Countries.defaultCountry;
  DateTime? _selectedBirthDate;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final token = await _storage.getToken();
    if (token == null) return;

    final profile = await _authService.getProfile(token);

    if (profile != null && mounted) {
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        
        // Parsear telefone para separar código do país
        if (profile.phone != null && profile.phone!.isNotEmpty) {
          final phoneDigits = profile.phone!.replaceAll(RegExp(r'[^\d]'), '');
          
          // Detectar país pelo código
          if (phoneDigits.startsWith('55') && phoneDigits.length >= 12) {
            // Brasil: +55
            _selectedCountry = Countries.findByCode('BR') ?? Countries.defaultCountry;
            _phoneController.text = phoneDigits.substring(2); // Remove o +55
          } else if (phoneDigits.startsWith('1') && phoneDigits.length >= 11) {
            // EUA: +1
            _selectedCountry = Countries.findByCode('US') ?? Countries.defaultCountry;
            _phoneController.text = phoneDigits.substring(1); // Remove o +1
          } else if (phoneDigits.startsWith('351') && phoneDigits.length >= 12) {
            // Portugal: +351
            _selectedCountry = Countries.findByCode('PT') ?? Countries.defaultCountry;
            _phoneController.text = phoneDigits.substring(3); // Remove o +351
          } else if (phoneDigits.startsWith('54') && phoneDigits.length >= 12) {
            // Argentina: +54
            _selectedCountry = Countries.findByCode('AR') ?? Countries.defaultCountry;
            _phoneController.text = phoneDigits.substring(2); // Remove o +54
          } else {
            // Não identificado, assume Brasil e usa tudo
            _phoneController.text = phoneDigits;
          }
        }
        
        _addressController.text = profile.address ?? '';
        _cityController.text = profile.city ?? '';
        _stateController.text = profile.state ?? '';
        _zipCodeController.text = profile.zipCode ?? '';
        _bioController.text = profile.bio ?? '';
        _selectedBirthDate = profile.birthDate;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final token = await _storage.getToken();
    if (token == null) {
      setState(() => _isSaving = false);
      return;
    }

    // Formatar telefone com código do país
    String? phoneWithCountryCode;
    if (_phoneController.text.trim().isNotEmpty) {
      final phoneDigits = _phoneController.text.trim().replaceAll(RegExp(r'[^\d]'), '');
      phoneWithCountryCode = '${_selectedCountry.dialCode} $phoneDigits';
    }

    final result = await _authService.updateProfile(
      token: token,
      name: _nameController.text.trim(),
      phone: phoneWithCountryCode,
      birthDate: _selectedBirthDate,
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
      zipCode: _zipCodeController.text.trim().isEmpty ? null : _zipCodeController.text.trim(),
      bio: _bioController.text.trim().isEmpty ? null : _bioController.text.trim(),
    );

    setState(() => _isSaving = false);

    if (!mounted) return;

    if (result.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Retorna true para recarregar
    } else {
      // Exibir mensagem de erro específica da API
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Erro ao atualizar perfil'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFFFFD700),
        appBar: AppBar(
          title: const Text('Editar Perfil'),
          backgroundColor: Colors.black,
          foregroundColor: const Color(0xFFFFD700),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        title: const Text('Editar Perfil'),
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
              // Progresso
              if (_profile != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Dados do Perfil Preenchidos',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: _profile!.profileCompletionPercentage / 100,
                          minHeight: 10,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _profile!.profileCompletionPercentage == 100
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${_profile!.profileCompletionPercentage}%',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Campos não editáveis
              Text(
                'DADOS FIXOS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              // Email (readonly)
              TextFormField(
                initialValue: _profile?.email,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.lock, size: 16),
                  helperText: 'Email não pode ser alterado',
                ),
              ),
              
              const SizedBox(height: 12),
              
              // CPF (readonly)
              TextFormField(
                initialValue: _profile?.cpf,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: const Icon(Icons.badge),
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: const Icon(Icons.lock, size: 16),
                  helperText: 'CPF não pode ser alterado',
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Campos editáveis
              Text(
                'INFORMAÇÕES PESSOAIS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              // Nome
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome Completo *',
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
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Data de Nascimento
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedBirthDate ?? DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _selectedBirthDate = date);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Data de Nascimento',
                    prefixIcon: const Icon(Icons.calendar_today),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _selectedBirthDate != null
                        ? '${_selectedBirthDate!.day.toString().padLeft(2, '0')}/${_selectedBirthDate!.month.toString().padLeft(2, '0')}/${_selectedBirthDate!.year}'
                        : 'Selecione uma data',
                    style: TextStyle(
                      color: _selectedBirthDate != null ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
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
              
              // Telefone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(_selectedCountry.phoneLength),
                ],
                decoration: InputDecoration(
                  labelText: 'Telefone',
                  hintText: _selectedCountry.phoneMask,
                  prefixIcon: const Icon(Icons.phone),
                  prefixText: '${_selectedCountry.dialCode} ',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Endereço
              Text(
                'ENDEREÇO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'Endereço',
                  prefixIcon: const Icon(Icons.home),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _cityController,
                      decoration: InputDecoration(
                        labelText: 'Cidade',
                        prefixIcon: const Icon(Icons.location_city),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stateController,
                      maxLength: 2,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z]')),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return newValue.copyWith(text: newValue.text.toUpperCase());
                        }),
                      ],
                      decoration: InputDecoration(
                        labelText: 'UF',
                        hintText: 'SP',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        counterText: '',
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _zipCodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(8),
                ],
                decoration: InputDecoration(
                  labelText: 'CEP',
                  hintText: '12345-678',
                  prefixIcon: const Icon(Icons.map),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  helperText: 'Apenas números (8 dígitos)',
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Sobre
              Text(
                'SOBRE VOCÊ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              
              TextFormField(
                controller: _bioController,
                maxLines: 4,
                maxLength: 500,
                decoration: InputDecoration(
                  labelText: 'Bio / Descrição',
                  hintText: 'Conte um pouco sobre você...',
                  prefixIcon: const Icon(Icons.description, size: 20),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Botão Salvar
              ElevatedButton(
                onPressed: _isSaving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: const Color(0xFFFFD700),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
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
                        'SALVAR PERFIL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
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

