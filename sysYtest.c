// 单行注释测试

/*
   多行注释测试
   这是第二行
*/

// 各种关键字测试
int main() {
    if (x > 0) {
        return 1;
    } else {
        while (i < 10) {
            break;
        }
        continue;
    }
    const float pi = 3.14;
    void func();
}

// 标识符测试
int _identifier;
int normal_var;
int var_with_123;
int 123invalid;  // 错误的标识符 - 以数字开头

// 运算符测试
int a = 1 + 2 - 3 * 4 / 5 % 6;

// 比较运算符测试
if (a == b && c != d || e <= f && g >= h) {
    int x = i < j || k > l;
}

// 赋值运算符
int y = 10;

// 整数常量测试
int dec_const = 123;
int zero = 0;
int octal_const = 0123;     // 正确的八进制
int illegal_octal = 0129;   // 错误的八进制 - 包含8,9
int hex_const = 0x1AF;      // 正确的十六进制
int hex_upper = 0XABC;
int illegal_hex = 0xGHIJ;   // 错误的十六进制 - 包含G,H,I,J

// 浮点数常量测试
float float_dec1 = 3.14;
float float_dec2 = .14159;
float float_dec3 = 6.02e23;
float float_dec4 = 1.6e-19;
float float_hex1 = 0x1.2P3;
float float_hex2 = 0X.ABCp-10;

// 分隔符测试
int arr[] = {1, 2, 3};
struct point { int x; int y; };

// 各种错误测试
int invalid@var;        // 非法字符 @
float wrong_float = 1.2.3;  // 错误的浮点数
int missing_semicolon   // 缺少分号

// 逻辑运算符测试
if (condition1 && condition2 || !condition3) {
    // 空代码块
}

// 更多边界情况测试
int very_large_hex = 0xFFFFFFFF;
int very_large_octal = 07777777777;
float scientific = 1.5e+308;
float negative_exp = 1.5e-308;

// 混合表达式测试
int complex_expr = (a + b) * c - d / e % f;

// 字符串测试（注意：sysY可能不支持字符串，这里测试词法分析器的错误处理）
char *str = "This is a string ";  // 可能被识别为错误

    // 字符常量测试
    char ch = 'A'; // 可能被识别为错误

// 预处理指令测试（应该被识别为错误）
#include <stdio.h>
#define MAX 100

// 更多非法字符测试
int weird$name = 100;
float strange#value = 3.14;

// 各种数字格式边界测试
int just_zero = 0;
int starts_with_zero = 012;  // 八进制
float decimal_point_only =.; // 错误的浮点数
float exponent_only = e10;   // 错误的浮点数

// 下划线测试
int __double_underscore__;
int _123_start_with_underscore;

// 混合错误模式
int mixed1 = 0x;      // 空的十六进制
int mixed2 = 0x12.34; // 十六进制浮点数但没有p指数
float mixed3 = 1.e;   // 错误的科学计数法

// 正确的复杂表达式
float complex_float = 0x1.FFFFFFFFFFFFFp1023;

// 结束测试
return 0;

}
/* 未闭合的多行注释测试 - 这里故意不闭合

// 未结束的注释测试
/* 这是另一个未结束的多行注释

// 正确的代码在错误后面
int good_after_bad = 42;