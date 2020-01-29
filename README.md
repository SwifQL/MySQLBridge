<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
    <img src="https://img.shields.io/github/workflow/status/SwifQL/MySQLBridge/test" alt="Github Actions">
</p>

# Bridge to MySQL

Work with MySQL with SwifQL through its pure NIO driver.

## Installation

```swift
.package(url: "https://github.com/SwifQL/MySQLBridge.git", from:"1.0.0-beta.1"),
.package(url: "https://github.com/SwifQL/VaporBridges.git", from:"1.0.0-beta.1"),
.target(name: "App", dependencies: ["Vapor", "MySQLBridge", "VaporBridges"]),
```

For more info please take a look at the `Bridges` repo.
