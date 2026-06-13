// 推荐数据模型

// 场景枚举
export enum SceneType {
  BIRTHDAY = 'birthday',
  CONFESSION = 'confession',
  ANNIVERSARY = 'anniversary',
  APOLOGY = 'apology',
  GRATITUDE = 'gratitude',
  VISIT = 'visit'
}

// 推荐请求参数
export interface GenerateRecommendationParams {
  scene: SceneType;
  budget?: number;
}

// 花束方案
export interface BouquetScheme {
  id: number;
  name: string;
  description: string;
  flowers: FlowerItem[];
  totalPrice: number;
  style: string;
  meaning: string;
  imageUrl: string;
  matchScore: number;
}

// 方案中的花材项
export interface FlowerItem {
  flowerId: number;
  flowerName: string;
  quantity: number;
  unitPrice: number;
  color: string;
  meaning: string;
}

// 推荐响应
export interface RecommendationResponse {
  schemes: BouquetScheme[];
  reason: string;
  sceneAnalysis: string;
}

// 创建订单请求
export interface CreateOrderParams {
  total_price: number;
  delivery_address: string;
  greeting_card_message?: string;
}
