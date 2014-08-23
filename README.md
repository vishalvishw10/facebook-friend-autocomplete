# Facebook Friend Autocomplete

A JQuery plugin to add a facebook-like suggestion box under inputs with the currently logged in user's facebook friends.

## Installation

include the script after including JQuery along with the css file (or your own):  

    <script src="/facebook-friend-autocomplete.js"></script>
    <link rel="stylesheet" href="/facebook-friend-autocomplete.css">

Also, you're going to need the Facebook Javascript SDK, obviously. More about that below, under 'Usage'.

## Usage

To use this plugin, you first need to have a Facebook app registered:

1. Go to [the Facebook developers page](https://developers.facebook.com/)
2. Click on Apps > Create a new app in the header
3. Configure your app however you like
4. Awesome!

Once that is ready, you'll need to load the Facebook Javascript SDK on your page and initialize your app.
You can read all about the SDK on [the Facebook developers portal](https://developers.facebook.com/docs/javascript).

Basically, just paste the code to load the SDK from Facebook and initialize your app with:

    FB.init({
      appId: 'THE ID OF THE APP YOU CREATED'
    });
    
Next, allow the user to login with Facebook somehow, preferablly with a button of some sort with:

    FB.login();

This will prompt the user to allow your app whatever permissions you requested when creating it.

Then, just listen for the `auth.authResponseChange` event, make sure the user logged in and didn't deny your app and initialize the plugin on whichever input you want, like so:

    FB.Event.subscribe('auth.authResponseChange', function(response) {
      if (response.status === 'connected') {
        $('#fb-input').facebookAutocomplete(function(friend) {

          ...

          });
      }
    });
    
And you're done!

## Configuration

### onpick

The only required option is the `onpick` handler, which you can pass in as part of the configuration object or as a function as the only argument.  
The `onpick` function gets called when the user picks a friend.  
The only argument passed to the `onpick` function is an object with the selected friends attributes, for example:  

    {
      id: '100003993588361', // Facebook ID
      name: 'Assaf Gelber',  // Name
      picture: 'http://graph.facebook.com/100003993588361/picture/?width=32&height=32' // Profile Picture
    }

### showAvatars

A boolean value indicating whether to show friend's avatars in suggestions or not. (defaults to `true`)

### avatarSize

A number indicating the avatar's width and height in suggestions in pixels. (defaults to `32`)

### maxSuggestions

A number indicating the maximum number of suggestions to show at once. (defaults to `6`)

#### Example

    $('#fb-input').facebookAutocomplete({
      showAvatars: true,
      avatarSize: 50,
      maxSuggestions: 8,
      onpick: function (friend) {
        console.log("You picked: " + friend.name);
      }
    });

## Running the Demo

Logging in with Facebook can only work on one domain per app. I set up the app to run on `http://localhost:8000`, so inorder to view the demo, you'll have to serve the page locally on port 8000.  
To do that, open your terminal and cd into the directory and run: (requires python to be installed)  

    python -m SimpleHTTPServer

and navigate to `http://localhost:8000/demo.html` from your browser.  
Don't worry about logging in, no one is stealing your identity.

## Contributing

Feel completely free to fork this repository and send pull requests. Thanks!
