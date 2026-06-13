// HTTP请求封装 - 基于@ohos.net.http模块

import http from '@ohos.net.http';
import { BASE_URL, HTTP_TIMEOUT } from '../utils/Constants';

// 通用响应结构
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

// HTTP方法枚举
export enum HttpMethod {
  GET = 'GET',
  POST = 'POST',
  PUT = 'PUT',
  DELETE = 'DELETE'
}

// 请求选项
interface RequestOptions {
  url: string;
  method: HttpMethod;
  data?: object;
  headers?: Record<string, string>;
}

export class HttpUtil {
  // 统一请求方法
  static async request<T>(options: RequestOptions): Promise<ApiResponse<T>> {
    const httpRequest = http.createHttp();

    try {
      const headers: Record<string, string> = {
        'Content-Type': 'application/json',
        ...options.headers
      };

      const fullUrl = options.url.startsWith('http') ? options.url : `${BASE_URL}${options.url}`;

      const response = await httpRequest.request(fullUrl, {
        method: options.method,
        header: headers,
        extraData: options.data ? JSON.stringify(options.data) : undefined,
        connectTimeout: HTTP_TIMEOUT,
        readTimeout: HTTP_TIMEOUT
      });

      if (response.responseCode === 200 || response.responseCode === 201) {
        const result: ApiResponse<T> = JSON.parse(response.result as string);
        if (result.code === 0 || result.code === 200) {
          return result;
        } else {
          throw new Error(`业务错误: ${result.message}`);
        }
      } else {
        throw new Error(`HTTP错误: ${response.responseCode}`);
      }
    } catch (error) {
      console.error(`请求失败 [${options.method} ${options.url}]:`, JSON.stringify(error));
      throw error;
    } finally {
      httpRequest.destroy();
    }
  }

  // GET请求
  static async get<T>(url: string, params?: Record<string, string | number>): Promise<ApiResponse<T>> {
    let fullUrl = url;
    if (params) {
      const queryParts: string[] = [];
      for (const key in params) {
        if (params[key] !== undefined && params[key] !== null) {
          queryParts.push(`${key}=${encodeURIComponent(String(params[key]))}`);
        }
      }
      if (queryParts.length > 0) {
        fullUrl += `?${queryParts.join('&')}`;
      }
    }

    return HttpUtil.request<T>({
      url: fullUrl,
      method: HttpMethod.GET
    });
  }

  // POST请求
  static async post<T>(url: string, data?: object): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>({
      url: url,
      method: HttpMethod.POST,
      data: data
    });
  }

  // PUT请求
  static async put<T>(url: string, data?: object): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>({
      url: url,
      method: HttpMethod.PUT,
      data: data
    });
  }

  // DELETE请求
  static async delete<T>(url: string): Promise<ApiResponse<T>> {
    return HttpUtil.request<T>({
      url: url,
      method: HttpMethod.DELETE
    });
  }
}
