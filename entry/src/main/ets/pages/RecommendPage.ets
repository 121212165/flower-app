// 推荐页 - 3步引导式智能推荐

import { AppTheme } from '../common/Theme';
import { SceneSelector } from '../components/SceneSelector';
import { CommonButton, CustomButtonType, ButtonSize } from '../components/CommonButton';
import { SceneType, GenerateRecommendationParams } from '../models/RecommendModel';
import { ApiService } from '../services/ApiService';
import router from '@ohos.router';

const STYLE_OPTIONS: string[] = ['简约', '华丽', '可爱', '优雅', '自然'];
const QUICK_TAGS: string[] = ['第一次送花', '想要惊喜', '需要浪漫', '预算有限', '想要大气', '低调内涵'];

interface ColorOption {
  name: string;
  value: string;
}

const COLOR_OPTIONS: ColorOption[] = [
  { name: '红', value: '#E74C3C' },
  { name: '粉', value: '#FF69B4' },
  { name: '白', value: '#FFFFFF' },
  { name: '紫', value: '#9B59B6' },
  { name: '黄', value: '#F1C40F' },
  { name: '蓝', value: '#3498DB' },
  { name: '混搭', value: '#E0E0E0' }
];

@Entry
@Component
export struct RecommendPage {
  @State currentStep: number = 0;
  @State isLoading: boolean = false;

  // Step1: 场景选择
  @State selectedScene: SceneType = SceneType.BIRTHDAY;
  @State sceneDescription: string = '';

  // Step2: 预算与偏好
  @State budget: number = 200;
  @State preferredColors: string[] = [];
  @State stylePreference: string = '';

  private stepTitles: string[] = ['场景选择', '预算与偏好', '生成方案'];

  aboutToAppear() {
    const preScene = AppStorage.get<string>('selectedScene');
    if (preScene) {
      this.selectedScene = preScene as SceneType;
      AppStorage.setOrCreate('selectedScene', '');
    }
  }

  private toggleInArray(arr: string[], item: string): string[] {
    const newArr: string[] = [];
    for (let i = 0; i < arr.length; i++) {
      newArr.push(arr[i]);
    }
    const idx = newArr.indexOf(item);
    if (idx >= 0) {
      newArr.splice(idx, 1);
    } else {
      newArr.push(item);
    }
    return newArr;
  }

  private buildRecommendParams(): GenerateRecommendationParams {
    return {
      scene: this.selectedScene,
      budget: this.budget
    };
  }

  private async submitRecommendation(): Promise<void> {
    this.isLoading = true;
    try {
      const params = this.buildRecommendParams();
      const response = await ApiService.generateRecommendation(params);

      router.pushUrl({
        url: 'pages/ResultPage',
        params: {
          schemesData: JSON.stringify(response.schemes),
          reason: response.reason,
          sceneAnalysis: response.sceneAnalysis,
          requestParams: JSON.stringify(params)
        }
      });
    } catch (error) {
      console.error('生成推荐失败:', JSON.stringify(error));
    }
    this.isLoading = false;
  }

  private prevStep(): void {
    if (this.currentStep > 0) {
      this.currentStep--;
    }
  }

  private nextStep(): void {
    if (this.currentStep < this.stepTitles.length - 1) {
      this.currentStep++;
    } else {
      this.submitRecommendation();
    }
  }

  @Builder
  SectionTitle(title: string) {
    Text(title)
      .fontSize(AppTheme.FONT_SIZE_NORMAL)
      .fontColor(AppTheme.TEXT_PRIMARY)
      .fontWeight(FontWeight.Medium)
      .margin({ top: AppTheme.SPACING_MEDIUM, bottom: AppTheme.SPACING_SMALL })
  }

