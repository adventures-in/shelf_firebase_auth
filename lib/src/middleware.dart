import 'dart:async';

import 'package:shelf/shelf.dart';

import 'services/project_metadata_service.dart';

/// Top level function that returns a [Middleware] that authenticates Firebase
/// users.
Middleware firebaseAuthMiddelware(
        {FutureOr<Response> Function(Object, StackTrace)? errorHandler}) =>
    createMiddleware(
        requestHandler: (request) async {
          final service = ProjectMetadataService();
          final projectId = service.getProjectId();
          service.close();

          request.headers['authorization'];

          // final claimSet = verifyJwtRSA256Signature(token, key);
          // claimSet.validate(issuer: 'teja', audience: 'audience1.example.com');

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
