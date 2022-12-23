import 'failure.dart';

class GenericFailure implements Failure {
  final String message;

  GenericFailure(this.message);
}
