# Bridge to MySQL

Work with MySQL with SwifQL through its pure NIO driver.

## Installation

```swift
.package(url: "https://github.com/SwifQL/MySQLBridge.git", from:"1.0.0-beta.1"),
.package(url: "https://github.com/SwifQL/VaporBridges.git", from:"1.0.0-beta.1"),
.target(name: "App", dependencies: ["Vapor", "MySQLBridge", "VaporBridges"]),
```

For more info please take a look at the `Bridges` repo.
