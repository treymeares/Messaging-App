//
//  RegisterViewController.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/4/22.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let firstName: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter First Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
    }()
    
    private let lastName: UITextField = {
        let field = UITextField()
        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .continue
        field.layer.cornerRadius = 6
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Enter Last Name"
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        
        return field
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
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Register"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register Now", style: .done, target: self, action: #selector(didTapRegister))
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        password.delegate = self
        
        //Add Scroll View Subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstName)
        scrollView.addSubview(lastName)
        scrollView.addSubview(emailField)
        scrollView.addSubview(password)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePicture))
        
        imageView.addGestureRecognizer(gesture)
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func didTapChangeProfilePicture(){
        print("Clicked to Change Profile Pic")
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width-size) / 2, y: 20, width: size, height: size)
        firstName.frame = CGRect(x: 30, y: imageView.bottom+10, width:scrollView.width - 60, height: 52)
        lastName.frame = CGRect(x: 30, y: firstName.bottom+10, width:scrollView.width - 60, height: 52)
        emailField.frame = CGRect(x: 30, y: lastName.bottom+10, width:scrollView.width - 60, height: 52)
        password.frame = CGRect(x: 30, y: emailField.bottom+10, width:scrollView.width - 60, height: 52)
        registerButton.frame = CGRect(x: 30, y: password.bottom+10, width:scrollView.width - 60, height: 52)
        imageView.layer.cornerRadius = imageView.width/2.0
    }
    
    @objc private func didTapRegister() {
        let rVC = RegisterViewController()
        rVC.title = "Create New Account"
        navigationController?.pushViewController(rVC, animated: true)
    }
    
    @objc private func registerButtonTapped(){
        emailField.resignFirstResponder()
        password.resignFirstResponder()
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        
        guard let firstName = firstName.text,
              let lastName = lastName.text,
              let email = emailField.text,
              let password = password.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6,  !firstName.isEmpty,  !lastName.isEmpty  else{
            alertUserLoginError()
            return
        }
        
        //FB Login Goes Here
    }
    
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Not So Fast", message: "Please Check All Entered Information, Some Was Missing To Create A New Account.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField{
            password.becomeFirstResponder()
        }
        else if textField == password{
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{
            return
        }
        self.imageView.image = selectedImage
    }
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "Pick One",preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self]_ in self?.presentCamera()}))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in self?.presentPhotoAlbum() }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let pVC = UIImagePickerController()
        pVC.sourceType = .camera
        pVC.delegate = self
        pVC.allowsEditing = true
        present(pVC, animated: true)
    }
    
    func presentPhotoAlbum() {
        let pVC = UIImagePickerController()
        pVC.sourceType = .photoLibrary
        pVC.delegate = self
        pVC.allowsEditing = true
        present(pVC, animated: true)
        
    }
}
