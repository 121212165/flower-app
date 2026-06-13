// 结果页 - 推荐方案展示 + 内联下单

import { AppTheme } from '../common/Theme';
import { CommonButton, CustomButtonType, ButtonSize } from '../components/CommonButton';
import { BouquetScheme, FlowerItem, GenerateRecommendationParams } from '../models/RecommendModel';
import { ApiService } from '../services/ApiService';
import router from '@ohos.router';

@Entry
@Component
export struct ResultPage {
  @State schemes: BouquetScheme[] = [];
  @State reason: string = '';
  @State sceneAnalysis: string = '';
  @State currentSchemeIndex: number = 0;
  @State isLoading: boolean = false;

  // 下单表单状态
  @State showOrderForm: boolean = false;
  @State orderSubmitted: boolean = false;
  @State selectedSchemeForOrder: BouquetScheme | null = null;
  @State recipientName: string = '';
  @State phone: string = '';
  @State deliveryAddress: string = '';
  @State greetingMessage: string = '';

  @State requestParamsJson: string = '';

  aboutToAppear() {
    const params = router.getParams();
    if (params) {
      if (params.schemesData) {
        try {
          this.schemes = JSON.parse(params.schemesData as string) as BouquetScheme[];
        } catch (e) {
          this.schemes = this.getMockSchemes();
        }
      } else {
        this.schemes = this.getMockSchemes();
      }
      if (params.reason) {
        this.reason = params.reason as string;
      }
      if (params.sceneAnalysis) {
        this.sceneAnalysis = params.sceneAnalysis as string;
      }
      if (params.requestParams) {
        this.requestParamsJson = params.requestParams as string;
      }
    } else {
      this.schemes = this.getMockSchemes();
    }
  }

  private getMockSchemes(): BouquetScheme[] {
    return [
      {
        id: 1,
        name: '初恋悸动',
        description: '粉白交织的温柔花束，如同初见时心跳加速的感觉',
        flowers: [
          { flowerId: 1, flowerName: '粉玫瑰', quantity: 9, unitPrice: 8, color: '粉色', meaning: '初恋' },
          { flowerId: 2, flowerName: '白百合', quantity: 3, unitPrice: 12, color: '白色', meaning: '纯洁' },
          { flowerId: 3, flowerName: '满天星', quantity: 5, unitPrice: 3, color: '白色', meaning: '真心喜欢' }
        ],
        totalPrice: 108,
        style: '简约',
        meaning: '初恋的悸动，如同这束粉白交织的花朵，纯真而心动。',
        imageUrl: '',
        matchScore: 95
      },
      {
        id: 2,
        name: '浪漫满屋',
        description: '红粉相伴的热情花束，诉说内心深处的爱意',
        flowers: [
          { flowerId: 4, flowerName: '红玫瑰', quantity: 11, unitPrice: 8, color: '红色', meaning: '一心一意' },
          { flowerId: 5, flowerName: '粉色绣球', quantity: 2, unitPrice: 15, color: '粉色', meaning: '浪漫' },
          { flowerId: 6, flowerName: '尤加利叶', quantity: 3, unitPrice: 5, color: '绿色', meaning: '回忆' }
        ],
        totalPrice: 133,
        style: '华丽',
        meaning: '十一朵红玫瑰诉说一心一意的深情，绣球花增添浪漫氛围。',
        imageUrl: '',
        matchScore: 88
      },
      {
        id: 3,
        name: '温柔告白',
        description: '紫色梦幻的优雅花束，用最温柔的方式说出爱',
        flowers: [
          { flowerId: 7, flowerName: '紫玫瑰', quantity: 9, unitPrice: 10, color: '紫色', meaning: '浪漫真情' },
          { flowerId: 8, flowerName: '白色桔梗', quantity: 5, unitPrice: 6, color: '白色', meaning: '永恒不变的爱' },
          { flowerId: 9, flowerName: '银叶菊', quantity: 3, unitPrice: 4, color: '银色', meaning: '珍贵' }
        ],
        totalPrice: 127,
        style: '优雅',
        meaning: '紫色玫瑰代表浪漫真情，白色桔梗象征永恒不变的爱。',
        imageUrl: '',
        matchScore: 82
      }
    ];
  }

