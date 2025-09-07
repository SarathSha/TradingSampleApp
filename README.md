# Trading Sample App

A modern iOS application built with Swift that displays stock portfolio holdings and calculates real-time P&L. The app demonstrates clean architecture principles with MVVM pattern, featuring offline-first data management and comprehensive testing.

## 📸 Screenshots

### Portfolio Overview
<img width="1125" height="2436" alt="IMG_0154 2" src="https://github.com/user-attachments/assets/0d5ffb91-a7be-4990-ae24-5d832cc71ee9" />
*Main portfolio screen showing individual stock holdings with real-time P&L calculations*

### Portfolio Summary
<img width="1125" height="2436" alt="IMG_0155 2" src="https://github.com/user-attachments/assets/792896a6-4b55-495a-923f-0b7d194d2a12" />
*Bottom summary bar displaying total portfolio value and overall P&L performance*

### Loading State
<img width="1125" height="2436" alt="IMG_0158 2" src="https://github.com/user-attachments/assets/45044fa1-f77a-498a-8a43-0073624f6523" />
*App loading state with spinner indicator while fetching data*

### Error Handling
<img width="1125" height="2436" alt="IMG_0157 2" src="https://github.com/user-attachments/assets/7b082384-3521-4616-8639-9e1b364ffe89" />
*Graceful error handling with retry functionality when network requests fail*

### Code Coverage
<img width="1440" height="900" alt="Screenshot 2025-09-07 at 10 30 43 PM" src="https://github.com/user-attachments/assets/b064b0b0-20cb-43ae-8420-0741813122a3" />
all functional cases covered
## 📱 Overview

This trading app provides users with a clean interface to view their stock holdings, track portfolio performance, and monitor daily P&L changes. The app fetches data from a REST API and caches it locally for offline access, ensuring a smooth user experience even without internet connectivity.

## 🏗️ Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture combined with **Clean Architecture** principles:

- **Presentation Layer**: ViewControllers, Views, and ViewModels
- **Domain Layer**: Business logic, use cases, and domain models
- **Data Layer**: Repository pattern with local and remote data sources

### Key Architectural Patterns

- **Repository Pattern**: Abstracts data access with `HoldingsRepository`
- **Dependency Injection**: Protocol-based dependencies for testability
- **Observer Pattern**: ViewModels notify views of state changes
- **Strategy Pattern**: Different calculation strategies for portfolio metrics

## 🛠️ Technologies & Frameworks

### Core Technologies
- **Swift 5.9+** - Primary programming language
- **UIKit** - User interface framework
- **Core Data** - Local data persistence
- **URLSession** - Network communication

### Architecture & Design
- **MVVM Pattern** - Separation of concerns
- **Protocol-Oriented Programming** - Testable and maintainable code
- **Async/Await** - Modern concurrency handling
- **Combine** - Reactive programming (where applicable)

### Testing
- **XCTest** - Unit testing framework
- **Mock Objects** - Isolated testing of components
- **Test Doubles** - Repository and service mocking

### Development Tools
- **Xcode 15+** - IDE and build system
- **Swift Package Manager** - Dependency management
- **Core Data Model Editor** - Data modeling

## 📁 Project Structure

```
TradingSampleApp/
├── Core/                           # Core infrastructure
│   ├── CoreData/
│   │   ├── CoreDataStack.swift     # Core Data setup and management
│   │   └── HoldingsLocalDataSource.swift # Local data operations
│   ├── Extensions/
│   │   ├── UIColor+Extensions.swift
│   │   ├── UIFont+Extensions.swift
│   │   └── UIView+Extensions.swift
│   └── Services/
│       ├── ModulesServices/
│       │   ├── EndPoints/
│       │   │   └── HoldingsEndPoint.swift
│       │   └── HoldingService.swift
│       └── NetworkManager/
│           ├── Endpoint.swift
│           ├── HTTPClient.swift
│           └── NetworkError.swift
├── Features/                       # Feature-based modules
│   ├── Holdings/                   # Holdings feature module
│   │   ├── Model/
│   │   │   ├── HoldingsModels.swift
│   │   │   └── HoldingsViewState.swift
│   │   ├── Repository/
│   │   │   ├── HoldingRepositoryProtocol.swift
│   │   │   └── HoldingsRepository.swift
│   │   ├── View/
│   │   │   ├── Cell/
│   │   │   │   └── HoldingsTableViewCell.swift
│   │   │   ├── HoldingsErrorView.swift
│   │   │   └── HoldingsViewController.swift
│   │   └── ViewModel/
│   │       ├── HoldingsViewModel.swift
│   │       └── HoldingViewModelProtocol.swift
│   └── Portfolio/                  # Portfolio feature module
│       ├── Model/
│       │   ├── PortfolioCalculator.swift
│       │   └── PortfolioModels.swift
│       ├── View/
│       │   └── PortfolioSummaryView.swift
│       └── ViewModel/
│           ├── PortfolioViewModel.swift
│           └── PortfolioViewModelProtocol.swift
├── Resources/
│   └── Constants/
│       └── AppConstants.swift
├── AppDelegate.swift
├── SceneDelegate.swift
└── Info.plist
```

