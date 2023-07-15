// Use custom trigger instead of Simple Trigger to obtain permission to call UrlFetchApp.fetch
// Mimicking Simple Trigger 'onEdit'
function atEdit(e) {
  var sheet = e.range.getSheet();
  if (sheet.getName() != "Team Assignments") {
    return;
  }

  var checkPost = sheet.getRange('G33');
  var checkReset = sheet.getRange('H33');
  var checkConfirm = sheet.getRange('H34');
  var output = sheet.getRange('G34');

  output.setNote("");

  if (e.range.getA1Notation() == 'G33') {
    if (e.range.isChecked()) {
      output.setValue("Confirm Post to Discord?");
      checkConfirm.insertCheckboxes();
      checkReset.setValue("FALSE");
    } else {
      output.setValue("");
      checkConfirm.removeCheckboxes();
    }
  } else if (e.range.getA1Notation() == 'H33') {
    if (e.range.isChecked()) {
      output.setValue("Confirm Reset?");
      checkConfirm.insertCheckboxes();
      checkPost.setValue("FALSE");
    } else {
      output.setValue("");
      checkConfirm.removeCheckboxes();
    }
  } else if (e.range.getA1Notation() == 'H34'&& e.range.isChecked()) {
    checkConfirm.removeCheckboxes();
    output.setValue("");

    if (checkPost.isChecked()) {
      copyAssignments();
    } else if (checkReset.isChecked()) {
      Reset();
    }

    checkPost.setValue("FALSE");
    checkReset.setValue("FALSE");
  }
}
