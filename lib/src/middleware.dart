import 'dart:async';
import 'dart:convert';

import 'package:corsac_jwt/corsac_jwt.dart';
import 'package:http/http.dart' as http;
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

          // Check the kid againt the public keys - we may want to use the value of
          // max-age in the Cache-Control header to know when to refresh the public keys
          final response = await http.Client().get(Uri.parse(
              'https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com'));

          final publicKeys = jsonDecode(response.body) as Map<String, String>;

          final authHeader = request.headers['authorization'];
          if (authHeader == null) throw 'No auth header';
          final splitHeader = authHeader.split(' ');
          if (splitHeader.first != 'Bearer') throw 'Auth header must be Bearer';
          final stringToken = splitHeader.last;

          final decodedToken = JWT.parse(stringToken);

          var signer = JWTRsaSha256Signer(
              publicKey: publicKeys[decodedToken.claims['kid']]);

          // Verify signature:
          print(decodedToken.verify(signer)); // true

          // Validate claims:
          final validator = JWTValidator() // uses DateTime.now() by default
            ..issuer =
                'https://api.foobar.com'; // set claims you wish to validate
          final errors = validator.validate(decodedToken);
          print(errors); // (empty list)

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
