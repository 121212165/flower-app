// 常量定义

// API基础地址
export const BASE_URL: string = 'http://localhost:3000/api';

// 请求超时时间(毫秒)
export const HTTP_TIMEOUT: number = 15000;

// 场景类型常量
export const SCENE_TYPES: string[] = [
  'birthday',
  'confession',
  'anniversary',
  'apology',
  'gratitude',
  'visit'
];

// 场景图标映射
export const SCENE_ICONS: Record<string, string> = {
  'birthday': '🎂',
  'confession': '💕',
  'anniversary': '🎁',
  'apology': '🙏',
  'gratitude': '🌻',
  'visit': '🏥'
};

// 场景名称映射
export const SCENE_NAMES: Record<string, string> = {
  'birthday': '生日',
  'confession': '表白',
  'anniversary': '纪念日',
  'apology': '道歉',
  'gratitude': '感谢',
  'visit': '探望'
};
