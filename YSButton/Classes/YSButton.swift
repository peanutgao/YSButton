//
//  YSButton.swift
//  Pods
//
//  Created by Joseph Koh on 2024/1/5.
//

import UIKit

// MARK: - YSButtonStyleProtocol

public protocol YSButtonStyleProtocol {
    var backgroundColor: UIColor { get }
    var shadowColor: UIColor? { get }
    var borderColor: UIColor? { get }
    var borderWidth: CGFloat? { get }
    var cornerRadius: CGFloat { get }

    var textColor: UIColor { get }
    var font: UIFont { get }
}

// MARK: - YSButtonDefaultStyle

public class YSButtonDefaultStyle: YSButtonStyleProtocol {
    public var backgroundColor: UIColor { UIColor.clear }
    public var shadowColor: UIColor? { UIColor(red: 0.41, green: 0.61, blue: 0.87, alpha: 1) }
    public var borderColor: UIColor? { nil }
    public var borderWidth: CGFloat? { nil }
    public var cornerRadius: CGFloat { 8 }

    public var font: UIFont { UIFont.systemFont(ofSize: 14) }
    public var textColor: UIColor { UIColor.white }

    public var gradientColors: [CGColor] {
        [
            UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.06, green: 0.44, blue: 0.95, alpha: 1).cgColor,
        ]
    }
}

// MARK: - GrayActionButtonStyle

public class GrayActionButtonStyle: YSButtonStyleProtocol {
    public var backgroundColor: UIColor { UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1) }
    public var shadowColor: UIColor? { nil }
    public var borderColor: UIColor? { nil }
    public var borderWidth: CGFloat? { nil }
    public var cornerRadius: CGFloat { 8 }

    public var font: UIFont { UIFont.systemFont(ofSize: 14) }
    public var textColor: UIColor { UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1) }
}

// MARK: - YSButtonBorderStyle

public class YSButtonBorderStyle: YSButtonStyleProtocol {
    public var backgroundColor: UIColor { UIColor.white }
    public var shadowColor: UIColor? { nil }
    public var borderColor: UIColor? { UIColor(red: 0.06, green: 0.44, blue: 0.95, alpha: 1) }
    public var borderWidth: CGFloat? { 1 }
    public var cornerRadius: CGFloat { 8 }

    public var textColor: UIColor { UIColor(red: 0.06, green: 0.44, blue: 0.95, alpha: 1) }
    public var font: UIFont { UIFont.systemFont(ofSize: 14) }
}

// MARK: - YSButtonNormalStyle

public class YSButtonNormalStyle: YSButtonStyleProtocol {
    public var backgroundColor: UIColor { UIColor.lightGray }
    public var shadowColor: UIColor? { nil }
    public var borderColor: UIColor? { nil }
    public var borderWidth: CGFloat? { nil }
    public var cornerRadius: CGFloat { 8 }

    public var textColor: UIColor { UIColor.black }
    public var font: UIFont { UIFont.systemFont(ofSize: 14) }
}

// MARK: - YSButtonCustomStyle

public class YSButtonCustomStyle: YSButtonStyleProtocol {
    public var backgroundColor: UIColor
    public var shadowColor: UIColor?
    public var borderColor: UIColor?
    public var borderWidth: CGFloat?
    public var cornerRadius: CGFloat
    public var gradientColors: [CGColor]?

    public var textColor: UIColor
    public var font: UIFont

    public init(
        backgroundColor: UIColor,
        textColor: UIColor = UIColor.white,
        font: UIFont = UIFont.systemFont(ofSize: 14),
        cornerRadius: CGFloat = 8,
        shadowColor: UIColor? = nil,
        borderColor: UIColor? = nil,
        borderWidth: CGFloat? = nil,
        gradientColors: [CGColor]? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.shadowColor = shadowColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.textColor = textColor
        self.font = font
        self.cornerRadius = cornerRadius
        self.gradientColors = gradientColors
    }
}

// MARK: - YSButtonStyleFactory

public enum YSButtonStyleFactory {
    public static func build(
        for type: YSButton.StyleType,
        customStyle: YSButtonCustomStyle? = nil
    ) -> YSButtonStyleProtocol {
        switch type {
        case .default:
            YSButtonDefaultStyle()
        case .gray:
            GrayActionButtonStyle()
        case .border:
            YSButtonBorderStyle()
        case .normal:
            YSButtonNormalStyle()
        case .custom:
            customStyle ?? YSButtonDefaultStyle()
        }
    }
}

// MARK: - YSButton

public class YSButton: UIButton {
    public enum StyleType {
        case `default`
        case gray
        case border
        case normal
        case custom
    }

    public var styleType: StyleType = .default {
        didSet {
            let styleInstance = YSButtonStyleFactory.build(for: styleType, customStyle: customStyle)
            apply(style: styleInstance)
        }
    }
    public var customStyle: YSButtonCustomStyle? {
        didSet {
            applyStyle()
        }
    }

    public var gradientLayer: CAGradientLayer?

    public init(styleType: StyleType = .default, frame: CGRect = .zero) {
        super.init(frame: frame)
        self.styleType = styleType
        applyStyle()
    }

    public init(style: YSButtonCustomStyle, frame: CGRect = .zero) {
        super.init(frame: frame)
        customStyle = style
        styleType = .custom
        applyStyle()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyStyle()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if let gradientLayer {
            gradientLayer.frame = bounds
        }
    }
}

private extension YSButton {
    func applyStyle() {
        apply(style: YSButtonStyleFactory.build(for: styleType, customStyle: customStyle))
    }

    func apply(style: YSButtonStyleProtocol) {
        backgroundColor = style.backgroundColor
        setTitleColor(style.textColor, for: .normal)
        layer.cornerRadius = style.cornerRadius
        layer.shadowColor = style.shadowColor?.cgColor
        layer.shadowOpacity = style.shadowColor != nil ? 0.5 : 0
        layer.shadowRadius = style.cornerRadius
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.borderWidth = style.borderWidth ?? 0
        layer.borderColor = style.borderColor?.cgColor
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath

        if let gradientStyle = style as? YSButtonDefaultStyle {
            applyGradientBackground(colors: gradientStyle.gradientColors)
            return
        } else {
            layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        }
    }

    func applyGradientBackground(colors: [CGColor]) {
        let _gradientLayer = CAGradientLayer()
        _gradientLayer.colors = colors
        _gradientLayer.locations = [0, 1]
        _gradientLayer.startPoint = CGPoint(x: 0.52, y: -2.34)
        _gradientLayer.endPoint = CGPoint(x: 0.85, y: 0.85)
        _gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(_gradientLayer, at: 0)

        gradientLayer = _gradientLayer
    }
}
