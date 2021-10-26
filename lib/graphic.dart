/// This library includes a [Chart] Flutter widget for data visualization and classes
/// for it's specification. Besids, it also provides some util classes and functions
/// for customization.
/// 
/// There are some basic conccepts for this data visualization, most of witch derive
/// from the Grammar of Graphics. they compose the parameters of the [Chart]'s constructor:
/// 
/// - **data**, the input data list, can be of any item type.
/// - **variable**, defines the fields of **tuple**, which is the real datum object
/// inside the chart.
/// - **scale**, to scale and normalize the values.
/// - **aesthetic**, to assign values to certain attributes for rendering.
/// - **element**, the graphics visualizing data tuples.
/// - **coordinate**, to locate abstract position values on the canvas.
/// - **shape**, decide how to render the elements.
/// - **signal**, a event that may cause a value changing.
/// - **selection**, the state whether a tuple is selected.
/// - **figure**, which is generated by chart evaluation and carries graphic information
/// for rendering engine to paint.
/// 
/// See details and others in the class documents below.
library graphic;

export 'src/chart/chart.dart' show Chart;
export 'src/chart/size.dart' show ResizeSignal;

export 'src/data/data_set.dart' show ChangeDataSignal;

export 'src/variable/variable.dart' show Variable;
export 'src/variable/transform/filter.dart' show Filter;
export 'src/variable/transform/map.dart' show MapTrans;
export 'src/variable/transform/proportion.dart' show Proportion;
export 'src/variable/transform/sort.dart' show Sort;

export 'src/scale/linear.dart' show LinearScale;
export 'src/scale/ordinal.dart' show OrdinalScale;
export 'src/scale/time.dart' show TimeScale;

export 'src/geom/area.dart' show AreaElement;
export 'src/geom/custom.dart' show CustomElement;
export 'src/geom/interval.dart' show IntervalElement;
export 'src/geom/line.dart' show LineElement;
export 'src/geom/point.dart' show PointElement;
export 'src/geom/polygon.dart' show PolygonElement;
export 'src/geom/modifier/dodge.dart' show DodgeModifier;
export 'src/geom/modifier/stack.dart' show StackModifier;
export 'src/geom/modifier/jitter.dart' show JitterModifier;
export 'src/geom/modifier/symmetric.dart' show SymmetricModifier;

export 'src/aes/color.dart' show ColorAttr;
export 'src/aes/elevation.dart' show ElevationAttr;
export 'src/aes/gradient.dart' show GradientAttr;
export 'src/aes/label.dart' show LabelAttr;
export 'src/aes/shape.dart' show ShapeAttr;
export 'src/aes/size.dart' show SizeAttr;

export 'src/algebra/varset.dart' show Varset;

export 'src/shape/area.dart' show AreaShape, BasicAreaShape;
export 'src/shape/custom.dart' show CustomShape, CandlestickShape;
export 'src/shape/interval.dart' show IntervalShape, RectShape, FunnelShape;
export 'src/shape/line.dart' show LineShape, BasicLineShape;
export 'src/shape/point.dart' show PointShape, CircleShape, SquareShape;
export 'src/shape/polygon.dart' show PolygonShape, HeatmapShape;
export 'src/shape/util/render_basic_item.dart' show renderBasicItem;

export 'src/graffiti/figure.dart'
  show Figure, PathFigure, ShadowFigure, TextFigure, RotatedTextFigure;

export 'src/coord/coord.dart' show CoordConv;
export 'src/coord/polar.dart' show PolarCoord, PolarCoordConv;
export 'src/coord/rect.dart' show RectCoord, RectCoordConv;

export 'src/guide/axis/axis.dart'
  show TickLine, TickLineMapper, LabelMapper, GridMapper, AxisGuide;
export 'src/guide/interaction/tooltip.dart' show TooltipGuide, RenderTooltip;
export 'src/guide/interaction/crosshair.dart' show CrosshairGuide;
export 'src/guide/annotation/line.dart' show LineAnnotation;
export 'src/guide/annotation/region.dart' show RegionAnnotation;
export 'src/guide/annotation/mark.dart' show MarkAnnotation;
export 'src/guide/annotation/tag.dart' show TagAnnotation;
export 'src/guide/annotation/custom.dart' show CustomAnnotation;

export 'src/interaction/signal.dart' show Signal, SignalType, SignalUpdate;
export 'src/interaction/gesture.dart' show GestureType, Gesture, GestureSignal;
export 'src/interaction/selection/selection.dart' show SelectionUpdate;
export 'src/interaction/selection/interval.dart' show IntervalSelection;
export 'src/interaction/selection/point.dart' show PointSelection;

export 'src/common/styles.dart' show StrokeStyle;
export 'src/common/label.dart' show Label, LabelStyle, renderLabel, getPaintPoint;
export 'src/common/defaults.dart' show Defaults;

export 'src/dataflow/tuple.dart' show Tuple, Aes;

export 'src/util/path.dart' show Paths;
