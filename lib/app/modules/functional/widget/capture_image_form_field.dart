import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';

class CaptureImageFormField extends StatefulWidget {
  const CaptureImageFormField({
    super.key,
    required this.name,
    required this.label,
    this.initialValue,
    this.required = false,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  final String name;
  final String label;

  /// Existing image path, if any.
  final String? initialValue;

  final bool required;
  final bool enabled;

  final String? Function(String?)? validator;

  final ValueChanged<String?>? onChanged;

  @override
  State<CaptureImageFormField> createState() => _CaptureImageFormFieldState();
}

class _CaptureImageFormFieldState extends State<CaptureImageFormField> {
  final ImagePicker _picker = ImagePicker();

  String? _imagePath;

  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();

    _imagePath = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilderField<String>(
      name: widget.name,
      initialValue: _imagePath,
      enabled: widget.enabled,
      validator: widget.validator,

      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel(),

            const SizedBox(height: 8),

            if (_imagePath == null || _imagePath!.isEmpty)
              _buildCaptureButton(field)
            else
              _buildImagePreview(field),

            if (field.errorText != null) _buildError(field.errorText!),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // LABEL
  // ===========================================================================

  Widget _buildLabel() {
    return RichText(
      text: TextSpan(
        text: widget.label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
        children: [
          if (widget.required)
            const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }

  // ===========================================================================
  // CAPTURE BUTTON
  // ===========================================================================

  Widget _buildCaptureButton(FormFieldState<String> field) {
    return InkWell(
      onTap:
          widget.enabled && !_isCapturing ? () => _captureImage(field) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            _isCapturing
                ? const Center(
                  child: SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
                : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(width: 8),
                    Text('Capture Image'),
                  ],
                ),
      ),
    );
  }

  // ===========================================================================
  // IMAGE PREVIEW
  // ===========================================================================

  Widget _buildImagePreview(FormFieldState<String> field) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(_imagePath!),
            ),

            // Remove button
            Positioned(
              top: 5,
              right: 5,
              child: GestureDetector(
                onTap: _isCapturing ? null : () => _removeImage(field),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(width: 12),

        // Retake button
        OutlinedButton.icon(
          onPressed:
              widget.enabled && !_isCapturing
                  ? () => _captureImage(field)
                  : null,
          icon: const Icon(Icons.camera_alt_outlined),
          label: const Text('Retake'),
        ),
      ],
    );
  }

  // ===========================================================================
  // IMAGE
  // ===========================================================================

  Widget _buildImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _buildImageError();
        },
      );
    }

    return Image.file(
      File(path),
      width: 120,
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return _buildImageError();
      },
    );
  }

  // ===========================================================================
  // CAPTURE
  // ===========================================================================

  Future<void> _captureImage(FormFieldState<String> field) async {
    if (_isCapturing) {
      return;
    }

    try {
      setState(() {
        _isCapturing = true;
      });

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (image == null) {
        return;
      }

      final String path = image.path;

      setState(() {
        _imagePath = path;
      });

      // Update FormBuilder value.
      field.didChange(path);

      // Notify parent/dynamic form.
      widget.onChanged?.call(path);
    } catch (e, stackTrace) {
      debugPrint('Capture image error: $e');

      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  // ===========================================================================
  // REMOVE
  // ===========================================================================

  void _removeImage(FormFieldState<String> field) {
    setState(() {
      _imagePath = null;
    });

    field.didChange(null);

    widget.onChanged?.call(null);
  }

  // ===========================================================================
  // ERROR
  // ===========================================================================

  Widget _buildError(String error) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Text(
        error,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontSize: 12,
        ),
      ),
    );
  }

  // ===========================================================================
  // IMAGE ERROR
  // ===========================================================================

  Widget _buildImageError() {
    return Container(
      width: 120,
      height: 120,
      color: Colors.grey.shade200,
      child: const Icon(Icons.broken_image, color: Colors.grey),
    );
  }
}
