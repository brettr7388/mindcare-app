# MindCare - Mental Health Companion App

MindCare is a comprehensive mental health companion app built with Flutter and Node.js. It provides users with tools for mood tracking, AI-powered chat support, and mental health resources.

## Features

- **User Authentication**
  - Secure login and registration
  - Profile management with picture upload
  - Session persistence

- **Mood Tracking**
  - Daily mood check-ins with visual scale
  - Mood history visualization with charts
  - Mood analytics and streak tracking
  - Notes and reflections

- **AI Chat Support**
  - 24/7 AI-powered mental health support using OpenAI GPT-4
  - Empathetic and helpful responses
  - Conversation history
  - Safe space for expression

- **Resources**
  - Mental health resources and articles
  - Self-care tips and recommendations
  - Emergency contacts and crisis support
  - Stress free games

## Tech Stack

### Frontend
- **Flutter/Dart** - Cross-platform mobile development
- **Provider** - State management
- **HTTP** - API communication
- **Shared Preferences** - Local storage
- **Flutter Secure Storage** - Sensitive data storage
- **Charts** - Data visualization with fl_chart
- **UI/UX** - Google Fonts, Lottie animations, custom theming

### Backend
- **Node.js with Express** - REST API server
- **MongoDB** - NoSQL database for user data and mood tracking
- **JWT** - Authentication and authorization
- **OpenAI GPT-4** - AI chat functionality
- **Multer** - File upload handling
- **Docker** - Containerization support

## Prerequisites

- **Flutter SDK** (3.0.0 or higher) - [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Node.js** (v18 or higher) - [Install Node.js](https://nodejs.org/)
- **MongoDB Atlas Account** - [Sign up for MongoDB Atlas](https://www.mongodb.com/atlas)
- **OpenAI API Key** - [Get OpenAI API Key](https://platform.openai.com/api-keys)
- **Git** - [Install Git](https://git-scm.com/)

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/your-username/MindCare.git
cd MindCare
```

### 2. Backend Setup

1. Navigate to the backend directory:
   ```bash
   cd backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create environment file from template:
   ```bash
   cp .env.example .env
   ```

4. Edit the `.env` file with your credentials:
   ```bash
   # Database Configuration
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/mindcare
   
   # Authentication
   JWT_SECRET=your_super_secret_jwt_key_here
   
   # AI Chat (OpenAI)
   OPENAI_API_KEY=sk-your-openai-api-key-here
   
   # Server Configuration
   PORT=3000
   ```

5. Start the backend server:
   ```bash
   npm start
   ```
   
   The server will run on `http://localhost:3000`

### 3. Frontend Setup

1. Open a new terminal and navigate to the project root:
   ```bash
   cd path/to/MindCare
   ```

2. Create frontend environment file:
   ```bash
   cp .env.example .env
   ```

3. Edit the `.env` file in the root directory:
   ```bash
   # API Configuration
   API_BASE_URL=http://localhost:3000/api
   ```

4. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

5. Run the Flutter app:
   ```bash
   flutter run
   ```

## Environment Setup Details

### Required API Keys

1. **MongoDB Atlas**:
   - Create a free cluster at [MongoDB Atlas](https://www.mongodb.com/atlas)
   - Get your connection string
   - Replace `<username>`, `<password>`, and `<cluster-url>` in the connection string

2. **OpenAI API Key**:
   - Sign up at [OpenAI Platform](https://platform.openai.com/)
   - Create an API key in your account settings
   - Note: You'll need credits in your OpenAI account for the chat feature

### Configuration Files

**Backend `.env` (in `/backend/` folder):**
```env
MONGODB_URI=mongodb+srv://your_username:your_password@your_cluster.mongodb.net/mindcare
JWT_SECRET=your_very_long_and_secure_secret_key_here
OPENAI_API_KEY=sk-your_openai_api_key_here
PORT=3000
```

**Frontend `.env` (in root folder):**
```env
API_BASE_URL=http://localhost:3000/api
```

## Testing the Application

1. **Create an Account**: Sign up with a test email and password
2. **Log a Mood**: Try the mood tracking feature with the slider interface
3. **Chat with AI**: Test the AI chat support (requires OpenAI API key)
4. **Upload Profile Picture**: Test file upload functionality
5. **View Analytics**: Check mood history and analytics charts

## Docker Setup (Alternative)

If you prefer using Docker:

1. **Update docker-compose.yml** with your environment variables
2. **Run with Docker Compose**:
   ```bash
   docker-compose up --build
   ```

## API Endpoints Documentation

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `GET /api/auth/profile` - Get user profile
- `PUT /api/auth/profile` - Update user profile
- `POST /api/auth/profile/upload-picture` - Upload profile picture

### Moods
- `POST /api/moods` - Create mood entry
- `GET /api/moods` - Get user's mood history
- `PUT /api/moods/:id` - Update specific mood entry
- `GET /api/moods/stats` - Get mood statistics

### Chat
- `POST /api/chat` - Send message to AI
- `POST /api/chat/clear` - Clear chat history

## Troubleshooting

### Common Issues

1. **"Could not connect to server" Error**:
   - Ensure backend is running on `http://localhost:3000`
   - Check that your `.env` file in the root directory has `API_BASE_URL=http://localhost:3000/api`

2. **MongoDB Connection Error**:
   - Verify your MongoDB Atlas connection string
   - Ensure your IP address is whitelisted in MongoDB Atlas
   - Check username/password are correct

3. **OpenAI API Error**:
   - Verify your OpenAI API key is valid
   - Ensure you have credits in your OpenAI account
   - Check the API key has the correct permissions

4. **Flutter Build Issues**:
   - Run `flutter clean` then `flutter pub get`
   - Ensure Flutter SDK is updated to latest stable version

### Platform-Specific Notes

- **iOS**: Requires Xcode for iOS development
- **Android**: Requires Android Studio and Android SDK
- **Web**: Works with Chrome for testing

## Project Structure

```
MindCare/
├── lib/                    # Flutter app source code
│   ├── config/            # Configuration files
│   │   ├── config.dart    # Configuration constants
│   │   └── theme.dart     # App theme configuration
│   ├── models/            # Data models
│   │   ├── mood.dart      # Mood model
│   │   └── user.dart      # User model
│   ├── providers/         # State management
│   │   ├── auth_provider.dart  # Authentication provider
│   │   ├── chat_provider.dart   # Chat provider
│   │   └── mood_provider.dart   # Mood provider
│   ├── screens/           # UI screens
│   │   ├── auth_screens/      # Authentication screens
│   │   ├── chat_screens/      # Chat screens
│   │   └── mood_screens/      # Mood tracking screens
│   ├── services/          # API services
│   │   └── api_service.dart   # API service
│   ├── utils/             # Utility functions
│   └── widgets/           # Reusable UI components
├── backend/               # Node.js backend
│   ├── src/
│   │   ├── controllers/   # Route controllers
│   │   ├── middleware/    # Express middleware
│   │   ├── models/        # MongoDB models
│   │   └── routes/        # API routes
│   └── uploads/           # File uploads storage
├── assets/                # App assets (images, sounds, etc.)
└── .env                   # Frontend environment variables
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Demo Credentials

For quick testing, you can create a test account or use these demo credentials if provided:
- **Email**: test@test.com
- **Password**: password123

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact & Feedback

For questions about this project or feedback:
- Create an issue in this repository
- Contact: [Your Email or LinkedIn]

## Acknowledgments

- Flutter team for the amazing framework
- OpenAI for the GPT-4 API
- MongoDB Atlas for database hosting
- All contributors and supporters of the project

---
