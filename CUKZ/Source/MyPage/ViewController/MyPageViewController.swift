//
//  MyPageViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/18/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: - Properties
    var nickName: String? = nil
    var role: String? = nil
    
    private let myPageSection = MyPageSection()
    
    let myPageView = MyPageView()
    
    // MARK: - View 설정
    override func loadView() {
        view = myPageView
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - ViewDidLodad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepare()
        setupTableView()
    }
    
    private func prepare() {
        
    }
    
    private func setupTableView() {
        let tb = myPageView.tableView
        
        tb.register(MyPageCell.self, forCellReuseIdentifier: "MyPageCell")
        tb.dataSource = self
        tb.delegate = self
        
        // 헤더뷰 설정
        let myPageTopView = MyPageTopView(frame: CGRect(x: 0, y: 0, width: 0, height: 150))
        myPageTopView.nicknameLabel.text = self.nickName
        if self.role == "user" {
            myPageTopView.leaderLabel.text = "총대인증 ❌"
        } else {
            myPageTopView.leaderLabel.text = "총대인증 ✅"
        }
        tb.tableHeaderView = myPageTopView
    }
}

extension MyPageViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myPageSection.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return myPageSection.sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return myPageSection.section0.count
        case 1:
            return myPageSection.section1.count
        case 2:
            return myPageSection.section2.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell", for: indexPath) as! MyPageCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = myPageSection.section0[indexPath.row]
        case 1:
            cell.titleLabel.text = myPageSection.section1[indexPath.row]
        case 2:
            cell.titleLabel.text = myPageSection.section2[indexPath.row]
        default:
            cell.titleLabel.text = ""
        }
        
        return cell
    }
}


extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
