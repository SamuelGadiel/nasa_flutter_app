import '../../../../core/failures/failure.dart';

abstract class ImageOfTheDayFailures implements Failure {
  final String message;

  const ImageOfTheDayFailures(this.message); // coverage:ignore-line
}
