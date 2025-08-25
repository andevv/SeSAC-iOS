//
//  SceneDelegate.swift
//  SeSAC0822Homework
//
//  Created by andev on 8/22/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let tab = UITabBarController()
        tab.viewControllers = [
            makeTamagotchiFlow(),
            makeLottoFlow(),
            makeBoxOfficeFlow()
        ]

        window?.rootViewController = tab
        window?.makeKeyAndVisible()
    }

    // 기존 분기 로직을 첫 번째 탭의 내비게이션 스택으로 이동
    private func makeTamagotchiFlow() -> UINavigationController {
        let root: UIViewController
        if let id = TamagotchiStorage.shared.selectedID,
           let tg = TamagotchiCatalog.find(by: id) {
            root = TamagotchiMainViewController(viewModel: TamagotchiMainViewModel(tamagotchi: tg))
            root.title = "다마고치"
        } else {
            root = TamagotchiSelectViewController()
            root.title = "다마고치 선택하기"
        }

        let nav = UINavigationController(rootViewController: root)
        nav.tabBarItem = UITabBarItem(
            title: "다마고치",
            image: UIImage(systemName: "face.smiling"),
            selectedImage: nil
        )
        return nav
    }

    // 두 번째 탭
    private func makeLottoFlow() -> UINavigationController {
        let vc = LottoViewController()
        vc.title = "로또"
        
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "로또",
            image: UIImage(systemName: "ticket"),
            selectedImage: nil
        )
        return nav
    }
        
    // 세 번째 탭
    private func makeBoxOfficeFlow() -> UINavigationController {
        let vc = BoxOfficeViewController()
        vc.title = "박스오피스"

        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem = UITabBarItem(
            title: "박스오피스",
            image: UIImage(systemName: "movieclapper"),
            selectedImage: nil
        )
        return nav
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

