// code-demo-request.go
// Demo code for making spa websocket connection
// Language: Golang
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Go Programming Language installed

// To run this code, run the command 'go run code-demo-websocket.go' from the command line in the same directory as this file

package main

import (
	"fmt"     // For printing output to terminal and string methods
	"net"     // For making websocket connections
	"os"      // For killing the program
	"strconv" // String conversion methods
	"strings" // String methods
)

// Import the required packages

// For parsing JSON data
// For printing output to terminal

// For making web requests

// VARIABLES - EDIT THIS SECTION ///////////////////////////////////////////////////////////////////////
const spaIP string = "YOUR SPA IP"           // <<< FILL THIS IN WITH YOUR SPALINK USERNAME
const memberID string = "YOUR MEMBER ID"     // <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
const socketID string = "YOUR SPA SOCKET ID" // <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
// Your spa IP, member ID and socket ID can be found by running the code-demo-request.go script and reading the output
////////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {
	// Start the websocket connection to the spa
	tcpAddr, err := net.ResolveTCPAddr("tcp", spaIP+":9090")
	if err != nil {
		// Couldn't resolve spa websocket address, do something such as throw an error
		fmt.Println("Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.")
		os.Exit(1)
	}
	client, err := net.DialTCP("tcp", nil, tcpAddr)
	if err != nil {
		// Couldn't connect to the spa websocket, do something such as throw an error
		fmt.Println("Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.")
		os.Exit(1)
	}

	// Write the command to connect to the spa
	fmt.Println("Opened TCP socket to spa")
	_, err = client.Write([]byte("<connect--" + socketID + "--" + memberID + ">"))
	if err != nil {
		// Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
		fmt.Println("Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).")
		os.Exit(1)
	}

	// Check that data sent successfully
	reply := make([]byte, 22)
	client.Read(reply)
	if string(reply) == "Successfully connected" {
		// The spa has successfully connected
		fmt.Println("Successfully connected to spa, ready to send/recieve commands")

		// In this example, we will demonstrate requesting an RF fix from the spa and then parsing it to get the water temperature
		// Request RF data
		client.Write([]byte("RF\n"))

		// Read response from spa
		reply := make([]byte, 1024)
		client.Read(reply)
		if strings.Contains(string(reply), "RF:") {
			// Parse tha data to get water temperature
			currentValueString := strings.Split(strings.Split(string(reply), "\n")[4], ",")[16]
			// Convert it to a float
			currentValueInt := currentValueString[:len(currentValueString)-1] + "." + currentValueString[len(currentValueString)-1:]
			currentValue, _ := strconv.ParseFloat(currentValueInt, 64)
			// Water temperature is now parsed nicely as a float, print the value to the console (must be a string to do this)
			fmt.Println("Water temperature is " + fmt.Sprintf("%g", currentValue) + " C")
		}
	}
}

/////////////////////////////////////////////// SENDING COMMANDS TO THE SPA ////////////////////////////////////////////////
// To send a command to the spa, use the `client.Write()` command                                                         //
// e.g.                                                                                                                   //
// To turn on pump/jet 3: client.Write([]byte("S24:1\n"))                                                                 //
// To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.Write([]byte("S23: + n + "\n"))   //
// To set the spa temperature to 36.2 C: client.Write([]byte("W40:362\n"))                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