## 🔧 Key Components

### Data Flow
1. **View** → **ViewModel** → **Repository** → **Service/DataSource**
2. **ViewModel** updates **View** through state changes
3. **Repository** manages data from both API and local storage

### Core Features

#### Holdings Management
- Fetch holdings from REST API
- Cache data locally using Core Data
- Offline-first approach with fallback to cached data
- Real-time P&L calculations

#### Portfolio Summary
- Current portfolio value calculation
- Total investment tracking
- Overall P&L with percentage
- Today's P&L calculation

#### Error Handling
- Network error management
- Graceful fallback to cached data
- User-friendly error messages
- Retry mechanisms

### Data Models

#### API Response Models
```swift
struct HoldingsAPIResponse: Codable {
    let symbol: String
    let quantity: Int
    let avgPrice: Double
    let ltp: Double
    let close: Double
}
```

#### Display Models
```swift
struct HoldingsDisplayModel: Equatable {
    let symbol: String
    let quantity: Int
    let lastTradedPrice: Double
    let averagePrice: Double
    let currentValue: Double
    let totalInvestment: Double
    let pnl: Double
    let todaysPnl: Double
    let pnlPercentage: Double
    let isProfit: Bool
    let isTodaysProfit: Bool
}
```

## 🧪 Testing Strategy

The app includes comprehensive unit tests covering:

- **ViewModel Logic**: State management and business logic
- **Repository Pattern**: Data fetching and caching
- **Portfolio Calculations**: P&L and value calculations
- **Error Handling**: Network and data errors
- **Functional Tests**: Complete user workflows and edge cases

### Test Coverage
- **Code Coverage**: 75% overall coverage
- **Functional Tests**: All critical user journeys tested
- **Unit Tests**: Core business logic and data layer
- **Integration Tests**: Repository and service interactions

### Test Structure
```
TradingSampleAppTests/
├── HoldingsViewModelTest.swift
├── PortfolioCalculatorTests.swift
├── PortfolioViewModelTest.swift
├── TradingSampleAppTests.swift
└── Mock/
    ├── MockHoldingRepository.swift
    └── MockPortfolioCalculator.swift
```

## 🚀 Getting Started

### Prerequisites
- Xcode 16.0 or later
- iOS 15.0 or later
- Swift 5.9 or later

### Installation
1. Clone the repository
2. Open `TradingSampleApp.xcodeproj` in Xcode
3. Build and run the project

### Configuration
- Update API endpoints in `HoldingsEndPoint.swift`
- Configure Core Data model if needed
- Adjust UI constants in `AppConstants.swift`

## 📊 Performance Considerations

- **Memory Management**: Weak references to prevent retain cycles
- **Background Processing**: Core Data operations on background contexts
- **Image Caching**: Efficient cell reuse in table views
- **Network Optimization**: Single API call with local caching

## 🔒 Security Features

- **Data Validation**: Input sanitization and validation
- **Secure Storage**: Core Data for sensitive financial data
- **Error Handling**: No sensitive data in error messages

## 🎯 Future Enhancements

- Real-time price updates
- Push notifications for price alerts
- Advanced charting capabilities
- Multiple portfolio support
- Dark mode optimization

## 📝 Development Notes

This project demonstrates several iOS development best practices:

- **Clean Architecture**: Separation of concerns with clear boundaries
- **Protocol-Oriented Design**: Highly testable and maintainable code
- **Modern Swift**: Async/await, proper error handling, and type safety
- **User Experience**: Offline-first approach with smooth state management
- **Testing**: Comprehensive test coverage with proper mocking

The codebase is structured to be easily maintainable, testable, and scalable for future feature additions.
