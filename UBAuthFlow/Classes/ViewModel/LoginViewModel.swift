//
//  LoginViewModel.swift
//  UBAuthFlow
//
//  Created by Usemobile on 04/07/19.
//

import Foundation

public class LoginViewModel {
    
    public var email: String
    public var password: String
    public var gender: String?
    public var cpf: String?
    public var phone: String?
    public var name: String?
    public var profileImage: String?
    
    public var updateUser: Bool
    
    public init(email: String,
                password: String,
                gender: String? = nil,
                cpf: String? = nil,
                phone: String? = nil,
                name: String? = nil,
                profileImage: String? = nil,
                updateUser: Bool = false) {
        self.email = email
        self.password = password
        self.gender = (gender == nil || gender == "") ? nil : gender?.first?.lowercased() == "m" ? .male : .female
        self.cpf = cpf
        self.phone = phone
        self.name = name
        self.profileImage = profileImage
        self.updateUser = updateUser
    }
    
    public func getJSON() throws -> [String: Any] {
        let passwordMinChar = 6
        if !self.email.isValidEmail {
            throw CustomError("Email inválido")
        }
        if self.password.count < passwordMinChar {
            throw CustomError("A senha deve conter ao menos \(passwordMinChar) caracteres")
        }
        let json: [String: Any] = ["login": self.email,
                                   "password": self.password]
        return json
    }
    
    
}
