import FeatherComponent
import FeatherModuleKit
import Foundation
import Logging
import OpenAPIRuntime
import SystemModuleKit
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
                configuration: oauthClientInit.configuration,  //+ custom configuration
                transport: oauthClientInit.transport,
                middlewares: oauthClientInit.middlewares  //+ custom Middlewares
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
                configuration: accountClientInit.configuration,  //+ custom configuration
                transport: accountClientInit.transport,
                middlewares: accountClientInit.middlewares  //+ custom Middlewares
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
    public let system: SystemModuleInterface
    let components: ComponentRegistry
    let logger: Logger
    let accountProxy: UserGatewayAccountProxy
    let oauthProxy: UserGatewayOAuthProxy

    public init(
        system: SystemModuleInterface,
        components: ComponentRegistry,
        accountGatewayInit: UserGatewayAccountInit,
        oauthGatewayInit: UserGatewayOAuthInit,
        logger: Logger = .init(label: "user-gateway")
    ) {
        self.system = system
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
