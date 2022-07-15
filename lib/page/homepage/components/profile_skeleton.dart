import 'package:flutter/material.dart';

class UserProfileSkeleton extends StatefulWidget {
  const UserProfileSkeleton({Key? key}) : super(key: key);

  @override
  State<UserProfileSkeleton> createState() => _UserProfileSkeletonState();
}

class _UserProfileSkeletonState extends State<UserProfileSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Skeleton(animation: _animationController, size: const Size(60, 60),shape: BoxShape.circle),
              const SizedBox(height: 5),
              Skeleton(animation: _animationController, size: const Size(60, 18)),
              const SizedBox(height: 10),
              SizedBox(
                width: 180,
                child: Align(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Skeleton(animation: _animationController, size: const Size(70, 15)),
                      const SizedBox(height: 5),
                      Skeleton(animation: _animationController, size: const Size(double.infinity, 5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  final AnimationController animation;
  final Size size;
  final BoxShape? shape;

  const Skeleton({Key? key, required this.animation, required this.size, this.shape}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        var stop = animation.value;

        return SizedBox(
          width: size.width,
          height: size.height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: shape ?? BoxShape.rectangle,
              gradient: LinearGradient(
                begin: const Alignment(-2, .5),
                end: const Alignment(1, 1),
                colors: const [Color(0x08000000), Color(0x10000000), Color(0x08000000)],
                stops: [stop, stop + 0.3, stop + 0.6],
              ),
            ),
          ),
        );
      },
    );
  }
}
