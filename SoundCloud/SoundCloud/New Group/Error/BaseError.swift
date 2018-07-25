//
//  BaseError.swift
//  SoundCloud
//
//  Created by Can Khac Nguyen on 7/25/18.
//  Copyright © 2018 Do Hung. All rights reserved.
//

import Foundation

enum BaseError: Error {
    case networkError
    case httpError(httpCode: Int)
    case unexpectedError
    case apiFailure(error: ErrorResponse?)
    private struct StatusMessage {
        static let networkError = "Network Error"
        static let unexpectedError = "Unexpected Error"
        static let information = "Information"
        static let success = "Success"
        static let redirection = "Redirection"
        static let clientError = "Client Error"
        static let serverError = "Server Error"
        static let undefined = "Undefined"
    }
    
    public var errorMessage: String? {
        switch self {
        case .networkError:
            return StatusMessage.networkError
        case .httpError(let code):
            return getHttpErrorMessage(httpCode: code)
        case .apiFailure(let error):
            return error?.message
        default:
            return StatusMessage.unexpectedError
        }
    }
    
    private func getHttpErrorMessage(httpCode: Int) -> String? {
        guard let responseType = HTTPStatusCode(rawValue: httpCode)?.responseType else {
            return StatusMessage.unexpectedError
        }
        switch responseType {
        case .informational:
            return StatusMessage.information
        case .success:
            return StatusMessage.success
        case .redirection:
            return StatusMessage.redirection
        case .clientError:
            return StatusMessage.clientError
        case .serverError:
            return StatusMessage.serverError
        default:
            return StatusMessage.undefined
        }
    }
}
