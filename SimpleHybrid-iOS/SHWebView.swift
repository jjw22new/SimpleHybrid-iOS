//
//  SHWebView.swift
//  SimpleHybrid-iOS
//
//  Created by Jung JaeYeol on 13/03/2019.
//  Copyright © 2019 Jung JaeYeol. All rights reserved.
//

import WebKit

@IBDesignable open class SHWebView: WKWebView, WKNavigationDelegate {
    
    let contentController = WKUserContentController()
    let config = WKWebViewConfiguration()
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.navigationDelegate = self
        self.customUserAgent = self.customUserAgent! + "SimpleHybrid;"
    }
    
    // JS -> Native CALL
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "appDataToWeb":
            let appData = UserDefaults.standard.dictionary(forKey: "appData")!
            let appDataString = appData.convertToString()
            self.evaluateJavaScript("shInitCallBack('" + appDataString! + "')", completionHandler: nil)
        case "appDataToApp":
            UserDefaults.standard.set(message.body, forKey: "appData")
        default:
            print("userContentController message not matched")
        }
    }
}

extension String {
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension Dictionary {
    func convertToString() -> String? {
        do {
            return try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) as? String
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
