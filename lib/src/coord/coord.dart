import 'dart:ui';
import 'dart:math';

import 'package:flutter/painting.dart';
import 'package:graphic/src/chart/view.dart';
import 'package:graphic/src/common/converter.dart';
import 'package:graphic/src/common/operators/value.dart';
import 'package:graphic/src/dataflow/operator.dart';
import 'package:graphic/src/dataflow/tuple.dart';
import 'package:graphic/src/interaction/signal.dart';
import 'package:graphic/src/parse/parse.dart';
import 'package:graphic/src/parse/spec.dart';

import 'rect.dart';
import 'polar.dart';

/// Specification of the coordinate.
/// 
/// As in a plane, The count of coordinate dimensions can be 1 or 2 (Which is set
/// by [dimCount]).
/// 
/// For a 2 dimensions coordinate, the coordinate will have both **domain dimension**
/// (usually denoted as "x") and **measure dimension** (usually denoted as "y").
/// 
/// For a 1 dimension coordinate, the coordinate will only have measure dimension,
/// and all points' domain dimensions will be set to [dimFill] for rendering position.
/// 
/// The **coordinate region** is the visual boundary rectangle of the coordinate
/// on the chart widget. It is determined by chart size and padding. the coordinate
/// range may be smaller or larger than the region. The range properties of [RectCoord]
/// and [PolarCoord] is are define in ratio to coordinate region.
abstract class Coord {
  /// Creates a coordinate.
  Coord({
    this.dimCount,
    this.dimFill,
    this.transposed,
  }) : assert(dimCount == null || (dimCount >= 1 && dimCount <=2));

  /// The count of coordinate dimensions.
  /// 
  /// If null, a default 2 is set.
  int? dimCount;

  /// The position value to fill the domain dimension when [dimCount] is 1.
  /// 
  /// It is a normalized value of `[0, 1]`.
  /// 
  /// If null, a default 0.5 is set, which means in the middle of the dimension.
  double? dimFill;

  /// Weither to transpose domain dimension and measure dimension.
  bool? transposed;

  @override
  bool operator ==(Object other) =>
    other is Coord &&
    dimCount == other.dimCount &&
    dimFill == other.dimFill &&
    transposed == other.transposed;
}

/// The converter of a coordinate.
/// 
/// The inputs are abstract position points from [Aes.position] and outputs are
/// canvas points.
abstract class CoordConv extends Converter<Offset, Offset> {
  /// Creates a coordinate converter.
  CoordConv(
    this.dimCount,
    this.dimFill,
    this.transposed,
    this.region,
  );

  /// The [Coord.dimCount].
  final int dimCount;

  /// The [Coord.dimFill].
  final double dimFill;

  /// The [Coord.transposed].
  final bool transposed;

  /// The coordinate region.
  final Rect region;

  /// Transforms an abstract dimension to canvas dimension according to whether
  /// [transposed].
  int getCanvasDim(int abstractDim) =>
    dimCount == 1
      // The last dimension is the mearure dimension.
      ? (transposed ? 1 : 2)
      : (transposed ? (3 - abstractDim) : abstractDim);
  
  /// Inverts a distance in canvas to abstract distance.
  double invertDistance(double canvasDistance, [int? dim]);
}

/// params:
/// All params needed to create a coord converter.
abstract class CoordConvOp<C extends CoordConv> extends Operator<C> {
  CoordConvOp(
    Map<String, dynamic> params,
  ) : super(params);  // The first value should be created in the first run.
}

class RegionOp extends Operator<Rect> {
  RegionOp(
    Map<String, dynamic> params,
  ) : super(params);

  @override
  Rect evaluate() {
    final size = params['size'] as Size;
    final padding = params['padding'] as EdgeInsets;

    final container = Rect.fromLTWH(0, 0, size.width, size.height);
    return padding.deflateRect(container);
  }
}

void parseCoord(
  Spec spec,
  View view,
  Scope scope,
) {
  final region = view.add(RegionOp({
    'size': scope.size,
    'padding': spec.padding ?? (
      spec.coord is PolarCoord
        ? EdgeInsets.all(10)
        : EdgeInsets.fromLTRB(40, 5, 10, 20)
    ),
  }));

  final coordSpec = spec.coord ?? RectCoord();

  if (coordSpec is RectCoord) {
    Operator<List<double>> horizontalRange = view.add(Value<List<double>>(
      coordSpec.horizontalRange ?? [0, 1],
    ));
    if (coordSpec.onHorizontalRangeSignal != null) {
      horizontalRange = view.add(SignalUpdateOp({
        'update': coordSpec.onHorizontalRangeSignal,
        'initialValue': horizontalRange,
        'signal': scope.signal,
      }));
    }
    Operator<List<double>> verticalRange = view.add(Value<List<double>>(
      coordSpec.verticalRange ?? [0, 1],
    ));
    if (coordSpec.onVerticalRangeSignal != null) {
      verticalRange = view.add(SignalUpdateOp({
        'update': coordSpec.onVerticalRangeSignal,
        'initialValue': verticalRange,
        'signal': scope.signal,
      }));
    }

    scope.coord = view.add(RectCoordConvOp({
      'region': region,
      'dimCount': coordSpec.dimCount ?? 2,
      'dimFill': coordSpec.dimFill ?? 0.5,
      'transposed': coordSpec.transposed ?? false,
      'renderRangeX': horizontalRange,
      'renderRangeY': verticalRange,
    }));
  } else {
    coordSpec as PolarCoord;
    Operator<List<double>> angleRange = view.add(Value<List<double>>(
      coordSpec.angleRange ?? [0, 1],
    ));
    if (coordSpec.onAngleRangeSignal != null) {
      angleRange = view.add(SignalUpdateOp({
        'update': coordSpec.onAngleRangeSignal,
        'initialValue': angleRange,
        'signal': scope.signal,
      }));
    }
    Operator<List<double>> radiusRange = view.add(Value<List<double>>(
      coordSpec.radiusRange ?? [0, 1],
    ));
    if (coordSpec.onRadiusRangeSignal != null) {
      radiusRange = view.add(SignalUpdateOp({
        'update': coordSpec.onRadiusRangeSignal,
        'initialValue': radiusRange,
        'signal': scope.signal,
      }));
    }

    scope.coord = view.add(PolarCoordConvOp({
      'region': region,
      'dimCount': coordSpec.dimCount ?? 2,
      'dimFill': coordSpec.dimFill ?? 0.5,
      'transposed': coordSpec.transposed ?? false,
      'renderRangeX': angleRange,
      'renderRangeY': radiusRange,
      'startAngle': coordSpec.startAngle ?? (-pi / 2),
      'endAngle': coordSpec.endAngle ?? (3 * pi / 2),
      'startRadius': coordSpec.startRadius ?? 0.0,
      'endRadius': coordSpec.endRadius ?? 1.0,
    }));
  }
}
