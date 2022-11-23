//
//  User.swift
//  WeRemember
//
//  Created by Alice on 2022/11/23.
//

import Foundation

struct UserBody: Encodable {
    let user: User
}

struct User: Encodable {
    let login: String
    let password: String
    var email: String?
}

struct UserResponse: Decodable {
    let userToken: String
    let login: String
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case userToken = "User-Token"
        case login
        case email
    }
    
}
