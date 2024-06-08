//
//  ContentView.swift
//  TeckBlogNotifications
//
//  Created by 이상현 on 5/29/24.
//

import SwiftUI

struct MainView: View {
    @Environment(PostManager.self) private var postManager
    var groupedPosts : [String: [Post]] {
        groupPostsByDate(posts: postManager.posts)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(groupedPosts.keys.sorted().reversed(), id: \.self) { key in
                    Section {
                        ForEach(groupedPosts[key]!) { post in
                            PostRowView(post: post)
                        }
//                        .swipeActions(edge: .leading) {
//                            Button(action: {
//                                // TODO: 실제 북마크 로직
//                                print("Bookmark!")
//                            }) {
//                                Label("Star", systemImage: "star")
//                            }
//                        }
//                        .tint(.orange)
                    } header: {
                        Text(key)
                    }
                }
            }
            .redacted(reason: postManager.isLoading ? .placeholder : [])
            .navigationTitle(Constants.Messages.HOME_TITLE)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
            // TODO: 실제 북마크 로직
//            .toolbar {
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink(destination: BookmarkView()) {
//                        Image(systemName: "bookmark")
//                    }
//                }
//            }
        }
    }
}

extension MainView {
    private static let RECENT_POST_DAY = 1
    
    func groupPostsByDate(posts: [Post]) -> [String: [Post]] {
        var groupedPosts: [String: [Post]] = [:]
        
        let calendar = Calendar.current
        let now = Date()
        
        for post in posts {
            let dateComponentsToNow = calendar.dateComponents([.year, .month, .day], from: post.timestamp, to: now)
            
            let groupKey: String
            if dateComponentsToNow.year == 0 && dateComponentsToNow.month == 0 && dateComponentsToNow.day ?? 0 <= MainView.RECENT_POST_DAY {
                groupKey = Constants.Messages.RECENT
            } else {
                groupKey = post.timestamp.formatDateToYearMonth()
            }
            
            if groupedPosts[groupKey] != nil {
                groupedPosts[groupKey]!.append(post)
            } else {
                groupedPosts[groupKey] = [post]
            }
        }
        return groupedPosts
    }
}



#Preview {
    MainView()
        .environment(PostManager())
}
