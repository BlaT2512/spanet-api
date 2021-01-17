// code-demo.go
// Full demo code for making SpaNET API requests and connecting to spa websocket
// Language: Golang
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Go Programming Language installed

// To run this code, run the command 'go run code-demo.go' from the command line in the same directory as this file

package main

// Import the required packages
import (
	"bytes"         // For reading & parsing HTTP output
	"encoding/json" // For parsing JSON data
	"fmt"           // For printing output to terminal and string methods
	"io/ioutil"     // For reading & parsing HTTP output
	"net"           // For making websocket connections
	"net/http"      // For making web requests
	"os"            // For killing the program
	"strconv"       // String conversion methods
	"strings"       // String methods
)

// VARIABLES - EDIT THIS SECTION ///////////////////////////////////////////////////////////////////////
const username string = "YOUR USERNAME"        // <<< FILL THIS IN WITH YOUR SPALINK USERNAME
const spaName string = "YOUR SPA NAME"         // <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
const password string = "YOUR HASHED PASSWORD" // <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
// To get your encrypted password, see instructions at section 1.1 on the Github repo
// https://github.com/BlaT2512/spanet-api/blob/main/spanet.md
////////////////////////////////////////////////////////////////////////////////////////////////////////

func main() {
	// First, login to API with your username and encrypted password key to see if user exists, otherwise throw error
	postBody, _ := json.Marshal(map[string]string{
		"login":    username,
		"api_key":  "4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5",
		"password": password,
	})
	responseBody := bytes.NewBuffer(postBody)

	// Make the login request
	resp, err := http.Post("https://api.spanet.net.au/api/MemberLogin", "application/json", responseBody)
	byt, byterr := ioutil.ReadAll(resp.Body)
	var data map[string]interface{}
	jsonerr := json.Unmarshal(byt, &data)

	if err == nil && byterr == nil && jsonerr == nil && data["success"].(bool) {

		// If you get to this section, login and decode was all successful
		fmt.Println("Successfully logged into SpaNET account!")

		// Variables needed for next request
		var body = data["data"].(map[string]interface{})
		var memberID = fmt.Sprintf("%g", body["id_member"].(float64))
		var sessionID = body["id_session"].(string)

		// Make the next request which will check the spas on your account
		resp, err := http.Get("https://api.spanet.net.au/api/membersockets?id_member=" + memberID + "&id_session=" + sessionID)
		byt, byterr := ioutil.ReadAll(resp.Body)
		var data map[string]interface{}
		jsonerr := json.Unmarshal(byt, &data)

		if err == nil && byterr == nil && jsonerr == nil && data["success"].(bool) {

			// If you get to this section, the spa request was successful
			fmt.Println("Successfully got list of spa's linked to SpaNET account!")

			// Parse through the list of spa sockets and check that the spa specified at the top exists
			if len(data["sockets"].([]interface{})) != 0 { // Make sure there are at least 1 spas on your account

				var spaFound = false // Variable to track if the right spa has been found
				for _, element := range data["sockets"].([]interface{}) {

					// Check whether the name matches the spa name specified at the top
					if element.(map[string]interface{})["name"] == spaName {

						// This is the correct spa that you chose
						spaFound = true

						// Now that the spa has been found, connect to it
						fmt.Println("Spa successfully found! Spa name: " + spaName)
						fmt.Println("Connection to this spa will now be initiated...")
						tcpAddr, err := net.ResolveTCPAddr("tcp", element.(map[string]interface{})["spaurl"].(string))
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
						_, err = client.Write([]byte("<connect--" + fmt.Sprintf("%g", element.(map[string]interface{})["id_sockets"]) + "--" + fmt.Sprintf("%g", element.(map[string]interface{})["id_member"]) + ">"))
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
				}

				if spaFound == false {
					// The spa couldn't be found, do something such as throw an error
					fmt.Println("Error: The specified spa does not exist for the SpaLINK account. Please log in with a different account or change the spa name.")
				}

			} else {
				// No spa's are on the linked account, do something such as throw an error
				fmt.Println("Error: No spa's are linked to the specified SpaLINK account. Please log in with a different account or link a spa in the SpaLINK app.")
			}

		} else {
			// Couldn't make the second request to get spa websockets, do something such as throw an error (unexpected error, highly unlikely if your code is right)
			fmt.Println("Error: Unable to obtain spa details from member, but login was successful. Please check your network connection, or open an issue on GitHub (unexpected).")
		}

	} else {
		// Login failed, do something such as throw an error
		fmt.Println("Error: Unable to login with details provided. Please ensure that you have the correct username and encrypted password (see 1.1 at https://github.com/BlaT2512/spanet-api/blob/main/spanet.md for details to obtain).")
	}
}

/////////////////////////////////////////////// SENDING COMMANDS TO THE SPA ////////////////////////////////////////////////
// To send a command to the spa, use the `client.Write()` command                                                         //
// e.g.                                                                                                                   //
// To turn on pump/jet 3: client.Write([]byte("S24:1\n"))                                                                 //
// To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.Write([]byte("S23: + n + "\n"))   //
// To set the spa temperature to 36.2 C: client.Write([]byte("W40:362\n"))                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
