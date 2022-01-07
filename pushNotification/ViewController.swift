//
//  ViewController.swift
//  pushNotification
//
//  Created by admin on 2021/12/02.
//

enum ActionIdentifier: String{
    case ok
    case no
}

import UIKit
import UserNotifications

class ViewController: UIViewController,UNUserNotificationCenterDelegate{
    
    var payloadText: String? {
        didSet{
            guard label != nil else {return}
            label.text = payloadText
            view.backgroundColor = backgroundColor ?? .white
        }
    }
    var backgroundColor:UIColor?
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    
        //プッシュ通知カスタムアクション設定
        //アクションの設定
        let okAction = UNNotificationAction(identifier: ActionIdentifier.ok.rawValue, title: "利用者ダッシュボード", options: [.foreground])
        let noAction = UNNotificationAction(identifier: ActionIdentifier.no.rawValue, title: "カメラ", options: [.foreground])
        //カテゴリーの設定
        let category = UNNotificationCategory(identifier: "message",
                                              actions: [okAction,noAction],
                                              intentIdentifiers: [], options: [])
        //UNUserNotificationCenterに設定
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        
        
    }

}

