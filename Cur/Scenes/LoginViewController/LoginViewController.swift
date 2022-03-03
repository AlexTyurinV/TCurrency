//
//  LoginViewController.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Cocoa
import WebKit

class LoginViewController: NSViewController {

    let webView: WKWebView = WKWebView(frame: NSRect(x: 0, y: 0, width: 900, height: 600))
    var completion: ((NSViewController) -> Void)?
    var sessionParam: Session?

    override func loadView() {
        view = webView
        webView.navigationDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        load(page: "https://www.tinkoff.ru")
    }

    func checkCookies() {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
            guard
                let self = self,
                let sessionID = cookies.first(where: { $0.name == "api_session" && ($0.expiresDate ?? Date()) > Date() })?.value,
                let userID = cookies.first(where: { $0.name == "__P__wuid" && ($0.expiresDate ?? Date()) > Date() })?.value,
                let gwSessionID = cookies.first(where: { $0.name == "gwSessionID" })?.value
            else {
                return
            }

            self.sessionParam?.setSessionID(sessionID)
            self.sessionParam?.setUserID(userID)
            self.completion?(self)
        }
    }
}

extension LoginViewController: WKNavigationDelegate {

    private func load(page: String) {
        if let url = URL(string: page) {
            let urlRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        checkCookies()
    }
}
