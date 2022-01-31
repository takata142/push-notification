

enum ActionIdentifier: String{
    case dashboard
    case camera
    case handle
    case handle_end
    
}

import UIKit
import UserNotifications
import WebKit


class ViewController: UIViewController,UNUserNotificationCenterDelegate,WKNavigationDelegate,WKScriptMessageHandler{
    @IBOutlet weak var btn: UIButton!
    
    var webView:WKWebView!
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        //let request = URLRequest(url:URL(string: "https://www.google.com/?hl=ja")!)
        //実機での場合
        let request = URLRequest(url:URL(string: "http://192.168.7.216:8000")!)
        //let request = URLRequest(url:URL(string: "https://mamo.tdxiot.net")!)

        self.webView.load(request)
        
        
        //-------------------------------------
        //プッシュ通知カスタムアクション設定
        //-------------------------------------
        //アクションの設定
        let dashboardAction = UNNotificationAction(identifier: ActionIdentifier.dashboard.rawValue, title:"利用者ダッシュボード",options: .foreground)
        let cameraAction = UNNotificationAction(identifier: ActionIdentifier.camera.rawValue, title: "カメラ", options: .foreground)
        let handleAction = UNNotificationAction(identifier: ActionIdentifier.handle.rawValue, title: "対応する", options: .foreground)
        let handle_endAction = UNNotificationAction(identifier: ActionIdentifier.handle_end.rawValue, title: "対応完了", options: .foreground)

        //カテゴリーの設定
        let category = UNNotificationCategory(identifier: "message",
                                              actions: [dashboardAction,cameraAction,handleAction,handle_endAction],
                                              intentIdentifiers: [], options: [])
        //UNUserNotificationCenterに設定
        UNUserNotificationCenter.current().setNotificationCategories([category])

    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == "callbackHandler"){
            print(message.body)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
