//
//  allFriendsViewcontroller.swift
//  kokofriends
//
//  Created by crawford on 2023/7/29.
//

import UIKit

class allFriendsViewcontroller: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var friendListTableView: UITableView!
    @IBOutlet weak var labelOfChatTip: UILabel!
    @IBOutlet weak var labelOfFriendsTip: UILabel!
    @IBOutlet weak var textOfSearch: UITextField!
    @IBOutlet weak var viewOfUserData: UIView!
    var refreshControl:UIRefreshControl!
    @IBOutlet weak var viewOfMenu: UIView!
    
    override func viewDidLoad() {
        refreshControl = UIRefreshControl()
        friendListTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(loadData), for: UIControl.Event.valueChanged)
        
        textOfSearch.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWasShown(_:)),
        name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillBeHidden(_:)),
        name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        overrideUserInterfaceStyle = .light
        friendListTableView.delegate = self
        friendListTableView.dataSource = self
        self.friendListTableView.rowHeight = 70
        labelOfFriendsTip.layer.cornerRadius = labelOfFriendsTip.bounds.size.width/2
        labelOfFriendsTip.layer.masksToBounds = true
        labelOfChatTip.layer.cornerRadius = labelOfChatTip.bounds.size.width/2
        labelOfChatTip.layer.masksToBounds = true
        
        
        DispatchQueue.global().async {
            Webservice().getFriends1Data()
                DispatchQueue.main.async {
                    self.friendListTableView.reloadData()
            }
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 2 {
            var statusCount = 0
            for i in lastArray.response {
                if i.status == 0 || i.status == 1 || i.status == 2 {
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
        var array2 =  urlFriendResponse(response: [friendDataResponse(name: "", status: 0, isTop: "", fid: "", updateDate: "")])
        array2.response.removeAll()
        for i in lastArray.response{
            print(i.status)
            if (i.status == 0) || (i.status == 1) || (i.status == 2) {
                array2.response.append(i)
            }
            
        }
        
        switch (tableView.tag) {
            
        case 1:
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
        Webservice().getFriends1Data()
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
        let contentInsets = viewOfUserData.bounds.height + viewOfMenu.bounds.maxY
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0) {
                self.view.bounds.origin.y = contentInsets
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: NSNotification) {
        self.view.bounds.origin.y = 0
    }

}
