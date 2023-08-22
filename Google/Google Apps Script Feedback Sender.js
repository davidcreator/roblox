const email = "YOUR EMAIL HERE";

function doGet(e) {

  let userId = e.parameters["UserId"].toString();
  let subject = e.parameters["Subject"].toString();
  let description = e.parameters["Body"].toString();

  let response = "Invalid parameter length!";

  if (userId.length > 0 && subject.length > 0 && description.length > 0) {

    let body = "<h1>Sent by user id: " + userId + "</h1><br>" + description;

    try {
      MailApp.sendEmail({
        to: email,
        subject: subject,
        htmlBody: body,
      });

      response = "success";

    } catch(err) {

      response = err;
    };
  }

  response = ContentService.createTextOutput(response);
  return response;
}