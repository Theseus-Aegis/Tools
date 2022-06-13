/**
 * @OnlyCurrentDoc
 */

function teamToText(spreadsheet, nameCell, valuesRange) {
  var items = spreadsheet.getRange(valuesRange).getValues();
  var text = items.filter(i => i[0] != '').map(i => i[0] + ' - ' + i[1] + '\n').join('');
  if (text != '') {
    return '\n*' + spreadsheet.getRange(nameCell).getValue() + '*\n' + text;
  } else {
    return '';
  }
}

function copyAssignments() {
  var spreadsheet = SpreadsheetApp.getActive();
  var target = spreadsheet.getRange('I33');

  var msg = 'Team Assignments for ';
  msg += '*"' + spreadsheet.getRange('F33').getValue() + '"*\n';

  msg += teamToText(spreadsheet, 'F1', 'F2:G11');
  msg += teamToText(spreadsheet, 'F13', 'F14:G23');
  msg += teamToText(spreadsheet, 'I1', 'I2:J11');
  msg += teamToText(spreadsheet, 'F25', 'F26:G30');
  msg += teamToText(spreadsheet, 'I13', 'I14:J23');
  msg += teamToText(spreadsheet, 'I25', 'I26:J30');

  msg += '\n_Additional contractors slot into Ares 3._'

  target.setValue(msg);
}
