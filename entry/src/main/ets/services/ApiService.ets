// API接口定义

import { HttpUtil } from './HttpUtil';
import { GenerateRecommendationParams, RecommendationResponse, CreateOrderParams } from '../models/RecommendModel';

export class ApiService {
  // 生成推荐方案
  static async generateRecommendation(params: GenerateRecommendationParams): Promise<RecommendationResponse> {
    const response = await HttpUtil.post<RecommendationResponse>('/recommendations/generate', params);
    return response.data;
  }

  // 创建订单
  static async createOrder(params: CreateOrderParams): Promise<object> {
    const response = await HttpUtil.post<object>('/orders', params);
    return response.data;
  }
}
