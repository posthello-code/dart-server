import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

const i = 0;
void main() async {
  final handler =
      const Pipeline().addMiddleware(logRequests()).addHandler(echoRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 4001);
  print('Serving at http://${server.address.host}:${server.port}');
}

Response echoRequest(Request request) {
  if (request.url.path == '/' || request.url.path == '') {
    return Response.ok('Server is up and running');
  } else {
    return Response.notFound('Not found');
  }
}
