int taskNotificationId(String taskId) {
  var hash = 0x811c9dc5;
  for (final code in taskId.codeUnits) {
    hash = ((hash ^ code) * 0x01000193) & 0x7fffffff;
  }
  return hash;
}
