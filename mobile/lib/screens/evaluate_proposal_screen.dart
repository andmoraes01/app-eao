import 'package:flutter/material.dart';
import '../models/proposal.dart';
import '../services/service_service.dart';
import '../widgets/app_logo.dart';

class EvaluateProposalScreen extends StatefulWidget {
  final Proposal proposal;

  const EvaluateProposalScreen({
    super.key,
    required this.proposal,
  });

  @override
  State<EvaluateProposalScreen> createState() => _EvaluateProposalScreenState();
}

class _EvaluateProposalScreenState extends State<EvaluateProposalScreen> {
  final ServiceService _serviceService = ServiceService();
  final TextEditingController _commentController = TextEditingController();
  int _rating = 0;
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitEvaluation() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione uma nota de 1 a 5 estrelas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = EvaluateProposalRequest(
        rating: _rating,
        evaluationComment: _commentController.text.trim().isEmpty 
            ? null 
            : _commentController.text.trim(),
      );

      await _serviceService.evaluateProposal(widget.proposal.id, request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avaliação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true); // Retorna true para indicar sucesso
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar avaliação: $e'),
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
        title: const Text(
          'Avaliar Serviço',
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
                  'Como foi o serviço?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Avalie o prestador: ${widget.proposal.contractorName}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // Conteúdo
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avaliação por estrelas
                    const Text(
                      'Nota (obrigatório)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(
                                index < _rating ? Icons.star : Icons.star_border,
                                size: 48,
                                color: index < _rating 
                                    ? const Color(0xFFFFD700) 
                                    : Colors.grey[400],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        _rating == 0 
                            ? 'Toque nas estrelas para avaliar'
                            : _rating == 1 
                                ? 'Péssimo'
                                : _rating == 2 
                                    ? 'Ruim'
                                    : _rating == 3 
                                        ? 'Regular'
                                        : _rating == 4 
                                            ? 'Bom'
                                            : 'Excelente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: _rating == 0 ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Comentário
                    const Text(
                      'Comentário (opcional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _commentController,
                      maxLines: 5,
                      maxLength: 1000,
                      decoration: InputDecoration(
                        hintText: 'Conte como foi a experiência com o prestador...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFFFD700),
                            width: 2,
                          ),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),

                    const Spacer(),

                    // Botão enviar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitEvaluation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                ),
                              )
                            : const Text(
                                'Enviar Avaliação',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
    );
  }
}
