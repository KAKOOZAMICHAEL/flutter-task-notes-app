# Flutter Task Notes App

A Flutter application for managing tasks and notes with local persistence using SQLite and SharedPreferences.

## Features

- **Task Management**: Create, view, and delete tasks
- **Priority Levels**: Assign priority (Low, Medium, High) to tasks
- **Task Completion**: Mark tasks as completed
- **Theme Toggle**: Switch between light and dark themes (persisted with SharedPreferences)
- **Local Database**: All tasks are stored locally using SQLite (sqflite)
- **Dynamic Lists**: Tasks are displayed in a dynamic ListView populated from the database

## Project Structure

```
lib/
├── main.dart                 # App entry point with theme management
├── models/
│   └── task_item.dart       # TaskItem model with JSON serialization
├── database/
│   └── database_helper.dart # SQLite database helper class
└── screens/
    ├── home_screen.dart     # Home screen with task list
    └── form_screen.dart     # Form screen for adding new tasks
```

## Dependencies

- `shared_preferences`: ^2.2.2 - For storing theme preference
- `sqflite`: ^2.3.0 - For local SQLite database
- `path`: ^2.1.1 - For database path handling

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

## Development History

- Initial setup
- Added form screen
- Integrated sqflite database
- Added SharedPreferences for theme persistence
- Implemented task deletion functionality

