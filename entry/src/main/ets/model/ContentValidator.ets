class ContentValidator {

  private static readonly FORBIDDEN_WORDS: string[] = ["弱智", "违规", "假冒", "诈骗"];//readonly将字段定义为只读，只能在定义时或构造函数中赋值

  // 检测内容是否包含违规词
  isContentValid(content: string): boolean {
    return !ContentValidator.FORBIDDEN_WORDS.some((word) => content.includes(word));//some() 方法会遍历数组中的每一个元素（word），并对每个元素执行回调函数。
  }

  // 返回违规词匹配的详情
  getInvalidWords(content: string): string[] {
    return ContentValidator.FORBIDDEN_WORDS.filter((word) => content.includes(word));
  }
}
const validator = new ContentValidator()
export default validator as ContentValidator