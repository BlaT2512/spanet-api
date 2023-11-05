const axios = require('axios');

const email = 'YOUR SMARTLINK EMAIL';
const password = 'YOUR SMARTLINK PASSWORD';

// Create the base API details
const spanetapi = axios.create ({
  baseURL: 'https://app.spanet.net.au/api',
  timeout: 2000,
  headers: {'User-Agent': 'SpaNET/2 CFNetwork/1465.1 Darwin/23.0.0'},
  validateStatus: function (status) {
    return status === 200; 
  },
});

// Post to the authenticate endpoint with email and password in JSON body
spanetapi.post('/Login/Authenticate', {
  'email': email,
  'password': password,
  'userDeviceId': 'Any random string / UUID',
  'language': 'en',
})
  .then((response) => {
    const accessToken = response.data.access_token;
    console.log('Logged in successfully, Access Token', accessToken);

    // Now use the auth token in authorization header for further requests made
    spanetapi.defaults.headers.common['Authorization'] = 'Bearer ' + accessToken;

    // Get from the devices endpoint to list your spas
    spanetapi.get('/Devices')
      .then((response) => {
        console.log('Devices on your account:', response.data.devices);

        // Use the first spa and get the current temperature
        if (response.data.devices.length > 0) {
          const spa = response.data.devices[0];
          console.log('Using spa "' + spa.name + '"');
        
          spanetapi.get('/Dashboard/' + spa.id)
            .then((response) => {
              console.log('Current water temperature is', response.data.setTemperature / 10);
            })
            .catch((error) => {
              console.log('Failed to get details of this spa', error);
            });
          
        } else {
          console.log('There are no spas on your account');
        }
      })
      .catch((error) => {
        console.log('Failed to get list of spas', error);
      });
  })
  .catch((error) => {
    console.log('Failed to authenticate, check email and password?', error); 
  });
