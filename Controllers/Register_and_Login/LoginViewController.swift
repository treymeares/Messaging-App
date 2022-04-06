//
//  LoginViewController.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/4/22.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    let signInConfig = GIDConfiguration.init(clientID: "com.googleusercontent.apps.162640757087-tm2jdgna11cfpvd2n11lugb821t0bf9o")
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter E-mail Address"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let password: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Password"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        field.returnKeyType = .done
        
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["public_profile", "email"]
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let googleLoginButton: GIDSignInButton = {
//    {
        let button = GIDSignInButton()
//        button.permissions = ["email, public_profile"]
//        button.layer.cornerRadius = 6
//        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        GIDSignIn.sharedInstance.presentingViewController = self
        view.backgroundColor = .white
        title = "Login"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        password.delegate = self
        facebookLoginButton.delegate = self
        
        
        //Add Scroll View Subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLoginButton)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width-size) / 2, y: 20, width: size, height: size)
        emailField.frame = CGRect(x: 30, y: imageView.bottom+10, width:scrollView.width - 60, height: 52)
        password.frame = CGRect(x: 30, y: emailField.bottom+10, width:scrollView.width - 60, height: 52)
        loginButton.frame = CGRect(x: 30, y: password.bottom+10, width:scrollView.width - 60, height: 52)
        facebookLoginButton.frame = CGRect(x: 30, y: loginButton.bottom+10, width:scrollView.width - 60, height: 52)
        googleLoginButton.frame = CGRect(x: 30, y: facebookLoginButton.bottom+10, width:scrollView.width - 60, height: 52)
    }
    
    @objc private func didTapRegister() {
        let rVC = RegisterViewController()
        rVC.title = "Create New Account"
        navigationController?.pushViewController(rVC, animated: true)
    }
    
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        
        guard let email = emailField.text, let password = password.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else{
            alertUserLoginError()
            return
        }
        
        //FB Login Goes Here
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] AuthDataResult, error in
            guard let strongSelf = self else{
                return
            }
            guard let result = AuthDataResult, error == nil else{
                print("Failed to login with email and password: \(email)")
                strongSelf.navigationController?.dismiss(animated: true)
                return
            }
            let user = result.user
            print("\(user) logged in.")
        })
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Not So Fast", message: "Please Check All Entered Information, Some Was Missing.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func signIn(sender: Any) {
      GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
        guard error == nil else { return }

        // If sign in succeeded, display the app's main content View.
      }
    }
}
    
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            password.becomeFirstResponder()
        }
        else if textField == password{
            loginButtonTapped()
        }
        return true
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //None
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else{
            print("Failed to login with Facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",parameters: ["fields": "email, name"],tokenString: token,version: nil, httpMethod: .get)
        
        facebookRequest.start(completion: { _, result, error in
            guard let result = result as? [String:Any], error == nil else{
                print("Failed to make FB Graph Request")
                return
            }
            print("\(result)")
        guard let userName = result["name"] as? String,
              let email = result["email"] as? String else{
            print("Failed to get name and email from Facebook")
            return
        }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstname = nameComponents[0]
            let lastname = nameComponents[1]
            
            DatabaseManager.shared.checkForEmailExists(with: email, completion: { exists in
                if !exists{
                    DatabaseManager.shared.insertUser(with: DatabaseManager.ChatAppUser(firstName: firstname, lastName: lastname, emailAddress:email))
                }
            })
        })
        
        let crediental = FacebookAuthProvider.credential(withAccessToken: token)
        
        FirebaseAuth.Auth.auth().signIn(with: crediental, completion: { [weak self] AuthDataResult, error in
           
            guard let strongSelf = self else{
                return
            }
            guard  AuthDataResult != nil, error == nil else {
                print("Login failed. MFA needed")
                return
            }
            print("Successful Login")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


