## WARNING: If you want to use the Godot 4 version go to the `godot4-implementation` branch

# GameJolt API plugin for Godot Engine.
![Screenshot](https://github.com/deakcor/godot-gamejolt-api-demo/blob/main/example/fond.png)
## About
**Features**
* Use GameJolt API in version 1.2
* Godot Engine plugin
* Parameters to the api calls can be passed both as strings and numbers
* Allow to verbose mode to see direct communication
* URLs are percent encoded
* Use HTTPS communication with GameJolt API
* For Godot 3+
* One common singal on end of request
* Many point of checking response

**Installing**
1. Download the repository
2. Create the "addons/gamejolt" folder in the root (res://) of your project
3. Copy files from repositiory to that folder (By downloading, git clone or submodule if your project use git)
4. In the project settings, head to the "Plugins" tab and activate the plugin by changing its state from "Inactive" to "Active"
5. Yay, you've installed the plugin!
6. You can check [a demo of this plugin](https://github.com/deakcor/godot-gamejolt-api-demo)

**How to use it**
1. Put the plugin as a Node in your project. For a project which need it in several place, could be intersting to add it in child of an autoload.
2. Call the function from the plugin. It'll initiate the request.
3. When response is received plugin will send the signal gamejolt_request_completed with the type of the request and a message
4. You may connect to this signal or yield. Now, you can also write all your request directly, there is a queue to process all the requests.
5. Get the response from the plugin - it's the parsed JSON to godot directory, which is the "response" part from GameJoltAPI.


# Methods description

## Authentication and users
### Authenticate user

`auto_auth()`

Authenticates the user who plays the game. It works only with html5 games on Gamejolt.

`auth_user(token, username)`

Authenticates the user with the given credentials
Before doing calls that deal with users in one way or another, you must authenticate a user to ensure that the username-token pair is valid.

* token - your gamejolt token (not your password)
* username - your gamejolt username

### Fetch user's information

`fetch_user(username=null, ids=null):` 

Fetch the user's information

* username - name of the user, whose information you'd like to fetch
* id - id of the user, whose information you'd like to fetch

You don't need to pass both arguments, but at least one argument must be passed! When using ids, multiple ids can be passed, like this: '1,2,3,4'

## Sessions
### Open the session

`open_session()`

Opens the session.
_Uses authenticated user credentials_
Piece of cake! If there's an active session, it will close it and open a new one.

### Ping the session

`ping_session()`

Ping the session to keep it alive.
_Uses authenticated user credentials_
A session is closed after 120 seconds if not pinged. You have to ping the session to prevent it from closing.
Usually a timer that pings the session every 60 seconds will do the trick.

### Close the session
`close_session()`

Closes the active session.
_Uses authenticated user credentials_
When the player quits the game, the session should be closed.
If the game is closed, the session will be closed automatically anyway since it's not being pinged, but it's better to close it manually with this method, just in case.

## Trophies a.k.a achievements
### Fetch user trophies

`fetch_trophy(achieved=null, trophy_ids=null)` 

Fetches user trophies.
* achieved - leave blank to extarct all trophies, "true" to extract only trophies that the user has already achieved and "false" to get only unachieved trophies
* trophy_ids - pass a trophy id to extract the specific trophy or a set of trophy ids to get a list of trophies, like this: '1,2,3,4'
_Uses authenticated user credentials_
Trophies are basically achievements, nothing unusual. Fetching a list of trophies, just one trophy, only achieved trophies or only the unachieved trophies is done through this supermethod.
If the second parameter is passed, the first one is ignored!

### Achieve the trophy
`set_trophy_achieved(trophy_id)` 

Sets the trophy as achieved.
* trophy_id - id of the trophy to set as achieved
_Uses authenticated user credentials_
To set a trophy as achieved.

### Remove achieved trophy
`remove_trophy_achieved(trophy_id)`

Remove the achieved trophy.
* trophy_id - id of the trophy to set as achieved
_Uses authenticated user credentials_

## Scores
### Fetch user scores
`fetch_scores(limit=null, table_id=null, better_than=null, worse_than=null)`

Fetches scores for the user.
* limit - how many scores to return. The default value is 10, the max is 100
* table_id - what table to extract scores from. Leaving it blank will extract scores from the main table
* better_than - take scores better than
* worse_than - take scores worse than
_Uses authenticated user credentials_

### Fetch guest scores
`fetch_guest_scores(guest, limit=null, table_id=null, better_than=null, worse_than=null)`

Fetches scores for the guest.
* guest - the guest name
* limit - how many scores to return. The default value is 10, the max is 100
* table_id - what table to extract scores from. Leaving it blank will extract scores from the main table
* better_than - take scores better than
* worse_than - take scores worse than

### Fetch global scores
`fetch_global_scores(limit=null, table_id=null, better_than=null, worse_than=null)`

Fetches global scores.
* limit - how many scores to return. The default value is 10, the max is 100
* table_id - what table to extract scores from. Leaving it blank will extract scores from the main table
* better_than - take scores better than
* worse_than - take scores worse than

### Add scores for user
`add_score(score, sort, table_id=null)`

Adds a score to a table
* score - string assotiated with the score. For instance: "124 Jumps"
* sort - the actual score value. For example: 124
* table_id - what table to submit scores to. If left blank, the score will be submitted to the main table
_Uses authenticated user credentials_

### Add scores for guest
`add_guest_score(score, sort, guest, table_id=null)`

Adds a score to a table
* score - string assotiated with the score. For instance: "124 Jumps"
* sort - the actual score value. For example: 124
* guest - the guest name
* table_id - what table to submit scores to. If left blank, the score will be submitted to the main table
_Uses authenticated user credentials_

### List scoreboards
`fetch_tables()` 

Returns a list of all scoreboards

## Data storage
### Set Data
`set_data(key, data, global=true)`

Stores data in the cloud
* key - a piece of data is stored in a *key*, this is the name of the key
* data - what you want to store in the key
* global - true, then use global data; false use authenticated user specific data
Data can be strings, integers, floats...anything

### Fetch data
`fetch_data(key, global=true)`

Fetches data from the key
* key - key to fetch data from
* global - true, then use global data; false use authenticated user specific data

### Update data
`update_data(key, operation, value, global=true)`

Updates data in the key
* key - key, whose data will be updated
* operation - what kind of operation to perform on the data. String can be prepended and appended to. Numbers can be divided, multiplied, added to and subtracted from. Use one of these: "append", "prepend", "divide", "multiply", "add", "subtract"
* value = value that will be used in the operation
* global - true, then use global data; false use authenticated user specific data

### Remove data
`remove_data(key, global=true)`

Removes a key
* key - what key to remove
* global - true, then use global data; false use authenticated user specific data

### List of data keys
`get_data_keys(pattern=null, global=true)`

Return a list of keys
* pattern - the pattern for filter data keys
* global - true, then use global data; false use authenticated user specific data

## Time
### Get server time
`fetch_time()`

Get a time from the server.

## Additional methods

* get_username() - returns authenticated username
* get_user_token() - return the authenticated user's token

# Hints

1. Don't use thread for html5 games. HTTPrequest doesn't work.
2. Remember - yield does out from current function and executes caller code (!). Action in that function (and only that function) will be resumed on the signal.
