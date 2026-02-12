/// Parses widget deep link URIs and returns navigation location.
///
/// Supported formats:
/// - nomo://widget/log-craving?trackerId=<id>
/// - nomo://widget/open-tracker?trackerId=<id>
class DeepLinkResult {
  const DeepLinkResult({
    required this.path,
    this.openLogCraving = false,
  });

  final String path;
  final bool openLogCraving;

  /// Full location with query param for openLogCraving (more reliable than extra).
  String get location =>
      openLogCraving ? '$path?openLogCraving=true' : path;

  static DeepLinkResult? fromUri(Uri? uri) {
    if (uri == null || uri.scheme != 'nomo' || uri.host != 'widget') return null;

    final trackerId = uri.queryParameters['trackerId'];
    if (trackerId == null || trackerId.isEmpty) return null;

    final path = '/dashboard/tracker/$trackerId';
    final segments = uri.pathSegments;
    if (segments.contains('log-craving')) {
      return DeepLinkResult(path: path, openLogCraving: true);
    }
    return DeepLinkResult(path: path);
  }
}
