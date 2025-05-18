# MindCare - Mental Health Companion App

MindCare is a comprehensive mental health companion app built with Flutter and Node.js. It provides users with tools for mood tracking, AI-powered chat support, and mental health resources.

## Features

- **User Authentication**
  - Secure login and registration
  - Profile management
  - Session persistence

- **Mood Tracking**
  - Daily mood check-ins
  - Mood history visualization
  - Notes and reflections

- **AI Chat Support**
  - 24/7 AI-powered mental health support
  - Empathetic and helpful responses
  - Conversation history

- **Resources**
  - Mental health resources
  - Self-care tips
  - Emergency contacts

## Tech Stack

### Frontend
- Flutter/Dart
- Provider for state management
- HTTP for API communication
- Shared Preferences for local storage
- Flutter Secure Storage for sensitive data

### Backend
- Node.js with Express
- MongoDB for database
- JWT for authentication
- OpenAI GPT-4 for AI chat
- Docker for containerization

## Prerequisites

- Flutter SDK (latest version)
- Node.js (v18 or higher)
- MongoDB Atlas account
- OpenAI API key
- Git

## Setup Instructions

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file in the backend directory with the following variables:
   ```
   MONGODB_URI=your_mongodb_connection_string
   JWT_SECRET=your_jwt_secret
   OPENAI_API_KEY=your_openai_api_key
   PORT=3000
   ```

4. Start the backend server:
   ```bash
   npm start
   ```

### Frontend Setup

1. Navigate to the project root directory:
   ```bash
   cd mind_care_app
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Docker Setup (Optional)

1. Build and run using Docker Compose:
   ```bash
   docker-compose up --build
   ```

## Environment Variables

### Backend (.env)
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: Secret key for JWT token generation
- `OPENAI_API_KEY`: OpenAI API key for chat functionality
- `PORT`: Server port (default: 3000)

### Frontend
- Update the `_baseUrl` in `lib/providers/chat_provider.dart` to match your backend URL

## API Endpoints

### Authentication
- `POST /api/auth/register`: Register new user
- `POST /api/auth/login`: User login
- `GET /api/auth/profile`: Get user profile

### Moods
- `POST /api/moods`: Create mood entry
- `GET /api/moods`: Get user's moods
- `GET /api/moods/today`: Get today's mood
- `GET /api/moods/stats`: Get mood statistics

### Chat
- `POST /api/chat`: Send message to AI
- `GET /api/chat/history`: Get chat history

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- OpenAI for the GPT-4 API
- All contributors and supporters of the project 