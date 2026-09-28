import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

/// A recorded request seen by [FakeAdapter].
class RecordedRequest {
  RecordedRequest(this.options, this.body);
  final RequestOptions options;
  final String body;
  String get method => options.method;
  String get path => options.path;
  String? get authorization => options.headers['Authorization'] as String?;
  Map<String, dynamic> get json => body.isEmpty ? {} : jsonDecode(body) as Map<String, dynamic>;
}

/// A scripted response.
class FakeReply {
  FakeReply(this.status, [this.body]) : contentType = 'text/plain';
  FakeReply.json(this.status, Object body)
      : body = jsonEncode(body),
        contentType = Headers.jsonContentType;
  FakeReply.offline()
      : status = -1,
        body = null,
        contentType = 'text/plain';
  final int status;
  final String? body;
  final String contentType;
}

/// Minimal Dio adapter that answers from a handler and records requests.
class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  FutureOr<FakeReply> Function(RecordedRequest request) handler;
  final List<RecordedRequest> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final chunks = <int>[];
    if (requestStream != null) {
      await for (final c in requestStream) {
        chunks.addAll(c);
      }
    }
    final req = RecordedRequest(options, utf8.decode(chunks, allowMalformed: true));
    requests.add(req);
    final reply = await handler(req);
    if (reply.status < 0) {
      throw DioException.connectionError(requestOptions: options, reason: 'offline');
    }
    return ResponseBody.fromString(
      reply.body ?? '',
      reply.status,
      headers: {
        Headers.contentTypeHeader: [reply.contentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
