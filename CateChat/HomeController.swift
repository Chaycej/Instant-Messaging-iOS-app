//
//  HomeController.swift
//  CateChat
//
//  Created by Chayce Heiberg on 7/12/17.
//  Copyright © 2017 wsuv. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {

    var ref = Database.database().reference()
    
    var account: Account? {
        didSet {
            navigationItem.title = account?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        checkIfUserIsLoggedIn()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(messagesButton)
        view.addSubview(settingsButton)
        
        setupMessagesButton()
        setupSettingsButton()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func viewMessages() {
        let userMessageController = UserMessageController()
        let navController = UINavigationController(rootViewController: userMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    func viewSettings() {
        let settingsController = SettingsController()
        settingsController.account = account
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true, completion: nil)
    }
    
    func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let accountController = AccountController()
        present(accountController, animated: true, completion: nil)
    }

    func checkIfUserIsLoggedIn() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return
        }
        ref.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                
            if let dictionary = snapshot.value as? [String: AnyObject] {
                self.account = Account(dictionary)
                self.account?.setValuesForKeys(dictionary)
                self.account?.id = uid
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }, withCancel: nil)
    }
    
    let messagesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("My messages", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.backgroundColor = UIColor(r: 28, g: 93, b: 153)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(viewMessages), for: .touchUpInside)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Settings", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.contentVerticalAlignment = UIControlContentVerticalAlignment.top
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center
        button.backgroundColor = UIColor(r: 0, g: 52, b: 89)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(viewSettings), for: .touchUpInside)
        return button
    }()
    
    func setupMessagesButton() {
        messagesButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 3).isActive = true
        messagesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3).isActive = true
        messagesButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2 - 10).isActive = true
        messagesButton.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
    }
    
    func setupSettingsButton() {
        settingsButton.leftAnchor.constraint(equalTo: messagesButton.rightAnchor, constant: 14).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2 - 10).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: view.bounds.height/4).isActive = true
    }
}
