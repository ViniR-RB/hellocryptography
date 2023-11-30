sealed class Either<E extends Exception, S> {}

final class Sucess<E extends Exception, S> extends Either<E, S> {
  final S value;
  Sucess(this.value);
}

final class Failure<E extends Exception, S> extends Either<E, S> {
  final E exception;
  Failure(this.exception);
}
