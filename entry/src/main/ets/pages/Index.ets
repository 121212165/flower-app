// 主入口 - Tab容器页面

import { AppTheme } from '../common/Theme';
import { HomePage } from './HomePage';
import { RecommendPage } from './RecommendPage';

@Entry
@Component
struct Index {
  @StorageLink('currentTab') currentIndex: number = 0;

  private tabItems: string[] = ['首页', '推荐'];

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, index: this.currentIndex }) {
        TabContent() {
          HomePage()
        }
        .tabBar(this.TabBuilder(0, '首页', '🏠'))

        TabContent() {
          RecommendPage()
        }
        .tabBar(this.TabBuilder(1, '推荐', '💡'))
      }
      .scrollable(true)
      .barBackgroundColor(AppTheme.CARD_BACKGROUND)
      .barHeight(56)
      .onChange((index: number) => {
        this.currentIndex = index;
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BACKGROUND_COLOR)
  }

  @Builder
  TabBuilder(index: number, title: string, icon: string) {
    Column() {
      Text(icon)
        .fontSize(20)
        .fontColor(this.currentIndex === index ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_SECONDARY)

      Text(title)
        .fontSize(12)
        .fontColor(this.currentIndex === index ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_SECONDARY)
        .margin({ top: 4 })
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : FontWeight.Normal)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}
