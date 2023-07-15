// Use custom trigger instead of Simple Trigger to obtain permission to call UrlFetchApp.fetch
// Mimicking Simple Trigger 'onEdit'
function atEdit(e) {
  if (e.range.getSheet().getName() == "Team Assignments") {
    if (e.range.getA1Notation() == 'G34' && e.value == "TRUE") {
      copyAssignments();
      e.range.setValue("FALSE");
    }
    if (e.range.getA1Notation() == 'H34' && e.value == "TRUE") {
      Reset();
      e.range.setValue("FALSE");
    }
  }
}
