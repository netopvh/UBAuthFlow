//
//  SignUpViewModel.swift
//  UBAuthFlow
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import Foundation
import UIKit

public class SignUpViewModel {
    
    public var profileImage: UIImage?
    public var name: String
    public var gender: String
    public var cpf: String
    public var email: String
    public var password: String
    public var phone: String
    public var indicationCode: String?
    public var enrollment: String?
    
    public init(profileImage: UIImage?,
                name: String,
                gender: String,
                cpf: String,
                email: String,
                password: String,
                phone: String,
                indicationCode: String? = nil,
                enrollment: String? = nil) {
        self.profileImage = profileImage
        self.name = name
        self.gender = gender
        self.cpf = cpf
        self.email = email
        self.password = password
        self.phone = phone
        self.indicationCode = indicationCode
        self.enrollment = enrollment
    }
    
    public func getJSON(profileImageLink: String, hasCheckCPF: Bool = false, minCharPhone: Int = 0) throws -> [String: Any] {
        
        let nameMinChar = 2
        let passwordMinChar = 6
        let phoneMinChar = minCharPhone == 0 ? 11 : minCharPhone
        if name.count < nameMinChar {
            throw CustomError("O nome deve conter ao menos \(nameMinChar) caracteres")
        }
        
        if hasCheckCPF{
            if !self.cpf.isValidCPF {
                throw CustomError("CPF inválido")
            }
        }
        if !self.email.isValidEmail {
            throw CustomError("Email inválido")
        }
        if self.password.count < passwordMinChar {
            throw CustomError("A senha deve conter ao menos \(passwordMinChar) caracteres")
        }
        if phone.count < phoneMinChar {
            throw CustomError("Telefone inválido")
        }
        if let indicationCode = self.indicationCode, indicationCode.isEmpty {
            throw CustomError("É necessário informar um código de indicação")
        }
        if let enrollment = self.enrollment, enrollment.isEmpty {
            throw CustomError("É necessário informar o número de matrícula")
        }
        let genderFirst = self.gender.first?.lowercased() ?? "o"
        let gender = genderFirst == "o" ? "other" : genderFirst
        
        var json: [String: Any] = ["name": self.name,
                                   "gender": gender,
                                   "cpf": self.cpf,
                                   "email": self.email,
                                   "phone": self.phone,
                                   "profileImage": profileImageLink,
                                   "password": self.password]
        if let indicationCode = self.indicationCode {
            json["code"] = indicationCode
        }
        if let enrollment = self.enrollment {
            json["enrollment"] = enrollment
        }
        return json
    }
    

}

public struct CustomError: LocalizedError {
    public var localizedDescription: String
    public init(_ message: String) {
        self.localizedDescription = message
    }
}
