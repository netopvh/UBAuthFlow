//
//  Strings.swift
//  UBAuthFlow
//
//  Created by Tulio Parreiras on 20/05/19.
//  Copyright (c) 2019 Usemobile. All rights reserved.
//

import Foundation

extension String {
    
    static var signUp: String {
        switch currentLanguage {
        case .en:
            return "Sign Up"
        case .pt:
            return "Cadastre-se"
        case .es:
            return "Registrarse"
        }

    }
    
    static var hasAccount: String {
        switch currentLanguage {
        case .en:
            return "Already has an account?"
        case .pt:
            return "Já possui uma conta?"
        case .es:
            return "¿Ya tienes una cuenta?"
        }

    }
    
    static var signIn: String {
        switch currentLanguage {
        case .en:
            return " Sign in "
        case .pt:
            return " Faça Login "
        case .es:
            return "iniciar sesión"
        }

    }
    
    static var email: String {
        switch currentLanguage {
        case .en:
            return "Email"
        case .pt:
            return "E-mail"
        case .es:
            return "Email"
        }

    }
    
    static var password: String {
        switch currentLanguage {
        case .en:
            return "Password"
        case .pt:
            return "Senha"
        case .es:
            return "contraseña"
        }

    }
    
    static var login: String {
        switch currentLanguage {
        case .en:
            return "Login"
        case .pt:
            return "Entrar"
        case .es:
            return "Entrar"
        }

    }
    
    static var forgotPassword: String {
        switch currentLanguage {
        case .en:
            return "Forgot password"
        case .pt:
            return "Esqueci minha senha"
        case .es:
            return "olvide mi contraseña"
        }

    }
    
    static var applyYour: String {
        switch currentLanguage {
        case .en:
            return "Apply your "
        case .pt:
            return "Faça seu "
             case .es:
                    return "haz tu "
                }
            }
            
    static var takePicture: String {
        switch currentLanguage {
        case .en:
            return "Take picture"
        case .pt:
            return "Tirar foto"
        case .es:
            return "Tomar la foto"
        }
    }
    
    static var chooseLibrary: String {
        switch currentLanguage {
        case .en:
            return "Choose from library"
        case .pt:
            return "Escolher da biblioteca"
        case .es:
            return "Elige de la biblioteca"
        }
    }

    
    static var registration: String {
        switch currentLanguage {
        case .en:
            return "registration"
        case .pt:
            return "cadastro"
        case .es:
            return "registro"
        }
    }
            
    static var selectImage: String {
        switch currentLanguage {
        case .en:
            return "Select an image"
        case .pt:
            return "Selecionar uma foto"
        case .es:
            return "Selecciona una foto"
        }
    }

    
    static var name: String {
        switch currentLanguage {
        case .en:
            return "Name"
        case .pt:
            return "Nome"
        case .es:
            return "Nombre"
        }
    }
    
    static var gender: String {
        switch currentLanguage {
        case .en:
            return "Gender"
        case .pt:
            return "Gênero"
        case .es:
            return "Género"
        }
    }
    
    static var cpf: String {
        switch currentLanguage {
        case .en:
            return "CPF"
        case .pt:
            return "CPF"
        case .es:
            return "CI"
        }
    }
    
    static var phone: String {
        switch currentLanguage {
        case .en:
            return "Phone"
        case .pt:
            return "Celular"
        case .es:
            return "Móvil"
        }
    }
    
    static var indicationCode: String {
        switch currentLanguage {
        case .en:
            return "Indication code"
        case .pt:
            return "Código de indicação"
        case .es:
            return "Código de indication"
        }
    }
    
    static var optional: String {
        switch currentLanguage {
        case .en:
            return " (Optional)"
        case .pt:
            return " (Opcional)"
        case .es:
            return " (Opcionales)"
        }

    }
    
    static var registrate: String {
        switch currentLanguage {
        case .en:
            return "Sign Up"
        case .pt:
            return "Cadastrar"
        case .es:
            return "Registrarse"
        }

    }
    
    static var save: String {
        switch currentLanguage {
        case .en:
            return "Save"
        case .pt:
            return "Salvar"
        case .es:
            return "Guardar"
        }

    }
    
