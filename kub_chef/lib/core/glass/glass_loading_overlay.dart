import 'package:flutter/material.dart';
import 'package:kub_chef/core/glass/glass_container.dart';


class GlassLoadingOverlay extends StatelessWidget {
  final bool loading;
  final Widget child;
  final String? message;
  const GlassLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: AnimatedOpacity(
                opacity: loading ? 1 : 0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(32),
                  child: GlassContainer(
                    elevation: 8,
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(strokeWidth: 5),
                        ),
                        if (message != null) ...[
                          const SizedBox(height: 18),
                          Text(
                            message!,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}