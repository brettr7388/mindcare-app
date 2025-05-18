# MindCare - Mental Health Companion App

A Flutter-based mobile application for mental health tracking and support, featuring mood tracking, AI-powered chat support, and mental health resources.

## Features

- User authentication (signup/login)
- Daily mood tracking with notes
- AI-powered chat support
- Mental health resources and articles
- User profile and settings
- Dark mode support
- Data synchronization across devices

## Tech Stack

### Frontend
- Flutter
- Dart
- Provider (State Management)
- Hive (Local Storage)
- flutter_secure_storage
- http

### Backend
- Node.js
- Express
- MongoDB
- JWT Authentication
- OpenAI GPT-4 API

## Prerequisites

- Flutter SDK
- Node.js
- MongoDB
- OpenAI API Key
- Docker (optional)

## Setup Instructions

### Frontend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/mindcare.git
   cd mindcare
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Update the API base URL in `lib/providers/auth_provider.dart`:
   ```dart
   final baseUrl = 'http://your-api-url:3000/api';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

### Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file:
   ```
   MONGODB_URI=mongodb://localhost:27017/mindcare
   JWT_SECRET=your_jwt_secret_key
   OPENAI_API_KEY=your_openai_api_key
   PORT=3000
   ```

4. Start the server:
   ```bash
   npm start
   ```

### Docker Setup

1. Build and run with Docker Compose:
   ```bash
   docker-compose up --build
   ```

## Environment Variables

### Frontend
- `API_BASE_URL`: Backend API URL

### Backend
- `MONGODB_URI`: MongoDB connection string
- `JWT_SECRET`: Secret key for JWT tokens
- `OPENAI_API_KEY`: OpenAI API key
- `PORT`: Server port (default: 3000)

## API Endpoints

### Authentication
- `POST /api/auth/signup`: Create new account
- `POST /api/auth/login`: Login
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