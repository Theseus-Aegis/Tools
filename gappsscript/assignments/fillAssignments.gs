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

  if (sheet.getRange('F33').getValue() != content.title) {
    sheet.getRange('F33').setValue(content.title);
  }

  for (var i in content.comments) {
    var row = parseInt(i) + 2;

    if (sheet.getRange('B' + row).getValue() != content.comments[i].author) {
      sheet.getRange('B' + row).setValue(content.comments[i].author);
      sheet.getRange('C' + row).setValue(content.comments[i].subject);
    }

    Logger.log(i + " " + content.comments[i].author + " " + row);
  }

  sheet.getRange('B' + (row + 1) + ':C33').clear({contentsOnly: true, skipFilteredRows: true});
}
