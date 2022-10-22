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
  var sheet = SpreadsheetApp.getActive().getSheetByName("Team Assignments");
  var content = requestNextContract();

  /*if (!["Contract", "Sub-Contract"].includes(content.type)) {
    return;
  }*/

  // Set mission name if different
  if (sheet.getRange('F30').getValue() != content.title) {
    sheet.getRange('F30').setRichTextValue(
      SpreadsheetApp.newRichTextValue()
        .setText(content.title)
        .setLinkUrl("https://www.theseus-aegis.com/node/" + content.id)
        .build())
  }

  // Filter attendees
  var comments = content.comments.filter(i => i.attendance != 'no');

  // Populate Contractors list
  for (var i in comments) {
    var comment = comments[parseInt(i)];

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

    var note = noteRange.getValue();

    // Append/Remove "[Recruit]" to note (comment)
    if (comment.isRecruit === true && !note.includes("[Recruit] ")) {
      noteRange.setValue("[Recruit] " + note);
    } else if (comment.isRecruit === false && note.includes("[Recruit] ")) {
      noteRange.setValue(note.replace("[Recruit] ", ""));
    }

    // Append/Remove "[Maybe]" to note (comment)
    if (comment.attendance == "may" && !note.includes("[Maybe] ")) {
      noteRange.setValue("[Maybe] " + note)
    } else if (comment.attendance != "may" && note.includes("[Maybe] ")) {
      noteRange.setValue(note.replace("[Maybe] ", ""));
    }
  }

  // Clear the rest of the Contractors list
  sheet.getRange('B' + (row + 1) + ':C33').clear({contentsOnly: true, skipFilteredRows: true});
}
