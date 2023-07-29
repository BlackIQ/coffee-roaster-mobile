class ConstData {
  final bool isProduction = true;

  final String _localUrl = 'http://localhost:8000/api';
  final String _serverUrl = 'https://roaster.amirhossein.info/api';

  String get getBaseUrl => isProduction ? _serverUrl : _localUrl;
}
