const url = "https://games.roblox.com/v1/games?universeIds="

function doGet(e) {
  
  const universeId = e.parameters["UniverseId"];
  const requestUrl = url.concat(universeId);
  
  let result = null;
  
  try {
    let response = UrlFetchApp.fetch(requestUrl);
    response = JSON.parse(response.getContentText());

    result = 
    {
      "result": "success",
      "response": {response}
    };
  }
  catch(error) {
    
    result = 
    {
      "result": "error",
      "error": error
    };
  }
  
  result = ContentService.createTextOutput(JSON.stringify(result)).setMimeType(ContentService.MimeType.JSON);

  return result;
}