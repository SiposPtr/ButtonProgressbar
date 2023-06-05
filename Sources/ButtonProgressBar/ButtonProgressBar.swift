import UIKit

public class ButtonProgressbar: UIButton {
    
    private var progressLayer: CAShapeLayer!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupProgressLayer()
    }
    
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
    
    public func setProgress(_ progress: CGFloat) {
        progressLayer.strokeEnd = progress
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (min(bounds.width, bounds.height) - progressLayer.lineWidth) / 2
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi
        
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = circularPath.cgPath
    }
}
