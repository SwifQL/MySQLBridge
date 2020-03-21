<p align="center">
    <a href="LICENSE">
        <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://swift.org">
        <img src="https://img.shields.io/badge/swift-5.2-brightgreen.svg" alt="Swift 5.2">
    </a>
    <img src="https://img.shields.io/github/workflow/status/SwifQL/MySQLBridge/test" alt="Github Actions">
    <a href="https://discord.gg/q5wCPYv">
        <img src="https://img.shields.io/badge/CLICK_HERE_TO_DISCUSS_THIS_LIB-SWIFT.STREAM-FD6F32.svg" alt="Swift.Stream">
    </a>
</p>

# Bridge to MySQL

Work with MySQL with SwifQL through its pure NIO driver.

## Installation

```swift
.package(url: "https://github.com/SwifQL/MySQLBridge.git", from:"1.0.0-rc"),
.package(url: "https://github.com/SwifQL/VaporBridges.git", from:"1.0.0-rc"),
.target(name: "App", dependencies: [
    .product(name: "Vapor", package: "vapor"),
    .product(name: "MySQLBridge", package: "MySQLBridge"),
    .product(name: "VaporBridges", package: "VaporBridges")
]),
```

For more info please take a look at the `Bridges` repo.
