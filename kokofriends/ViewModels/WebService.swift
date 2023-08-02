//
//  WebService.swift
//  kokofriends
//
//  Created by crawford on 2023/7/27.
//

import Foundation

struct urlUserDataResponse: Codable {
    var response: [userDataResponse]
}

struct urlFriendResponse: Codable {
    var response: [friendDataResponse]
}

struct userDataResponse: Codable{
    var name: String
    var kokoid: String
}

struct friendDataResponse: Codable{
    var name: String
    var status: Int
    var isTop: String
    var fid: String
    var updateDate: String
}

var friendDataList =  urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
var lastArray = urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
var nameArray: [String] = []
var fidArray: [String] = []


class Webservice {
    func getUserData() {
        if let url = URL(string: "https://dimanyen.github.io/man.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(urlUserDataResponse.self, from: data) {
                        print(userData.response)
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func getFriends1Data() {
        friendDataList.response.removeAll()
        if let url = URL(string: "https://dimanyen.github.io/friend1.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(urlFriendResponse.self, from: data) {
                        friendDataList.response.append(contentsOf: userData.response)
                        self.getFriends2Data()
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func getFriends2Data() {
        var newArray = urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
        newArray.response.removeAll()
        lastArray.response.removeAll()
        if let url = URL(string: "https://dimanyen.github.io/friend2.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(urlFriendResponse.self, from: data) {
                        friendDataList.response.append(contentsOf: userData.response)
                        
                        var count=0
                        for i in friendDataList.response {
                            friendDataList.response[count].updateDate =  i.updateDate.filter { $0 != "/" }
                            count += 1
                        }
                        
                        for i in friendDataList.response{
                            if (newArray.response.filter{$0.fid == i.fid}).count == 0 {
                                newArray.response.append(i)
                                }
                        }
                        for i in newArray.response{
                            for j in friendDataList.response {
                                if i.fid == j.fid && Int(i.updateDate)! < Int(j.updateDate)! {
                                    lastArray.response.append(j)
                                }else if i.fid == j.fid && Int(i.updateDate)! > Int(j.updateDate)! {
                                    lastArray.response.append(i)
                                }
                            }
                        }
                        
                        for i in newArray.response{
                            if (lastArray.response.filter{$0.fid == i.fid}).count == 0 {
                                lastArray.response.append(i)
                                }
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func getFriends3Data() {
        lastArray.response.removeAll()
        if let url = URL(string: "https://dimanyen.github.io/friend3.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(urlFriendResponse.self, from: data) {
                        for i in userData.response {
                            lastArray.response.append(i)
                        }
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
    
    func getFriends4Data() {
        if let url = URL(string: "https://dimanyen.github.io/friend4.json") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let response = response as? HTTPURLResponse,let data = data {
                    print("Status code: \(response.statusCode)")
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(urlFriendResponse.self, from: data) {
                        print(userData.response)
                    }
                }
            }.resume()
        } else {
            print("Invalid URL.")
        }
    }
}
extension Array where Element: Hashable {
  func removingDuplicates() -> [Element] {
      var addedDict = [Element: Bool]()
      return filter {
        addedDict.updateValue(true, forKey: $0) == nil
      }
   }
   mutating func removeDuplicates() {
      self = self.removingDuplicates()
   }
}
