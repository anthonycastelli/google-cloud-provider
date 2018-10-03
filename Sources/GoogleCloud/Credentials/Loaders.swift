//
//  Loaders.swift
//  Async
//
//  Created by Brian Hatfield on 7/17/18.
//

import Foundation

enum CredentialLoadError: Error {
    case fileLoadError
    case noValidFileError
    case missingEnvironmentVariable
}

extension GoogleApplicationDefaultCredentials {
    init(contentsOfFile path: String) throws {
        let decoder = JSONDecoder()
        let filePath = NSString(string: path).expandingTildeInPath

        if let contents = try String(contentsOfFile: filePath).data(using: .utf8) {
            self = try decoder.decode(GoogleApplicationDefaultCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError
        }
    }
}

extension GoogleServiceAccountCredentials {
    init(contentsOfFile path: String) throws {
        let decoder = JSONDecoder()
        let filePath = NSString(string: path).expandingTildeInPath

        if let contents = try String(contentsOfFile: filePath).data(using: .utf8) {
            self = try decoder.decode(GoogleServiceAccountCredentials.self, from: contents)
        } else {
            throw CredentialLoadError.fileLoadError
        }
    }
    
    /*
    init(type: String, projectId: String, privateKeyId: String, privateKey: String, clientEmail: String, clientId: String, authUri: URL, tokenUri: URL, authProviderX509CertUrl: URL, clientX509CertUrl: URL) {
        self.type = type
        self.projectId = projectId
        self.privateKeyId = privateKeyId
        self.privateKey = privateKey
        self.clientEmail = clientEmail
        self.clientId = clientId
        self.authUri = authUri
        self.tokenUri = tokenUri
        self.authProviderX509CertUrl = authProviderX509CertUrl
        self.clientX509CertUrl = clientX509CertUrl
    }
    */
}
