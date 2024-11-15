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
```

# Usage

Initialize the NetworkManager

First, create a NetworkManager instance by providing a NetworkConfiguration with a specific environment and headers.

```import NetworkManager

// Define your environment provider
struct MyEnvironment: NetworkEnvironmentProvider {
    var baseURL: String {
        return "https://api.example.com"
    }
}

// Define your headers provider
class MyHeaders: NetworkHeadersProvider {
    var defaultHeaders: [String: String] {
        return ["Content-Type": "application/json"]
    }

    func updateHeader(key: String, value: String) {
        defaultHeaders[key] = value
    }

    func removeHeader(key: String) {
        defaultHeaders.removeValue(forKey: key)
    }
}

// Create network configuration
let environment = MyEnvironment()
let headers = MyHeaders()
let networkConfiguration = NetworkConfiguration(
    environment: environment,
    headers: headers
)

// Initialize the NetworkManager with configuration
let networkManager = NetworkManager(networkConfiguration: networkConfiguration)
```

# Make a Request

You can now use the NetworkManager to make requests. Here's an example of how to make a GET request to fetch a profile:

```swift
import NetworkManager
import Combine

class ProfileWorker {
    let networkManager: NetworkManager
    private var cancellables = Set<AnyCancellable>()

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    func getProfile(id: String) {
        let endPoint = ProfileEndPoint.getProfile(id: id)

        networkManager.request(endPoint: endPoint)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finished")
                case .failure(let error):
                    print("Error: \(error)")
                }
            } receiveValue: { (profile: Profile) in
                print("Received profile: \(profile.name)")
            }.store(in: &cancellables)
    }
}

struct Profile: Decodable {
    let name: String
}
```
