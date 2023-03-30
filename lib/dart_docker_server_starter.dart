import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

const port = String.fromEnvironment('PORT', defaultValue: '8080');

Future<void> start() async {
  final app = Router();

  app.get('/hello', (Request request) {
    return Response.ok('hello-world');
  });

  app.post('/user/<user>', (Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body);

    return Response.ok('hello ${json['name']}');
  });

  final handler = const Pipeline().addMiddleware(logRequests()).addHandler(app);

  final server = await shelf_io.serve(handler, 'localhost', 8080);
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
