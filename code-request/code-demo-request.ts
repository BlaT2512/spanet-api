// code-demo-request.ts
// Demo code for making SpaNET API web requests
// Language: Typescript
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Node JS and NPM installed
//  - 'Request' package installed globally or in the same folder as this code (npm i request)
//  - 'ts-node' package installed globally or in the same folder as this code to easily run it (npm i ts-node)

// To run this code, run the command 'npx ts-node code-demo-request.ts' from the command line in the same directory as this file


// VARIABLES - EDIT THIS SECTION
const username = 'YOUR USERNAME'; // <<< FILL THIS IN WITH YOUR SPALINK USERNAME
const spaName = 'YOUR SPA NAME';  // <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
const password = 'YOUR HASHED PASSWORD'; // <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
// To get your encrypted password, see instructions at section 1.1 on the Github repo https://github.com/BlaT2512/spanet-api/blob/main/spanet.md


// Import the 'request' library for making the web requests
import request = require('request');

// First, login to API with your username and encrypted password key to see if user exists, otherwise throw error
const loginParams = {
    uri: 'https://api.spanet.net.au/api/MemberLogin',
    method: 'POST',
    json: {
      'login': username,
      'api_key': '4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5',
      'password': password,
    },
};

// Make the login request
request(loginParams, (error, response, body) => {
  if (!error && response.statusCode === 200 && body['success']) {

    // If you get to this section, login was successful
    console.log('Successfully logged into SpaNET account!');
      
    // Variables needed for next request
    const memberId = body['data']['id_member'];
    const sessionId = body['data']['id_session'];

    // Make the next request which will check the spas on your account
    const spaParams = {
      uri: 'https://api.spanet.net.au/api/membersockets?id_member=' + memberId + '&id_session=' + sessionId,
      method: 'GET',
    };

    request(spaParams, (error, response, body) => {
      if (!error && response.statusCode === 200 && JSON.parse(body)['success']) {
       
        // If you get to this section, the spa request was successful
        console.log('Successfully got list of spa\'s linked to SpaNET account!');

        // Parse through the list of spa sockets and check that the spa specified at the top exists
        const bodyJSON = JSON.parse(body);

        if (bodyJSON['sockets'][0] !== undefined){ // Make sure there are at least 1 spas on your account

          let spaFound = false; // Variable to track if the right spa has been found
          for(const result of bodyJSON['sockets']){
            
            // Check whether the name matches the spa name specified at the top
            if (result['name'] === spaName){

              // This is the correct spa that you chose
              spaFound = true;
                
              // WRITE SOME CODE TO DO ONCE THE SPA HAS BEEN FOUND
              // You could connect to it's websocket, this is done in the code-demo.ts file in the code-demo folder
              console.log('Spa successfully found! Spa name:', spaName);
              console.log('Use these details for websocket connection: Spa IP ' + result['spaurl'].slice(0, -5) + ' ; Member ID ' + result['id_member'] + ' ; Socket ID ' + result['id_sockets']);

            }

          }

          if (spaFound === false){
            // The spa couldn't be found, do something such as throw an error
            console.log('Error: The specified spa does not exist for the SpaLINK account. Please log in with a different account or change the spa name.');
          }

        } else {
          // No spa's are on the linked account, do something such as throw an error
          console.log('Error: No spa\'s are linked to the specified SpaLINK account. Please log in with a different account or link a spa in the SpaLINK app.');
        }

      } else {
        // Couldn't make the second request to get spa websockets, do something such as throw an error (unexpected error, highly unlikely if your code is right)
        console.log('Error: Unable to obtain spa details from member, but login was successful. Please check your network connection, or open an issue on GitHub (unexpected).');
      }
    });

  } else {
    // Login failed, do something such as throw an error
    console.log('Error: Unable to login with details provided. Please ensure that you have the correct username and encrypted password (see 1.1 at https://github.com/BlaT2512/spanet-api/blob/main/spanet.md for details to obtain).');
  }
});