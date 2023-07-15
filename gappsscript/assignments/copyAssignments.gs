/**
 * @OnlyCurrentDoc
 */

function teamToText(sheet, nameCell, valuesRange) {
  var items = sheet.getRange(valuesRange).getValues();
  var text = items.filter(i => i[0] != '').map(i => i[0] + ' - ' + i[1] + '\n').join('');
  if (text != '') {
    return '\n**' + sheet.getRange(nameCell).getValue() + '**\n' + text;
  } else {
    return '';
  }
}

function copyAssignments() {
  var sheet = SpreadsheetApp.getActive().getSheetByName("Team Assignments");

  var contract = sheet.getRange('F30').getValue();
  var contractUrl = sheet.getRange('F30').getRichTextValue().getLinkUrl();
  var leftSlots = sheet.getRange('F31').getValue();
  var recommendedAmmo = sheet.getRange('F32').getValue();
  var additionalInfo = sheet.getRange('F33').getValue();

  var msg = teamToText(sheet, 'E1', 'E2:F11');
  msg += teamToText(sheet, 'E13', 'E14:F23');
  msg += teamToText(sheet, 'G1', 'G2:H11');
  msg += teamToText(sheet, 'E25', 'E26:F28');
  msg += teamToText(sheet, 'G13', 'G14:H23');
  msg += teamToText(sheet, 'G25', 'G26:H30');

  if (contract == "" || msg == "" || leftSlots == "") {
    showWarning("No Contract selected, no contractors have assigned roles or no team selected for additional contractors!");
    return; // Fail-safe if empty
  }

  msg += "\n_Additional contractors slot into **" + leftSlots + "**._";

  if (recommendedAmmo != "") {
    msg += "\n\n> **Recommended Ammo:** " + recommendedAmmo;
  }
  if (additionalInfo != "") {
    msg += "\n> \n" + additionalInfo.toString().replace(/^/gm, "> ");
  }

  // Send to chat
  postAssignments(contract, contractUrl, msg);
}
