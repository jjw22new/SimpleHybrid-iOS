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
        super.init(coder: <#T##NSCoder#>)
        
        self.navigationDelegate = self
    }
    
    private func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var action: WKNavigationActionPolicy?
        
        defer {
            decisionHandler(action ?? .allow)
        }
        
        guard let url = navigationAction.request.url else { return }
        
        print(url)
        
        if (navigationAction.navigationType == .linkActivated && url.absoluteString.hasPrefix("SH://")) {
            action = .cancel // Stop in WebView
            
            if(url.absoluteString.hasPrefix("SH://data.view")) {
                let queryItems = URLComponents(string: url.absoluteString)?.queryItems
                let param1 = queryItems?.filter({$0.name == "name"}).first
                print(param1?.value ?? "")
            }
        }
    }
}
