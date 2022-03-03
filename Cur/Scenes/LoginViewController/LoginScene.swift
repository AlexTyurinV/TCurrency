//
//  LoginScene.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Cocoa

struct LoginScene {

    static func login(presenter: NSViewController, sessionParam: Session, completion: @escaping () -> Void) {
        let controller = LoginScene.build(
            sessionParam: sessionParam,
            completion: { [weak presenter] controller in
                presenter?.dismiss(controller)
                completion()
            }
        )
        presenter.presentAsSheet(controller)
    }

    static func requestLogin(presenter: NSViewController, sessionParam: Session, completion: @escaping () -> Void) {
        let login: () -> Void = {
            LoginScene.login(presenter: presenter, sessionParam: sessionParam, completion: completion)
        }

        let alert = NSAlert()
        alert.messageText = "Авторизация"
        alert.informativeText = "Для дальнейшей работы нужно обновить токен, а для этого нужно авторизоваться"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Авторизоваться")
        alert.addButton(withTitle: "Отмена")

        if let window = presenter.view.window {
            alert.beginSheetModal(for: window) {
                if $0 == .alertFirstButtonReturn {
                    login()
                }
            }
        }
    }

    static func build(sessionParam: Session, completion: @escaping (NSViewController) -> Void) -> NSViewController {
        let vc = LoginViewController()
        vc.completion = completion
        vc.sessionParam = sessionParam
        return vc
    }
}
