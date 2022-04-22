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

            cookies.forEach {
                print("\($0.name) = \($0.value)")
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
/* LOGINED:

 SSO_CONVERSATION_CSRF_s9SyT = dtR3LxUEb2uT3lBBsjzUxjigBTM.1646297107
 SSO_SESSION = yuX2fb7zz8whRW3KAtq7Zpu8F3kJoU18MTY1NefdgpEPMV_gpa83ytEEQArdWt4wCkqEIAklbigzdnB6YjGKng
 SSO_SESSION_STATE = yuX2fb7zz8
 s_nr = 1646298777609-Repeat
 source = output
 pcId = 2652183
 userType = Client-Heavy
 api_session = UPh8oTmwTV4sOWzaec7QVqrrC2OIh8XD.m1-prod-api85
 api_session_csrf_token_ea737d = ff28471d-7890-4086-b279-de497c5370f8.1646297107
 api_session_csrf_token_61b1a1 = 46325c1d-6ea9-4915-9e51-2a315f570c60.1646297111
 api_session_csrf_token_2caa39 = 88649cc5-2036-43cd-a2b6-0ff62ab58a6e.1646297144
 api_session_csrf_token_cab241 = e33e1885-0269-41a7-a1fc-8100df396239.1646297146
 api_session_csrf_token_1982c3 = e1fdb2dc-db92-42f7-9adb-7441f040432c.1646297949
 api_session_csrf_token_0aee3a = 97fff255-73ca-4b8f-9870-1a41d978fce5.1646297951
 api_session_csrf_token_56dcb7 = 4f357e89-be6c-40f1-98fe-f2409239a4b5.1646298592
 api_session_csrf_token_16b894 = f83f2533-562d-4c78-9ee9-1c0b9ac412b4.1646298606
 api_session_csrf_token_4ad263 = cc6b16b4-1d20-48c7-8217-f22e7a0834bd.1646298669
 api_session_csrf_token_1e9c2c = 15413512-7d4d-410b-a153-9d72843cd001.1646298677
 testcookiesenabled =
 test_cookie_QpHfCYJQhs = true
 api_session_csrf_token_2cddcd = fc6373a8-5c69-487a-996f-66890e8ac712.1646298776
 gwSessionID = t.ujjZiIzIWT_hjVJ0-yTvsb8uymhXWQTXZCd5Pg_PxXsi33lI7zIWQaCP9ViYT018yfTUes_PgGCLA05G8q59lg
 psid = UPh8oTmwTV4sOWzaec7QVqrrC2OIh8XD.m1-prod-api85
 mediaInfo = {%22width%22:900%2C%22height%22:600%2C%22isTouch%22:false%2C%22retina%22:false}
 __P__wuid = 282f7c47092c7dbe361514ef0d82c7d0
 dco.id = 207f4d6f-0843-4e0d-a8fa-0000d5f4df49
 userType = Client-Heavy
 dsp_click_id = no%20dsp_click_id
 ta_uid = 1646225548278717989
 utm_source =
 ta_nr = return
 ta_visit_num = 6
 __P__wuid_last_update_time = 1646225548275
 AMCV_A002FFD3544F6F0A0A4C98A5%40AdobeOrg = -1124106680%7CMCIDTS%7C19054%7CMCMID%7C16909886334640122181721171552171090380%7CMCAAMLH-1646903577%7C6%7CMCAAMB-1646903577%7C6G1ynYcLPuiQxYZrsz_pkqfLG9yMXBpb2zX5dvJdYQJzPXImdj0y%7CMCOPTOUT-1646305977s%7CNONE%7CMCSYNCSOP%7C411-19061%7CvVersion%7C5.2.0
 dmp.id = 0afd815b-5334-47c4-b3bd-23dc8f06567a
 stDeIdU = 9bafb086-157d-40c8-b7c9-c5c1e8ec8ddc
 _ga = GA1.2.2076186865.1646225550
 _gid = GA1.2.777556757.1646225550
 _ga_43H68Z69W3 = GS1.1.1646295003.10.0.1646298695.42
 enabledSharedAuth = true
 _gcl_au = 1.1.1540048895.1646238454
 amplitude_id_9f0f2b08f59d3c2922c1775a2d2b5edbtinkoff.ru = eyJkZXZpY2VJZCI6IjVjY2FhMmE4LWEwY2EtNDRmZC05M2E1LWI4ZDdkODFiNDRjYlIiLCJ1c2VySWQiOm51bGwsIm9wdE91dCI6ZmFsc2UsInNlc3Npb25JZCI6MTY0NjIzODQ1NTgxMCwibGFzdEV2ZW50VGltZSI6MTY0NjIzODQ1NTk4NywiZXZlbnRJZCI6MSwiaWRlbnRpZnlJZCI6MSwic2VxdWVuY2VOdW1iZXIiOjJ9
 ta_visit_start_ts = 1646287045401
 dmp.sid = AWIgWMVG4aw
 api_sso_id = 2ea5ad7a56db452de0c94f9c72bad6ea
 sso_api_session = t.WJ8O0ZkFJBxh-b--LJJdlTEQVB77oBKrRii8S4E8IUbQdw-aQhOuU7KQEAW8gOXWeghvPH13BbHsfy2d_6iJ5A
 pageLanding = https%3A%2F%2Fwww.tinkoff.ru%2F
 curProfileUrl = https://www.tinkoff.ru/summary
 _gat_gtag_UA_9110453_3 = 1
 _gat_gtag_UA_9110453_17 = 1
 AMCVS_A002FFD3544F6F0A0A4C98A5%40AdobeOrg = 1
 s_cc = true
 */
