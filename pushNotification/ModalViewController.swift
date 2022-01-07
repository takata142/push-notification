//
//  ModalViewController.swift
//  pushNotification
//
//  Created by admin on 2021/12/03.
//

import UIKit
import WebKit

class ModalViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    
    var webView: WKWebView!
    var jsonAps = Dictionary<String,Any>()
    var jsonAps2 = Dictionary<String,Any>()
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            //appDelegateで定義した変数を使用できるようにする
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            jsonAps2 = appDelegate.jsonAps2
            jsonAps = appDelegate.jsonAps

            
            

            
        // Do any additional setup after loading the view.
            
            //javascriptの呼び出しを可能にする
            let userController = WKUserContentController()
            userController.add(self, name: "callbackHandler")
            
            //webviewの設定を行うためのクラス
            let webConfigration = WKWebViewConfiguration()
            webConfigration.userContentController = userController

            webView = WKWebView(frame: CGRect(x:0,
                                              y:0,
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

            self.webView.load(request)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler"){
            print(message.body)
        }
    }
    
    //HTMLのロード終了後しかJavascriptが実行できないためのdidFinish
    func webView(_ webView:WKWebView,didFinish navigation:WKNavigation!){
        //let data:[String:Any] = ["keyNumber":1000,"keyString":"test"]
        
//        let arr:[String] = text!.components(separatedBy: ": ")
//        print("hairetu:",arr)
//        
//        var key:[String] =[]
//        var val:String
//        var jud:Int = 0
//        
//        for i in 0..<(arr.count){
//            if ((arr.count % 2) == 0){
//                key = arr[i]
//                print(key)
//            }else{
//                val = i
//            }
//            //print(i)
//            jud += 1
//        }

//        struct Employee: Codable{
//            var keynumber: Int
//            var keystring: String
//            //var alert: String
//        }
//
//
//        //JSONオブジェクト生成
//        let data = Employee(keynumber: 1000,keystring: "test")
//        print(jsonAps)
//        //JSONへ変換
//        let encoder = JSONEncoder()
//        guard let jsonValue = try? encoder.encode(data)else{
//            fatalError("Failed to encode to JSON.")
//        }
//        print(jsonValue)
//        //stringに
//        let json = String(bytes: jsonValue,encoding: .utf8)!
//        print("json:",json)
//        print("text:",text)
        
       
        let data:[String:Any] = jsonAps
        print("jsonAps:",jsonAps)
        print("jsonAps2:",jsonAps2)
        
        do{
                    //Jsonデータ作成
                    let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                    let json = String(data:jsonData,encoding: .utf8)! as String
        
                    print(json)
        
                    //let returnData = "returnData('\(json)')"
        
                    self.webView.evaluateJavaScript("test('\(json)')", completionHandler: {result,error in
                        print("Completed Javascript evaluation.")
                        print("Result: \(String(describing: result))")
                        print("Error:\(String(describing: error))")
                    })
                    }catch{
                        print("Error!:\(error)")
                    }
        
        //
        //let execJsFunc:String = "test(\'\(json)')"
        //javascriptに送信
//        webView.evaluateJavaScript(execJsFunc, completionHandler: { (object, error) -> Void in
//            print("Result: \(String(describing: object))")
//
//                })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    
    


}
