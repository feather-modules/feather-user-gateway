import FeatherAPIKit
import FeatherOpenAPIKit
import Foundation
import OauthAPIKit
import OpenAPIKit
import SystemAPIKit
import UserAPIKit
import UserGatewayAccountsAPIKit

let components: [Component.Type] =
    [
        Feather.Core.self,

        System.Permission.Schemas.self,

        User.Account.Schemas.self,
        User.Account.Parameters.self,
        User.Account.Responses.self,
        User.Role.Schemas.self,

        UserGateway.self,
        Oauth.self,
    ]

let documents: [OpenAPIDocument] = [
    .init(
        title: "UserGateway - Accounts - API",
        description:
            "The complete Accounts API definition used by the UserGateway.",
        path: "openapi-accounts",
        kitPath: "UserGatewayAccountsKit",
        components: components
    )
]

struct OpenAPIDocument: Document {

    let title: String
    let description: String
    let path: String
    let kitPath: String

    let components: [Component.Type]

    func openAPIDocument() throws -> OpenAPI.Document {
        let dateString = DateFormatter.localizedString(
            from: Date(),
            dateStyle: .medium,
            timeStyle: .medium
        )

        return try composedDocument(
            info: .init(
                title: title,
                description: """
                    \(description)
                    (Generated on: \(dateString))
                    """,
                contact: .init(
                    name: "Binary Birds",
                    url: .init(string: "https://binarybirds.com")!,
                    email: "info@binarybirds.com"
                ),
                version: "1.0.0"
            ),
            servers: []
        )
    }
}
