# MortyverseExplorer

A Swift iOS application that displays characters from the Rick and Morty API with status filtering capabilities. The app follows MVVM architecture with Coordinator pattern and uses Combine for reactive programming.

## Features

- Fetch and display characters from Rick and Morty API
- Filter characters by status (Alive, Dead, Unknown)
- Pagination support for loading more characters
- Image caching using AlamofireImage
- Error handling and loading states
- Clean architecture with MVVM + Coordinator pattern
- Reactive programming with Combine framework

## Architecture

The project follows the MVVM (Model-View-ViewModel) architectural pattern with the addition of a Coordinator for navigation:

```
├── Presentation
│   ├── Views
│   │   ├── CharacterListView
│   │   ├── CharacterFilterView
│   │   └── LoadingView
│   ├── ViewModels
│   │   └── CharacterListViewModel
│   └── Coordinators
│       └── CharacterListCoordinator
├── Domain
│   ├── Models
│   │   ├── CharacterListItem
│   │   └── CharacterFilterItem
│   └── UseCases
│       └── CharacterListUseCase
└── Data
    └── Network
        └── API
```

### Key Components

- **Views**: UI components responsible for displaying data and handling user interactions
- **ViewModels**: Business logic and state management
- **Coordinators**: Handle navigation flow
- **UseCases**: Encapsulate business rules and data operations
- **Models**: Data structures representing the application's entities

## Requirements

- iOS 15.0+
- Xcode 15.3
- Swift 5.9

## Dependencies

- **AlamofireImage**: Used for efficient image loading and caching
- **Combine**: Apple's framework for handling asynchronous events

## Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Open `CharacterList.xcodeproj` in Xcode 15.3 or later

3. Install dependencies using Swift Package Manager:
   - The project uses Swift Package Manager for dependency management
   - Dependencies will be resolved automatically when opening the project

4. Build and run the project

## Project Structure

### Views
- `CharacterListView`: Main view controller displaying the list of characters
- `CharacterFilterView`: Custom view for status filtering
- `LoadingView`: Loading indicator view

### ViewModels
- `CharacterListViewModel`: Manages character list state and business logic
  - Handles data fetching
  - Manages filtering logic
  - Handles pagination
  - Manages loading and error states

### Models
- `CharacterListItem`: Represents a character entity
- `CharacterFilterItem`: Represents a filter option

### Networking
- Uses Combine for network requests
- Implements pagination
- Handles API responses and errors

## API Integration

The app integrates with the Rick and Morty API:
- Base URL: `https://rickandmortyapi.com/api/`
- Endpoint: `/character`

## Features in Detail

### Character List
- Displays character images, names, and status
- Implements infinite scrolling for pagination
- Handles loading and error states

### Filtering
- Filter characters by status:
  - Alive
  - Dead
  - Unknown
- Single filter selection at a time
- Reset capability to show all characters

### Image Handling
- Efficient image loading using AlamofireImage
- Image caching for better performance
- Placeholder images during loading

## Architecture Details

### MVVM Implementation
- **View**: Responsible for UI and user interaction
- **ViewModel**: Handles business logic and state management
- **Model**: Represents data structures

### Coordinator Pattern
- Manages navigation flow
- Decouples view controllers
- Makes the app more modular

### Combine Usage
- Reactive data binding
- Network request handling
- State management

## Future Improvements

- [ ] Add unit tests
- [ ] Add more filter options
- [ ] Implement search functionality
- [ ] Add offline support
- [ ] Implement UI tests
- [ ] Add localization

## Acknowledgments

- [Rick and Morty API](https://rickandmortyapi.com/) for providing the data
- [AlamofireImage](https://github.com/Alamofire/AlamofireImage) for image handling
