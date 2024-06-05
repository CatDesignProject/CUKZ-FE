//
//  MyPageViewController.swift
//  CUKZ
//
//  Created by 이승민 on 3/18/24.
//

import UIKit

final class MyPageViewController: UIViewController, MyPageTopViewDelegate {
    // MARK: - Properties
    private var userInfoData: UserModel?
    
    private let myPageSection = MyPageSection()
    
    var isLoggedOut: Bool = false // 로그아웃 여부
    
    let myPageView = MyPageView()
    
    // MARK: - View 설정
    override func loadView() {
        view = myPageView
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        fetchData()
        
        if isLoggedOut { // 로그아웃 하고 처음 들어왔을 때
            fetchData()
            isLoggedOut = false
        }
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchData()
        setupNaviBar()
        setupTableView()
    }
    
    func fetchData() {
        UserNetworkManager.shared.getUserInfo { result in
            switch result {
            case .success(let data):
                self.userInfoData = data
                AppDelegate.role = data.role
                DispatchQueue.main.async {
                    self.updateHeaderView()
                }
            case .failure(let error):
                print("내 정보 조회 - \(error)")
            }
        }
    }
    
    private func setupNaviBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .gadaeBlue
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
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
        
        switch data.role {
        case "user":
            myPageTopView.leaderLabel.text = "총대 ❌"
        case "manager":
            myPageTopView.leaderLabel.text = "총대 ✅"
        case "admin":
            myPageTopView.leaderLabel.text = "관리자 🛠️"
        default:
            break
        }
        
        myPageTopView.delegate = self
        
        myPageView.tableView.tableHeaderView = myPageTopView
    }
    
    func requestLeaderButtonTapped() {
        if AppDelegate.role == "manager" {
            showAlertWithDismissDelay(message: "이미 총대 신청을 했습니다.")
        } else {
            let VC = UINavigationController(rootViewController: RequestLeaderViewController())
            VC.modalPresentationStyle = .fullScreen
            self.present(VC, animated: true, completion: nil) // 로그인 화면 모달로 뜨게
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 { // 내가 작성한 상품
                guard AppDelegate.role != "user" else {
                    showAlertWithDismissDelay(message: "총대신청을 진행해주세요.")
                    return
                }
                
                let VC = ProductHomeViewController()
                VC.hidesBottomBarWhenPushed = true // 탭바 숨기기
                VC.isMyproduct = true
                navigationController?.pushViewController(VC, animated: true)
            }
            if indexPath.row == 1 { // 내가 참여한 수요조사
                let VC = AllDemandUserViewController()
                VC.hidesBottomBarWhenPushed = true // 탭바 숨기기
                navigationController?.pushViewController(VC, animated: true)
            }
        case 2:
            if indexPath.row == 0 { // 로그아웃
                print("로그아웃 버튼 클릭됨")
                let sheet = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
                sheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
                sheet.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                    UserNetworkManager.shared.postLogout { error in
                        if let error = error {
                            print("로그아웃 실패: \(error.localizedDescription)")
                        } else {
                            print("로그아웃 성공")
                            AppDelegate.isLogin = false
                            AppDelegate.memberId = -1
                            AppDelegate.role = ""
                            
                            if let tabBarControllers = self.tabBarController?.viewControllers {
                                for vc in tabBarControllers {
                                    if let navVC = vc as? UINavigationController, let likeVC = navVC.viewControllers.first(where: { $0 is LikeViewController }) as? LikeViewController {
                                        likeVC.isLoggedOut = true
                                    }
                                    
                                    if let navVC = vc as? UINavigationController, let myPageVC = navVC.viewControllers.first(where: { $0 is MyPageViewController }) as? MyPageViewController {
                                        myPageVC.isLoggedOut = true
                                    }
                                }
                            }
                            
                            // 탭바의 첫 번째 탭으로 이동
                            if let tabBarController = self.tabBarController {
                                tabBarController.selectedIndex = 0
                                self.showAlertWithDismissDelay(message: "로그아웃 되었습니다.")
                            }
                        }
                    }
                }))
                present(sheet, animated: true)
            }
        default:
            break
        }
    }
}
