function showWarning(text = "Something went wrong.") {
  var output = SpreadsheetApp.getActive().getSheetByName("Team Assignments").getRange('G34');
  output.setValue("Warning! (see note)");
  output.setNote(text);
}
