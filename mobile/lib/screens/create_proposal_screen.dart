import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/service.dart';
import '../models/proposal.dart';
import '../services/service_service.dart';
import '../widgets/app_logo.dart';

class CreateProposalScreen extends StatefulWidget {
  final Service service;
  final Proposal? proposalToEdit;

  const CreateProposalScreen({
    super.key,
    required this.service,
    this.proposalToEdit,
  });

  @override
  State<CreateProposalScreen> createState() => _CreateProposalScreenState();
}

class _CreateProposalScreenState extends State<CreateProposalScreen> {
  final _formKey = GlobalKey<FormState>();
  final ServiceService _serviceService = ServiceService();

  // Controllers
  final _descriptionController = TextEditingController();
  final _laborCostController = TextEditingController();
  final _materialCostController = TextEditingController();
  final _notesController = TextEditingController();

  // Valores selecionados
  DateTime _selectedStartDate = DateTime.now().add(const Duration(days: 1));
  DateTime _selectedEndDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  // Lista de materiais da proposta
  List<ProposalMaterialRequest> _materials = [];

  @override
  void initState() {
    super.initState();
    if (widget.proposalToEdit != null) {
      _loadProposalData();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _laborCostController.dispose();
    _materialCostController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadProposalData() {
    final proposal = widget.proposalToEdit!;
    _descriptionController.text = proposal.description;
    _laborCostController.text = proposal.laborCost.toString();
    _materialCostController.text = proposal.materialCost?.toString() ?? '';
    _notesController.text = proposal.notes ?? '';
    _selectedStartDate = proposal.estimatedStartDate;
    _selectedEndDate = proposal.estimatedEndDate;
    
    _materials = proposal.materials.map((material) => ProposalMaterialRequest(
      name: material.name,
      brand: material.brand,
      quantity: material.quantity,
      unit: material.unit,
      unitPrice: material.unitPrice,
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
      builder: (context) => _MaterialDialog(
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
      builder: (context) => _MaterialDialog(
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

  double _calculateTotalMaterialCost() {
    return _materials.fold(0.0, (sum, material) => sum + (material.quantity * material.unitPrice));
  }

  Future<void> _saveProposal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final materialCost = _calculateTotalMaterialCost();
      
      final request = CreateProposalRequest(
        description: _descriptionController.text.trim(),
        laborCost: double.parse(_laborCostController.text.trim()),
        materialCost: materialCost > 0 ? materialCost : null,
        estimatedStartDate: _selectedStartDate,
        estimatedEndDate: _selectedEndDate,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        materials: _materials.isNotEmpty ? _materials : null,
      );

      if (widget.proposalToEdit != null) {
        await _serviceService.updateProposal(widget.proposalToEdit!.id, request);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proposta atualizada com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        await _serviceService.createProposal(widget.service.id, request);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proposta enviada com sucesso!'),
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
          widget.proposalToEdit != null ? 'Editar Proposta' : 'Nova Proposta',
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

            // Informações do serviço
            Container(
              color: const Color(0xFFFFD700),
              padding: const EdgeInsets.all(16),
              child: Card(
                color: const Color(0xFFFFD700),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Serviço:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.service.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.service.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
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
                      // Descrição da proposta
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Descrição da Proposta',
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

                      // Custo da mão de obra
                      TextFormField(
                        controller: _laborCostController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Custo da Mão de Obra (R\$)',
                          prefixIcon: const Icon(Icons.attach_money),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Custo da mão de obra é obrigatório';
                          }
                          final cost = double.tryParse(value.trim());
                          if (cost == null || cost <= 0) {
                            return 'Custo deve ser um valor positivo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Datas estimadas
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

                      // Seção de materiais
                      Row(
                        children: [
                          const Text(
                            'Materiais',
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
                                  '${material.quantity} ${material.unit} - R\$ ${(material.quantity * material.unitPrice).toStringAsFixed(2)}',
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

                      // Total dos materiais
                      if (_materials.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calculate, color: Colors.blue),
                              const SizedBox(width: 8),
                              const Text(
                                'Total dos Materiais: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                'R\$ ${_calculateTotalMaterialCost().toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Observações
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Observações (opcional)',
                          prefixIcon: const Icon(Icons.note),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Botão salvar
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveProposal,
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
                                widget.proposalToEdit != null ? 'Atualizar Proposta' : 'Enviar Proposta',
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

class _MaterialDialog extends StatefulWidget {
  final ProposalMaterialRequest? material;
  final Function(ProposalMaterialRequest) onSave;

  const _MaterialDialog({
    this.material,
    required this.onSave,
  });

  @override
  State<_MaterialDialog> createState() => _MaterialDialogState();
}

class _MaterialDialogState extends State<_MaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.material != null) {
      _nameController.text = widget.material!.name;
      _brandController.text = widget.material!.brand ?? '';
      _quantityController.text = widget.material!.quantity.toString();
      _unitController.text = widget.material!.unit;
      _unitPriceController.text = widget.material!.unitPrice.toString();
      _notesController.text = widget.material!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _unitPriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final material = ProposalMaterialRequest(
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty ? null : _brandController.text.trim(),
        quantity: int.parse(_quantityController.text.trim()),
        unit: _unitController.text.trim(),
        unitPrice: double.parse(_unitPriceController.text.trim()),
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      );
      widget.onSave(material);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.material != null ? 'Editar Material' : 'Adicionar Material'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome do Material',
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
                  labelText: 'Marca (opcional)',
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
                        labelText: 'Quantidade',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Quantidade é obrigatória';
                        }
                        final quantity = int.tryParse(value.trim());
                        if (quantity == null || quantity <= 0) {
                          return 'Quantidade deve ser positiva';
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
                        labelText: 'Unidade',
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
                controller: _unitPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Preço Unitário (R\$)',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Preço é obrigatório';
                  }
                  final price = double.tryParse(value.trim());
                  if (price == null || price <= 0) {
                    return 'Preço deve ser positivo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Observações (opcional)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: Text(widget.material != null ? 'Atualizar' : 'Adicionar'),
        ),
      ],
    );
  }
}
