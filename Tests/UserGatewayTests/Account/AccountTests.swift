import FeatherModuleKit
import UserGateway
import UserGatewayKit
import XCTest

final class AccountTests: TestCase {

    func testDetail() async throws {

        let email = "user1@example.com"

        _ = try await userModule.system.permission.create(
            .init(
                key: .init(rawValue: "manager.test.permission"),
                name: "manager.test.permission"
            )
        )
        let role = try await userModule.role.create(
            .init(
                key: .init(rawValue: "manager"),
                name: "Account manager",
                permissionKeys: [.init(rawValue: "manager.test.permission")]
            )
        )
        
        let account = try await userModule.account.create(
            .init(
                email: email,
                password: "ChangeMe1",
                firstName: "firstName",
                lastName: "lastName",
                imageKey: nil,
                roleKeys: [
                    .init(rawValue: "manager")
                ]
            )
        )

        let detail = try await module.account.require(account.id)
        
        print(detail)

        XCTAssertEqual(detail.roles.count, 1)
        XCTAssertEqual(detail.roles[0].key, role.key)
        XCTAssertEqual(detail.roles[0].name, role.name)
        XCTAssertEqual(detail.permissions.count, 1)
    }

}
