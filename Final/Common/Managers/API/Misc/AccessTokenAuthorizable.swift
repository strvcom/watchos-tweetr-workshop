//
//  AccessTokenAuthorizable.swift
//  Tweetr Watch WatchKit Extension
//
//  Created by Nick Beresnev on 11/15/21.
//

import CryptoKit
import Foundation

protocol AccessTokenAuthorizable {
    var authorizationType: AuthorizationType? { get }

    func getAuthenticationHeader(token: String?, tokenSecret: String?) throws -> String?
}

extension AccessTokenAuthorizable where Self: Router {
    func getAuthenticationHeader(token: String?, tokenSecret: String? = nil) throws -> String? {
        var params = [
            "oauth_consumer_key": Constants.Authentication.consumerKey,
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": Int(Date().timeIntervalSince1970),
            "oauth_nonce": UUID().uuidString,
            "oauth_version": "1.0"
        ] as [String: Any]

        if let token = token {
            params["oauth_token"] = token
        }

        if let urlParams = urlParameters {
            params.merge(urlParams) { current, _ in current }
        }

        let sign = try getOauthSignature(
            httpMethod: method.rawValue,
            params: params,
            oauthTokenSecret: tokenSecret
        )

        params["oauth_signature"] = sign

        return getAuthorizationHeader(params: params)
    }
}

// MARK: - Private helpers
private extension AccessTokenAuthorizable where Self: Router {
    func getAuthorizationHeader(params: [String: Any]) -> String? {
        let parts: [String] = params.map { key, value in
            let stringValue = String(describing: value)

            return "\(key.urlEncoded)=\(stringValue.urlEncoded)"
        }

        guard let authorizationType = authorizationType?.value else {
            return nil
        }

        return authorizationType + " " + parts.sorted().joined(separator: ", ")
    }

    func signatureKey(oauthTokenSecret: String?) -> String {
        let tokenSecret = oauthTokenSecret?.urlEncoded ?? ""

        return Constants.Authentication.consumerSecret + "&" + tokenSecret
    }

    func getSignatureBaseString(
        httpMethod: String = HTTPMethod.post.rawValue,
        url: String,
        params: [String: Any]
    ) -> String {
        let parameterString = getSignatureParameterString(params: params)
        return httpMethod + "&" + url.urlEncoded + "&" + parameterString.urlEncoded
    }

    func getSignatureParameterString(params: [String: Any]) -> String {
        let result: [String] = params.map { key, value in
            let stringValue = String(describing: value)

            return "\(key.urlEncoded)=\(stringValue.urlEncoded)"
        }

        return result.sorted().joined(separator: "&")
    }

    func getOauthSignature(
        httpMethod: String = HTTPMethod.post.rawValue,
        params: [String: Any],
        oauthTokenSecret: String? = nil
    ) throws -> String {
        let signingKey = signatureKey(oauthTokenSecret: oauthTokenSecret)
        let signatureBase = getSignatureBaseString(
            httpMethod: httpMethod,
            url: baseURL.appendingPathComponent(path).absoluteString,
            params: params
        )

        return try hmac_sha1(signingKey: signingKey, signatureBase: signatureBase)
    }

    func hmac_sha1(signingKey: String, signatureBase: String) throws -> String {
        guard
            let signingKeyData = signingKey.data(using: .utf8),
            let signatureBaseData = signatureBase.data(using: .utf8)
        else {
            throw APIError.encryptionFailed
        }

        let key = SymmetricKey(data: signingKeyData)
        var hmac: HMAC<Insecure.SHA1> = HMAC(key: key)
        hmac.update(data: signatureBaseData)
        let mac = hmac.finalize()
        let data = Data(mac.map { $0 })

        return data.base64EncodedString()
    }
}
