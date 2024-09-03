//
//  File.swift
//
//
//  Created by Tibor Bodecs on 16/02/2024.
//

import FeatherComponent
import FeatherScripts
import SystemModuleKit
import SystemModuleMigrationKit
import UserGatewayKit
import UserGatewayMigrationKit
import UserModuleKit
import UserModuleMigrationKit

extension ComponentRegistry {

    func runMigrations() async throws {

        let scripts = ScriptExecutor(
            components: self,
            policy: .runAll
        )

        try await scripts.execute([
            System.Migrations.V1.self,
            User.Migrations.V1.self,
            UserGateway.Migrations.V1.self,
        ])
    }
}
