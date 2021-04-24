import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

class ProjectMetadataService {
  static const _requestHeaders = {'Metadata-Flavor': 'Google'};
  final _uri =
      Uri.parse('http://metadata.google.internal/computeMetadata/v1/project/');
  final _client = Client();

  /// Retrieves projectId from a GCP metadata server, if executed where
  /// one is a available (eg. Cloud Run).
  ///
  /// Otherwise throws an exception.
  Future<String> getProjectId() async {
    if (!onCloudRun) throw 'Ran getProjectId() from unsupported environment';

    final response = await _client.get(_uri, headers: _requestHeaders);

    if (response.statusCode != 200) {
      throw HttpException(
        '${response.statusCode} : ${response.body}',
        uri: _uri,
      );
    }

    final json = jsonDecode(response.body);
    final projectId = json['projectId'] as String?;

    if (projectId == null) throw 'Project Id was not found.';

    return projectId;
  }

  bool get onCloudRun => Platform.environment.containsKey('K_SERVICE');

  void close() {
    _client.close();
  }
}
