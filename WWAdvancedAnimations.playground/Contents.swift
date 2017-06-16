
import UIKit
import PlaygroundSupport

final class CommentsViewController: UIViewController
{
    let topBarHeight: CGFloat = 50.0
    let bottomBarHeight: CGFloat = 50.0
    
    lazy var headerView: UIView =
    {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: self.topBarHeight).isActive = true
        return headerView
    }()
    
    lazy var bottomView: UIView =
    {
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bottomView)
        bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: self.bottomBarHeight).isActive = true
        return bottomView
    }()
    
    lazy var bottomLabel: UILabel =
    {
        let bottomLabel = UILabel()
        bottomLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        self.bottomView.addSubview(bottomLabel)
        bottomLabel.centerXAnchor.constraint(equalTo: self.bottomView.centerXAnchor).isActive = true
        bottomLabel.centerYAnchor.constraint(equalTo: self.bottomView.centerYAnchor).isActive = true
        bottomLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        return bottomLabel
    }()
    
    lazy var inLabel: UILabel =
    {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.preferredFont(forTextStyle: .body)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor).isActive = true
        headerLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        return headerLabel
    }()
    
    lazy var outLabel: UILabel =
    {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.systemFont(ofSize: 36, weight: .black)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor).isActive = true
        headerLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        headerLabel.alpha = 0.0
        return headerLabel
    }()
    
    lazy var tableView: UITableView =
    {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomView.topAnchor).isActive = true
        return tableView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        inLabel.text = "Comments"
        outLabel.text = "Comments"
        bottomLabel.text = "Add Comment"
        tableView.backgroundColor = .white
    }
}

final class PhotoViewController: UIViewController
{
    
    enum State
    {
        case expanded
        case collapsed
    }
    
    let bottomBarHeight: CGFloat = 50.0
    var containerViewTopLayoutConstraint: NSLayoutConstraint!
    var runningAnimators = [UIViewPropertyAnimator]()
    var progressWhenInterrupted = [CGFloat]()
    var state = State.collapsed
    let animationDuration: TimeInterval = 0.5
    
    lazy var visualEffectView: UIVisualEffectView =
    {
        let visualEffectView = UIVisualEffectView()
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.view.insertSubview(visualEffectView, belowSubview: self.containerView)
        visualEffectView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        visualEffectView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        visualEffectView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        visualEffectView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        return visualEffectView
    }()
    
    lazy var headerView: UIView =
    {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(headerView)
        headerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        return headerView
    }()
    
