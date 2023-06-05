import UIKit

public class ButtonProgressbar: UIButton {

    private var progressLayer: CAShapeLayer!
    private var loadingLabel: UILabel!
    private var startAngle: CGFloat!
    private var progressColor: UIColor

    public init(frame: CGRect, start: Float, pos: Position, cornerRadius: Double, borderWidth: Double, borderColor: CGColor, progressColor: CGColor) {
        self.progressColor = UIColor(cgColor: progressColor) ?? UIColor.gray // Provide a default color, such as gray

        super.init(frame: frame)

        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.masksToBounds = true
        setupProgressLayer()
        startAngle = CGFloat(start)
        self.pos = pos
        setupLoadingLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var pos: Position!

    private func setupProgressLayer() {
        let lineWidth: CGFloat = 4.0

        progressLayer = CAShapeLayer()
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = nil
        progressLayer.strokeEnd = 0.0

        layer.addSublayer(progressLayer)
    }
    
    private func setupLoadingLabel() {
        loadingLabel = UILabel(frame: bounds)
        loadingLabel.textAlignment = .center
        loadingLabel.textColor = .white
        loadingLabel.font = UIFont.systemFont(ofSize: 20.0)
        addSubview(loadingLabel)
    }

    public func setProgress(_ progress: Double) {
        let clampedProgress = max(0.0, min(progress, 1.0))

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = CGFloat(clampedProgress)
        animation.duration = 0.3 // Set the duration of the animation to your desired value
        progressLayer.strokeEnd = CGFloat(clampedProgress)
        progressLayer.add(animation, forKey: "progressAnimation")
        
        loadingLabel.text = "\(Int(progress * 100))%" // Display the progress percentage
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
        startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = circularPath.cgPath
        
        loadingLabel.frame = bounds

        // Position the text relative to the progressLayer
        let textPosition: CGPoint
        switch pos {
        case .left:
            textPosition = CGPoint(x: center.x - radius, y: center.y)
        case .right:
            textPosition = CGPoint(x: center.x + radius, y: center.y)
        case .top:
            textPosition = CGPoint(x: center.x, y: center.y - radius)
        case .bottom:
            textPosition = CGPoint(x: center.x, y: center.y + radius)
        default:
            textPosition = CGPoint(x: center.x - radius, y: center.y)
        }
        loadingLabel.center = textPosition

        // Apply the fade animation
        UIView.animate(withDuration: 0.3, animations: {
            self.loadingLabel.alpha = 0.0
        }) { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.loadingLabel.alpha = 1.0
            })
        }
    }
}

public enum Position {
    case left, right, top, bottom
}
