//
//  Behaviours.swift
//  CashBackEPN
//
//  Created by Ivan Nikitin on 18/09/2018.
//  Copyright © 2018 Ivan Nikitin. All rights reserved.
//

import Foundation

public enum LastStepBehaviourType {
    case SignUp, RecreatePassword, RecoverEmail//, InfoAttachAccount, AttachAccount, 
}

public enum ActionType {
    case SignIn, SignUp, SignInSocial
}

public enum AuthType {
    case SignIn, SignUp
}

public enum CaptchaAction {
    case App, Oauth
}

public enum SocialType: String {
    case vk, google, fb, apple
}

public enum Language : String{
    case en
    case ru
    case es
}
