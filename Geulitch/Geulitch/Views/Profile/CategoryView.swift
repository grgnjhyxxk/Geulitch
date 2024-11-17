//
//  CategoryView.swift
//  Geulitch
//
//  Created by Jaehyeok Lim on 10/21/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CategoryView: UIView {
    enum Category {
        case post
        case series
    }
    
    typealias ChangeCategoryAction = ((Category) -> Void)
    
    var changeCategoryAction: ChangeCategoryAction?
    
    var selectedCategory: Category? {
        didSet { update() }
    }
    
    private var disposeBag = DisposeBag()
    
    private lazy var layoutView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        
        return view
    }()
    
    private lazy var postButton: Button = {
        let button = Button(with: "게시글")
        button.isSelected = true
        
        return button
    }()
    
    private lazy var seriesButton: Button = {
        Button(with: "시리즈")
    }()
    
    private lazy var bottomDefaultLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.separator
        return view
     }()
    
    private lazy var bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.AccentButtonBackgroundColor
        return view
     }()
     
    private var bottomLineLeadingConstraint: NSLayoutConstraint?
     
    init() {
        super.init(frame: .zero)

        prepare()

        configureSubviews()
        configureConstraints()

        bindEvents()

        setupBottomLine()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        prepare()
        
        configureSubviews()
        configureConstraints()
        
        bindEvents()
    }
    
    private func prepare() {
        backgroundColor = UIColor.primaryBackgroundColor
    }
    
    private func configureSubviews() {
        addSubview(layoutView)
        
        layoutView.addArrangedSubview(postButton)
        layoutView.addArrangedSubview(seriesButton)
    }
    
    private func configureConstraints() {
        layoutView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    private func bindEvents() {
        postButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeCategoryAction?(.post)
                owner.changeButtons(with: .post)
            }
            .disposed(by: disposeBag)
        
        seriesButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.changeCategoryAction?(.series)
                owner.changeButtons(with: .series)
            }
            .disposed(by: disposeBag)
    }
    
    private func update() {
        guard let selectedCategory else { return }
        
        changeButtons(with: selectedCategory)
    }
    
    private func setupBottomLine() {
        addSubview(bottomDefaultLine)
        addSubview(bottomLine)
        
        bottomDefaultLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        
        bottomDefaultLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(bottomLine)
            make.height.equalTo(0.5)
        }
        
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomLine.widthAnchor.constraint(equalTo: layoutView.widthAnchor, multiplier: 1/2).isActive = true
        
        bottomLineLeadingConstraint = bottomLine.leadingAnchor.constraint(equalTo: layoutView.leadingAnchor)
        bottomLineLeadingConstraint?.isActive = true
    }
    
    func moveBottomLine(to category: Category) {
        let multiplier: CGFloat
        switch category {
        case .post:
            multiplier = 0.0
        case .series:
            multiplier = 1.0
        }
        
        let newConstant = (layoutView.frame.width / 2) * multiplier
        bottomLineLeadingConstraint?.constant = newConstant
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func changeButtons(with category: Category) {
        postButton.isSelected = category == .post
        seriesButton.isSelected = category == .series
        
        moveBottomLine(to: category)
    }
}

extension CategoryView {
    final class Button: UIButton {
        private var text: String?
        
        override var isSelected: Bool {
            didSet { update() }
        }
        
        convenience init(with text: String) {
            self.init(frame: .zero)
            
            self.text = text
            
            setup()
        }
        
        private func setup() {
            setTitle(text, for: .normal)
            setTitleColor(UIColor.darkGray, for: .normal)
            titleLabel?.font = UIFont.notoSans(size: 15, weight: .semibold)
        }
        
        private func update() {
            let textColor: UIColor = isSelected ? .primaryTextColor : UIColor.darkGray
            setTitleColor(textColor, for: .normal)
        }
    }
}
