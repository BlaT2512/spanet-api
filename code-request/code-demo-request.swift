// code-demo-request.swift
// Demo code for making SpaNET API web requests
// Language: Swift
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - XCode and Cocoapods installed & configured for current project
//  - 'Alamofire' pod installed with    pod 'Alamofire', '~> 5.2'    in your pod file
//  - 'SwiftyJSON' pod installed with   pod 'SwiftyJSON', '~> 4.0'   in your pod file
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
// Import Alamofire for HTTP networking and SwiftyJSON for parsing JSON data
import Alamofire
import SwiftyJSON

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
                
                                    // WRITE SOME CODE TO DO ONCE THE SPA HAS BEEN FOUND
                                    // You could connect to it's websocket, this is done in the code-demo.swift file in the code-demo folder
                                    debugPrint("Spa successfully found! Spa name: " + self.spaName);
                                    debugPrint("Use these details for websocket connection: Spa IP " + String(result["spaurl"].description.removeLast(5)) + " ; Member ID " + result["id_member"].description + " ; Socket ID " + result["id_sockets"].description);

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