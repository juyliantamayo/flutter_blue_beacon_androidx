import 'package:http/http.dart' as http;

class HttpService {
  Future<http.Response> getPassword() {
    return http.get('https://whispering-headland-55740.herokuapp.com/password');
  }

  Future<http.Response> setPassword(String uuid) {
    return http.post('https://whispering-headland-55740.herokuapp.com/password',
        body: {'password': uuid.replaceAll('-', '')});
  }
}
