import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kub_chef/core/glass/glass_app.dart';
import 'package:kub_chef/core/glass/glass_loading_overlay.dart';
import 'package:kub_chef/core/glass/primary_glass_button.dart';
import 'package:provider/provider.dart';

import '../../../core/glass/glass_container.dart';
import '../../suggestions/view/suggestions_screen.dart';
import '../provider/scan_provider.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScanProvider>();

    return GlassLoadingOverlay(
      loading: p.loading,
      message: 'Analyzing image...',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const GlassAppBar(title: 'Scan Ingredients'),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showPicker(context),
                  borderRadius: BorderRadius.circular(30),
                  child: GlassContainer(
                    elevation: 4,
                    padding: EdgeInsets.zero,
                    child: p.image == null
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 60,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Tap to Capture or Upload',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'JPG / PNG • Clear the ingredients',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.white70),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.file(
                              p.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: PrimaryGlassButton(
                      label: 'Retake',
                      icon: Icons.refresh,
                      onPressed: p.image == null
                          ? null
                          : () => p.pickImage(source: ImageSource.camera),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PrimaryGlassButton(
                      label: 'Analyze',
                      icon: Icons.auto_awesome,
                      onPressed: p.image == null
                          ? null
                          : () async {
                              final res = await context
                                  .read<ScanProvider>()
                                  .analyze();
                              if (res != null && context.mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SuggestionsScreen(result: res),
                                  ),
                                );
                              }
                            },
                    ),
                  ),
                ],
              ),
              if (p.error != null) ...[
                const SizedBox(height: 12),
                GlassContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  elevation: 1,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          p.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPicker(BuildContext context) {
    final p = context.read<ScanProvider>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
        child: GlassContainer(
          elevation: 6,
          padding: EdgeInsets.zero,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    p.pickImage(source: ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Upload from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    p.pickImage(source: ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
