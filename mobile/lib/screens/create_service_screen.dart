import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/service_service.dart';
import '../models/service.dart';
import '../models/service_material.dart';
import '../widgets/app_logo.dart';

class CreateServiceScreen extends StatefulWidget {
  final Service? serviceToEdit;

  const CreateServiceScreen({super.key, this.serviceToEdit});

  @override
  State<CreateServiceScreen> createState() => _CreateServiceScreenState();
}

class _CreateServiceScreenState extends State<CreateServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final ServiceService _serviceService = ServiceService();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _materialsDescriptionController = TextEditingController();
  final _budgetRangeController = TextEditingController();

  // Valores selecionados
  String _selectedServiceType = 'Construção Civil';
  String _selectedLocationType = 'Residencial';
  String _selectedPreferredTime = 'Manhã';
  DateTime _selectedStartDate = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 7));
  bool _requiresMaterials = false;
  bool _isLoading = false;

  // Lista de materiais do serviço
  List<ServiceMaterialRequest> _materials = [];

  final List<String> _serviceTypes = [
    'Construção Civil',
    'Elétrica',
    'Hidráulica',
    'Pintura',
    'Limpeza',
    'Jardinagem',
    'Manutenção',
    'Outros',
  ];

  final List<String> _locationTypes = [
    'Residencial',
    'Comercial',
    'Industrial',
    'Rural',
    'Outros',
  ];

  final List<String> _preferredTimes = [
    'Manhã',
    'Tarde',
    'Noite',
    'Qualquer horário',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.serviceToEdit != null) {
      _loadServiceData();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _materialsDescriptionController.dispose();
    _budgetRangeController.dispose();
    super.dispose();
  }

  void _loadServiceData() {
    final service = widget.serviceToEdit!;
    _titleController.text = service.title;
    _descriptionController.text = service.description;
    _locationController.text = service.location;
    _materialsDescriptionController.text = service.materialsDescription ?? '';
    _budgetRangeController.text = service.budgetRange?.toString() ?? '';
    _selectedServiceType = service.serviceType;
    _selectedLocationType = service.locationType;
    _selectedPreferredTime = service.preferredTime;
    _selectedStartDate = service.preferredStartDate;
    _selectedEndDate = service.preferredEndDate;
    _requiresMaterials = service.requiresMaterials;
    
    // Carregar materiais existentes
    _materials = service.materials.map((material) => ServiceMaterialRequest(
      name: material.name,
      brand: material.brand,
      quantity: material.quantity,
      unit: material.unit,
      estimatedPrice: material.estimatedPrice,
      notes: material.notes,
    )).toList();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _selectedStartDate : _selectedEndDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _selectedStartDate = picked;
          if (_selectedEndDate.isBefore(picked)) {
            _selectedEndDate = picked.add(const Duration(days: 1));
          }
        } else {
          _selectedEndDate = picked;
        }
      });
    }
  }

  void _addMaterial() {
    showDialog(
      context: context,
      builder: (context) => _ServiceMaterialDialog(
        onSave: (material) {
          setState(() {
            _materials.add(material);
          });
        },
      ),
    );
  }

  void _editMaterial(int index) {
    showDialog(
      context: context,
      builder: (context) => _ServiceMaterialDialog(
        material: _materials[index],
        onSave: (material) {
          setState(() {
            _materials[index] = material;
          });
        },
      ),
    );
  }

  void _removeMaterial(int index) {
    setState(() {
      _materials.removeAt(index);
    });
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = CreateServiceRequest(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        serviceType: _selectedServiceType,
        location: _locationController.text.trim(),
        locationType: _selectedLocationType,
        preferredStartDate: _selectedStartDate,
        preferredEndDate: _selectedEndDate,
        preferredTime: _selectedPreferredTime,
        requiresMaterials: _requiresMaterials,
        materialsDescription: _materialsDescriptionController.text.trim().isEmpty
            ? null
            : _materialsDescriptionController.text.trim(),
        budgetRange: _budgetRangeController.text.trim().isEmpty
            ? null
            : double.tryParse(_budgetRangeController.text.trim()),
        materials: _materials.isNotEmpty ? _materials : null,
      );

      if (widget.serviceToEdit != null) {
        await _serviceService.updateService(widget.serviceToEdit!.id, request);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _serviceService.createService(request);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Serviço criado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: Text(
          widget.serviceToEdit != null ? 'Editar Serviço' : 'Criar Serviço',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Header com logo
            Container(
              width: double.infinity,
              color: const Color(0xFFFFD700),
              child: Column(
                children: [
                  const AppLogo.small(),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Formulário
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Título
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Título do Serviço',
                          prefixIcon: const Icon(Icons.title),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Título é obrigatório';
                          }
                          if (value.trim().length < 5) {
                            return 'Título deve ter pelo menos 5 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tipo de serviço
                      DropdownButtonFormField<String>(
                        value: _selectedServiceType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Serviço',
                          prefixIcon: const Icon(Icons.work),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _serviceTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedServiceType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Descrição
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Descrição Detalhada',
                          prefixIcon: const Icon(Icons.description),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Descrição é obrigatória';
                          }
                          if (value.trim().length < 20) {
                            return 'Descrição deve ter pelo menos 20 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Localização
                      TextFormField(
                        controller: _locationController,
                        decoration: InputDecoration(
                          labelText: 'Localização',
                          prefixIcon: const Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Localização é obrigatória';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Tipo de local
                      DropdownButtonFormField<String>(
                        value: _selectedLocationType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Local',
                          prefixIcon: const Icon(Icons.home),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _locationTypes.map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedLocationType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Datas preferidas
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, true),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Data de Início',
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '${_selectedStartDate.day.toString().padLeft(2, '0')}/${_selectedStartDate.month.toString().padLeft(2, '0')}/${_selectedStartDate.year}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => _selectDate(context, false),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Data de Fim',
                                  prefixIcon: const Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  '${_selectedEndDate.day.toString().padLeft(2, '0')}/${_selectedEndDate.month.toString().padLeft(2, '0')}/${_selectedEndDate.year}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Horário preferido
                      DropdownButtonFormField<String>(
                        value: _selectedPreferredTime,
                        decoration: InputDecoration(
                          labelText: 'Horário Preferido',
                          prefixIcon: const Icon(Icons.access_time),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _preferredTimes.map((String time) {
                          return DropdownMenuItem<String>(
                            value: time,
                            child: Text(time),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPreferredTime = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Faixa de orçamento
                      TextFormField(
                        controller: _budgetRangeController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: 'Faixa de Orçamento (R\$)',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Requer materiais
                      SwitchListTile(
                        title: const Text('Requer Materiais'),
                        subtitle: const Text('Marque se precisa de materiais para o serviço'),
                        value: _requiresMaterials,
                        onChanged: (bool value) {
                          setState(() {
                            _requiresMaterials = value;
                          });
                        },
                        activeColor: const Color(0xFFFFD700),
                      ),

                      // Descrição de materiais
                      if (_requiresMaterials) ...[
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _materialsDescriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Descrição dos Materiais',
                            prefixIcon: const Icon(Icons.inventory),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],

                      // Seção de lista de materiais
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Text(
                            'Lista de Materiais',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _addMaterial,
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Lista de materiais
                      if (_materials.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: const Column(
                            children: [
                              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
                              SizedBox(height: 8),
                              Text(
                                'Nenhum material adicionado',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Adicione os materiais necessários para o serviço',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: _materials.asMap().entries.map((entry) {
                            final index = entry.key;
                            final material = entry.value;
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                title: Text(material.name),
                                subtitle: Text(
                                  '${material.quantity} ${material.unit}${material.estimatedPrice != null ? ' - R\$ ${material.estimatedPrice!.toStringAsFixed(2)}' : ''}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () => _editMaterial(index),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () => _removeMaterial(index),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 32),

                      // Botão salvar
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                              )
                            : Text(
                                widget.serviceToEdit != null ? 'Atualizar Serviço' : 'Criar Serviço',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceMaterialDialog extends StatefulWidget {
  final ServiceMaterialRequest? material;
  final Function(ServiceMaterialRequest) onSave;

  const _ServiceMaterialDialog({
    this.material,
    required this.onSave,
  });

  @override
  State<_ServiceMaterialDialog> createState() => _ServiceMaterialDialogState();
}

class _ServiceMaterialDialogState extends State<_ServiceMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _estimatedPriceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.material != null) {
      _nameController.text = widget.material!.name;
      _brandController.text = widget.material!.brand ?? '';
      _quantityController.text = widget.material!.quantity.toString();
      _unitController.text = widget.material!.unit;
      _estimatedPriceController.text = widget.material!.estimatedPrice?.toString() ?? '';
      _notesController.text = widget.material!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _estimatedPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final material = ServiceMaterialRequest(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        unit: _unitController.text.trim(),
        estimatedPrice: _estimatedPriceController.text.trim().isEmpty
            ? null
            : double.tryParse(_estimatedPriceController.text.trim()),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );

      widget.onSave(material);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.material == null ? 'Adicionar Material' : 'Editar Material'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Material *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nome é obrigatório';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantidade *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Quantidade é obrigatória';
                        }
                        if (int.tryParse(value.trim()) == null) {
                          return 'Quantidade inválida';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: const InputDecoration(
                        labelText: 'Unidade *',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Unidade é obrigatória';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _estimatedPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço Estimado (R\$)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}