  private async refreshSchemes(): Promise<void> {
    if (!this.requestParamsJson) return;
    this.isLoading = true;
    try {
      const params = JSON.parse(this.requestParamsJson) as GenerateRecommendationParams;
      const response = await ApiService.generateRecommendation(params);
      this.schemes = response.schemes;
      this.reason = response.reason;
      this.sceneAnalysis = response.sceneAnalysis;
      this.currentSchemeIndex = 0;
    } catch (error) {
      console.error('重新推荐失败:', JSON.stringify(error));
    }
    this.isLoading = false;
  }

  private startOrder(scheme: BouquetScheme): void {
    this.selectedSchemeForOrder = scheme;
    this.showOrderForm = true;
    this.orderSubmitted = false;
  }

  private async submitOrder(): Promise<void> {
    if (!this.selectedSchemeForOrder || !this.deliveryAddress) return;
    this.isLoading = true;
    try {
      await ApiService.createOrder({
        total_price: this.selectedSchemeForOrder.totalPrice,
        delivery_address: this.deliveryAddress,
        greeting_card_message: this.greetingMessage || undefined
      });
      this.orderSubmitted = true;
      this.showOrderForm = false;
    } catch (error) {
      console.error('下单失败:', JSON.stringify(error));
    }
    this.isLoading = false;
  }

  private getStyleColor(style: string): string {
    const colorMap: Record<string, string> = {
      '简约': '#4CAF50',
      '华丽': '#FF69B4',
      '可爱': '#FFB6C1',
      '优雅': '#9B59B6',
      '自然': '#8BC34A'
    };
    return colorMap[style] || AppTheme.PRIMARY_COLOR;
  }

  private getGreetingText(scheme: BouquetScheme): string {
    const greetings: Record<string, string> = {
      '初恋悸动': '遇见你的那一刻，世界突然有了颜色。',
      '浪漫满屋': '每一朵玫瑰都是我对你的思念。',
      '温柔告白': '用最温柔的方式告诉你，你是我心中最珍贵的存在。'
    };
    return greetings[scheme.name] || `送你一束${scheme.name}，愿每一朵花都带给你幸福与喜悦。`;
  }

