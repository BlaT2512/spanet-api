// code-demo.swift
// Full demo code for making SpaNET API requests and connecting to spa websocket
// Language: Swift
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - XCode and Cocoapods installed & configured for current project
//  - 'Alamofire' pod installed with    pod 'Alamofire', '~> 5.2'    in your pod file
//  - 'SwiftyJSON' pod installed with   pod 'SwiftyJSON', '~> 4.0'   in your pod file
//  - 'SwiftSocket' pod installed with  pod 'SwiftSocket'            in your pod file
//  - 'pod install' command run in terminal for the current project to install these pods

// To run this code, use the run button in XCode to compile and run it on either a device simulator or real device
// Either copy the code inside the viewDidLoad() function to your own spot in your code, or to just run this file
//   copy the entire thing into your ViewController.swift file, replacing the current code there

// INFORMATION - If you recieve an error about server certificates being invalid or similar, open your info.plist
//   file, add an entry to 'App Transport Security Settings' called 'Exception Domains', then click the add button
//   again on 'Exception Domains' and type 'api.spanet.net.au' [Enter]


// MARK: - IMPORTS
// Import standard libraries for iOS ViewController file
import UIKit
// Import Alamofire for HTTP networking, SwiftyJSON for parsing JSON data and SwiftSocket for websocket connection
import Alamofire
import SwiftyJSON
import SwiftSocket

class ViewController: UIViewController {
    
    // MARK: - VARIABLES - EDIT
    let username = "YOUR USERNAME"; // <<< FILL THIS IN WITH YOUR SPALINK USERNAME
    let spaName = "YOUR SPA NAME";  // <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
    let password = "YOUR HASHED PASSWORD"; // <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
    // To get your encrypted password, see instructions at section 1.1 on the Github repo https://github.com/BlaT2512/spanet-api/blob/main/spanet.md
    

    // MARK: - STANDARD UI FUNCTIONS
    override func viewDidLoad() {
        // Do any additional setup after loading the view
        // We are going to place the code for the request here, so it will run as soon as the app opens
        // You could also move it to an @IBAction func outlet for a button or other control

        // First, login to API with your username and encrypted password key to see if user exists, otherwise throw error
        var loginParams = ["login": username, "api_key": "4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5", "password": password]

        // MARK: - LOGIN REQUEST
        AF.request("https://api.spanet.net.au/api/MemberLogin", method: .post, parameters: loginParams, encoding: JSONEncoding.default).responseJSON { response in
            
            if JSON(response.value)["success"].description == "true" {
                
                // If you get to this section, login was successful
                debugPrint("Successfully logged into SpaNET account!")
                
                // Parameters needed for next request
                let sessionParams = ["id_member": JSON(response.value)["data"]["id_member"].description, "id_session": JSON(response.value)["data"]["id_session"].description]
                
                // MARK: - SPA SOCKET REQUEST
                AF.request("https://api.spanet.net.au/api/membersockets", parameters: sessionParams).response { response in
                    
                    if JSON(response.value)["success"].description == "true" {

                        // If you get to this section, the spa request was successful
                        debugPrint("Successfully got list of spa's linked to SpaNET account!")
                        
                        // Parse through the list of spa sockets and check that the spa specified at the top exists
                        let bodyJSON = JSON(response.value)

                        if bodyJSON["sockets"].count != 0 { // Make sure there are at least 1 spas on your account

                            var spaFound = false; // Variable to track if the right spa has been found
                            for result in bodyJSON["sockets"].arrayValue {

                                // Check whether the name matches the spa name specified at the top
                                if result["name"].description == self.spaName {

                                    // This is the correct spa that you chose
                                    spaFound = true;
                
                                    // Now that the spa has been found, connect to it
                                    debugPrint("Spa successfully found! Spa name: " + self.spaName);
                                    debugPrint("Connection to this spa will now be initiated...");
                                    let client = TCPClient(address: String(result["spaurl"].description.removeLast(5)), port: 9090);
                                    switch client.connect(timeout: 1) {

                                        case .success:

                                            // Write the command to connect to the spa
                                            debugPrint("Opened TCP socket to spa");
                                            switch client.send(string: "<connect--" + result["id_sockets"].description + "--" + result["id_member"].description + ">") {

                                                case .success:
                                                    //do{sleep(1)} // If your program returns on the next line, uncomment this as a short delay before reading may help
                                                    guard let data = client.read(22) else { return }
                                                    let response = String(bytes: data, encoding: .utf8);
                                                    
                                                    if response == "Successfully connected" {
                                                        // The spa has successfully connected
                                                        debugPrint("Successfully connected to spa, ready to send/recieve commands");

                                                        // In this example, we will demonstrate requesting an RF fix from the spa and then parsing it to get the water temperature
                                                        // Request RF data
                                                        switch client.send(string: "RF:\n") {
                                                            case .success:
                                                                // Read response from spa
                                                                guard let rfdata = client.read(1024*10) else { return }
                                                                let rfresponse = String(bytes: rfdata, encoding: .utf8);

                                                                if rfresponse!.contains("RF:") {
                                                                    // Parse the data to get water temperature
                                                                    let currentValueString = rfresponse!.split(separator: "\n")[4].split(separator: ",")[15];
                                                                    // Convert it to a float
                                                                    let currentValueInt = currentValueString.dropLast() + "." + currentValueString.suffix(1);
                                                                    let currentValue = (currentValueString as NSString).floatValue;
                                                                    // Water temperature is now parsed nicely as a float, print the value to the console (must be a string to do this)
                                                                    debugPrint("Water temperature is " + currentValueInt + " C");
                                                                }
                                                            
                                                            case .failure(_):
                                                                // Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
                                                                debugPrint("Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).");
                                                        
                                                        }
                                                    }
                                        
                                                case .failure(_):
                                                    // Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
                                                    debugPrint("Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).");
                                        
                                            }

                                        case .failure(_):
                                            // Couldn't connect to the spa websocket, do something such as throw an error
                                            debugPrint("Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.");
                                    
                                    }

                                }

                            }

                            if spaFound == false {
                                // The spa couldn't be found, do something such as throw an error
                                debugPrint("Error: The specified spa does not exist for the SpaLINK account. Please log in with a different account or change the spa name.")
                            }

                        } else {
                            // No spa's are on the linked account, do something such as throw an error
                            debugPrint("Error: No spa\'s are linked to the specified SpaLINK account. Please log in with a different account or link a spa in the SpaLINK app.")
                            return
                        }

                    } else {
                        // Couldn't make the second request to get spa websockets, do something such as throw an error (unexpected error, highly unlikely if your code is right)
                        debugPrint("Error: Unable to obtain spa details from member, but login was successful. Please check your network connection, or open an issue on GitHub (unexpected).")
                        return
                    }

                }

            } else { 
                // Login failed, do something such as throw an error
                debugPrint("Error: Unable to login with details provided. Please ensure that you have the correct username and encrypted password (see 1.1 at https://github.com/BlaT2512/spanet-api/blob/main/spanet.md for details to obtain).")
                return
            }
        }
    }
}

/////////////////////////////////////////////// SENDING COMMANDS TO THE SPA ///////////////////////////////////////////////
// To send a command to the spa, use the `client.send()` command                                                         //
// e.g.                                                                                                                  //
// To turn on pump/jet 3: client.send(string: "S24:1\n")                                                                 //
// To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.send(string: "S23: + n + "\n")   //
// To set the spa temperature to 36.2 C: client.send(string: "W40:362\n")                                                //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////