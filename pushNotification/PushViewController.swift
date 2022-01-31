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
    var jsonAps2 = Dictionary<String,Any>()
    var TC = UIApplication.shared.keyWindow?.rootViewController;


        override func viewDidLoad() {
        super.viewDidLoad()
            //appDelegateで定義した変数を使用できるようにする
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            //jsonAps2 = appDelegate.jsonAps2
            jsonAps = appDelegate.jsonAps

            
            //--------------------------------------------------
            //nativeView
            //--------------------------------------------------
//            let nativeView = UIView()
//            nativeView.backgroundColor = UIColor.white
//            nativeView.frame = CGRect(x:0,
//                                      y:0,
//                                      width: self.view.frame.size.width,
//                                      height: (self.view.frame.size.height)/4)
//
//            //nativeView表示
//            self.view.addSubview(nativeView)
//
//            //ボタン作成
//            let btn:UIButton = UIButton()
//            btn.frame = CGRect(x: self.view.frame.width/2,
//                                  y:(self.view.frame.size.height)/4,
//                                  width: 80,
//                                  height: 50)
//            btn.layer.position = CGPoint(x: self.view.frame.width/2, y:100)
//            btn.setTitle("< Back", for: UIControl.State.normal)
//            btn.sizeToFit()
//            btn.setTitleColor(.blue, for: .normal)
//            //btn.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.6, alpha: 1)
//
//            self.view.addSubview(btn)
//
//            //ボタンクリック時アクション指定
//            btn.addTarget(self, action: #selector(self.btn_tapped(_:)), for: UIControl.Event.touchUpInside)
            
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
                                              y:self.view.frame.midY,
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
    
    
    
    //ボタンアクション
    @IBAction func btn_tapped(_ sender:Any){
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name:"Main",bundle:nil)
//        let initialViewContorller = storyboard.instantiateViewController(withIdentifier: "home")
//        self.window?.rootViewController = initialViewContorller
//        self.window?.makeKeyAndVisible()
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
        

    }

    // 現在表示されている最前面の画面を取得するメソッド
        func getTopMostViewController()->UIViewController{
            TC = UIApplication.shared.keyWindow?.rootViewController;
            while ((TC!.presentedViewController) != nil) {
                TC = TC!.presentedViewController;
            }
            return TC!;
        }

        // 画面遷移させるメソッド
        func ChangeVC() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let AfterVC = storyboard.instantiateViewController(withIdentifier: "second")

            TC?.present(AfterVC, animated: true, completion: nil)
        }





}
