//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherModuleKit
import NIO
import SystemModule
import UserGateway
import UserGatewayKit
import UserGatewayMigrationKit
import UserModule
import UserModuleKit
import XCTest

class TestCase: XCTestCase {

    var eventLoopGroup: EventLoopGroup!
    var components: ComponentRegistry!
    var userModule: UserModuleInterface!
    var module: UserGatewayInterface!

    override func setUp() async throws {
        self.eventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        components = ComponentRegistry()

        let system = SystemModule(components: components)

        userModule = UserModule(system: system, components: components)

        module = UserGatewayModule(
            components: components,
            accountGatewayInit: .init(userModuleInit: userModule),
            oauthGatewayInit: .init(UserGateway.AlwaysThrowingGateway.self)
        )

        try await components.configure(.singleton, eventLoopGroup)
        try await components.runMigrations()
    }

    override func tearDown() async throws {
        try await self.eventLoopGroup.shutdownGracefully()
    }
}
