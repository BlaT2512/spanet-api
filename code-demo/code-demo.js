// code-demo.js
// Full demo code for making SpaNET API requests and connecting to spa websocket
// Language: Javascript
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Node JS and NPM installed
//  - 'Request' package installed globally or in the same folder as this code (npm i request)

// To run this code, run the command 'node code-demo.js' from the command line in the same directory as this file


// VARIABLES - EDIT THIS SECTION
const username = 'YOUR USERNAME'; // <<< FILL THIS IN WITH YOUR SPALINK USERNAME
const spaName = 'YOUR SPA NAME';  // <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
const password = 'YOUR HASHED PASSWORD'; // <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
// To get your encrypted password, see instructions at section 1.1 on the Github repo https://github.com/BlaT2512/spanet-api/blob/main/spanet.md


// Import the 'request' library for making the web requests
const request = require('request');
// Import the 'net' library for making the websocket connections
const net = require('net');

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
// Create the websocket object
const client = new net.Socket();

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
                
              // Now that the spa has been found, connect to it
              console.log('Spa successfully found! Spa name:', spaName);
              console.log('Connection to this spa will now be initiated...');
              try {
                client.connect(9090, result['spaurl'].slice(0, -5), () => {
              
                  try {
                    // Write the command to connect to the spa
                    console.log('Opened TCP socket to spa');
                    client.write('<connect--' + result['id_sockets'] + '--' + result['id_member'] + '>');
              
                  } catch {
                    // Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
                    console.log('Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).');
                    process.exit(1);
                  }
              
                });
              } catch {
                // Couldn't connect to the spa websocket, do something such as throw an error
                console.log('Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.');
                process.exit(1);
              }
                
            }

          }

          if (spaFound === false){
            // The spa couldn't be found, do something such as throw an error
            console.log('Error: The specified spa does not exist for the SpaLINK account. Please log in with a different account or change the spa name.');
            process.exit(1);
          }

        } else {
          // No spa's are on the linked account, do something such as throw an error
          console.log('Error: No spa\'s are linked to the specified SpaLINK account. Please log in with a different account or link a spa in the SpaLINK app.');
          process.exit(1);
        }

      } else {
        // Couldn't make the second request to get spa websockets, do something such as throw an error (unexpected error, highly unlikely if your code is right)
        console.log('Error: Unable to obtain spa details from member, but login was successful. Please check your network connection, or open an issue on GitHub (unexpected).');
        process.exit(1);
      }
    });

  } else {
    // Login failed, do something such as throw an error
    console.log('Error: Unable to login with details provided. Please ensure that you have the correct username and encrypted password (see 1.1 at https://github.com/BlaT2512/spanet-api/blob/main/spanet.md for details to obtain).');
    process.exit(1);
  }
});

client.on('data', function(data) {
	if (data.toString().includes('RF:')){

    // RF Data fix recieved from spa, you could parse this here, call a function to parse it or drop it in a global var for reading when needed
    // INFO: To make the spa send an RF fix without programmatically sending the command (e.g. in this example), open the SpaLINK app and open
    // the spa being used in this example. Switching tabs at the bottom of the app will request an RF fix each time as well.

    // In this example, we will print the current water temperature
    const currentValueString = data.toString().split('\n')[4].split(',')[16];
    // Convert it to a float
    const currentValueInt = String(currentValueString).slice(0, -1) + '.' + String(currentValueString).slice(-1);
    const currentValue = parseFloat(currentValueInt);
    // Water temperature is now parsed nicely as a float, print the value to the console
    console.log('Water temperature is', currentValue, 'C');

  } else if (data.toString() === 'Successfully connected'){

    // The spa has successfully connected
    console.log('Successfully connected to spa, ready to send/recieve commands');

  }
});

client.on('close', function() {
  // Function called when the connection is closed
  // This code never disconnects from the spa (until you kill the program) so this is unexpected
	throw new Error('Error: Connection to spa unexpectedly closed.');
});

/////////////////////////////////////////// SENDING COMMANDS TO THE SPA ////////////////////////////////////////////
// To send a command to the spa, use the `client.write()` command                                                 //
// e.g.                                                                                                           //
// To turn on pump/jet 3: client.write('S24:1\n')                                                                 //
// To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.write('S23:' + n + '\n')  //
// To set the spa temperature to 36.2 C: client.write('W40:362\n')                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////