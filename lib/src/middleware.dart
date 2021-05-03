import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart';
import 'package:shelf_firebase_auth/src/services/project_metadata_service.dart';

/// Top level function that returns a [Middleware] that authenticates Firebase
/// users.
Middleware firebaseAuthMiddelware(
        {FutureOr<Response> Function(Object, StackTrace)? errorHandler}) =>
    createMiddleware(
        requestHandler: (request) async {
          final service = ProjectMetadataService();
          final projectId = service.getProjectId();
          service.close();

          // Check the kid againt the public keys - we may want to use the value of
          // max-age in the Cache-Control header to know when to refresh the public keys
          final response = await http.Client().get(Uri.parse(
              'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'));

          final publicKeys = jsonDecode(response.body);

          request.headers['authorization'];

          // request.change(headers: {uid: userId});

          return null; // null means the request is sent to the inner [Handler]
        },
        errorHandler: errorHandler ??
            (error, trace) {
              // If no errorHandler was passed in, just print the trace and
              // respond with internal error.
              print(trace);
              return Response.internalServerError(body: '$error');
            });
