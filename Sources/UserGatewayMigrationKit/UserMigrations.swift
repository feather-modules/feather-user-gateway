import FeatherComponent
import FeatherDatabase
import FeatherScripts
import UserGatewayDatabaseKit
import UserGatewayKit

extension User {

    public enum Migrations {

        public enum V1: Script {

            public static func run(
                _ components: ComponentRegistry
            ) async throws {
            }
        }
    }

}
