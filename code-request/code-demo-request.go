// code-demo-request.go
// Demo code for making SpaNET API web requests
// Language: Golang
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - Go Programming Language installed

// To run this code, run the command 'go run code-demo-request.go' from the command line in the same directory as this file

package main

// Import the required packages
import (
	"bytes"         // For reading & parsing HTTP output
	"encoding/json" // For parsing JSON data
	"fmt"           // For printing output to terminal and string methods
	"io/ioutil"     // For reading & parsing HTTP output
	"net/http"      // For making web requests
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

						// WRITE SOME CODE TO DO ONCE THE SPA HAS BEEN FOUND
						// You could connect to it's websocket, this is done in the code-demo.go file in the code-demo folder
						fmt.Println("Spa successfully found! Spa name: " + spaName)
						fmt.Println("Use these details for websocket connection: Spa IP " + strings.TrimSuffix(element.(map[string]interface{})["spaurl"].(string), ":9090") + " ; Member ID " + fmt.Sprintf("%g", element.(map[string]interface{})["id_member"].(float64)) + " ; Socket ID " + fmt.Sprintf("%g", element.(map[string]interface{})["id_sockets"].(float64)))

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