    lazy var backButton: UIButton =
    {
        let backButton = UIButton()
        let back = UIImage(named: "back.png")!.withRenderingMode(.alwaysTemplate)
        backButton.setImage(back, for: .normal)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addSubview(backButton)
        backButton.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 8.0).isActive = true
        backButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 40.0).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        backButton.contentMode = .scaleAspectFit
        return backButton
    }()
    
    lazy var headerLabel: UILabel =
    {
        let headerLabel = UILabel()
        headerLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: self.headerView.centerXAnchor).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor).isActive = true
        headerLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200.0).isActive = true
        return headerLabel
    }()
    
    lazy var imageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.bottomBarHeight).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var containerView: UIView =
    {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerView)
        self.containerViewTopLayoutConstraint = containerView.topAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -self.bottomBarHeight)
        self.containerViewTopLayoutConstraint.isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        return containerView
    }()
    
    lazy var commentsChildViewController: CommentsViewController =
    {
        let commentsChildViewController = CommentsViewController()
        self.addChildViewController(commentsChildViewController)
        commentsChildViewController.view.frame = self.containerView.bounds
        self.containerView.addSubview(commentsChildViewController.view)
        commentsChildViewController.view.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        commentsChildViewController.view.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        commentsChildViewController.view.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true
        commentsChildViewController.view.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor).isActive = true
        commentsChildViewController.didMove(toParentViewController: self)
        commentsChildViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        commentsChildViewController.view.layer.masksToBounds = true
        return commentsChildViewController
    }()
    
    lazy var detailsButton: UIButton =
    {
        let detailButton = UIButton()
        detailButton.translatesAutoresizingMaskIntoConstraints = false
        self.visualEffectView.contentView.addSubview(detailButton)
        detailButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -12.0).isActive = true
        detailButton.centerYAnchor.constraint(equalTo: self.headerView.centerYAnchor).isActive = true
        detailButton.setTitleColor(.orange, for: .normal)
        detailButton.alpha = 0.0
        return detailButton
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .white
        headerLabel.text = "Sam's Photo"
        imageView.image = UIImage(named: "parcourguy.png")!
        commentsChildViewController.view.backgroundColor = .blue
        backButton.addTarget(self, action: #selector(self.didPressBack), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressBack))
        commentsChildViewController.view.addGestureRecognizer(tapGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(recognizer:)))
        commentsChildViewController.view.addGestureRecognizer(panGesture)
        detailsButton.setTitle("Details", for: .normal)
    }
    
    func animateTransitionIfNeeded(state: State, duration: TimeInterval)
    {
        if runningAnimators.isEmpty
        {
            let frameAnimator = self.frameAnimator(duration: duration, state: state)
            frameAnimator.startAnimation()
            runningAnimators.append(frameAnimator)
            
            let blurAnimator = self.blurAnimator(duration: duration, state: state)
            blurAnimator.startAnimation()
            runningAnimators.append(blurAnimator)
            
            switch state
            {
            case .collapsed:
                let outLabelScale = CGAffineTransform(scaleX: self.commentsChildViewController.inLabel.bounds.width / self.commentsChildViewController.outLabel.bounds.width, y: self.commentsChildViewController.inLabel.bounds.height / self.commentsChildViewController.outLabel.bounds.height)
                self.commentsChildViewController.outLabel.transform = outLabelScale.concatenating(CGAffineTransform(translationX: 0.0, y: -5.0))
            case .expanded:
                let inLabelScale = CGAffineTransform(scaleX: self.commentsChildViewController.outLabel.bounds.width / self.commentsChildViewController.inLabel.bounds.width, y: self.commentsChildViewController.outLabel.bounds.height / self.commentsChildViewController.inLabel.bounds.height)
                self.commentsChildViewController.inLabel.transform = inLabelScale.concatenating(CGAffineTransform(translationX: 0.0, y: 0.0))
            }
            
            let transformAnimator = self.transformAnimator(duration: duration, state: state)
            transformAnimator.startAnimation()
            runningAnimators.append(transformAnimator)
            
            let outLabelAnimator = self.outLabelAnimator(duration: duration, state: state)
            outLabelAnimator.scrubsLinearly = false
            outLabelAnimator.startAnimation()
            runningAnimators.append(outLabelAnimator)
            
            let inLabelAnimator = self.inLabelAnimator(duration: duration, state: state)
            inLabelAnimator.scrubsLinearly = false
            inLabelAnimator.startAnimation()
            runningAnimators.append(inLabelAnimator)
            
            let cornerAnimator = self.cornerAnimator(duration: duration, state: state)
            cornerAnimator.startAnimation()
            runningAnimators.append(cornerAnimator)
            
            let buttonAnimator = self.buttonAnimator(duration: duration, state: state)
            buttonAnimator.startAnimation()
            runningAnimators.append(buttonAnimator)
            
            switchState()
        }
    }
    
    func frameAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
        {[unowned self] in
            switch state
            {
            case .expanded:
                self.containerViewTopLayoutConstraint.constant = -self.bottomBarHeight
            case .collapsed:
                self.containerViewTopLayoutConstraint.constant = -self.view.bounds.height + self.bottomBarHeight
            }
            self.view.layoutIfNeeded()
        }
        frameAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: frameAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
            if position == .start
            {
                switch state
                {
                case .expanded:
                    self.containerViewTopLayoutConstraint.constant = -self.view.bounds.height + self.bottomBarHeight
                case .collapsed:
                    self.containerViewTopLayoutConstraint.constant = -self.bottomBarHeight
                }
            }
        }
        return frameAnimator
    }
    
    func blurAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let timing: UITimingCurveProvider
        switch state
        {
        case .collapsed:
            timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.75, y: 0.1), controlPoint2: CGPoint(x: 0.9, y: 0.25))
        case .expanded:
            timing = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.1, y: 0.75), controlPoint2: CGPoint(x: 0.25, y: 0.9))
        }
        let blurAnimator = UIViewPropertyAnimator(duration: duration, timingParameters: timing)
        blurAnimator.scrubsLinearly = false
        blurAnimator.addAnimations
        { [unowned self] in
            switch state
            {
            case .collapsed:
                self.visualEffectView.effect = UIBlurEffect(style: .dark)
            case .expanded:
                self.visualEffectView.effect = nil
            }
        }
        blurAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: blurAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
            if position == .start
            {
                switch state
                {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
        }
        return blurAnimator
    }
    
    func transformAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let transformAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1)
        { [unowned self] in
            switch state
            {
            case .collapsed:
                let inLabelScale = CGAffineTransform(scaleX: self.commentsChildViewController.outLabel.bounds.width / self.commentsChildViewController.inLabel.bounds.width, y: self.commentsChildViewController.outLabel.bounds.height / self.commentsChildViewController.inLabel.bounds.height)
                self.commentsChildViewController.inLabel.transform = inLabelScale.concatenating(CGAffineTransform(translationX: 0, y: 0))
                self.commentsChildViewController.outLabel.transform = .identity
            case .expanded:
                self.commentsChildViewController.inLabel.transform = .identity
                let outLabelScale = CGAffineTransform(scaleX: self.commentsChildViewController.inLabel.bounds.width / self.commentsChildViewController.outLabel.bounds.width, y: self.commentsChildViewController.inLabel.bounds.height / self.commentsChildViewController.outLabel.bounds.height)
                self.commentsChildViewController.outLabel.transform = outLabelScale.concatenating(CGAffineTransform(translationX: 0, y: -5))
            }
        }
        transformAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: transformAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
        }
        return transformAnimator
    }
    
    func inLabelAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let inLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        { [unowned self] in
            switch state
            {
            case .collapsed:
                self.commentsChildViewController.inLabel.alpha = 0
            case .expanded:
                self.commentsChildViewController.inLabel.alpha = 1
            }
        }
        inLabelAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: inLabelAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
        }
        return inLabelAnimator
    }
    
    func outLabelAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let outLabelAnimator = UIViewPropertyAnimator(duration: duration, curve: .easeIn)
        { [unowned self] in
            switch state
            {
            case .collapsed:
                self.commentsChildViewController.outLabel.alpha = 1
            case .expanded:
                self.commentsChildViewController.outLabel.alpha = 0
            }
        }
        outLabelAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: outLabelAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
        }
        return outLabelAnimator
    }
    
    func cornerAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let cornerAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        { [unowned self] in
            switch state
            {
            case .collapsed:
                self.commentsChildViewController.view.layer.cornerRadius = 30.0
            case .expanded:
                self.commentsChildViewController.view.layer.cornerRadius = 0.0
            }
        }
        cornerAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: cornerAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
        }
        return cornerAnimator
    }
    
    func buttonAnimator(duration: TimeInterval, state: State) -> UIViewPropertyAnimator
    {
        let buttonAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        { [unowned self] in
            UIView.animateKeyframes(withDuration: 0.0, delay: 0.0, options: [], animations: {
                switch state
                {
                case .collapsed:
                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5)
                    {
                        self.detailsButton.alpha = 1.0
                    }
                case .expanded:
                    UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5)
                    {
                        self.detailsButton.alpha = 0.0
                    }
                }
            }, completion: nil)
            
        }
        buttonAnimator.addCompletion
        { [unowned self] (position) in
            if let index = self.runningAnimators.index(of: buttonAnimator)
            {
                self.runningAnimators.remove(at: index)
            }
        }
        return buttonAnimator
    }
    
    func animateOrReverseRunningTransition(state: State, duration: TimeInterval)
    {
        if runningAnimators.isEmpty
        {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        else
        {
            runningAnimators.forEach { $0.isReversed = !$0.isReversed }
            switchState()
        }
    }
    
    func switchState()
    {
        switch state
        {
        case .expanded:
            self.state = .collapsed
        case .collapsed:
            self.state = .expanded
        }
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer)
    {
        guard let view = recognizer.view else { return }
        let velocity = recognizer.velocity(in: view)
        let translation = recognizer.translation(in: self.view)
        switch recognizer.state
        {
        case .began:
            startInteractiveTransition(state: state, duration: animationDuration)
        case .changed:
            let fraction = abs(translation.y / (self.view.bounds.height - bottomBarHeight * 2.0))
            updateInteractiveTransition(fractionComplete: fraction)
        case .ended:
            let cancel: Bool
            switch state
            {
            case .expanded:
                cancel = velocity.y > 0.0
            case .collapsed:
                cancel = velocity.y < 0.0
            }
            continueInteractiveTransition(cancel: cancel)
        case .cancelled, .failed:
            continueInteractiveTransition(cancel: true)
        case .possible:
            break
        }
    }
    
    func startInteractiveTransition(state: State, duration: TimeInterval)
    {
        animateTransitionIfNeeded(state: state, duration: duration)
        progressWhenInterrupted = runningAnimators.map { $0.fractionComplete }
        runningAnimators.forEach { $0.pauseAnimation() }
    }
    
    func updateInteractiveTransition(fractionComplete: CGFloat)
    {
        let animatorAndProgress = zip(runningAnimators, progressWhenInterrupted)
        animatorAndProgress.forEach {  $0.0.fractionComplete = $0.1 + fractionComplete }
    }
    
    func continueInteractiveTransition(cancel: Bool)
    {
        if cancel
        {
            animateOrReverseRunningTransition(state: state, duration: animationDuration)
        }
        
        let timing = UISpringTimingParameters(dampingRatio: 1)
        runningAnimators.forEach { $0.continueAnimation(withTimingParameters: timing, durationFactor: 0) }
    }
    
    @objc func didPressBack()
    {
        animateOrReverseRunningTransition(state: state, duration: animationDuration)
    }
}

let photoVC = PhotoViewController()
PlaygroundPage.current.liveView = photoVC





