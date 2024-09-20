import FeatherComponent
import FeatherModuleKit
import Foundation
import HTTPTypes
import Logging
import OpenAPIRuntime
import UserGatewayAccountsKit
import UserGatewayKit
import UserModuleKit

public struct UserGatewayClientInit {
    let serverURL: URL
    let configuration: Configuration
    let transport: any ClientTransport
    let middlewares: [any ClientMiddleware]

    public init(
        serverURL: URL,
        configuration: Configuration = .init(),
        transport: any ClientTransport,
        middlewares: [any ClientMiddleware] = []
    ) {
        self.serverURL = serverURL
        self.configuration = configuration
        self.transport = transport
        self.middlewares = middlewares
    }
}

public struct UserGatewayAccountInit {
    public struct Config {
        public init() {}
    }

    let accountClientInit: UserGatewayClientInit?
    let userModuleInit: UserModuleInterface?
    let config: Config

    public init(
        accountClientInit: UserGatewayClientInit,
        config: Config = .init()
    ) {
        self.accountClientInit = accountClientInit
        self.userModuleInit = nil
        self.config = config
    }

    public init(
        userModuleInit: UserModuleInterface,
        config: Config = .init()
    ) {
        self.accountClientInit = nil
        self.userModuleInit = userModuleInit
        self.config = config
    }
}

public struct UserGatewayOAuthInit {
    public struct Config {
        public init() {}
    }

    let oauthClientInit: UserGatewayClientInit?
    let config: Config

    public init(
        oauthClientInit: UserGatewayClientInit,
        config: Config = .init()
    ) {
        self.oauthClientInit = oauthClientInit
        self.config = config
    }

    public init(
        _: UserGateway.AlwaysThrowingGateway.Type,
        config: Config = .init()
    ) {
        self.oauthClientInit = nil
        self.config = config
    }
}

struct UserGatewayOAuthProxy: Sendable {
    let oauthClient: UserGatewayAccountsKit.Client?

    public init(
        oauthGatewayInit: UserGatewayOAuthInit
    ) {
        if let oauthClientInit = oauthGatewayInit.oauthClientInit {
            self.oauthClient = .init(
                serverURL: oauthClientInit.serverURL,
                //+ custom configuration
                configuration: oauthClientInit.configuration,
                transport: oauthClientInit.transport,
                //+ custom Middlewares
                middlewares: oauthClientInit.middlewares
            )
        }
        else {
            self.oauthClient = nil
        }
    }
}

struct UserGatewayAccountProxy: Sendable {
    let accountClient: UserGatewayAccountsKit.Client?
    let userModule: UserModuleInterface?

    public init(
        accountGatewayInit: UserGatewayAccountInit
    ) {
        if let accountClientInit = accountGatewayInit.accountClientInit {
            self.accountClient = .init(
                serverURL: accountClientInit.serverURL,
                //+ custom configuration
                configuration: accountClientInit.configuration,
                transport: accountClientInit.transport,
                //+ custom Middlewares
                middlewares: accountClientInit.middlewares
            )
        }
        else {
            self.accountClient = nil
        }

        if let userModule = accountGatewayInit.userModuleInit {
            self.userModule = userModule
        }
        else {
            self.userModule = nil
        }
    }
}

public struct UserGatewayModule: UserGatewayInterface {
    let components: ComponentRegistry
    let logger: Logger
    let accountProxy: UserGatewayAccountProxy
    let oauthProxy: UserGatewayOAuthProxy

    static func throwResponse(
        _ status: HTTPResponse.Status,
        _ encodable: Encodable
    ) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [
            .sortedKeys
        ]
        let data = try encoder.encode(encodable)

        throw UserGateway.Error.httpResponse(
            .init(
                status: status,
                headerFields: [
                    .contentType: "application/json; charset=utf-8"
                ]
            ),
            .init([UInt8](data))
        )
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreBadRequest
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.badRequest, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreConflict
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.conflict, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreForbidden
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.forbidden, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreGone
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.gone, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreMethodNotAllowed
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.methodNotAllowed, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreNotAcceptable
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.notAcceptable, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreNotFound
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.notFound, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreUnauthorized
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.unauthorized, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreUnprocessableContent
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.unprocessableContent, content)
        }
    }

    static func throwResponse(
        _ error: Components.Responses.FeatherCoreUnsupportedMediaType
    ) throws {
        switch error.body {
        case .json(let content):
            try throwResponse(.unsupportedMediaType, content)
        }
    }

    static func throwResponse(
        _ statusCode: Int,
        _ payload: OpenAPIRuntime.UndocumentedPayload
    ) throws {
        throw UserGateway.Error.httpResponse(
            HTTPResponse(
                status: .init(code: statusCode),
                headerFields: payload.headerFields
            ),
            payload.body
        )
    }

    public init(
        components: ComponentRegistry,
        accountGatewayInit: UserGatewayAccountInit,
        oauthGatewayInit: UserGatewayOAuthInit,
        logger: Logger = .init(label: "user-gateway")
    ) {
        self.components = components
        self.logger = logger
        self.accountProxy = .init(accountGatewayInit: accountGatewayInit)
        self.oauthProxy = .init(oauthGatewayInit: oauthGatewayInit)
    }

    public var account: UserGatewayKit.UserGatewayAccountInterface {
        if let accountClient = accountProxy.accountClient {
            return AccountController(
                components: components,
                user: self,
                accountClient: accountClient
            )
        }

        return AccountControllerLocal(
            components: components,
            user: self,
            userModule: accountProxy.userModule!
        )
    }

    public var oauth: UserGatewayKit.UserGatewayOAuthInterface {
        if let oauthClient = oauthProxy.oauthClient {
            return OAuthController(
                components: components,
                user: self,
                oauthClient: oauthClient
            )
        }

        return OAuthControllerLocal(
            components: components,
            user: self
        )
    }
}
