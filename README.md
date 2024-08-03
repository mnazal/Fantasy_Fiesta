# Fantasy Fiesta - A Fantasy football application

The Fantasy Football Fiesta Application is a mobile app designed to offer a user-friendly platform for managing fantasy football teams. It utilizes modern technologies to provide a seamless experience from both the user interface and backend perspectives.

## Aim

The project was developed to host a fantasy football competition at my college.

## Tech Stack

- **Client:** Flutter, Bloc State Management
- **Server:** Node.js, Express.js, MongoDB

## Features

- **Player Selection:** Users can select players to form their fantasy football teams.
- **Match Listing:** Display a list of upcoming and past matches with detailed information.
- **Live Match Data:** Integration with an external API to fetch live match data and updates.
- **Dynamic Points Update:** Automatically update player points in the database and reflect the changes in the user's fantasy team.
- **Performance Optimization:** Use caching to store frequently accessed data, reducing the load on the database and improving response times.


##  UI 

## Installation

### Prerequisites

- Node.js and npm installed
- MongoDB instance running
- Flutter installed

### Backend Setup

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/fantasy-football-fiesta.git
    cd fantasy-football-fiesta/backend
    ```

2. Install dependencies:
    ```bash
    npm install
    ```

3. Set up environment variables:
    Create a `.env` file in the `backend` directory and add the following:
    ```plaintext
    MONGODB_URI=your_mongodb_uri
    
    ```

4. Start the server:
    ```bash
    npm start
    ```

### Frontend Setup

1. Navigate to the frontend directory:
    ```bash
    cd ../frontend
    ```

2. Get the Flutter packages:
    ```bash
    flutter pub get
    ```

3. Run the app:
    ```bash
    flutter run
    ```

## Usage

1. Open the app on your mobile device or emulator.
2. Select a match from List of matches available
3. Select players to form your fantasy football team.
4. View the list of upcoming and past matches.
5. Check live match data and updates.
6. Monitor your team's performance as points are updated dynamically.


## Demo

[Link to Demo]()

## License

This project is licensed under the [MIT License](https://choosealicense.com/licenses/mit/).
