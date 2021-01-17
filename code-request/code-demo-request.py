# code-demo-request.py
# Demo code for making SpaNET API web requests
# Language: Python 3
# Created by Blake Tourneur
# https://github.com/BlaT2512/spanet-api

# Prerequisites:
#  - Latest Python 3.x installed with the Python Package Manager, PIP
#  - 'Requests' package installed (pip install requests)

# To run this code, run the command 'python code-demo-request.py' from the command line in the same directory as this file


# VARIABLES - EDIT THIS SECTION
username = 'YOUR USERNAME' # <<< FILL THIS IN WITH YOUR SPALINK USERNAME
spaName = 'YOUR SPA NAME'  # <<< FILL THIS IN WITH A VALID SPA NAME ON YOUR ACCOUNT
password = 'YOUR HASHED PASSWORD' # <<< FILL THIS IN WITH YOUR SPALINK ENCRYPTED PASSWORD
# To get your encrypted password, see instructions at section 1.1 on the Github repo https://github.com/BlaT2512/spanet-api/blob/main/spanet.md


# Import the 'requests' library for making the web requests
import requests

# First, login to API with your username and encrypted password key to see if user exists, otherwise throw error
loginParams = {
    'login': username,
    'api_key': '4a483b9a-8f02-4e46-8bfa-0cf5732dbbd5',
    'password': password,
}

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

                    # WRITE SOME CODE TO DO ONCE THE SPA HAS BEEN FOUND
                    # You could connect to it's websocket, this is done in the code-demo.py file in the code-demo folder
                    print('Spa successfully found! Spa name: ' + spaName)
                    print('Use these details for websocket connection: Spa IP ' + result['spaurl'][:-5] + ' ; Member ID ' + str(result['id_member']) + ' ; Socket ID ' + str(result['id_sockets']))
            
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