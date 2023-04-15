import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

void main() async {
  // Check if index.html exists
  String indexFile = 'build/web/index.html';
  bool indexFileExists = await File('build/web/index.html').exists();

  if (!indexFileExists) {
    indexFile = 'README.md';
  }

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders) // Add CORS headers middleware
      .addHandler(createStaticHandler('build/web', defaultDocument: indexFile));

  final handler2 = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders) // Add CORS headers middleware
      .addHandler(echoRequest);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 4001);
  final server2 = await io.serve(handler2, InternetAddress.anyIPv4, 4002);
  print('Serving static site at http://${server.address.host}:${server.port}');
  print(
      'Serving handling requests at http://${server2.address.host}:${server2.port}');
}

Response echoRequest(Request request) {
  if (request.url.path == '/' || request.url.path == '') {
    return Response.ok('Server is up and running');
  } else {
    return Response.notFound('Not found');
  }
}

// CORS headers middleware
Middleware _corsHeaders =
    createMiddleware(responseHandler: (Response response) {
  response = response.change(headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers':
        'Origin, X-Requested-With, Content-Type, Accept'
  });
  return response;
});
