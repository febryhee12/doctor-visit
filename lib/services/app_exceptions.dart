class AppExcetption implements Exception {
  final String? message;
  final String? prefix;
  final String? url;

  AppExcetption(this.message, this.prefix, this.url);
}

class BadRequestException extends AppExcetption {
  BadRequestException(String message, String url)
      : super(message, 'Bad Request', url);
}

class FetchDataException extends AppExcetption {
  FetchDataException(String message, String url)
      : super(message, 'Unable to process', url);
}

class ApiNotRespondingException extends AppExcetption {
  ApiNotRespondingException(String message, String url)
      : super(message, 'Api not responded', url);
}

class UnAuthorizedException extends AppExcetption {
  UnAuthorizedException(String message, String url)
      : super(message, 'UnAuthorized Request', url);
}
