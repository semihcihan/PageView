//
//  PageView.swift
//
//  Created by Semih Cihan on 10.07.2023.
//

import SwiftUI

struct PageView<Content: View>: View {
    @State var currentPage: Int = 0
    @State private var swiping: Bool = false
    @State private var dragTranslation: CGFloat = 0
    var content: Content
    var spacing: Double
    var peekWidth: Double
    private let pageCount: Int
    
    init(
        spacing: Double,
        peekWidth: Double,
        pageCount: Int,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.spacing = spacing
        self.peekWidth = peekWidth
        self.pageCount = pageCount
    }
    
    private func calculatePage(offset: Double, width: Double, currentPage: Int) -> Int {
        let halfPage = width / 2
        var toPage = currentPage
        
        if offset < 0 && -offset > halfPage {
            toPage += 1
        } else if offset > 0 && offset > halfPage {
            toPage -= 1
        } else {
            return currentPage
        }

        if toPage < 0 {
            return 0
        }
        if toPage >= pageCount {
            return pageCount - 1
        }

        return toPage
    }
    
    private func calculateOffset(page: Int, width: Double) -> CGFloat {
        return -(calculateElementWidth(width: width, index: .middle) + spacing) * CGFloat(page)
    }
    
    private func calculateElementWidth(width: Double, index: Index) -> CGFloat {
        let singleElementWidth = width - 2 * (spacing + peekWidth)
        switch index {
            case .middle:
                return singleElementWidth
            case .startEnd:
                return singleElementWidth + peekWidth
        }
    }
    
    private func indexNumberToIndex(_ index: Int) -> Index {
        if index == 0 || index == pageCount - 1 {
            return .startEnd
        }
        return .middle
    }
    
    private enum Index {
        case middle
        case startEnd
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal) {
                HStack(spacing: spacing) {
                    Color(.black)
                        .frame(width: 0, height: 0)
                        .opacity(0)

                    PageViewLayout(spacing: spacing, peekWidth: peekWidth, subviewWidth: calculateElementWidth(width: geometry.size.width, index: .middle)) {
                        content
                    }

                    Color(.black)
                        .frame(width: 0, height: 0)
                        .opacity(0)
                }
            }
            .content
            .offset(x: swiping ? dragTranslation : calculateOffset(page: currentPage, width: geometry.size.width))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        swiping = true
                        dragTranslation = value.translation.width + calculateOffset(page: currentPage, width: geometry.size.width)
                    })
                    .onEnded({ value in
                        currentPage = calculatePage(offset: value.predictedEndTranslation.width, width: geometry.size.width, currentPage: currentPage)
                        withAnimation(.easeOut) {
                            swiping = false
                        }
                    })
            )
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Color.red
            
            Spacer()
            
            PageView(spacing: 40, peekWidth: 60, pageCount: 3) {
                Color(.black)
                    .frame(height: 40)
                Color(.yellow)
                    .frame(height: 40)
                Color(.red)
                    .frame(height: 40)
            }
            .background(.green)
            
            Spacer()
            Color.red
        }
    }
}
