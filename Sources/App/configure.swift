import Fluent
import FluentPostgresDriver
import Vapor
import JWT

extension String{
    var bytes:[UInt8] { .init(self.utf8) }
}

extension JWKIdentifier{
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    print(app.directory.publicDirectory) //print public path
    app.http.server.configuration.port = 8080
    app.databases.use(.postgres(hostname: "localhost" ,username: "postgres",password:"",database:"TMDB"), as: .psql)

    //terminal: vapor run migrate
    app.migrations.add(CreateUser())
    app.migrations.add(CreateArticle())
    app.migrations.add(CreateComment())
    app.migrations.add(CreateList())
    app.migrations.add(CreateListMovie())
    app.migrations.add(CreateLikeMovie())
    app.migrations.add(CreateLikeArticle())

    
    
    //JWT private key
    let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key")
    let privateSigner = try JWTSigner.rs256(key: .private(pem:privateKey.bytes))
    //JWT public key
    let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "myjwt.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem:publicKey.bytes))
    
    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)
    
    // register routes
    try routes(app)
}
