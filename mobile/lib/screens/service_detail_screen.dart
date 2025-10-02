import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/proposal.dart';
import '../services/service_service.dart';
import '../services/token_storage.dart';
import '../widgets/app_logo.dart';
import 'create_proposal_screen.dart';
import 'evaluate_proposal_screen.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  final ServiceService _serviceService = ServiceService();
  final TokenStorage _tokenStorage = TokenStorage();
  List<Proposal> _proposals = [];
  bool _isLoadingProposals = true;
  String _errorMessage = '';
  String? _currentUserId;
  bool _hasUserProposal = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
    _loadProposals();
  }

  Future<void> _loadCurrentUser() async {
    final userId = await _tokenStorage.getUserId();
    setState(() {
      _currentUserId = userId;
    });
  }

  Future<void> _loadProposals() async {
    setState(() {
      _isLoadingProposals = true;
      _errorMessage = '';
    });

    try {
      final proposals = await _serviceService.getProposalsByServiceId(widget.service.id);
      setState(() {
        _proposals = proposals;
        _isLoadingProposals = false;
        // Verificar se o usuário atual já fez uma proposta
        _hasUserProposal = _currentUserId != null && 
            proposals.any((proposal) => 
                proposal.contractorId.trim().toLowerCase() == _currentUserId!.trim().toLowerCase());
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoadingProposals = false;
      });
    }
  }

  Future<void> _acceptProposal(Proposal proposal) async {
    try {
      await _serviceService.acceptProposal(proposal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposta aceita com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadProposals();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao aceitar proposta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _completeProposal(Proposal proposal) async {
    try {
      await _serviceService.completeProposal(proposal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Serviço concluído! Agora você pode avaliar o prestador.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadProposals();
        
        // Navegar para a tela de avaliação
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EvaluateProposalScreen(proposal: proposal),
          ),
        );
        
        // Recarregar propostas após avaliação
        if (result == true) {
          _loadProposals();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao concluir proposta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _rejectProposal(Proposal proposal) async {
    try {
      await _serviceService.rejectProposal(proposal.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Proposta rejeitada'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadProposals();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao rejeitar proposta: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Verificar se o usuário atual é o criador do serviço
  bool get _isServiceOwner {
    if (_currentUserId == null) return false;
    
    // Normalizar os IDs removendo espaços e convertendo para minúsculas
    final normalizedCurrentUserId = _currentUserId!.trim().toLowerCase();
    final normalizedServiceUserId = widget.service.userId.trim().toLowerCase();
    
    return normalizedCurrentUserId == normalizedServiceUserId;
  }

  // Verificar se pode fazer proposta
  bool get _canMakeProposal => !_isServiceOwner && !_hasUserProposal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFD700),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD700),
        elevation: 0,
        title: const Text(
          'Detalhes do Serviço',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
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

          // Conteúdo principal
          Expanded(
            child: Container(
              color: Colors.white,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card principal do serviço
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título e status
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.service.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(widget.service.status),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    _getServiceStatusText(widget.service.status),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Informações básicas
                            _buildInfoRow(
                              Icons.work,
                              'Tipo',
                              widget.service.serviceType,
                            ),
                            _buildInfoRow(
                              Icons.location_on,
                              'Localização',
                              widget.service.location,
                            ),
                            _buildInfoRow(
                              Icons.home,
                              'Tipo de Local',
                              widget.service.locationType,
                            ),
                            _buildInfoRow(
                              Icons.person,
                              'Cliente',
                              widget.service.userName,
                            ),
                            _buildInfoRow(
                              Icons.calendar_today,
                              'Período',
                              '${_formatDate(widget.service.preferredStartDate)} - ${_formatDate(widget.service.preferredEndDate)}',
                            ),
                            _buildInfoRow(
                              Icons.access_time,
                              'Horário',
                              widget.service.preferredTime,
                            ),

                            if (widget.service.budgetRange != null)
                              _buildInfoRow(
                                Icons.attach_money,
                                'Orçamento',
                                'R\$ ${widget.service.budgetRange!.toStringAsFixed(0)}',
                              ),

                            const SizedBox(height: 16),

                            // Descrição
                            const Text(
                              'Descrição:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.service.description,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                                height: 1.5,
                              ),
                            ),

                            // Materiais necessários
                            if (widget.service.requiresMaterials) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Materiais Necessários:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (widget.service.materialsDescription != null)
                                Text(
                                  widget.service.materialsDescription!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                            ],

                            // Lista de materiais
                            if (widget.service.materials.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Text(
                                'Lista de Materiais:',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...widget.service.materials.map((material) =>
                                Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              material.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (material.brand != null)
                                              Text(
                                                'Marca: ${material.brand}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            Text(
                                              'Quantidade: ${material.quantity} ${material.unit}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (material.estimatedPrice != null)
                                        Text(
                                          'R\$ ${material.estimatedPrice!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Seção de propostas
                    Row(
                      children: [
                        const Text(
                          'Propostas Recebidas',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_proposals.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Lista de propostas
                    _buildProposalsList(),

                    const SizedBox(height: 24),

                    // Botão para fazer proposta
                    // Botão de proposta com validações
                    if (_canMakeProposal)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateProposalScreen(
                                  service: widget.service,
                                ),
                              ),
                            ).then((_) => _loadProposals());
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Fazer Proposta'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    else if (_isServiceOwner)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Você não pode fazer proposta para seu próprio serviço',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (_hasUserProposal)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Você já fez uma proposta para este serviço',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalsList() {
    if (_isLoadingProposals) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red[200]!),
        ),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              'Erro ao carregar propostas',
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loadProposals,
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (_proposals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Column(
          children: [
            Icon(Icons.handshake_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Nenhuma proposta recebida ainda',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Compartilhe este serviço para receber propostas',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: _proposals.map((proposal) => _buildProposalCard(proposal)).toList(),
    );
  }

  Widget _buildProposalCard(Proposal proposal) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header da proposta
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        proposal.contractorName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Prestador de Serviço',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getProposalStatusColor(proposal.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getProposalStatusText(proposal.status),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Avaliação (se existir)
            if (proposal.rating != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xFFFFD700),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Avaliação: ${proposal.rating}/5',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    if (proposal.evaluationComment != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        proposal.evaluationComment!,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Descrição da proposta
            Text(
              proposal.description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Informações financeiras
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mão de Obra',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'R\$ ${proposal.laborCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                if (proposal.materialCost != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Materiais',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'R\$ ${proposal.materialCost!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'R\$ ${proposal.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Prazo
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Prazo: ${_formatDate(proposal.estimatedStartDate)} - ${_formatDate(proposal.estimatedEndDate)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            // Botões de ação (apenas para o criador do serviço)
            if (_isServiceOwner) ...[
              const SizedBox(height: 16),
              if (proposal.status.toLowerCase() == 'pending') ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _rejectProposal(proposal),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text('Rejeitar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _acceptProposal(proposal),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Aceitar'),
                      ),
                    ),
                  ],
                ),
              ] else if (proposal.status.toLowerCase() == 'accepted') ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _completeProposal(proposal),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFD700),
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Concluir Serviço'),
                  ),
                ),
              ] else if (proposal.status.toLowerCase() == 'completed' && proposal.rating == null) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EvaluateProposalScreen(proposal: proposal),
                        ),
                      ).then((result) {
                        if (result == true) {
                          _loadProposals();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Avaliar Serviço'),
                  ),
                ),
              ] else if (proposal.status.toLowerCase() == 'completed' && proposal.rating != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < (proposal.rating ?? 0) ? Icons.star : Icons.star_border,
                            size: 24,
                            color: index < (proposal.rating ?? 0) 
                                ? const Color(0xFFFFD700) 
                                : Colors.grey[400],
                          );
                        }),
                      ),
                      if (proposal.evaluationComment != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          proposal.evaluationComment!,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getProposalStatusColor(String status) {
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _getServiceStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return 'Ativo';
      case 'inprogress':
        return 'Em Execução';
      case 'completed':
        return 'Concluído';
      case 'cancelled':
        return 'Cancelado';
      default:
        return status;
    }
  }

  String _getProposalStatusText(String status) {
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
}
