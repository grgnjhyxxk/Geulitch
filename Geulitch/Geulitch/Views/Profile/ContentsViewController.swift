//
//  ContentsViewController.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/21/24.
//

import UIKit
import Aquaman
import SkeletonView

final class ContentsViewController: UIViewController, AquamanChildViewController {
    enum ContentType {
        case post
        case series
        
        var cellCount: Int {
            switch self {
            case .post:
                return 12
            case .series:
                return 2
            }
        }
    }
    
    var isLoading = true

    private let contentType: ContentType
    
    private let viewHolder = ViewHolder()
    
    required init(with type: ContentType) {
        self.contentType = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bind()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.viewHolder.layoutView.reloadData()
            self.viewHolder.layoutView.reloadData()
        }
    }
    
    func aquamanChildScrollView() -> UIScrollView {
        viewHolder.layoutView
    }
    
    func reload() {
        viewHolder.layoutView.reloadData()
    }
}

private extension ContentsViewController {
    func setUI() {
        viewHolder.configureSubviews(view)
        viewHolder.configureConstraints(view)
    }
    
    func bind() {
        viewHolder.layoutView.delegate = self
        viewHolder.layoutView.dataSource = self
    }
}

extension ContentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 3
        } else {
            return contentType.cellCount
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoading {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonTableViewCell.identifier, for: indexPath) as? SkeletonTableViewCell else {
             return UITableViewCell()
            }
            
            DispatchQueue.main.async {
                let animationDuration: TimeInterval = 1.0
                let animation = SkeletonAnimationBuilder()
                    .makeSlidingAnimation(withDirection: .leftRight, duration: animationDuration)
                let gradient = SkeletonGradient(baseColor: UIColor.skeleton)
                cell.showAnimatedGradientSkeleton(usingGradient: gradient, animation: animation)
            }
            
            return cell
         }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedTableCustomCell.identifier, for: indexPath) as? RecommendedTableCustomCell else {
            return UITableViewCell()
        }
        
        switch contentType {
        case .post:
            cell.postTitleTextLabel.text = "포스트 \(indexPath.row + 1) 제목"
            cell.postBlurbTextLabel.text = "포스트 \(indexPath.row + 1)의 간단한 설명입니다. 이 설명은 포스트의 내용을 미리 보여줍니다. 길이를 더욱 늘리기 위한 발악."
        case .series:
            cell.postTitleTextLabel.text = "시리즈 \(indexPath.row + 1) 제목"
            cell.postBlurbTextLabel.text = "시리즈 \(indexPath.row + 1)의 간단한 설명입니다. 이 설명은 시리즈의 내용을 미리 보여줍니다. 길이를 더욱 늘리기 위한 발악."
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 188
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("tab cell \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isLoading {
            cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
        } else {
            cell.separatorInset = .zero
        }
    }
}

extension ContentsViewController {
    final class ViewHolder {
        private(set) lazy var layoutView: UITableView = {
            let view = UITableView()
            
            view.showsHorizontalScrollIndicator = false
            view.showsVerticalScrollIndicator = false
            view.backgroundColor = UIColor.primaryBackgroundColor
            view.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            view.register(RecommendedTableCustomCell.self, forCellReuseIdentifier: RecommendedTableCustomCell.identifier)
            view.register(SkeletonTableViewCell.self, forCellReuseIdentifier: SkeletonTableViewCell.identifier)
            
            return view
        }()
        
        func configureSubviews(_ view: UIView) {
            view.addSubview(layoutView)
        }
        
        func configureConstraints(_ view: UIView) {
            layoutView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}
