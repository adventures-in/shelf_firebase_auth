import 'dart:async';

import 'package:shelf/shelf.dart';

/// Top level function that returns a [Middleware] that authenticates Firebase
/// users.
Middleware firebaseAuthMiddelware(
        {FutureOr<Response> Function(Object, StackTrace)? errorHandler}) =>
    createMiddleware(
        requestHandler: (request) {
          // final projectId = await projectMetadataService.getProjectId();

          request.headers['authorization'];

          // final claimSet = verifyJwtRSA256Signature(token, key);
          // verifyJwtHS256Signature(token, hmacKey)
          // claimSet.validate(issuer: 'teja', audience: 'audience1.example.com');

          return null; // null means the request is sent to the inner [Handler]
        },
        errorHandler: errorHandler ??
            (error, trace) {
              // If no errorHandler was passed in, just print the trace and
              // respond with internal error.
              print(trace);
              return Response.internalServerError(body: '$error');
            });
