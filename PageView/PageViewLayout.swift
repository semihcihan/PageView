//
//  PageViewLayout.swift
//
//  Created by Semih Cihan on 11.07.2023.
//

import SwiftUI

struct PageViewLayout: Layout {
    var spacing: CGFloat
    var peekWidth: Double
    var subviewWidth: CGFloat
    
    init(spacing: CGFloat, peekWidth: Double, subviewWidth: CGFloat) {
        self.spacing = spacing
        self.peekWidth = peekWidth
        self.subviewWidth = subviewWidth
    }
    
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        guard !subviews.isEmpty else { return .zero }
        guard let height = proposal.height else { return .zero }
                        
        let count = CGFloat(subviews.count)
        let totalWidth = (subviewWidth * count) + ((count - 1) * spacing) + (2 * peekWidth)
        
        return CGSize(width: totalWidth, height: height)
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        guard !subviews.isEmpty else { return }

        var nextX: CGFloat = bounds.minX
        for index in subviews.indices {
            var width = subviewWidth
            if index == 0 || index == subviews.count - 1 {
                width += peekWidth
            }
            let placementProposal = ProposedViewSize(width: width, height: proposal.height)
            subviews[index].place(
                at: CGPoint(x: nextX, y: bounds.midY),
                anchor: .leading,
                proposal: placementProposal)
            nextX += width + spacing
        }
    }
    
    private func spacing(subviews: Subviews) -> [CGFloat] {
        subviews.indices.map { index in
            guard index < subviews.count - 1 else { return 0 }
            return spacing
        }
    }
}

struct PageViewLayout_Previews: PreviewProvider {
    static var previews: some View {
        
        VStack {
            Color.red
                .frame(width: 50, height: 50)
            ScrollView(.horizontal) {
                PageViewLayout(spacing: 5, peekWidth: 10, subviewWidth: 50) {
                    Color.black
                    Color.red
                    Color.green
                }
                .background(.yellow)
            }
            .frame(height: 20)
        }
    }
}
