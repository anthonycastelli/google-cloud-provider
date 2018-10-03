//
//  OAuthCredentialLoader.swift
//  GoogleCloudProvider
//
//  Created by Brian Hatfield on 7/19/18.
//

import Vapor

public class OAuthCredentialLoader {
    public static let defaultScope = [StorageScope.fullControl]
    
    public static func getRefreshableToken(credentialFilePath: String, withClient client: Client) throws -> OAuthRefreshable {
        if let credentials = try? GoogleServiceAccountCredentials(contentsOfFile: credentialFilePath) {
            return OAuthServiceAccount(credentials: credentials, scopes: defaultScope, httpClient: client)
        }

        if let credentials = try? GoogleApplicationDefaultCredentials(contentsOfFile: credentialFilePath) {
            return OAuthApplicationDefault(credentials: credentials, httpClient: client)
        }
        
        return try OAuthCredentialLoader.getRefreshableToken(withClient: client)
    }
    
    public static func getRefreshableToken(withClient client: Client) throws -> OAuthRefreshable {
        let environment = ProcessInfo.processInfo.environment
        guard let type = environment["GOOGLE_TYPE"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let projectId = environment["GOOGLE_PROJECT_ID"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let privateKeyId = environment["GOOGLE_PRIVATE_KEY_ID"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let privateKey = environment["GOOGLE_PRIVATE_KEY"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let clientEmail = environment["GOOGLE_CLIENT_EMAIL"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let clientId = environment["GOOGLE_CLIENT_ID"] else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let authUriString = environment["GOOGLE_AUTH_URI"], let authUri = URL(string: authUriString) else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let tokenUriString = environment["GOOGLE_TOKEN_URI"], let tokenUri = URL(string: tokenUriString) else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let authProviderX509CertUrlString = environment["GOOGLE_AUTH_PROVIDER_X509_URL"], let authProviderX509CertUrl = URL(string: authProviderX509CertUrlString) else { throw CredentialLoadError.missingEnvironmentVariable }
        guard let clientX509CertUrlString = environment["GOOGLE_CLIENT_X509_URL"], let clientX509CertUrl = URL(string: clientX509CertUrlString) else { throw CredentialLoadError.missingEnvironmentVariable }
        let credentials = GoogleServiceAccountCredentials(
            type: type,
            projectId: projectId,
            privateKeyId: privateKeyId,
            privateKey: privateKey,
            clientEmail: clientEmail,
            clientId: clientId,
            authUri: authUri,
            tokenUri: tokenUri,
            authProviderX509CertUrl: authProviderX509CertUrl,
            clientX509CertUrl: clientX509CertUrl
        )
        return OAuthServiceAccount(credentials: credentials, scopes: defaultScope, httpClient: client)
    }
}
