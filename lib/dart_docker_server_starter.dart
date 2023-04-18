import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

final portVar = Platform.environment['PORT'];

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

  final server = await shelf_io.serve(
    handler,
    InternetAddress.anyIPv4,
    int.tryParse(portVar ?? '8080') ?? 8080,
  );
  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
