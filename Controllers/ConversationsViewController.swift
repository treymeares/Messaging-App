//
//  ViewController.swift
//  Sp22_Message_App
//
//  Created by Trey Meares on 4/4/22.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class ConversationsViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let noConvoLabel: UILabel = {
        let label = UILabel()
        label.text = "No Conversations To Load"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(tableView)
        view.addSubview(noConvoLabel)
        fetchConversations()
        setupTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCOmposeButton))
    }
    
    @objc private func didTapCOmposeButton() {
        let vc = BeginConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func validateAuth(){
        if FirebaseAuth.Auth.auth().currentUser ==  nil {
            let cVC = LoginViewController()
            let nVC = UINavigationController(rootViewController:  cVC)
            nVC.modalPresentationStyle = .fullScreen
            present(nVC, animated: true)
            
        }
        
        
    }
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func fetchConversations() {
        tableView.isHidden = false
    }
    
    
}

extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello World"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Trey Meares"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
