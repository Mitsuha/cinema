import 'package:flutter/material.dart';
import 'package:hourglass/components/player/controller.dart';
import 'package:hourglass/components/player/state.dart';
import 'package:provider/provider.dart';
import 'package:hourglass/helpers.dart';

class StatusIndication extends StatelessWidget {
  const StatusIndication({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = context.read<PlayerController>();
    var state = context.watch<PlayerState>();

    if (state.fastForwardTo != Duration.zero) {
      return notifierWarp(
        child: Text("${state.fastForwardTo.humanRead()}/${controller.duration.humanRead()}"),
      );
    }

    if (state.brightUpdating || state.volumeUpdating) {
      return SizedBox(
        width: 160,
        child: notifierWarp(
          child: Row(
            children: [
              Icon(
                state.brightUpdating ? Icons.wb_sunny_outlined : Icons.volume_up,
                color: Colors.white,
                size: 19,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: LinearProgressIndicator(
                  value: state.brightUpdating ? state.brightValue : state.volumeValue,
                  color: Colors.white,
                  backgroundColor: const Color(0x30FFFFFF),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget notifierWarp({required Widget child}) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Color(0x90000000),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: child,
        ),
      );
}