  // 步骤1：场景选择
  @Builder
  Step1Content() {
    Column() {
      Text('选择送花场景')
        .fontSize(AppTheme.FONT_SIZE_LARGE)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      SceneSelector({
        onSceneSelect: (scene: SceneType) => {
          this.selectedScene = scene;
        }
      })

      this.SectionTitle('描述具体情况')
      TextArea({ placeholder: '描述具体情况，如：刚交往3天的女朋友第一个生日' })
        .width('100%')
        .height(80)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .placeholderColor(AppTheme.TEXT_SECONDARY)
        .backgroundColor('#F5F5F5')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .padding(12)
        .onChange((value: string) => { this.sceneDescription = value; })

      this.SectionTitle('常用标签')
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(QUICK_TAGS, (tag: string) => {
          Text(tag)
            .fontSize(AppTheme.FONT_SIZE_SMALL)
            .fontColor(AppTheme.PRIMARY_COLOR)
            .backgroundColor(AppTheme.PRIMARY_COLOR_ALPHA20)
            .borderRadius(AppTheme.BORDER_RADIUS_CIRCLE)
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .margin({ right: AppTheme.SPACING_SMALL, bottom: AppTheme.SPACING_SMALL })
            .onClick(() => {
              this.sceneDescription = this.sceneDescription ? `${this.sceneDescription} ${tag}` : tag;
            })
        }, (tag: string) => tag)
      }
      .width('100%')
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  // 步骤2：预算与偏好
  @Builder
  Step2Content() {
    Column() {
      Text('预算和偏好')
        .fontSize(AppTheme.FONT_SIZE_LARGE)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      this.SectionTitle(`预算范围：¥${this.budget}`)
      Slider({
        value: this.budget,
        min: 50,
        max: 2000,
        step: 50,
        style: SliderStyle.InSet
      })
        .width('100%')
        .trackColor(AppTheme.DIVIDER_COLOR)
        .selectedColor(AppTheme.PRIMARY_COLOR)
        .blockColor(AppTheme.PRIMARY_COLOR)
        .showTips(false)
        .onChange((value: number) => {
          this.budget = Math.round(value);
        })

      this.SectionTitle('喜欢的颜色')
      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(COLOR_OPTIONS, (option: ColorOption) => {
          Column() {
            Circle()
              .width(36)
              .height(36)
              .fill(option.value)
              .stroke(this.preferredColors.indexOf(option.name) >= 0 ? AppTheme.PRIMARY_COLOR : AppTheme.DIVIDER_COLOR)
              .strokeWidth(this.preferredColors.indexOf(option.name) >= 0 ? 3 : 1)

            Text(option.name)
              .fontSize(AppTheme.FONT_SIZE_SMALL)
              .fontColor(AppTheme.TEXT_SECONDARY)
              .margin({ top: 4 })
          }
          .margin({ right: AppTheme.SPACING_MEDIUM, bottom: AppTheme.SPACING_SMALL })
          .onClick(() => {
            this.preferredColors = this.toggleInArray(this.preferredColors, option.name);
          })
        }, (option: ColorOption) => option.name)
      }

      this.SectionTitle('风格偏好')
      Row() {
        ForEach(STYLE_OPTIONS, (option: string) => {
          Text(option)
            .fontSize(AppTheme.FONT_SIZE_SMALL)
            .fontColor(this.stylePreference === option ? '#FFFFFF' : AppTheme.TEXT_PRIMARY)
            .backgroundColor(this.stylePreference === option ? AppTheme.PRIMARY_COLOR : AppTheme.CARD_BACKGROUND)
            .borderRadius(AppTheme.BORDER_RADIUS_CIRCLE)
            .padding({ left: 14, right: 14, top: 6, bottom: 6 })
            .margin({ right: AppTheme.SPACING_SMALL })
            .border({
              width: 1,
              color: this.stylePreference === option ? AppTheme.PRIMARY_COLOR : AppTheme.DIVIDER_COLOR,
              style: BorderStyle.Solid
            })
            .onClick(() => { this.stylePreference = option; })
        }, (option: string) => option)
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  // 步骤3：确认生成
  @Builder
  Step3Content() {
    Column() {
      Text('确认信息')
        .fontSize(AppTheme.FONT_SIZE_LARGE)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AppTheme.SPACING_LARGE })

      Column() {
        Row() {
          Text('送花场景')
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_SECONDARY)
          Text(this.selectedScene)
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .margin({ left: AppTheme.SPACING_SMALL })
        }
        .width('100%')
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

        Row() {
          Text('预算')
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_SECONDARY)
          Text(`¥${this.budget}`)
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .margin({ left: AppTheme.SPACING_SMALL })
        }
        .width('100%')
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

        if (this.stylePreference) {
          Row() {
            Text('风格')
              .fontSize(AppTheme.FONT_SIZE_NORMAL)
              .fontColor(AppTheme.TEXT_SECONDARY)
            Text(this.stylePreference)
              .fontSize(AppTheme.FONT_SIZE_NORMAL)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .margin({ left: AppTheme.SPACING_SMALL })
          }
          .width('100%')
          .margin({ bottom: AppTheme.SPACING_MEDIUM })
        }

        if (this.sceneDescription) {
          Column() {
            Text('场景描述')
              .fontSize(AppTheme.FONT_SIZE_NORMAL)
              .fontColor(AppTheme.TEXT_SECONDARY)
            Text(this.sceneDescription)
              .fontSize(AppTheme.FONT_SIZE_NORMAL)
              .fontColor(AppTheme.TEXT_PRIMARY)
              .margin({ top: AppTheme.SPACING_SMALL })
          }
          .width('100%')
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width('100%')
      .padding(AppTheme.SPACING_MEDIUM)
      .backgroundColor(AppTheme.CARD_BACKGROUND)
      .borderRadius(AppTheme.BORDER_RADIUS_MEDIUM)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  build() {
    Column() {
      // 步骤指示器
      Row() {
        ForEach(this.stepTitles, (title: string, index?: number) => {
          Row() {
            Text(`${(index ?? 0) + 1}`)
              .fontSize(14)
              .fontColor((index ?? 0) <= this.currentStep ? '#FFFFFF' : AppTheme.TEXT_SECONDARY)
              .backgroundColor((index ?? 0) <= this.currentStep ? AppTheme.PRIMARY_COLOR : AppTheme.DIVIDER_COLOR)
              .width(28)
              .height(28)
              .borderRadius(14)
              .textAlign(TextAlign.Center)
              .justifyContent(FlexAlign.Center)

            Text(title)
              .fontSize(AppTheme.FONT_SIZE_SMALL)
              .fontColor((index ?? 0) === this.currentStep ? AppTheme.PRIMARY_COLOR : AppTheme.TEXT_SECONDARY)
              .margin({ left: 4 })
          }
          .margin({ right: AppTheme.SPACING_MEDIUM })
        }, (title: string) => title)
      }
      .width('100%')
      .padding(AppTheme.SPACING_MEDIUM)
      .justifyContent(FlexAlign.Center)

      // 步骤内容
      Scroll() {
        Column() {
          if (this.currentStep === 0) {
            this.Step1Content()
          } else if (this.currentStep === 1) {
            this.Step2Content()
          } else if (this.currentStep === 2) {
            this.Step3Content()
          }
        }
        .width('100%')
        .padding(AppTheme.SPACING_MEDIUM)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Auto)
      .edgeEffect(EdgeEffect.Spring)
      .layoutWeight(1)

      // 底部按钮区
      Row() {
        if (this.currentStep > 0) {
          CommonButton({
            text: '上一步',
            type: CustomButtonType.OUTLINE,
            size: ButtonSize.LARGE,
            onClick: () => this.prevStep()
          })
          .width('45%')
        }

        CommonButton({
          text: this.currentStep === this.stepTitles.length - 1 ? '生成专属花束方案' : '下一步',
          type: CustomButtonType.PRIMARY,
          size: ButtonSize.LARGE,
          disabled: this.isLoading,
          onClick: () => this.nextStep()
        })
        .width(this.currentStep > 0 ? '45%' : '100%')
      }
      .width('100%')
      .padding({ left: AppTheme.SPACING_MEDIUM, right: AppTheme.SPACING_MEDIUM, top: AppTheme.SPACING_SMALL, bottom: AppTheme.SPACING_MEDIUM })
      .justifyContent(FlexAlign.SpaceBetween)
      .backgroundColor(AppTheme.CARD_BACKGROUND)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BACKGROUND_COLOR)
  }
}
