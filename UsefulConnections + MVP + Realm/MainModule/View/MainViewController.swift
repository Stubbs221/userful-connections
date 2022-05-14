//
//  ViewController.swift
//  UsefulConnections + MVP + Realm
//
//  Created by Vasily on 12.05.2022.
//

import UIKit

class MainViewController: UIViewController {

   override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.viewDidLoad()
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavItem()
    }
    
// MARK: - Actions
    
    @objc func addTapped() {
        let alert = UIAlertController(title: "Add new connection", message: "", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default){ [weak self] _ in
            let person = Person()
            guard let email = alert.textFields?[0].text else { return }
            person.email = email
            if let account = alert.textFields?[1].text {
                person.account = account
            } else {
                person.account = ""
            }
            if let rating = alert.textFields?[2].text{
                person.rating = rating
            } else {
                person.rating = ""
            }
            
            self?.presenter.addTapped(email: person.email, account: person.account, rating: person.rating)
        }
        
        alert.addTextField{ (textField) in
            textField.placeholder = "Email..."
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Description..."
        }
        alert.addTextField{ (textField) in
            textField.placeholder = "Rating..."
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func cellTapped(indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit connection", message: "", preferredStyle: .alert)
        let person = Person(email: emails[indexPath.row], account: accounts[indexPath.row], rating: ratings[indexPath.row], personID: indexPath.row)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let save = UIAlertAction(title: "Save", style: .default){ [weak self] _ in
            guard let email = alert.textFields?[0].text else { return }
            person.email = email
            if let account = alert.textFields?[1].text {
                person.account = account
            } else {
                person.account = ""
            }
            if let rating = alert.textFields?[2].text{
                person.rating = rating
            } else {
                person.rating = ""
            }
            self?.presenter.editTapped(email: person.email, account: person.account, rating: person.rating, id: person.personID)
        }
        
        alert.addTextField{ (textField) in
            textField.text = person.email
        }
        alert.addTextField{ (textField) in
            textField.text = person.account
        }
        alert.addTextField{ (textField) in
            textField.text = person.rating
        }
        
        alert.addAction(cancel)
        alert.addAction(save)
        self.present(alert, animated: true, completion: nil)
    }
// MARK: - Properties
    
    var cellID = "CellID"
    
    var emails: [String] = []
    var accounts: [String] = []
    var ratings: [String] = []
    var personIDs: [Int] = []
    
    var presenter: MainViewPresenterProtocol!
    
    lazy var addBarItem: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        button.tintColor = .systemYellow
        return button
    }()
    
    lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 20)
        label.textColor = .darkGray
        label.text = "No stored persons yet"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

}
// MARK: - UITableView Data Source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.isHidden = self.emails.isEmpty
        placeholderLabel.isHidden = !self.emails.isEmpty
        
        return self.emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MainTableViewCell
        cell.emailLabel.text = emails[indexPath.row]
        cell.accountLabel.text = accounts[indexPath.row]
        cell.ratingLabel.text = ratings[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter.deleteSelecter(for: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellTapped(indexPath: indexPath)
    }
}

// MARK: - UITableView Delegate

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}

// MARK: - Conforming 'MainViewProtocol'

extension MainViewController: MainViewProtocol {
    
    func onPersonDeletion(index: Int) {
        print("View receives a deletion result from the presenter")
        self.emails.remove(at: index)
        self.accounts.remove(at: index)
        self.ratings.remove(at: index)
        self.personIDs.remove(at: index)
        self.tableView.reloadData()
    }
    
    
    
    func onPersonRetrieval(emails: [String], accounts: [String], ratings: [String], personIDs: [Int]) {
        print("View receives the result from the Presenter")
        self.emails = emails
        self.accounts = accounts
        self.ratings = ratings
        self.personIDs = personIDs
        self.tableView.reloadData()
    }
    
    func onPersonAddFailure(message: String) {
        print("View receives a failure result from the Presenter with message: \(message)")
    }
    
    func onPersonAddSuccess(email: String, account: String, rating: String, personID: Int) {
        print("View receives the result from the Presenter")
        self.emails.append(email)
        self.accounts.append(account)
        self.ratings.append(rating)
        self.personIDs.append(personID)
        self.tableView.reloadData()
    }
    
    func onPersonEditFailure(message: String) {
        print("View receives a failure result from the Presenter with message: \(message)")
    }
    
    func onPersonEditSuccess(email: String, account: String, rating: String, id: Int) {
        print("View receiver the edit result from the Presenter")
        self.emails[id] = email
        self.accounts[id] = account
        self.ratings[id] = rating
        self.personIDs[id] = id
        self.tableView.reloadData()
    }
    func setCellText(text: String) {
        
    }
    
    
}

// MARK: - UI Setup

extension MainViewController {
    private func setupUI() {
        self.view.backgroundColor = .systemCyan
        
        self.view.addSubview(tableView)
        self.view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            placeholderLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)])
        
    }
    
    private func setupNavItem() {
        self.navigationItem.rightBarButtonItem = addBarItem
        self.navigationItem.titleView = createCustomTitleView()
//        self.navigationItem.title = "Useful Connections"
    }
    
    private func createCustomTitleView() -> UIView {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 280, height: 41)
        
        let label = UILabel()
        
        label.textAlignment = .left
        
        label.frame = CGRect(x: 55, y: 0, width: 220, height: 20)
        label.font = UIFont.systemFont(ofSize: 26)
        
        label.text = "Useful connections"
        view.addSubview(label)
        
        return view
    }
}
