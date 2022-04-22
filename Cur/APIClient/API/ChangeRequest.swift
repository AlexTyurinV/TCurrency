//
//  ChangeRequest.swift
//  Cur
//
//  Created by Alex Tyurin on 02.03.2022.
//

import Foundation

struct ChangeRequest {

    static func urlRequest(sessionID: String, userID: String, currencyFrom: CurrencyType, currencyTo: CurrencyType, amount: Float) -> URLRequest? {

        let urlStr = "https://www.tinkoff.ru/api/common/v1/get_held_payment_commission?sessionid=\(sessionID)&wuid=\(userID)"

        let body: [String: Any] = [
            "account": currencyFrom.account,
            "currency": currencyFrom.rawValue,
            "amount": String(format: "%.2f", amount),
            "srcCurrency": currencyFrom.rawValue,
            "dstCurrency": currencyTo.rawValue,
            "provider": "transfer-inner"
        ]

        guard let url = URL(string: urlStr) else {
            return nil
        }
/*
        SSO_SESSION = 0ZBkLZF0OCzEDOHGnEVcjqZCwt6oiICe-50EWkvGRqXsQiscbAWWbt3SxFp3qI0C07_urRPol5cyiReasnHxGw
        SSO_SESSION_STATE = 0ZBkLZF0OC
        s_nr = 1646911912927-Repeat
        source = output
        pcId = 2652183
        api_session_csrf_token_b6ee48 = 777838a0-b9c3-4145-8a45-c51c41156042.1646911366
        api_session = pckKZahu0ph1B0vftZCKSeDeTLAAX1jw.m1-prod-api85
        api_session_csrf_token_a770b6 = 03b47365-5338-4e7b-a9bb-2a0d4731a989.1646911368
        api_session_csrf_token_360c7f = 4114cc57-e565-4871-904b-fc397d3b3276.1646911566
        psid = pckKZahu0ph1B0vftZCKSeDeTLAAX1jw.m1-prod-api85
        testcookiesenabled =
        mediaInfo = {%22width%22:900%2C%22height%22:600%2C%22isTouch%22:false%2C%22retina%22:false}
        test_cookie_QpHfCYJQhs = true
        gwSessionID = t.v2YETG9nY4qWVXbBQijUCllUUKP80vb7EXmoW0RLZIGFbFK91d3DLfsIvO-h9aiNJIsa0wQ-s2FGQIqwcvYlpA
        __P__wuid = 282f7c47092c7dbe361514ef0d82c7d0
        dco.id = 207f4d6f-0843-4e0d-a8fa-0000d5f4df49
        userType = Client-Heavy
        dsp_click_id = no%20dsp_click_id
        ta_uid = 1646225548278717989
        utm_source =
        ta_nr = return
        ta_visit_num = 34
        __P__wuid_last_update_time = 1646906829674
        AMCV_A002FFD3544F6F0A0A4C98A5%40AdobeOrg = -1124106680%7CMCIDTS%7C19062%7CMCMID%7C16909886334640122181721171552171090380%7CMCAAMLH-1647516712%7C6%7CMCAAMB-1647516712%7C6G1ynYcLPuiQxYZrsz_pkqfLG9yMXBpb2zX5dvJdYQJzPXImdj0y%7CMCOPTOUT-1646919112s%7CNONE%7CMCSYNCSOP%7C411-19068%7CvVersion%7C5.2.02022-03-10 14:31:59.497609+0300 Cur[82532:490314] [] CurrentVBLDelta returned 0 for display 3 -- ignoring unreasonable value

        dmp.id = 0afd815b-5334-47c4-b3bd-23dc8f06567a
        _ga = GA1.2.2076186865.1646225550
        _ga_43H68Z69W3 = GS1.1.1646911368.28.1.1646911647.5
        enabledSharedAuth = true
        _gid = GA1.2.1677385763.1646770536
        stDeIdU = ba517dbb-0f12-40ee-9c40-a1a98e9643f9
        api_sso_id = 2ea5ad7a56db452de0c94f9c72bad6ea
        ta_visit_start_ts = 1646911366162
        dmp.sid = AWIp34a5AZk
        sso_api_session = t.zVHJPAU5Re3UAdbPVBbZNo3xFDn0NewQtMKqjl4Y-IzB3JM1GrEug2dgSOOGgyIj6i-V_Ibaz03rlZP6vGRISg
        pageLanding = https%3A%2F%2Fwww.tinkoff.ru%2F
        _gat_gtag_UA_9110453_3 = 1
        _gat_gtag_UA_9110453_17 = 1
        AMCVS_A002FFD3544F6F0A0A4C98A5%40AdobeOrg = 1
        s_cc = true
        curProfileUrl = https://www.tinkoff.ru/summary
                                                                                                                                                                                                                                                                                                                                                                                                    */

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body.map({ "\($0.key)=\($0.value)" }).joined(separator: "&").data(using: .utf8)
        return request
    }
}
