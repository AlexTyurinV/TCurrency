//
//  Session.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Cocoa

struct Session {

    let sessionID: () -> String
    let setSessionID: (String) -> Void

    let userID: () -> String
    let setUserID: (String) -> Void
}

extension Session {
    static let live = Session.new()
}

extension Session {

    static func new() -> Self {
        var sessionID: String?
        var userID: String?

        return .init(
            sessionID: { sessionID ?? ""},
            setSessionID: { sessionID = $0 },
            userID: { userID ?? "" },
            setUserID: { userID = $0 }
        )
    }
}
