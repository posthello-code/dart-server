import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import '../bin/server.dart';

void main() {
  test('that the health controller works', () {
    var request = Request('GET', Uri.parse('http://localhost:4001/'));
    var response = echoRequest(request);
    expect(response.statusCode, equals(200));
  });
}
