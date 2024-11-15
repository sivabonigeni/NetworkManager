# NetworkManager

A Swift package that provides an easy-to-use, flexible networking solution for making HTTP requests with customizable configurations. The package uses `Combine` for reactive programming and integrates with your app's network environment, headers, timeout settings, and retry policies.

## Features

- **Network Configuration**: Easily configurable environment (base URL), headers, timeout, and retry policies.
- **HTTP Request Handling**: Supports GET, POST, PUT, and DELETE methods with automatic request handling.
- **Error Handling**: Provides structured error handling for common network errors.
- **Decodable Responses**: Supports decoding responses directly into Swift models using `Decodable`.
- **Flexible Environment Support**: Allows setting and updating environments (e.g., development, staging, production).

## Installation

To integrate `NetworkManager` into your Xcode project, follow these steps:

### Using Swift Package Manager (SPM)

1. Open Xcode and go to `File` > `Add Packages...`.
2. Enter the repository URL for this package.
3. Select the version you wish to install (usually the latest version).
4. Add the package to your project.

Alternatively, if you are manually using Swift Package Manager, add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/NetworkManager.git", from: "1.0.0")
]
