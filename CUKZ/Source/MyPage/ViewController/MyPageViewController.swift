//
//  MyPageViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/18/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    // MARK: - Properties
    private var userInfoData: UserModel?
    
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
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        setupTableView()
        setupRefresh()
    }
    
    private func fetchData() {
        UserNetworkManager.shared.getUserInfo { result in
            switch result {
            case .success(let data):
                self.userInfoData = data
                DispatchQueue.main.async {
                    self.updateHeaderView()
                }
            case .failure(let error):
                print("내 정보 조회 - \(error)")
            }
        }
    }
    
    // 테이블뷰 설정
    private func setupTableView() {
        let tb = myPageView.tableView
        
        tb.register(MyPageCell.self, forCellReuseIdentifier: "MyPageCell")
        tb.dataSource = self
        tb.delegate = self
    }
    
    // 테이블뷰 헤더뷰 설정
    private func updateHeaderView() {
        guard let data = userInfoData else { return }
        
        let myPageTopView = MyPageTopView(frame: CGRect(x: 0, y: 0, width: myPageView.tableView.bounds.width, height: 150))
        myPageTopView.nicknameLabel.text = data.nickname
        myPageTopView.leaderLabel.text = (data.role == "user") ? "총대인증 ❌" : "총대인증 ✅"
        myPageView.tableView.tableHeaderView = myPageTopView
    }
    
    // 새로고침 설정
    private func setupRefresh() {
        let rc = myPageView.refreshControl
        rc.addTarget(self, action: #selector(refreshTable(refresh:)), for: .valueChanged)
        rc.tintColor = .gadaeBlue
        
        myPageView.tableView.refreshControl = rc
    }
}

// MARK: - @objc
extension MyPageViewController {
    // 새로고침
    @objc func refreshTable(refresh: UIRefreshControl) {
        print("새로고침 시작")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchData()
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UITableViewDelegate
extension MyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