  @Builder
  SchemeCard(scheme: BouquetScheme) {
    Scroll() {
      Column() {
        Text(scheme.name)
          .fontSize(AppTheme.FONT_SIZE_XLARGE)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AppTheme.SPACING_SMALL })

        Row() {
          Text(scheme.style)
            .fontSize(AppTheme.FONT_SIZE_SMALL)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getStyleColor(scheme.style))
            .borderRadius(AppTheme.BORDER_RADIUS_CIRCLE)
            .padding({ left: 10, right: 10, top: 3, bottom: 3 })

          Text(`匹配度 ${scheme.matchScore}%`)
            .fontSize(AppTheme.FONT_SIZE_SMALL)
            .fontColor(AppTheme.SECONDARY_COLOR)
            .backgroundColor(AppTheme.SECONDARY_COLOR_ALPHA20)
            .borderRadius(AppTheme.BORDER_RADIUS_CIRCLE)
            .padding({ left: 10, right: 10, top: 3, bottom: 3 })
            .margin({ left: AppTheme.SPACING_SMALL })

          Text(`¥${scheme.totalPrice}`)
            .fontSize(AppTheme.FONT_SIZE_LARGE)
            .fontColor(AppTheme.ACCENT_COLOR)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 'auto' })
        }
        .width('100%')
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

        Text(scheme.description)
          .fontSize(AppTheme.FONT_SIZE_NORMAL)
          .fontColor(AppTheme.TEXT_SECONDARY)
          .margin({ bottom: AppTheme.SPACING_MEDIUM })

        Text('花材搭配')
          .fontSize(AppTheme.FONT_SIZE_MEDIUM)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AppTheme.SPACING_SMALL })

        Column() {
          ForEach(scheme.flowers, (flower: FlowerItem) => {
            Row() {
              Text(`${flower.flowerName} x${flower.quantity}`)
                .fontSize(AppTheme.FONT_SIZE_NORMAL)
                .fontColor(AppTheme.TEXT_PRIMARY)
                .fontWeight(FontWeight.Medium)
                .layoutWeight(1)

              Text(flower.color)
                .fontSize(AppTheme.FONT_SIZE_SMALL)
                .fontColor(AppTheme.TEXT_SECONDARY)
                .margin({ right: AppTheme.SPACING_MEDIUM })

              Text(flower.meaning)
                .fontSize(AppTheme.FONT_SIZE_SMALL)
                .fontColor(AppTheme.PRIMARY_COLOR)

              Text(`¥${flower.unitPrice * flower.quantity}`)
                .fontSize(AppTheme.FONT_SIZE_SMALL)
                .fontColor(AppTheme.TEXT_SECONDARY)
                .margin({ left: AppTheme.SPACING_SMALL })
            }
            .width('100%')
            .padding({ top: AppTheme.SPACING_SMALL, bottom: AppTheme.SPACING_SMALL })
          }, (flower: FlowerItem) => `${flower.flowerId}`)
        }
        .width('100%')
        .padding(AppTheme.SPACING_SMALL)
        .backgroundColor('#FAFAFA')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

        Text('花语解读')
          .fontSize(AppTheme.FONT_SIZE_MEDIUM)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AppTheme.SPACING_SMALL })

        Row() {
          Text('"')
            .fontSize(AppTheme.FONT_SIZE_TITLE)
            .fontColor(AppTheme.PRIMARY_COLOR)
            .fontWeight(FontWeight.Bold)
            .margin({ right: AppTheme.SPACING_SMALL })

          Text(scheme.meaning)
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .fontStyle(FontStyle.Italic)
            .layoutWeight(1)
            .lineHeight(22)
        }
        .width('100%')
        .padding(AppTheme.SPACING_MEDIUM)
        .backgroundColor(AppTheme.PRIMARY_COLOR_ALPHA20)
        .borderRadius(AppTheme.BORDER_RADIUS_MEDIUM)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

        if (this.reason) {
          Text('推荐理由')
            .fontSize(AppTheme.FONT_SIZE_MEDIUM)
            .fontColor(AppTheme.TEXT_PRIMARY)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: AppTheme.SPACING_SMALL })

          Text(this.reason)
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_SECONDARY)
            .lineHeight(22)
            .margin({ bottom: AppTheme.SPACING_MEDIUM })
        }

        Text('贺卡文案')
          .fontSize(AppTheme.FONT_SIZE_MEDIUM)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: AppTheme.SPACING_SMALL })

        Text(this.getGreetingText(scheme))
          .fontSize(AppTheme.FONT_SIZE_NORMAL)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .lineHeight(22)
          .width('100%')
          .padding(AppTheme.SPACING_MEDIUM)
          .backgroundColor('#FAFAFA')
          .borderRadius(AppTheme.BORDER_RADIUS_MEDIUM)

        CommonButton({
          text: '立即下单',
          type: CustomButtonType.PRIMARY,
          size: ButtonSize.LARGE,
          onClick: () => this.startOrder(scheme)
        })
        .width('100%')
        .margin({ top: AppTheme.SPACING_LARGE })
      }
      .width('100%')
      .padding(AppTheme.SPACING_MEDIUM)
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .edgeEffect(EdgeEffect.Spring)
  }

  @Builder
  OrderForm() {
    Column() {
      Text('填写配送信息')
        .fontSize(AppTheme.FONT_SIZE_LARGE)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      Text(`方案：${this.selectedSchemeForOrder?.name ?? ''}  ¥${this.selectedSchemeForOrder?.totalPrice ?? 0}`)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.ACCENT_COLOR)
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      Text('收件人姓名')
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .margin({ bottom: AppTheme.SPACING_SMALL })
      TextInput({ placeholder: '请输入收件人姓名' })
        .width('100%')
        .height(40)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .backgroundColor('#F5F5F5')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => { this.recipientName = value; })
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      Text('联系电话')
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .margin({ bottom: AppTheme.SPACING_SMALL })
      TextInput({ placeholder: '请输入联系电话' })
        .width('100%')
        .height(40)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .backgroundColor('#F5F5F5')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => { this.phone = value; })
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      Text('配送地址')
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .margin({ bottom: AppTheme.SPACING_SMALL })
      TextInput({ placeholder: '请输入配送地址' })
        .width('100%')
        .height(40)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .backgroundColor('#F5F5F5')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .padding({ left: 12, right: 12 })
        .onChange((value: string) => { this.deliveryAddress = value; })
        .margin({ bottom: AppTheme.SPACING_MEDIUM })

      Text('贺卡留言')
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .margin({ bottom: AppTheme.SPACING_SMALL })
      TextArea({ placeholder: '写一句祝福的话吧' })
        .width('100%')
        .height(60)
        .fontSize(AppTheme.FONT_SIZE_NORMAL)
        .fontColor(AppTheme.TEXT_PRIMARY)
        .backgroundColor('#F5F5F5')
        .borderRadius(AppTheme.BORDER_RADIUS_SMALL)
        .padding(12)
        .onChange((value: string) => { this.greetingMessage = value; })
        .margin({ bottom: AppTheme.SPACING_LARGE })

      Row() {
        CommonButton({
          text: '取消',
          type: CustomButtonType.OUTLINE,
          size: ButtonSize.LARGE,
          onClick: () => { this.showOrderForm = false; }
        })
        .width('45%')

        CommonButton({
          text: '确认下单',
          type: CustomButtonType.PRIMARY,
          size: ButtonSize.LARGE,
          disabled: this.isLoading || !this.deliveryAddress,
          onClick: () => this.submitOrder()
        })
        .width('45%')
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
    .width('100%')
    .padding(AppTheme.SPACING_MEDIUM)
    .backgroundColor(AppTheme.CARD_BACKGROUND)
    .borderRadius(AppTheme.BORDER_RADIUS_MEDIUM)
  }

  build() {
    Column() {
      Row() {
        Text('<')
          .fontSize(AppTheme.FONT_SIZE_LARGE)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .padding(AppTheme.SPACING_SMALL)
          .onClick(() => { router.back(); })

        Text('为TA定制的花束方案')
          .fontSize(AppTheme.FONT_SIZE_LARGE)
          .fontColor(AppTheme.TEXT_PRIMARY)
          .fontWeight(FontWeight.Bold)
          .margin({ left: AppTheme.SPACING_SMALL })
      }
      .width('100%')
      .height(56)
      .padding({ left: AppTheme.SPACING_MEDIUM, right: AppTheme.SPACING_MEDIUM })
      .alignItems(VerticalAlign.Center)
      .backgroundColor(AppTheme.CARD_BACKGROUND)

      if (this.orderSubmitted) {
        Column() {
          Text('下单成功!')
            .fontSize(AppTheme.FONT_SIZE_XLARGE)
            .fontColor(AppTheme.SUCCESS_COLOR)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: AppTheme.SPACING_MEDIUM })

          Text('我们会尽快为您安排配送')
            .fontSize(AppTheme.FONT_SIZE_NORMAL)
            .fontColor(AppTheme.TEXT_SECONDARY)
            .margin({ bottom: AppTheme.SPACING_LARGE })

          CommonButton({
            text: '返回首页',
            type: CustomButtonType.PRIMARY,
            size: ButtonSize.LARGE,
            onClick: () => {
              AppStorage.setOrCreate('currentTab', 0);
              router.back();
            }
          })
          .width('80%')
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      } else if (this.showOrderForm) {
        Scroll() {
          this.OrderForm()
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Auto)
        .layoutWeight(1)
        .padding(AppTheme.SPACING_MEDIUM)
      } else {
        Swiper() {
          ForEach(this.schemes, (scheme: BouquetScheme) => {
            this.SchemeCard(scheme)
          }, (scheme: BouquetScheme) => `${scheme.id}`)
        }
        .width('100%')
        .layoutWeight(1)
        .indicator(true)
        .loop(false)
        .onChange((index: number) => {
          this.currentSchemeIndex = index;
        })

        Column() {
          CommonButton({
            text: '换一批方案',
            type: CustomButtonType.OUTLINE,
            size: ButtonSize.LARGE,
            disabled: this.isLoading,
            onClick: () => this.refreshSchemes()
          })
          .width('100%')
        }
        .width('100%')
        .padding({ left: AppTheme.SPACING_MEDIUM, right: AppTheme.SPACING_MEDIUM, top: AppTheme.SPACING_SMALL, bottom: AppTheme.SPACING_MEDIUM })
        .backgroundColor(AppTheme.CARD_BACKGROUND)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor(AppTheme.BACKGROUND_COLOR)
  }
}
