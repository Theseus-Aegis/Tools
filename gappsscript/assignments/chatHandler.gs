/**
 * @OnlyCurrentDoc
 *
 * WEBHOOK_URL_* variables should be saved in Git-ignored secrets.gs file.
 */

function sendWebhookMessage(webhookUrl, message) {
    var options = {
      "method": "post",
      "headers": {
          "Content-Type": "application/json",
      },
      "payload": JSON.stringify(message)
    };
    UrlFetchApp.fetch(webhookUrl, options);
}

function postNextActuals() {
  var sheet = SpreadsheetApp.getActive().getSheetByName("Actual Rotation");
  var actuals = sheet.getRange("R10:R14").getValues();

  var msg = "\n- **" + actuals[0] + "**";
  msg += "\n- " + actuals[1];

  for (var i in actuals.slice(2)) {
    var actual = actuals[parseInt(i) + 2];
    msg += "\n- _" + actual + "_";
  }

  var fields = [];
  if (actuals[0] == "Ethan McQuade") { // special
    fields.push({
      "name": "Ethan's Motivational Speech",
      "value": "https://www.youtube.com/shorts/x0UzjYHroNM",
      "inline": false
    });
  }

  var message = {
    "content": "Actuals be advised!",
    "embeds": [{
      "title": "Next Actual",
      "url": "https://docs.google.com/spreadsheets/d/1kvTsZ9rlfJH1AYLsppqjTv8uJMza4YUf3jq7fZZtl5E#gid=697718321",
      "description": msg,
      "fields": fields
    }]
  };
  sendWebhookMessage(WEBHOOK_URL_TEAM_LEADS, message);
}

function postAssignments(title, url, msg) {
  var message = {
    "content": "All contractors be advised, roles for the next contract have been assigned.",
    "embeds": [{
      "title": title,
      "url": url,
      "description": msg
    }]
  };
  sendWebhookMessage(WEBHOOK_URL_ASSIGNMENTS, message);
}
