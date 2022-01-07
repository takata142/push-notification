//
//  AppDelegate.swift
//  pushNotification
//
//  Created by admin on 2021/12/02.
//

import UIKit
import UserNotifications
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    //ペイロード取得変数定義(データの受け渡し用)
    //アプリ未起動時
    var jsonAps2 = Dictionary<String,Any>()
    //フォアグラウンド、バックグラウンド時
    var jsonAps = Dictionary<String,Any>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //プッシュ通知利用リクエストの送信
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound]){granted, error in
            if error != nil{
                return
            }
            if granted {
                //フォアグラウンドで通知を受信した時
                UNUserNotificationCenter.current().delegate = self
            }
            //プッシュ通知利用の登録
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                print("登録")
            }
        }
        
        //アプリ未起動時ペイロード取得
        if let notificationOptions = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            //string:AnyObjectの形でペイロードを取得
            guard let apsPart = notificationOptions["aps"] as? [String: AnyObject] else { return true }
            //代入
            jsonAps2 = apsPart
            //guard let vc = window?.rootViewController as? ViewController else { return true }
            //key,valueごとにテキストで取り出し
            //let text = apsPart.map { (key, value) in "\(key): \(value)" }.joined(separator: "\n")

//            vc.payloadText = text
//            vc.backgroundColor = .yellow
        }
        
        return true
    }
    


    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                    //通知が押された際の処理
//                                    didReceive response: UNNotificationResponse,
//                                    withCompletionHandler completionHandler: @escaping() -> Void) {
//
//
//
//
//        debugPrint("opened")
//            //カスタム通知アクションのハンドリング
//        switch response.actionIdentifier{
//            //OKボタン
//        case ActionIdentifier.ok.rawValue:
//            //画面遷移
//            self.window = UIWindow(frame: UIScreen.main.bounds)
//            //Storyboardを指定
//            let storyboard = UIStoryboard(name:"Main",bundle:nil)
//            //ViewControllerを指定
//            let initialViewContorller = storyboard.instantiateViewController(withIdentifier: "second")
//            //rootViewControlerに代入
//            self.window?.rootViewController = initialViewContorller
//            //表示
//            self.window?.makeKeyAndVisible()
//            print("pushButton")
//
//            //NOボタン
//        case ActionIdentifier.no.rawValue:
//            break
//        default:
//            ()
//
//        }
//        completionHandler()
//    }
}

extension AppDelegate{
    //プッシュ通知の利用登録が成功した場合
    func application(_ application:UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let token = deviceToken.map{String(format:"%.2hhx",$0)}.joined()
        print("Device token:\(token)")
    }
    
    //プッシュ通知の利用登録が失敗した場合
    func application(_ application:UIApplication,
                     didRegisterForRemoteNotificationsWithError error:Error){
        print("Failed to register to APNs: \(error)")
    }
    
    //フォアグランド、バックグラウンド時ペイロード取得
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //string:AnyObjectの形でペイロードを取得
        guard let apsPart = userInfo["aps"] as? [String: AnyObject] else {
            completionHandler(.failed)
            return
        }
        //代入
        jsonAps = apsPart
        
        print("apsPart:",apsPart)
        //guard let vc = self.window?.rootViewController as? ViewController else {return}
        //guard let vc = window?.rootViewController as? ModalViewController else { return }
        //key,valueごとにテキストで取り出し
        //let text = apsPart.map { (key, value) in "\(key): \(value)" }.joined(separator: ": ")

    }
    

}


extension AppDelegate:UNUserNotificationCenterDelegate{
    
    //アプリが起動中それ以外でも通知が届く設定
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                //フォアグランドでも通知が届く
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:@escaping(UNNotificationPresentationOptions)->Void) {
        if notification.request.trigger is UNPushNotificationTrigger{
                        debugPrint("プッシュ通知受信")
                        completionHandler([.sound,.alert])
                    }else{
                        debugPrint("受信できず")
                    }
        completionHandler([.alert,.sound])
    }
    


}

