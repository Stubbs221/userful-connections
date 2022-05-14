//
//  Presenter.swift
//  UsefulConnections + MVP + Realm
//
//  Created by Vasily on 12.05.2022.
//

import Foundation
import RealmSwift

protocol MainViewProtocol {
    func setCellText(text: String)
    func onPersonRetrieval(emails: [String], accounts: [String], ratings: [String], personIDs: [Int])
    func onPersonAddFailure(message: String)
    func onPersonAddSuccess(email: String, account: String, rating: String, personID: Int)
    func onPersonDeletion(index: Int)
    func onPersonEditFailure(message: String)
    func onPersonEditSuccess(email: String, account: String, rating: String, id: Int)
}

protocol MainViewPresenterProtocol {
    init(view: MainViewProtocol, person: Person)
    func showEmail(indexPath: Int) -> String
    func viewDidLoad()
    func addTapped(email: String, account: String, rating: String)
    func deleteSelecter(for index: Int)
    func editTapped(email: String, account: String, rating: String, id: Int)
}

class MainPresenter: MainViewPresenterProtocol {
    
    
   
    let view: MainViewProtocol!
    let model: Person!
    
    private var persons: Results<Person>?
    let realm = try! Realm()
    
    required init(view: MainViewProtocol, person: Person) {
        self.view = view
        self.model = person
    }
    
    func showEmail(indexPath: Int) -> String {
        return model.email
    }
    
    func viewDidLoad() {
        print("View notifies the presenter that it has loaded.")
        retrievePersons()
    }
    
    func retrievePersons() {
        print("Presenter retrieves Person objects from the Realm Database")
        self.persons = realm.objects(Person.self)
        
        let emails:  [String]? = self.persons?.compactMap{ $0.email }
//        print(emails)
        let accounts: [String]? = self.persons?.compactMap{ $0.account }
//        print(accounts)
        let ratings: [String]? = self.persons?.compactMap{ $0.rating }
//        print(ratings)
        let personIDs: [Int]? = self.persons?.compactMap{ $0.personID }
        
        view?.onPersonRetrieval(emails: emails ?? [], accounts: accounts ?? [], ratings: ratings ?? [], personIDs: personIDs ?? [])
    }
    
    func addTapped(email: String, account: String, rating: String){
        print("View notifies the presenter that Add button was tapped")
        addPerson(email: email, account: account, rating: rating)
    }
    
    func addPerson(email: String, account: String, rating: String) {
        print("Presenter adds a Person object to the Realm Database")
        let id = persons?.count ?? 0
        let person = Person(email: email, account: account, rating: rating, personID: id)
        do {
            try self.realm.write{
                self.realm.add(person)
            }
        } catch {
            view?.onPersonAddFailure(message: error.localizedDescription)
        }
        view?.onPersonAddSuccess(email: email, account: account, rating: rating, personID: id)
    }
    
    func editTapped(email: String, account: String, rating: String, id: Int) {
        print("View notifies the presenter that Edit button was tapped")
        editPerson(email: email, account: account, rating: rating, id: id)
    }
    
    func editPerson(email: String, account: String, rating: String, id: Int) {

        let personResults = persons?.filter("personID = %@", id)
        if let person = personResults?.first{
            do {
                try self.realm.write{
                    person.email = email
                    person.account = account
                    person.rating = rating
                    person.personID = id
                    
                }
            } catch {
                view?.onPersonEditFailure(message: "Object editing error \(error.localizedDescription)")
            }
        }
        view?.onPersonEditSuccess(email: email, account: account, rating: rating, id: id)
    }
    func deleteSelecter(for index: Int) {
        print("View notifies the presenter that a delete action was performed")
        deletePerson(at: index)
    }
    
    func deletePerson(at index: Int) {
        print("Presenter deletes Person object from Realm Database ")
        if let persons = persons {
            do {
                try self.realm.write{
                    self.realm.delete(persons[index])
                }
            } catch {
                print("Couldn't delete a person")
            }
            view?.onPersonDeletion(index: index)
        }
    }
}
