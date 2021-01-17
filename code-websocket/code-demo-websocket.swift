// code-demo-request.swift
// Demo code for making spa websocket connection
// Language: Swift
// Created by Blake Tourneur
// https://github.com/BlaT2512/spanet-api

// Prerequisites:
//  - XCode and Cocoapods installed & configured for current project
//  - 'SwiftSocket' pod installed with   pod 'SwiftSocket'   in your pod file
//  - 'pod install' command run in terminal for the current project to install this pod

// To run this code, use the run button in XCode to compile and run it on either a device simulator or real device
// Either copy the code inside the viewDidLoad() function to your own spot in your code, or to just run this file
//   copy the entire thing into your ViewController.swift file, replacing the current code there


// MARK: - IMPORTS
// Import standard libraries for iOS ViewController file
import UIKit
// Import SwiftSocket for making the websocket connections
import SwiftSocket

class ViewController: UIViewController {
    
    // MARK: - VARIABLES - EDIT
    let spaIP = "YOUR SPA IP"; // <<< FILL THIS IN WITH THE IP ADDRESS OF YOUR CHOSEN SPA (EXCLUDING PORT)
    let memberID = "YOUR MEMBER ID";  // <<< FILL THIS IN WITH YOUR 4-DIGIT MEMBER ID
    let socketID = "YOUR SPA SOCKET ID"; // <<< FILL THIS IN WITH YOUR SPA'S 4-DIGIT SOCKET ID
    // Your spa IP, member ID and socket ID can be found by running the code-demo-request.swift script and reading the output
    

    // MARK: - STANDARD UI FUNCTIONS
    override func viewDidLoad() {
        // Do any additional setup after loading the view
        // We are going to place the code for the connection here, so it will run as soon as the app opens
        // You could also move it to an @IBAction func outlet for a button or other control

        // MARK: - WEBSOCKET CONNECTION
        let client = TCPClient(address: spaIP, port: 9090);
        switch client.connect(timeout: 1) {

            case .success:

                // Write the command to connect to the spa
                debugPrint("Opened TCP socket to spa");
                switch client.send(string: "<connect--" + socketID + "--" + memberID + ">") {

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

/////////////////////////////////////////////// SENDING COMMANDS TO THE SPA ///////////////////////////////////////////////
// To send a command to the spa, use the `client.send()` command                                                         //
// e.g.                                                                                                                  //
// To turn on pump/jet 3: client.send(string: "S24:1\n")                                                                 //
// To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.send(string: "S23: + n + "\n")   //
// To set the spa temperature to 36.2 C: client.send(string: "W40:362\n")                                                //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////