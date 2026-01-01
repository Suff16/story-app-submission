import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/story_provider.dart';
import '../l10n/app_localizations.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // Navigasi Back menggunakan goNamed (Declarative)
  void _onBack() {
    context.goNamed('stories');
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // HAPUS TOTAL: context.pop();
      // Kita tidak butuh pop karena tidak ada dialog yang dibuka.

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null && mounted) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        final localization = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${localization.translate('failed_to_pick_image')}: $e',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // HAPUS TOTAL: void _showImageSourceDialog() { ... }
  // Kita ganti dengan UI tombol langsung di layar.

  Future<void> _uploadStory() async {
    if (_isUploading) return;

    final localization = AppLocalizations.of(context);

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localization.translate('please_select_image')),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      final storyProvider = context.read<StoryProvider>();

      try {
        final success = await storyProvider.addStory(
          _selectedImage!,
          _descriptionController.text.trim(),
        );

        if (!mounted) return;

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                localization.translate('story_uploaded_successfully'),
              ),
              backgroundColor: Colors.green,
            ),
          );
          await Future.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            // Navigasi sukses menggunakan goNamed (Declarative)
            context.goNamed('stories');
          }
        } else {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                storyProvider.errorMessage ??
                    localization.translate('failed_to_upload_story'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onBack();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(localization.translate('add_new_story')),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _isUploading ? null : _onBack,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container Gambar
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[400]!, width: 2),
                  ),
                  child: _selectedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(_selectedImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 64,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localization.translate('tap_to_select_image'),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(height: 16),

    
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading
                            ? null
                            : () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: Text(localization.translate('camera')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isUploading
                            ? null
                            : () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: Text(localization.translate('gallery')),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 5,
                  enabled: !_isUploading,
                  decoration: InputDecoration(
                    labelText: localization.translate('description'),
                    hintText: localization.translate('write_description_hint'),
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('please_enter_description');
                    }
                    if (value.length < 10) {
                      return localization.translate('description_min_10_chars');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isUploading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _uploadStory,
                        icon: const Icon(Icons.upload),
                        label: Text(localization.translate('upload_story')),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
