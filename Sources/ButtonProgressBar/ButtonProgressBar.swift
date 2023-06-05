import UIKit


public class ButtonProgressbar: UIButton {

    private var progressLayer: CAShapeLayer!
    private var startAngle: CGFloat!
    private var progressColor: UIColor

    public init(frame: CGRect, start: Float, pos: Position, cornerRadius: Double, borderWidth: Double, borderColor: CGColor, progressColor: CGColor) {
        self.progressColor = UIColor(cgColor: progressColor) ?? UIColor.gray // Provide a default color, such as gray

        super.init(frame: frame)

        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        setupProgressLayer()
        startAngle = CGFloat(start)
        self.pos = pos
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

    public func setProgress(_ progress: Double) {
        let clampedProgress = max(0.0, min(progress, 1.0))

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = progressLayer.strokeEnd
        animation.toValue = CGFloat(clampedProgress)
        animation.duration = 0.3 // Set the duration of the animation to your desired value
        progressLayer.strokeEnd = CGFloat(clampedProgress)
        progressLayer.add(animation, forKey: "progressAnimation")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - progressLayer.lineWidth) / 8
        startAngle = -CGFloat.pi / 5
        let endAngle = startAngle + 2 * CGFloat.pi

        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = circularPath.cgPath

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
        titleLabel?.center = textPosition
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        animateButtonScale(scaleFactor: 0.9)
    }

    private func animateButtonScale(scaleFactor: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        }
    }

}

public enum Position {
    case left, right, top, bottom
}
