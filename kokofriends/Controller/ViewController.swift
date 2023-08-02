//
//  ViewController.swift
//  kokofriends
//
//  Created by crawford on 2023/7/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var labelOfChatTip: UILabel!
    @IBOutlet weak var inviteListTableView: UITableView!
    @IBOutlet weak var labelOfFriendsTip: UILabel!
    @IBOutlet weak var textOfSearch: UITextField!
    @IBOutlet weak var viewOfUserData: UIView!
    @IBOutlet weak var viewOfMenu: UIView!
    
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad() {
        textOfSearch.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
        name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        
        refreshControl = UIRefreshControl()
        friendListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        overrideUserInterfaceStyle = .light
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        inviteListTableView.delegate = self
        inviteListTableView.dataSource = self
        self.friendListTableView.rowHeight = 70
        self.inviteListTableView.rowHeight = 70
        labelOfFriendsTip.layer.cornerRadius = labelOfFriendsTip.bounds.size.width/2
        labelOfFriendsTip.layer.masksToBounds = true
        labelOfChatTip.layer.cornerRadius = labelOfChatTip.bounds.size.width/2
        labelOfChatTip.layer.masksToBounds = true
        
        DispatchQueue.global().async {
            Webservice().getFriends3Data()
                DispatchQueue.main.async {
                    self.friendListTableView.reloadData()
                    self.inviteListTableView.reloadData()
            }
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 1 {
            var statusCount = 0
            for i in lastArray.response {
                if i.status == 2 {
                    print(lastArray.response)
                    statusCount += 1
                }
            }
            return statusCount
        }
        else if tableView.tag == 2 {
            var statusCount = 0
            for i in lastArray.response {
                if i.status == 0 || i.status == 1 {
                    statusCount += 1
                }
            }
            return statusCount
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : friendListTableViewCell!
        var array1 =  urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
        var array2 =  urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
        array1.response.removeAll()
        array2.response.removeAll()
        for i in lastArray.response{
            print(i.status)
            if (i.status == 0) || (i.status == 1) {
                array2.response.append(i)
                }
            else if (i.status == 2) {
                array1.response.append(i)
                print(array1)
            }
                    }
        
        switch (tableView.tag) {
            
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as? friendListTableViewCell
            cell.imageOfhead2.image = UIImage(named: "imgFriendsList")
            cell.labelOfName2.text = array1.response[indexPath.row].name
            break;
            
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as? friendListTableViewCell
            cell.imageOfTop.isHidden = array2.response[indexPath.row].isTop == "0"
            cell.imageOfhead.image = UIImage(named: "imgFriendsList")
            cell.labelOfName.text = array2.response[indexPath.row].name
            cell.buttonOfRemit.setTitle("轉帳", for: .normal)
            cell.LabelOfInvite.isHidden = (array2.response[indexPath.row].status == 1)
            print(array2.response[indexPath.row].name)
            cell.LabelOfInvite.text = "邀請中"
            break;
            
        default:
            break;
        }
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var foldTag = false
        switch (tableView.tag) {
        case 1:
            if foldTag == false {
                foldTag = true
                var searchArray = urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
                searchArray.response.removeAll()
                
                print("inviteList = \(lastArray)")
                for i in lastArray.response{
                    if (i.status == 2) {
                        searchArray.response.append(i)
                    }
                }
                print(searchArray.response)
                print(searchArray.response.count)
                searchArray.response.removeSubrange(1..<searchArray.response.count)
                print("fold inviteList = \(searchArray)")
                lastArray = searchArray
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    print("inviteList = \(lastArray)")
                    self.inviteListTableView.reloadData()
                }
            }else if foldTag == true {
                foldTag = false
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                    print("inviteList = \(lastArray)")
                    self.inviteListTableView.reloadData()
                }
                
            }
            
            break
        default:
            break
        }
    }
     */
    
    @IBAction func buttonOfSearch(_ sender: Any) {
        var searchArray = urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
        searchArray.response.removeAll()
        
        print("last = \(lastArray)")
        for i in lastArray.response{
            if  i.name.contains(textOfSearch.text!) || textOfSearch.text == "" {
                searchArray.response.append(i)
            }
        }
        print("search = \(searchArray)")
        lastArray = searchArray
        friendListTableView.reloadData()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
        }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
        
    @objc func loadData(){
        Webservice().getFriends3Data()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5) {
                self.refreshControl.endRefreshing()
                self.friendListTableView.reloadData()
                // 滾動到最下方最新的 Data
                //self.friendListTableView.scrollToRow(at: [0,self.data.count - 1], at: UITableViewScrollPosition.bottom, animated: true)
            }
            
        }
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_ :)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    @objc func keyboardWasShown(_ notification: NSNotification) {
        let contentInsets = viewOfUserData.bounds.height + viewOfMenu.bounds.maxY + inviteListTableView.bounds.maxY
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
                self.view.bounds.origin.y = contentInsets
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }
}
