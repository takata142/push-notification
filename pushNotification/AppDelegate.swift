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
    
    var CurrentVC = UIApplication.shared.keyWindow?.rootViewController

    //通知押下時に渡ってくるペイロードを格納
    var jsonAps = Dictionary<String,Any>()
    

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        
        return true
    }
    
}

extension AppDelegate{
    //デバイストークンの登録が成功した場合
    func application(_ application:UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let token = deviceToken.map{String(format:"%.2hhx",$0)}.joined()
        print("Device token:\(token)")
    }
    
    //デバイストークンの登録が失敗した場合
    func application(_ application:UIApplication,
                     didRegisterForRemoteNotificationsWithError error:Error){
        print("Failed to register to APNs: \(error)")
    }
    

}


extension AppDelegate:UNUserNotificationCenterDelegate{
    
    
    //フォアグランドでも通知が届く
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:@escaping(UNNotificationPresentationOptions)->Void) {
        //push通知をトリガーにアラートとサウンドを出す
        if notification.request.trigger is UNPushNotificationTrigger{
                        debugPrint("プッシュ通知受信")
                    }else{
                        debugPrint("通知を受信できません")
                    }

        completionHandler([.alert,.sound])
    }
    
    //通知が押された際の処理(通知に対する操作）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping() -> Void) {
        
        //let userInfo = response.notification.request.content.userInfo
        
        //string:AnyObjectの形でペイロードを取得
        guard let apsPart = response.notification.request.content.userInfo["aps"] as? [String: AnyObject] else {
            print("error")
            return
        }
        print(apsPart)
        print("pushButton")
        
        //カスタム通知アクションのハンドリング
        switch response.actionIdentifier{
            
            //利用者ダッシュボードボタン
            case ActionIdentifier.dashboard.rawValue:
                print("利用者ダッシュボードボタンが押されました")
                break
            //カメラボタン
            case ActionIdentifier.camera.rawValue:
                print("カメラボタンが押されました")
                break
            //対応ボタン
            case ActionIdentifier.handle.rawValue:
                print("対応ボタンが押されました")
                break
            //対応完了ボタン
            case ActionIdentifier.handle_end.rawValue:
                print("対応完了ボタンが押されました")
            
            //通知自体を押下した時の処理
            default:
            
                //ペイロードを渡す
                jsonAps = apsPart
            
                //通知押下時画面遷移
                self.window = UIWindow(frame: UIScreen.main.bounds)
                //Storyboardを指定
                let storyboard = UIStoryboard(name:"Main",bundle:nil)
                //ViewControllerを指定
                let vc1 = storyboard.instantiateViewController(withIdentifier: "home")
                let vc2 = storyboard.instantiateViewController(withIdentifier: "second")
            
                let nv = UINavigationController()
                nv.viewControllers  = [vc1,vc2]
                //rootViewControllerに代入
                self.window?.rootViewController = nv
                //表示
                self.window?.makeKeyAndVisible()
                

        }
        
        completionHandler()
        

    }
    

    

}



