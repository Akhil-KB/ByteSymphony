import 'package:flutter/material.dart';
import '../models/client_model.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import 'package:bytesymphony/services/api_services.dart';
class ClientFormScreen extends StatefulWidget {
  final ClientModel? client;

  const ClientFormScreen({super.key, this.client});

  @override
  State<ClientFormScreen> createState() => _ClientFormScreenState();
}

class _ClientFormScreenState extends State<ClientFormScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  bool _isLoading = false;
  bool get isEditing => widget.client != null;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(
      text: widget.client?.firstName ?? '',
    );
    lastNameController = TextEditingController(
      text: widget.client?.lastName ?? '',
    );
    emailController = TextEditingController(
      text: widget.client?.email ?? '',
    );
    phoneController = TextEditingController(
      text: widget.client?.phone ?? '',
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveClient() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final client = ClientModel(
      id: widget.client?.id,
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
    );

    final result = isEditing
        ? await ApiService.updateClient(widget.client!.id!.toString(), client)
        : await ApiService.createClient(client);

    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      if (result['success']) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        title: Text(
          isEditing ? 'Edit Client' : 'Add Client',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isEditing ? Icons.edit : Icons.person_add,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isEditing ? 'Update Information' : 'New Client',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isEditing
                                ? 'Modify client details below'
                                : 'Enter client information',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form Fields Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    CustomTextField(
                      label: 'First Name',
                      hint: 'Enter first name',
                      controller: firstNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Last Name',
                      hint: 'Enter last name',
                      controller: lastNameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Email',
                      hint: 'Enter email address',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter email';
                        }

                        // Comprehensive email regex pattern
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid email address';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    CustomTextField(
                      label: 'Phone',
                      hint: 'Enter phone number',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter phone number';
                        }

                        // Remove all non-digit characters to count actual digits
                        final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

                        // Check if exactly 10 digits
                        if (digitsOnly.length < 10) {
                          return 'Phone number must be at least 10 digits';
                        }

                        if (digitsOnly.length > 10) {
                          return 'Phone number cannot exceed 10 digits';
                        }

                        // Phone regex: supports multiple formats
                        // Accepts: +1234567890, 1234567890, (123) 456-7890, 123-456-7890, etc.
                        final phoneRegex = RegExp(
                          r'^[\+]?[(]?[0-9]{1,4}[)]?[-\s\.]?[(]?[0-9]{1,4}[)]?[-\s\.]?[0-9]{1,9}$',
                        );

                        if (!phoneRegex.hasMatch(value.trim())) {
                          return 'Please enter a valid phone number';
                        }

                        return null;
                      },
                    ),


                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      isOutlined: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: isEditing ? 'Update' : 'Create',
                      onPressed: _saveClient,
                      isLoading: _isLoading,
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
