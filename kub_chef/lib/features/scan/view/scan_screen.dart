import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/loading_overlay.dart';
import '../provider/scan_provider.dart';
import '../../suggestions/view/suggestions_screen.dart';
import '../../../common_widgets/primary_button.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScanProvider>();
    return LoadingOverlay(
      loading: p.loading,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _showPicker(context),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceVariant.withOpacity(0.35),
                  ),
                  child: p.image == null
                      ? const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.camera_alt, size: 48),
                              SizedBox(height: 10),
                              Text('Tap to Capture or Upload'),
                            ],
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(24),
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
            const SizedBox(height: 18),
            PrimaryButton(
              label: 'Analyze',
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
              const SizedBox(height: 10),
              Text(
                p.error!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
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
      builder: (_) => SafeArea(
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
    );
  }
}
