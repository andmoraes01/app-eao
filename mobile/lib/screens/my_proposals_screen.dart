import 'package:flutter/material.dart';
import '../models/proposal.dart';
import '../models/service.dart';
import '../services/service_service.dart';
import '../services/token_storage.dart';
import '../widgets/app_logo.dart';
import 'service_detail_screen.dart';

class MyProposalsScreen extends StatefulWidget {
  const MyProposalsScreen({super.key});

  @override
  State<MyProposalsScreen> createState() => _MyProposalsScreenState();
}

class _MyProposalsScreenState extends State<MyProposalsScreen> {
  final ServiceService _serviceService = ServiceService();
  final TokenStorage _tokenStorage = TokenStorage();
  
  List<Proposal> _proposals = [];
  bool _isLoading = true;
  String? _currentUserId;
  String _selectedFilter = 'Todos';

  final List<String> _filterOptions = [
    'Todos',
    'Pendentes',
    'Aceitas',
    'Rejeitadas',
    'Concluídas',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await _tokenStorage.getUserId();
    setState(() {
      _currentUserId = userId;
    });
    if (userId != null) {
      _loadProposals();
    }
  }

  Future<void> _loadProposals() async {
    if (_currentUserId == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Buscar todas as propostas do usuário (incluindo aceitas, rejeitadas, etc.)
      final userProposals = await _serviceService.getMyProposals();

      // Aplicar filtro adicional se necessário
      final filteredProposals = _applyFilter(userProposals);

      setState(() {
        _proposals = filteredProposals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar propostas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Proposal> _applyFilter(List<Proposal> proposals) {
    switch (_selectedFilter) {
      case 'Pendentes':
        return proposals.where((p) => p.status.toLowerCase() == 'pending').toList();
      case 'Aceitas':
        return proposals.where((p) => p.status.toLowerCase() == 'accepted').toList();
      case 'Rejeitadas':
        return proposals.where((p) => p.status.toLowerCase() == 'rejected').toList();
      case 'Concluídas':
        return proposals.where((p) => p.status.toLowerCase() == 'completed').toList();
      default:
        return proposals;
    }
  }

  void _onFilterChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedFilter = value;
      });
      _loadProposals();
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendente';
      case 'accepted':
        return 'Aceita';
      case 'rejected':
        return 'Rejeitada';
      case 'completed':
        return 'Concluída';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text(
          'Minhas Propostas',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // Header com logo
          Container(
            color: const Color(0xFFFFD700),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                AppLogo.medium(),
                const SizedBox(height: 16),
                const Text(
                  'Suas Propostas Enviadas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Filtros
          Container(
            color: const Color(0xFFFFD700),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                const Text(
                  'Filtrar:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedFilter,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: _filterOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: _onFilterChanged,
                  ),
                ),
              ],
            ),
          ),

          // Lista de propostas
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFD700)),
                      ),
                    )
                  : _proposals.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.description_outlined,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhuma proposta encontrada',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Você ainda não enviou nenhuma proposta',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadProposals,
                          color: const Color(0xFFFFD700),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _proposals.length,
                            itemBuilder: (context, index) {
                              final proposal = _proposals[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    // Buscar o serviço real antes de navegar
                                    try {
                                      final services = await _serviceService.getActiveServices();
                                      final service = services.firstWhere(
                                        (s) => s.id == proposal.serviceId,
                                        orElse: () => Service(
                                          id: proposal.serviceId,
                                          userId: '',
                                          userName: 'Serviço não encontrado',
                                          title: 'Serviço não encontrado',
                                          description: 'Este serviço não está mais disponível',
                                          serviceType: '',
                                          location: '',
                                          locationType: '',
                                          preferredStartDate: DateTime.now(),
                                          preferredEndDate: DateTime.now(),
                                          preferredTime: '',
                                          budgetRange: 0.0,
                                          requiresMaterials: false,
                                          materialsDescription: '',
                                          status: 'Inactive',
                                          createdAt: DateTime.now(),
                                          updatedAt: DateTime.now(),
                                          materials: [],
                                          proposalCount: 0,
                                        ),
                                      );
                                      
                                      if (mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ServiceDetailScreen(
                                              service: service,
                                            ),
                                          ),
                                        ).then((_) => _loadProposals());
                                      }
                                    } catch (e) {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Erro ao carregar serviço: $e'),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Proposta #${proposal.id}',
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: _getStatusColor(proposal.status),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                _getStatusText(proposal.status),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          proposal.description,
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'R\$ ${proposal.totalCost.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${proposal.estimatedStartDate.day}/${proposal.estimatedStartDate.month}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'até',
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${proposal.estimatedEndDate.day}/${proposal.estimatedEndDate.month}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.grey[600],
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'Para: ${proposal.contractorName}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                            const Spacer(),
                                            if (proposal.rating != null) ...[
                                              Row(
                                                children: List.generate(5, (index) {
                                                  return Icon(
                                                    index < (proposal.rating ?? 0) 
                                                        ? Icons.star 
                                                        : Icons.star_border,
                                                    size: 16,
                                                    color: index < (proposal.rating ?? 0) 
                                                        ? const Color(0xFFFFD700) 
                                                        : Colors.grey[400],
                                                  );
                                                }),
                                              ),
                                              const SizedBox(width: 8),
                                            ],
                                            Text(
                                              'Enviada em ${proposal.createdAt.day}/${proposal.createdAt.month}/${proposal.createdAt.year}',
                                              style: TextStyle(
                                                color: Colors.grey[500],
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Comentário da avaliação (se existir)
                                        if (proposal.evaluationComment != null) ...[
                                          const SizedBox(height: 8),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.green[50],
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.green[200]!),
                                            ),
                                            child: Text(
                                              proposal.evaluationComment!,
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 11,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
