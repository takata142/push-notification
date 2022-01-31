//
//  ModalViewController.swift
//  pushNotification
//
//  Created by admin on 2021/12/03.
//

import UIKit
import WebKit

class PushViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

    var webView: WKWebView!
    var window: UIWindow?
    var jsonAps = Dictionary<String,Any>()


        override func viewDidLoad() {
        super.viewDidLoad()
            //appDelegateで定義した変数を使用できるようにする
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            jsonAps = appDelegate.jsonAps


            
            //--------------------------------------------------
            //webView
            //--------------------------------------------------


            //javascriptの呼び出しを可能にする
            let userController = WKUserContentController()
            userController.add(self, name: "callbackHandler")

            //webviewの設定を行うためのクラス
            let webConfigration = WKWebViewConfiguration()
            webConfigration.userContentController = userController

            webView = WKWebView(frame: CGRect(x:0,
                                              y:self.view.frame.midY/2,
                                              width: self.view.frame.size.width,
                                              height: self.view.frame.size.height),
                                              configuration: webConfigration)
            webView.navigationDelegate = self
            webView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(webView)

            //アドレス
            //let request = URLRequest(url:URL(string: "http://localhost:8000")!)
            //実機での場合
            let request = URLRequest(url:URL(string: "http://192.168.7.216:8000")!)
            //let request = URLRequest(url:URL(string: "https://mamo.tdxiot.net/test")!)

            self.webView.load(request)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler"){
            print(message.body)
        }
    }

    //HTMLのロード終了後しかJavascriptが実行できないためのdidFinish
    func webView(_ webView:WKWebView,didFinish navigation:WKNavigation!){


        let data:[String:Any] = jsonAps
        print("jsonAps:",jsonAps)

        do{
                    //Jsonデータ作成
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let json = String(data:jsonData,encoding: .utf8)! as String

                    print(json)

                    self.webView.evaluateJavaScript("test('\(json)')", completionHandler: {result,error in
                        print("Completed Javascript evaluation.")
                        print("Result: \(String(describing: result))")
                        print("Error:\(String(describing: error))")
                    })
                    }catch{
                        print("Error!:\(error)")
                    }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    






}
