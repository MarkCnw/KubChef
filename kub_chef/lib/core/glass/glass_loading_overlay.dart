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
                  padding: const EdgeInsets.all(40),
                  child: GlassContainer(
                    elevation: 10,
                    padding: const EdgeInsets.all(36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          child: const CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        if (message != null) ...[
                          const SizedBox(height: 24),
                          Text(
                            message!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.white,
                            ),
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