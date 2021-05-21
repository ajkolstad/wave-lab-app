# Website

## Requirements
 - Javascript
 - NodeJS
 - Completion of MySQL server setup

## How to build
1. Install NodeJS
2. Clone repository
3. Inside the repository, run `npm install` to download dependencies
4. Open `Website` directory
5. Run `node server.js`
6. Website is now live at localhost:port
   - Port is printed when server starts

## Important Files

### `/server.js`
 - Heart of the server and opens the port and launches the web server
 - Calls on helper functions to render website

### `/routes/auth.js`
 - Routes functions to buttons on webpage
 - Used for login and adding depth requests

### `/routes/pages.js`
 - Handles all webpage rendering
 - Connects to database to get information before rendering pages
 - Changes available page content if user is logged in

### `/controllers/auth.js`
 - Contains functions for logging in and posting depth requests