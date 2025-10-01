/// Modelo de país com código e prefixo telefônico
class Country {
  final String code;
  final String name;
  final String flag;
  final String dialCode;
  final String phoneMask;
  final int phoneLength; // Quantidade de dígitos após o DDD

  const Country({
    required this.code,
    required this.name,
    required this.flag,
    required this.dialCode,
    required this.phoneMask,
    required this.phoneLength,
  });

  String get displayName => '$flag $name ($dialCode)';
}

/// Lista de países suportados
class Countries {
  static const List<Country> all = [
    Country(
      code: 'BR',
      name: 'Brasil',
      flag: '🇧🇷',
      dialCode: '+55',
      phoneMask: '(##) #####-####',
      phoneLength: 11, // DDD (2) + 9 dígitos
    ),
    Country(
      code: 'US',
      name: 'Estados Unidos',
      flag: '🇺🇸',
      dialCode: '+1',
      phoneMask: '(###) ###-####',
      phoneLength: 10,
    ),
    Country(
      code: 'PT',
      name: 'Portugal',
      flag: '🇵🇹',
      dialCode: '+351',
      phoneMask: '### ### ###',
      phoneLength: 9,
    ),
    Country(
      code: 'AR',
      name: 'Argentina',
      flag: '🇦🇷',
      dialCode: '+54',
      phoneMask: '(##) ####-####',
      phoneLength: 10,
    ),
  ];

  static Country get defaultCountry => all.first; // Brasil
  
  static Country? findByCode(String code) {
    try {
      return all.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }
}

