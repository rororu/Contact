//
//  Contact.swift
//  Contact
//
//  Created by Роман Романов on 31.10.2022.
//

import UIKit

protocol ContactProtocol {
    var title: String {get set}
    var phone: String {get set}
}

protocol ContactStorageProtocol {
    func load() -> [ContactProtocol]
    func save(contacts: [ContactProtocol])
}

class ContactStorage: ContactStorageProtocol {
    private var storage = UserDefaults.standard
    private var storageKey = "contacts"
    
    private enum ContactKey: String {
        case title
        case phone
    }
    
    func load() -> [ContactProtocol] {
        var resultContacts: [ContactProtocol] = []
        let contactFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        
        for contact in contactFromStorage {
            guard let title = contact[ContactKey.title.rawValue],
                  let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    
    func save(contacts: [ContactProtocol]) {
        var arrayForStorage: [[String:String]] = []
        
        contacts.forEach { contact in
            var newElementForStorage: [String:String] = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        
        storage.set(arrayForStorage, forKey: storageKey)
        
    }
}


struct Contact: ContactProtocol {
    var title: String
    var phone: String
}