// 花材数据模型

// 花材分类枚举
export enum FlowerCategory {
  ROSE = 'rose',
  LILY = 'lily',
  CARNATION = 'carnation',
  SUNFLOWER = 'sunflower',
  HYDRANGEA = 'hydrangea',
  OTHER = 'other'
}

// 花材颜色枚举
export enum FlowerColor {
  RED = 'red',
  WHITE = 'white',
  YELLOW = 'yellow',
  PINK = 'pink',
  MIXED = 'mixed'
}

// 花材接口定义
export interface FlowerInfo {
  id: number;
  name: string;
  category: FlowerCategory;
  color: FlowerColor;
  description: string;
  meaning: string;
  price: number;
  imageUrl: string;
}
