import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/glass/glass_loading_overlay.dart';
import '../../../core/glass/glass_container.dart';
import '../../../core/glass/primary_glass_button.dart';
import '../provider/scan_provider.dart';
import '../../suggestions/view/suggestions_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScanProvider>();
    return GlassLoadingOverlay(
      loading: p.loading,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          children: [
            Expanded(
              child: GlassContainer(
                interactive: true,
                onTap: () => _showPicker(context),
                elevation: p.image != null ? 6 : 2,
                padding: EdgeInsets.zero,
                child: p.image == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 56,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Capture or Upload',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Take a photo of your ingredients',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white.withOpacity(0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(28),
                        child: Stack(
                          children: [
                            Image.file(
                              p.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: GlassContainer(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryGlassButton(
              label: 'Analyze Ingredients',
              icon: Icons.analytics_outlined,
              onPressed: p.image == null
                  ? null
                  : () async {
                      final res = await context
                          .read<ScanProvider>()
                          .analyze();
                      if (res != null && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SuggestionsScreen(result: res),
                          ),
                        );
                      }
                    },
            ),
            if (p.error != null) ...[
              const SizedBox(height: 16),
              GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.error,
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
    );
  }

  void _showPicker(BuildContext context) {
    final p = context.read<ScanProvider>();
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: GlassContainer(
          elevation: 8,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'Choose Photo Source',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: GlassContainer(
                          interactive: true,
                          onTap: () {
                            Navigator.pop(context);
                            p.pickImage(source: ImageSource.camera);
                          },
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.photo_camera_outlined,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Camera',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GlassContainer(
                          interactive: true,
                          onTap: () {
                            Navigator.pop(context);
                            p.pickImage(source: ImageSource.gallery);
                          },
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: const Icon(
                                  Icons.photo_library_outlined,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Gallery',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
