# code-demo.py
# Full demo code for making SpaNET API requests and connecting to spa websocket
# Language: Python 3
# Created by Blake Tourneur
# https://github.com/BlaT2512/spanet-api

# Prerequisites:
#  - Latest Python 3.x installed with the Python Package Manager, PIP
#  - 'Requests' package installed (pip install requests)

# To run this code, run the command 'python code-demo.py' from the command line in the same directory as this file


# VARIABLES - EDIT THIS SECTION
username = 'YOUR USERNAME' # <<< FILL THIS IN WITH YOUR SPALINK USERNAME
spaName = 'YOUR SPA NAME'  # <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
password = 'YOUR HASHED PASSWORD' # <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
# To get your encrypted password, see instructions at section 1.1 on the Github repo https://github.com/BlaT2512/spanet-api/blob/main/spanet.md


# Import the 'requests' library for making the web requests
import requests
# Import the 'socket' library for making the websocket connections
import socket

# First, login to API with your username and encrypted password key to see if user exists, otherwise throw error
loginParams = {
    'login': username,
    'api_key': '4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5',
    'password': password,
}
# Create the websocket object
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

r = requests.post("https://api.spanet.net.au/api/MemberLogin", data=loginParams)
if (r.status_code == 200 and r.json()["success"]):
    # If you get to this section, login was successful
    print('Successfully logged into SpaNET account!')

    # Variables needed for next request
    memberId = r.json()["data"]["id_member"]
    sessionId = r.json()["data"]["id_session"]

    # Make the next request which will check the spas on your account
    spaParams = {
        'id_member': memberId,
        'id_session': sessionId,
    }

    r2 = requests.get("https://api.spanet.net.au/api/membersockets", params=spaParams)
    if (r2.status_code == 200 and r2.json()["success"]):
        # If you get to this section, the spa request was successful
        print("Successfully got list of spa's linked to SpaNET account!")

        # Parse through the list of spa sockets and check that the spa specified at the top exists
        bodyJSON = r2.json()

        if (len(bodyJSON['sockets']) != 0): # Make sure there are at least 1 spas on your account
            spaFound = False # Variable to track if the right spa has been found

            for result in bodyJSON["sockets"]:
                # Check whether the name matches the spa name specified at the top
                if (result['name'] == spaName):
                    # This is the correct spa that you chose
                    spaFound = True

                    # Now that the spa has been found, connect to it
                    print('Spa successfully found! Spa name: ' + spaName)
                    print('Connection to this spa will now be initiated...')
                    try:
                        client.connect((result['spaurl'][:-5], 9090))

                    except:
                        # Couldn't connect to the spa websocket, do something such as throw an error
                        print('Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.')

                    else:
                        # Connected to spa websocket
                        print('Opened TCP socket to spa')

                        try:
                            # Write the command to connect to the spa
                            client.send(bytes('<connect--' + str(result['id_sockets']) + '--' + str(result['id_member']) + '>', 'utf-8'))
                        
                        except:
                            # Couldn't send data to the spa, do something such as throw an error (unexpected error, highly unlikely if your code is right)
                            print('Error: Data transfer to the websocket failed, but connection was successful. Please check your network connection, or open an issue on GitHub (unexpected).')
                        
                        else:
                            # Check that data sent successfully
                            data = client.recv(22)
                            
                            if (str(data)[2:-1] == 'Successfully connected'):
                                # The spa has successfully connected
                                print('Successfully connected to spa, ready to send/recieve commands')

                                # In this example, we will demonstrate requesting an RF fix from the spa and then parsing it to get the water temperature
                                # Request RF data
                                client.send(bytes('RF\n', 'utf-8'))

                                # Read response from spa
                                data = client.recv(1024)

                                if 'RF:' in str(data):
                                    # Parse tha data to get water temperature
                                    currentValueString = str(data).split('\\r\\n')[4].split(',')[16]
                                    # Convert it to a float
                                    currentValueInt = currentValueString[0:-1] + '.' + currentValueString[-1:]
                                    currentValue = float(currentValueInt)
                                    # Water temperature is now parsed nicely as a float, print the value to the console (must be a string to do this)
                                    print('Water temperature is ' + str(currentValue) + ' C')

            
            if (spaFound == False):
                # The spa couldn't be found, do something such as throw an error
                print('Error: The specified spa does not exist for the SpaLINK account. Please log in with a different account or change the spa name.')
        
        else:
            # No spa's are on the linked account, do something such as throw an error
            print('Error: No spa\'s are linked to the specified SpaLINK account. Please log in with a different account or link a spa in the SpaLINK app.')
    
    else:
        # Couldn't make the second request to get spa websockets, do something such as throw an error (unexpected error, highly unlikely if your code is right)
        print('Error: Unable to obtain spa details from member, but login was successful. Please check your network connection, or open an issue on GitHub (unexpected).')

else:
    # Login failed, do something such as throw an error
    print('Error: Unable to login with details provided. Please ensure that you have the correct username and encrypted password (see 1.1 at https://github.com/BlaT2512/spanet-api/blob/main/spanet.md for details to obtain).')

########################################### SENDING COMMANDS TO THE SPA ###########################################################
## To send a command to the spa, use the `client.send()` command                                                                 ##
## e.g.                                                                                                                          ##
## To turn on pump/jet 3: client.send(bytes('S24:1\n', 'utf-8'))                                                                 ##
## To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.send(bytes('S23:' + n + '\n', 'utf-8'))  ##
## To set the spa temperature to 36.2 C: client.send(bytes('W40:362\n', 'utf-8'))                                                ##
###################################################################################################################################