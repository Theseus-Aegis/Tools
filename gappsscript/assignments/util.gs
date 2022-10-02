function showAlert(text = "Are you sure you want to continue?") {
  var ui = SpreadsheetApp.getUi();
  var result = ui.alert("Please confirm", text, ui.ButtonSet.YES_NO);
  return result == ui.Button.YES;
}

function showWarning(text = "Something went wrong.") {
  var ui = SpreadsheetApp.getUi();
  var result = ui.alert("Warning", text, ui.ButtonSet.OK);
  return result == ui.Button.YES;
}
