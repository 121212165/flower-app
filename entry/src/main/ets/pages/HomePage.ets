// 首页 - 场景选择 + 开始推荐

import { AppTheme } from '../common/Theme';
import { SceneSelector } from '../components/SceneSelector';
import { CommonButton, CustomButtonType, ButtonSize } from '../components/CommonButton';
import { SceneType } from '../models/RecommendModel';
import router from '@ohos.router';

@Entry
@Component
export struct HomePage {
  @State selectedScene: SceneType = SceneType.BIRTHDAY;

  build() {
    Column() {
      Text('选一个送花场景')
        .fontSize(AppTheme.FONT_SIZE_LARGE)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ top: AppTheme.SPACING_LARGE, bottom: AppTheme.SPACING_MEDIUM })
        .padding({ left: AppTheme.SPACING_MEDIUM })

      SceneSelector({
        onSceneSelect: (scene: SceneType) => {
          this.selectedScene = scene;
        }
      })
      .margin({ left: AppTheme.SPACING_MEDIUM, right: AppTheme.SPACING_MEDIUM })

      CommonButton({
        text: '开始推荐',
        type: CustomButtonType.PRIMARY,
        size: ButtonSize.LARGE,
        onClick: () => {
          AppStorage.setOrCreate('selectedScene', this.selectedScene);
          AppStorage.setOrCreate('currentTab', 1);
        }
      })
      .width('90%')
      .margin({ top: AppTheme.SPACING_LARGE })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BACKGROUND_COLOR)
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Center)
  }
}