    static var checkOur: String {
        switch currentLanguage {
        case .en:
            return "Check our "
        case .pt:
            return "Confira nossos "
        case .es:
            return "Consulta nuestros "
        }
    }
    
    static var terms: String {
        switch currentLanguage {
        case .en:
            return "Terms"
        case .pt:
            return "Termos de Uso"
        case .es:
            return "Términos de uso"
        }

    }
    
    static var male: String {
        switch currentLanguage {
        case .en:
            return "Male"
        case .pt:
            return "Masculino"
        case .es:
            return "Masculino"
        }
    }
    
    static var female: String {
        switch currentLanguage {
        case .en:
            return "Female"
        case .pt:
            return "Feminino"
        case .es:
            return "Femenino"
        }
    }
    
    static var other: String {
        switch currentLanguage {
        case .en:
            return "Other"
        case .pt:
            return "Outro"
        case .es:
            return "Otro"
        }
    }
    
    static var enterEmail: String {
        switch currentLanguage {
        case .en:
            return "Enter your email address"
        case .pt:
            return """
            Informe o email
            cadastrado
            """
        case .es:
            return """
            Ingrese el email
            registrado
            """
        }

    }
    
    static var recover: String {
        switch currentLanguage {
        case .en:
            return "Recover"
        case .pt:
            return "Recuperar"
        case .es:
            return "Recuperar"
        }
    }
    
    static var confirmNumber: String {
        switch currentLanguage {
        case .en:
            return "Confirm your "
        case .pt:
            return "Confirme seu "
        case .es:
            return "Confirma tu "
        }
    }
    
    static var fillYourPhone: String {
        switch currentLanguage {
        case .en:
            return "Fill with the code sent to your cell phone"
        case .pt:
            return "Preencha com o código que enviamos no seu celular"
        case .es:
            return "Complete el código que enviamos en su teléfono móvil"
        }

    }
    
    static var resendCode: String {
        switch currentLanguage {
        case .en:
            return "Resend code"
        case .pt:
            return "Reenviar código"
        case .es:
            return "Reenviar código"
        }
    }
    
    static var resendMessage: String {
        switch currentLanguage {
        case .en:
            return "Resend code within "
        case .pt:
            return "Reenviar código em "
        case .es:
            return "Reenviar código en "
        }
    }
    
    static var seconds: String {
        switch currentLanguage {
        case .en:
            return " seconds"
        case .pt:
            return " segundos"
        case .es:
            return " segundos"
        }
    }
    
    static var logOut: String {
        switch currentLanguage {
        case .en:
            return "Logout"
        case .pt:
            return "Sair"
        case .es:
            return "Salir"
        }
    }
    
    static var confirm: String {
        switch currentLanguage {
        case .en:
            return "Confirm"
        case .pt:
            return "Confirmar"
        case .es:
            return "Confirmar"
        }
    }
    
    static var didntReceiveSMS: String {
        switch currentLanguage {
        case .en:
            return "Didn't received the SMS code?"
        case .pt:
            return "Não recebeu o código via SMS?"
        case .es:
            return "¿No recibió el código por SMS?"
        }

    }
    
    static var fillPhoneAgain: String {
        switch currentLanguage {
        case .en:
            return "Fill your phone again to receive a new code"
        case .pt:
            return "Insira seu celular novamente para que possamos enviar um novo código"
        case .es:
            return "Vuelva a ingresar su teléfono para que podamos enviarle un nuevo código."
        }

    }
    
    static var sendAgain: String {
        switch currentLanguage {
        case .en:
            return "Resend"
        case .pt:
            return "Enviar novamente"
        case .es:
            return "Reenviar"
        }
    }
    
    static var cancel: String {
        switch currentLanguage {
        case .en:
            return "Cancel"
        case .pt:
            return "Cancelar"
        case .es:
            return "Cancelar"
        }
    }
    
    static var enrollment: String {
        switch currentLanguage {
        case .en:
            return "Enrollment"
        case .pt:
            return "Matrícula"
        case .es:
            return "Registro"
        }
    }
    
    //    static var model: String {
    //        switch currentLanguage {
    //        case .en:
    //            return ""
    //        case .pt:
    //            return ""
    //        }
    //    }
    
}
