// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "feather-user-gateway",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(name: "UserGatewayKit", targets: ["UserGatewayKit"]),
        .library(name: "UserGatewayAccountsKit", targets: ["UserGatewayAccountsKit"]),
        .library(name: "UserGateway", targets: ["UserGateway"]),
        .library(name: "UserGatewayMigrationKit", targets: ["UserGatewayMigrationKit"]),
        .library(name: "UserGatewayDatabaseKit", targets: ["UserGatewayDatabaseKit"]),
        .executable(name: "UserGatewayOpenAPIGenerator", targets: ["UserGatewayOpenAPIGenerator"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.61.0"),
        .package(url: "https://github.com/binarybirds/swift-bcrypt", from: "1.0.2"),
        .package(url: "https://github.com/feather-framework/feather-database-driver-sqlite", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/feather-framework/feather-module-kit", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/feather-modules/feather-system-module", .upToNextMinor(from: "0.17.0")),
        .package(url: "https://github.com/feather-framework/feather-validation", .upToNextMinor(from: "0.1.1")),
        .package(url: "https://github.com/feather-framework/feather-access-control", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/feather-framework/feather-openapi-kit", .upToNextMinor(from: "0.9.2")),
        .package(url: "https://github.com/feather-framework/feather-api-kit", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/jpsim/Yams", from: "5.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        
        .package(url: "https://github.com/feather-modules/feather-user-api", branch: "fix/user-account-reference-image-key"),
//        .package(url: "https://github.com/feather-modules/feather-user-api", .upToNextMinor(from: "0.9.0")),
        .package(url: "https://github.com/feather-modules/feather-oauth-api", .upToNextMinor(from: "0.1.3")),
        .package(url: "https://github.com/feather-modules/feather-user-module", branch: "fix/user-account-reference-image-key"),
//        .package(url: "https://github.com/feather-modules/feather-user-module", .upToNextMinor(from: "0.22.0")),
        .package(url: "https://github.com/feather-modules/feather-oauth-module", .upToNextMinor(from: "0.1.0")),
        .package(url: "https://github.com/feather-modules/feather-user-gateway-accounts-api", .upToNextMinor(from: "0.1.4")),
    ],
    targets: [
        .target(
            name: "UserGatewayKit",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-module-kit"),
                .product(name: "FeatherACL", package: "feather-access-control"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
                .target(name: "UserGatewayAccountsKit"),
                .product(name: "UserModuleKit", package: "feather-user-module"),
                .product(name: "OauthModuleKit", package: "feather-oauth-module"),
            ]
        ),
        .target(
            name: "UserGatewayDatabaseKit",
            dependencies: [
                .target(name: "UserGatewayKit"),
            ]
        ),
        .target(
            name: "UserGateway",
            dependencies: [
                //.product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "FeatherValidationFoundation", package: "feather-validation"),
                .target(name: "UserGatewayDatabaseKit"),
                .product(name: "UserModuleKit", package: "feather-user-module"),
                .product(name: "OauthModuleKit", package: "feather-oauth-module"),
            ]
        ),

        .target(
            name: "UserGatewayMigrationKit",
            dependencies: [
                .product(name: "Bcrypt", package: "swift-bcrypt"),
                .product(name: "SystemModuleMigrationKit", package: "feather-system-module"),
                .target(name: "UserGatewayDatabaseKit"),
            ]
        ),

        .testTarget(
            name: "UserGatewayKitTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserGatewayKit")
            ]
        ),

        .testTarget(
            name: "UserGatewayTests",
            dependencies: [
                .product(name: "NIO", package: "swift-nio"),
                .target(name: "UserGateway"),
                .target(name: "UserGatewayMigrationKit"),
                .product(name: "UserModule", package: "feather-user-module"),
                .product(name: "UserModuleMigrationKit", package: "feather-user-module"),
                .product(name: "SystemModuleKit", package: "feather-system-module"),
                // drivers
                .product(name: "FeatherDatabaseDriverSQLite", package: "feather-database-driver-sqlite"),
            ]
        ),
        
        // MARK: - openapi
        
        .executableTarget(
            name: "UserGatewayOpenAPIGenerator",
            dependencies: [
                .product(name: "Yams", package: "Yams"),
                .product(name: "FeatherOpenAPIKit", package: "feather-openapi-kit"),
                .product(name: "FeatherAPIKit", package: "feather-api-kit"),
                .product(name: "UserAPIKit", package: "feather-user-api"),
                .product(name: "OauthAPIKit", package: "feather-oauth-api"),
                .product(name: "UserGatewayAccountsAPIKit", package: "feather-user-gateway-accounts-api"),
            ]
        ),
        
        .target(
            name: "UserGatewayAccountsKit",
            dependencies: [
                .product(name: "FeatherModuleKit", package: "feather-module-kit"),
                .product(name: "FeatherACL", package: "feather-access-control"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
            ],
            resources: [
                .copy("openapi-generator-config.yaml"),
                .copy("openapi.yaml"),
            ],
            plugins: [
                .plugin(name: "OpenAPIGenerator", package: "swift-openapi-generator")
            ]
        ),
    ]
)
