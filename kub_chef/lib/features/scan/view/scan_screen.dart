import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../common_widgets/loading_overlay.dart';
import '../../../common_widgets/primary_button.dart';
import '../provider/scan_provider.dart';
import '../../suggestions/view/suggestions_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.watch<ScanProvider>();
    return LoadingOverlay(
      loading: p.loading,
      child: Scaffold(
        appBar: AppBar(title: const Text('Scan')),
        bottomNavigationBar: NavigationBar(
          selectedIndex: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              label: 'Recipes',
            ),
            NavigationDestination(
              icon: Icon(Icons.bookmark_border),
              label: 'Saved',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => _showPicker(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.surfaceVariant,
                    ),
                    child: p.image == null
                        ? const Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt, size: 40),
                                SizedBox(height: 8),
                                Text('Take Photo or Upload'),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(16),
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
              const SizedBox(height: 16),
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
                              builder: (_) =>
                                  SuggestionsScreen(result: res),
                            ),
                          );
                        }
                      },
              ),
              if (p.error != null) ...[
                const SizedBox(height: 8),
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
