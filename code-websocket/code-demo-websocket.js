// code-demo-websocket.js
// Demo code for making spa websocket connection
// Language: Javascript
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Node JS and NPM installed

// To run this code, run the command 'node code-demo-websocket.js' from the command line in the same directory as this file


// VARIABLES - EDIT THIS SECTION
const spaIP = 'YOUR SPA IP'; // <<< FILL THIS IN WITH THE IP ADDRESS OF YOUR CHOSEN SPA (EXCLUDING PORT)
const memberID = 'YOUR MEMBER ID';  // <<< FILL THIS IN WITH YOUR 4-DIGIT MEMBER ID
const socketID = 'YOUR SPA SOCKET ID'; // <<< FILL THIS IN WITH YOUR SPA'S 4-DIGIT SOCKET ID
// Your spa IP, member ID and socket ID can be found by running the code-demo-request.js script and reading the output


// Import the 'net' library for making the websocket connections
const net = require('net');

// Start the websocket connection to the spa
const client = new net.Socket();
try {
  client.connect(9090, spaIP, () => {

    try {
      // Write the command to connect to the spa
      console.log('Opened TCP socket to spa');
      client.write('<connect--' + socketID + '--' + memberID + '>');

    } catch {
      // Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
      console.log('Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).');
    }

  });
} catch {
  // Couldn't connect to the spa websocket, do something such as throw an error
  console.log('Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.');
}

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