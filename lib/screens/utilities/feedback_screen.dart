import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/constants.dart';
import '../../widgets/shared_widgets.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _messageController = TextEditingController();
  String _feedbackType = 'report'; // 'report' or 'suggestion'
  String _selectedReason = 'Fraudulent';
  bool _submitted = false;

  final List<String> _reportReasons = [
    'Fraudulent',
    'Inappropriate Content',
    'Wrong Information',
    'Spam',
    'Not a Car',
    'Other',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (_messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a message')),
      );
      return;
    }

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    // Simulate submission
    await Future.delayed(const Duration(seconds: 2));

    Navigator.pop(context); // Close loading

    setState(() => _submitted = true);
    _messageController.clear();

    // Reset after showing success
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _submitted = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.active;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback & Support'),
        elevation: 0,
        backgroundColor: theme.bg,
        foregroundColor: theme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_submitted)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Thank You!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          Text(
                            'Your feedback has been sent to our team.',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              Text(
                'Help Us Improve',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Report issues or suggest improvements',
                style: TextStyle(color: C.textSub, fontSize: 14),
              ),
              const SizedBox(height: 24),

              // Feedback Type Selector
              Text(
                'What is this about?',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: C.textSub,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _feedbackType = 'report'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _feedbackType == 'report'
                              ? theme.primary
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _feedbackType == 'report'
                                ? theme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Report Issue',
                            style: TextStyle(
                              color: _feedbackType == 'report'
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _feedbackType = 'suggestion'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        decoration: BoxDecoration(
                          color: _feedbackType == 'suggestion'
                              ? theme.primary
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _feedbackType == 'suggestion'
                                ? theme.primary
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Suggestion',
                            style: TextStyle(
                              color: _feedbackType == 'suggestion'
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Reason Dropdown (only for reports)
              if (_feedbackType == 'report') ...[
                Text(
                  'What is the issue?',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: C.textSub,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    value: _selectedReason,
                    items: _reportReasons
                        .map(
                          (reason) => DropdownMenuItem(
                            value: reason,
                            child: Text(reason),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedReason = value!);
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Message Box
              Text(
                'Details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: C.textSub,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageController,
                maxLines: 6,
                decoration: InputDecoration(
                  hintText: _feedbackType == 'report'
                      ? 'Describe the issue in detail...'
                      : 'Tell us your idea...',
                  hintStyle: TextStyle(color: C.textSub),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your feedback is important to us. Our team reviews all submissions within 24 hours.',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
              PriBtn(
                label: 'Submit',
                onTap: _submitFeedback,
              ),
              const SizedBox(height: 24),

              // Contact Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'Need immediate help?',
                      style: TextStyle(color: C.textSub),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'support@carpro.io',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
