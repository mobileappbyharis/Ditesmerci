//
//  ContainerViewController.swift
//  Ditesmerci
//
//  Created by 7k04 on 05/08/2019.
//  Copyright © 2019 mobileappbyharis. All rights reserved.
//


import UIKit

class ContainerViewController: UIViewController {
    enum SlideOutState {
        case bothCollapsed
        case rightPanelExpanded
    }
    
    var profileNavigationController: UINavigationController!
    var profileViewController: ProfileViewController!
    var firstName = "none"
    var lastName = "none"
    var panGestureRecognizer: UIGestureRecognizer!
    
    var currentState: SlideOutState = .bothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .bothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    
    var rightViewController: SidePanelViewController?
    
    let centerPanelExpandedOffset: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileViewController = ProfileViewController()
        profileViewController.delegate = self
        
        // wrap the centerViewController in a navigation controller, so we can push views to it
        // and display bar button items in the navigation bar
        profileNavigationController = UINavigationController(rootViewController: profileViewController)
        
        view.addSubview(profileNavigationController.view)
        addChild(profileNavigationController)
        
        profileNavigationController.didMove(toParent: self)
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))

    }
}

// MARK: CenterViewController delegate

extension ContainerViewController: ProfileViewControllerDelegate {
    func giveName(firstName: String, lastName: String){
        self.lastName = lastName
        self.firstName = firstName
    }
    
    func toggleRightPanel(firstName: String, lastName: String) {
        self.lastName = lastName
        self.firstName = firstName
        let notAlreadyExpanded = (currentState != .rightPanelExpanded)
        
        if notAlreadyExpanded {
            addRightPanelViewController(firstName: firstName, lastName: lastName)
        }

        animateRightPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func enableGesture(){
        profileNavigationController.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func disableGesture(){
        profileNavigationController.view.removeGestureRecognizer(panGestureRecognizer)
    }
    
    func addRightPanelViewController(firstName: String, lastName: String) {
        guard rightViewController == nil else { return }
        let sidePanelViewController = SidePanelViewController()
        addChildSidePanelController(sidePanelViewController)
        rightViewController = sidePanelViewController
        rightViewController?.firstName = firstName
        rightViewController?.lastName = lastName
        
    }
    
    func animateRightPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .rightPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: -profileNavigationController.view.frame.width + centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { _ in
                self.currentState = .bothCollapsed
                
                self.rightViewController?.view.removeFromSuperview()
                self.rightViewController = nil
            }
        }
    }
    
    func collapseSidePanels() {
        switch currentState {
        case .rightPanelExpanded:
            toggleRightPanel(firstName: self.firstName , lastName: self.lastName)
        default:
            break
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.profileNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
    func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
        sidePanelController.delegate = profileViewController
        view.insertSubview(sidePanelController.view, at: 0)
        addChild(sidePanelController)
        sidePanelController.didMove(toParent: self)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        if shouldShowShadow {
            profileNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            profileNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
}

 //MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)

        switch recognizer.state {
        case .began:
            if currentState == .bothCollapsed {
                if gestureIsDraggingFromLeftToRight {

                } else {
                    print(firstName)
                    addRightPanelViewController(firstName: self.firstName, lastName: self.lastName)
                }

                showShadowForCenterViewController(true)
            }

        case .changed:
            if let rview = recognizer.view {
                rview.center.x = rview.center.x + recognizer.translation(in: view).x
                recognizer.setTranslation(CGPoint.zero, in: view)
            }

        case .ended:
            if let _ = rightViewController,
                let rview = recognizer.view {
                let hasMovedGreaterThanHalfway = rview.center.x < 0
                animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }

        default:
            break
        }
    }
}
