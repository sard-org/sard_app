import 'package:flutter/material.dart';

// These are the import values of your Figma design reference to create your UI responsively.
const double FIGMA_DESIGN_WIDTH = 300;
const double FIGMA_DESIGN_HEIGHT = 800;

/// Extension for responsive scaling
extension ResponsiveExtension on double {
  double get width => (this * SizeUtils.width) / FIGMA_DESIGN_WIDTH;
  double get height => (this * SizeUtils.height) / FIGMA_DESIGN_HEIGHT;
}

/// Extension for formatting numbers
extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double nonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

/// Enum for device type
enum DeviceType { mobile, tablet, desktop }

/// Typedef for responsive builder
typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

/// Widget that helps in responsive UI development
class Sizer extends StatelessWidget {
  const Sizer({Key? key, required this.builder}) : super(key: key);

  /// Builds the widget whenever the orientation changes
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

/// Utility class for screen size calculations
class SizeUtils {
  static late BoxConstraints boxConstraints;
  static late Orientation orientation;
  static late DeviceType deviceType;
  static late double width;
  static late double height;

  static void setScreenSize(BoxConstraints constraints, Orientation currentOrientation) {
    boxConstraints = constraints;
    orientation = currentOrientation;

    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.nonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxHeight.nonZero(defaultValue: FIGMA_DESIGN_HEIGHT);
    } else {
      width = boxConstraints.maxHeight.nonZero(defaultValue: FIGMA_DESIGN_WIDTH);
      height = boxConstraints.maxWidth.nonZero(defaultValue: FIGMA_DESIGN_HEIGHT);
    }

    deviceType = width < 600 ? DeviceType.mobile : (width < 1024 ? DeviceType.tablet : DeviceType.desktop);
  }
}
