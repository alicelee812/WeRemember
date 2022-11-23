//
//  LoginViewController.swift
//  WeRemember
//
//  Created by Alice on 2022/11/23.
//

import UIKit
import FirebaseAuth
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        let url = URL(string: "https://favqs.com/api/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("Token token=09d6d89b94f38b97acbe3f1f47a1ef9d", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let body = UserBody(user: User(login: account, password: password))
        request.httpBody = try? JSONEncoder().encode(body)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data {
                do {
                    let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                    print(userResponse)
                    UserDefaults.standard.set(userResponse.userToken, forKey: "token")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "showHome", sender: nil)
                    }
                    
                } catch  {
                    print(error)
                }
            }
        }.resume()
    }
   
    
    
    @IBAction func registerAction(_ sender: Any) {
        let controller = UIAlertController(title: "註冊成功", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "確認", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
        
//        let url = URL(string: "https://favqs.com/api/users")!
//            var request = URLRequest(url: url)
//            request.httpMethod = "post"
//            request.setValue("Token token=09d6d89b94f38b97acbe3f1f47a1ef9d", forHTTPHeaderField: "Authorization")
//            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let account = accountTextField.text ?? ""
//            let password = passwordTextField.text ?? ""
//            let body = UserBody(user: User(login: account, password: password))
//            request.httpBody = try? JSONEncoder().encode(body)
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                if let data {
//                    print(String(data: data, encoding: .utf8)!)
//                    DispatchQueue.main.async {
//                        self.performSegue(withIdentifier: "showHome", sender: nil)
//                    }
//                    do {
//                        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
//                        print(userResponse)
//                    } catch  {
//                        print(error)
//                    }
//                }
//            }.resume()
    }
    
    
    //firebase電子信箱與密碼登入
    /*
    @IBAction func loginAction(_ sender: Any) {
        if self.accountTextField.text == "" || self.passwordTextField.text == "" {
            
            //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        
        } else {
            
            Auth.auth().signIn(withEmail: self.accountTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
     */

    @IBAction func noAction(_ sender: Any) {
    }
    
}
