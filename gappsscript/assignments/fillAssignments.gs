/**
 * @OnlyCurrentDoc
 */

function requestNextContract() {
  var options = {muteHttpExceptions: true};
  var response = UrlFetchApp.fetch('https://api.theseus-aegis.com/contract', options);
  if (response.getResponseCode() == 200) {
    Logger.log(response.getContentText());
    return JSON.parse(response.getContentText());
  }
  throw new Error('Querying contract failed!');
}

function fillAssignments() {
  var sheet = SpreadsheetApp.getActiveSheet();
  var content = requestNextContract();

  if (!["Contract", "Sub-Contract"].includes(content.type)) {
    return;
  }

  // Set mission name if different
  if (sheet.getRange('F33').getValue() != content.title) {
    sheet.getRange('F33').setValue(content.title);
  }

  // Populate Contractors list
  for (var i in content.comments) {
    var comment = content.comments[i];

    var row = parseInt(i) + 2;
    var nameRange = sheet.getRange('B' + row);
    var roleRange = sheet.getRange('C' + row);
    var noteRange = sheet.getRange('D' + row);

    // Author and roles if different
    if (nameRange.getValue() != comment.author) {
      nameRange.setValue(comment.author);
    }
    if (roleRange.getValue() != comment.subject) {
      roleRange.setValue(comment.subject);
    }

    // Append/Remove "[Recruit]" to note (comment)
    var note = noteRange.getValue();
    if (comment.isRecruit === true && !note.includes("[Recruit]")) {
      noteRange.setValue("[Recruit] " + note);
    } else if (note.includes("[Recruit]")) {
      noteRange.setValue(note.substring(9));
    }
  }

  // Clear the rest of the Contractors list
  sheet.getRange('B' + (row + 1) + ':C33').clear({contentsOnly: true, skipFilteredRows: true});
}
