# Postify
A flutter based web application which allows users to connect, create posts, and send friend requests, and chat with friends. To use the web app go to this link: https://postify-16l.pages.dev/ 
To know more about the design and improvements that can be made refer to the design doc: https://docs.google.com/document/d/1VVitMtY_d1hZxBDaYAMw1jJNY4rVtklJ4gVQntFo3Ok/edit?usp=sharing

– Implemented the frontend using **Flutter**, creating interactive user interfaces with widgets and handling user input.

– Integrated backend functionality using **Node.js** and **MongoDB**, allowing users to store and retrieve data from the
database.

– Tech Stacks: Flutter, Dart, Node.js, MongoDB, Cloudinary

## Branches

- **master**: Contains only the README file with guidance.
- **backend**: Hosts the backend code and configurations.
- **frontend**: Holds the frontend codebase.
- **build**: Specifically for the built and deployable version of the frontend.

## Backend

The backend of Postify is hosted on the `backend` branch. The Backend is built using Node.js , Express.js. The databse used is MongoDB.  It is deployed using Render.

## Frontend

The frontend code can be found on the `frontend` branch. Frontend is built completely using Flutter. This branch contains all the flutter code other than build folder.

## Deployment

- **Backend**: Hosted from the `backend` branch. Deployed using Render

- **Frontend**: Deployed from the `build` branch. Deployed using clouflare. To visit go here: https://postify-16l.pages.dev/

## High Level Architecture:
  The architecture of Postify is really simple.  Client sends HTTP Requests to the backend server. Backend is responsible for authenticating the user, performing CRUD updates on the database and sending HTTP   responses back to the client in JSON format. The Request and Response  sent/received are handled by flutter framework and the JSON is displayed in beautified fashion in UI.
  
  ![HLD](https://github.com/Satyam1942/Postify/assets/126737709/c8b6877e-c71d-4946-b163-f43f641fd4a5)

Feel free to explore each branch for specific code and documentation related to that part of the project.
