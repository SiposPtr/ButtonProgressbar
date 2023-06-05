import UIKit

public class ButtonProgressbar: UIButton {
    
    private var progressLayer: CAShapeLayer!
    private var startAngle: CGFloat!
    public init(frame: CGRect, start: Float, pos: Position) {
        super.init(frame: frame)
        setupProgressLayer()
        startAngle = CGFloat(start)
        self.pos = pos
    }
    
    public var pos: Position!
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProgressLayer()
    }
    
    private func setupProgressLayer() {
        let lineWidth: CGFloat = 4.0
        let progressColor = UIColor.blue.cgColor
        
        progressLayer = CAShapeLayer()
        progressLayer.strokeColor = progressColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = nil
        progressLayer.strokeEnd = 0.0
        
        layer.addSublayer(progressLayer)
    }
    
    public func setProgress(_ progress: Double) {
        let clampedProgress = max(0.0, min(progress, 1.0))
        progressLayer.strokeEnd = CGFloat(clampedProgress)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - progressLayer.lineWidth) / 5
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
        }
        titleLabel?.center = textPosition
    }
}

public enum Position {
    case left, right, top, bottom
}
