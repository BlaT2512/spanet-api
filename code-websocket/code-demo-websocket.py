# code-demo-websocket.py
# Demo code for making spa websocket connection
# Language: Python 3
# Created by Blake Tourneur
# https://github.com/BlaT2512/spanet-api

# Prerequisites:
#  - Latest Python 3.x installed with the Python Package Manager, PIP

# To run this code, run the command 'python code-demo-websocket.py' from the command line in the same directory as this file


# VARIABLES - EDIT THIS SECTION
spaIP = 'YOUR SPA IP' # <<< FILL THIS IN WITH THE IP ADDRESS OF YOUR CHOSEN SPA (EXCLUDING PORT)
memberID = 'YOUR MEMBER ID'  # <<< FILL THIS IN WITH YOUR 4-DIGIT MEMBER ID
socketID = 'YOUR SPA SOCKET ID' # <<< FILL THIS IN WITH YOUR SPA'S 4-DIGIT SOCKET ID
# Your spa IP, member ID and socket ID can be found by running the code-demo-request.py script and reading the output


# Import the 'socket' library for making the websocket connections
import socket

# Start the websocket connection to the spa
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
try:
    client.connect((spaIP, 9090))

except:
    # Couldn't connect to the spa websocket, do something such as throw an error
    print('Error: The websocket connection to the spa failed. Please check the spa IP provided in the variables section.')

else:
    # Connected to spa websocket
    print('Opened TCP socket to spa')

    try:
        # Write the command to connect to the spa
        client.send(bytes('<connect--' + socketID + '--' + memberID + '>', 'utf-8'))
    
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

########################################### SENDING COMMANDS TO THE SPA ###########################################################
## To send a command to the spa, use the `client.send()` command                                                                 ##
## e.g.                                                                                                                          ##
## To turn on pump/jet 3: client.send(bytes('S24:1\n', 'utf-8'))                                                                 ##
## To set pump/jet 2 to value of variable `n` (n must be a 0 or 1 in this case): client.send(bytes('S23:' + n + '\n', 'utf-8'))  ##
## To set the spa temperature to 36.2 C: client.send(bytes('W40:362\n', 'utf-8'))                                                ##
###################################################################################################################################