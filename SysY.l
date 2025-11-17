%{
/** SysY.l
 * SysY词法分析器
 * 使用flex自动生成工具实现
 * 支持识别关键字、标识符、运算符、分隔符、整数常量、浮点数常量、字符串常量、字符常量、注释等
 * 可以完成对字符数量和各类词法单元数量的统计
 * 可以检测并报告SysY语言的词法错误
 * author: 2023211419-姜一
*/

// 引入在用户定义代码块中需要的头文件
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <time.h>

// 定义每一类词法单元的枚举类型
enum tokentype{
    IDENTIFIER=1,
    KEYWORD,
    OPERATOR,
    COMPARATOR,
    LOGICAL,
    ASSIGN,
    NONZERO,
    DIGIT,
    LETTER,
    DEC_CONST,
    OCTAL_CONST,
    OCTAL_DIGIT,
    ILLEGAL_OCTAL,
    HEXADECIMAL_CONST,
    HEXADECIMAL_DIGIT,
    HEXADECIMAL_PREFIX,
    ILLEGAL_HEXADECIMAL,
    COMMENT_LINE,
    COMMENT_BLOCK,
    DELIMITER,
    FLOAT_DEC_CONST,
    FLOAT_HEXADECIMAL_CONST,
    STRING,
    CHAR,
    ILLEGAL_IDENTIFIER,
    ILLEGAL_FLOAT,
    ILLEGAL_FLOAT_HEXADECIMAL,
    NONE
};

// 定义统计变量
int line = 1;
int char_count = 0;
int identifier_count = 0;
int keyword_count = 0;
int operator_count = 0;
int assign_op = 0;
int comparator_count = 0;
int delimiter_count = 0;
int int_const_count = 0;
int float_const_count = 0;
int error_count = 0;

// 定义一个报告错误的函数
void report_error(const char* msg, int lineno);
%}


DIGIT [0-9]
NONZERO [1-9]
LETTER [a-zA-Z]
KEYWORD if|else|while|break|continue|return|int|float|const|void|char
OPERATOR "+"|"-"|"*"|"/"|"%"
COMPARATOR "=="|"!="|"<="|">="|"<"|">"
LOGICAL "&&"|"||"|"!"
ASSIGN "="
OCTAL_DIGIT [0-7]
OCTAL_CONST 0{OCTAL_DIGIT}+
ILLEGAL_OCTAL 0{DIGIT}+
HEXADECIMAL_PREFIX 0[xX]
HEXADECIMAL_DIGIT [0-9a-fA-F]
HEXADECIMAL_CONST {HEXADECIMAL_PREFIX}{HEXADECIMAL_DIGIT}+
ILLEGAL_HEXADECIMAL {HEXADECIMAL_PREFIX}({LETTER}|{DIGIT})*
DELIMITER [\(\)\{\}\[\],;]
FLOAT_DEC_CONST {DIGIT}+[eE][+-]?{DIGIT}+|{DIGIT}+\.{DIGIT}*([eE][+-]?{DIGIT}+)?|\.{DIGIT}+([eE][+-]?{DIGIT}+)?
FLOAT_HEXADECIMAL_CONST {HEXADECIMAL_PREFIX}({HEXADECIMAL_DIGIT}+\.{HEXADECIMAL_DIGIT}*|\.{HEXADECIMAL_DIGIT}+|{HEXADECIMAL_DIGIT}+)([pP][+-]?{DIGIT}+)?
ILLEGAL_FLOAT ({DIGIT}|{LETTER})*(\.{DIGIT}*)+|({DIGIT}|{LETTER})*([eE][+-]?({LETTER}|{DIGIT}))+|({DIGIT}|{LETTER})*\.[eE]
ILLEGAL_FLOAT_HEXADECIMAL {HEXADECIMAL_PREFIX}{FLOAT_DEC_CONST}
IDENTIFIER ({LETTER}|_)({LETTER}|{DIGIT}|_)*
DEC_CONST {NONZERO}{DIGIT}*|0
ILLEGAL_IDENTIFIER {DIGIT}+({LETTER}|{DIGIT}|_)+



%x COMMENT_LINE
%x COMMENT_BLOCK
%x STRING
%x CHAR

%%

\"    { BEGIN(STRING); printf("<\033[1;32mSTRING BEGINS\033[0m,%s>\n", yytext); char_count++; }
<STRING>\"  { char_count++; printf("<\033[1;32mSTRING ENDS\033[0m,%s>\n", yytext); BEGIN(INITIAL); }
<STRING>\n    { report_error("Unclosed string literal", line); error_count++; line++; char_count++; return 0; }
<STRING>\\\"  { char_count += 1; }
<STRING>\\\\ { char_count += 1; }
<STRING>.    { char_count++; }
<STRING><<EOF>>  { report_error("Unclosed string literal", line); error_count++; return 0; }

\'    { BEGIN(CHAR); printf("<\033[1;32mCHAR BEGINS\033[0m,%s>\n", yytext); char_count++; }
<CHAR>\'    { char_count++; printf("<\033[1;32mCHAR ENDS\033[0m,%s>\n", yytext); BEGIN(INITIAL); }
<CHAR>\n    {report_error("Unclosed char literal", line); error_count++; line++; char_count++; return 0; }
<CHAR>.\'    { char_count += 1; printf("<\033[1;32mCHAR ENDS\033[0m,%s>\n", yytext); BEGIN(INITIAL); }
<CHAR>\\\'\'  { char_count += 1; printf("<\033[1;32mCHAR ENDS\033[0m,%s>\n", yytext); BEGIN(INITIAL); }
<CHAR>.    { char_count++; error_count++; report_error("Invalid char constant", line); return 0; }
<CHAR><<EOF>>    { report_error("Unclosed char literal", line); error_count++; return 0; }

"//"        { printf("Line comment begins\n"); BEGIN(COMMENT_LINE); char_count += 1; }
"/*"        { printf("Block comment begins\n"); BEGIN(COMMENT_BLOCK); char_count += 1;}

<COMMENT_LINE>\n    { line++; char_count++; printf("Line comment ends\n"); BEGIN(INITIAL); }
<COMMENT_LINE>.     { char_count++; }

<COMMENT_BLOCK>"*/"     { char_count += 2; printf("Block comment ends\n"); BEGIN(INITIAL); }
<COMMENT_BLOCK>\n   { line++; char_count++; }
<COMMENT_BLOCK>.    {char_count++; }
<COMMENT_BLOCK><<EOF>>  {report_error("Unclosed block comment", line); error_count++; return 0; }

{KEYWORD}   { printf("<\033[1;32mKEYWORD\033[0m,%s>\n", yytext); keyword_count++; char_count+=1; return KEYWORD;}
{OPERATOR}  { printf("<\033[1;32mOPERATOR\033[0m,%s>\n", yytext); operator_count++; char_count+=1; return OPERATOR;}
{COMPARATOR}    { printf("<\033[1;32mCOMPARATOR\033[0m,%s>\n", yytext); comparator_count++; char_count+=1; return COMPARATOR;}
{LOGICAL}   { printf("<\033[1;32mLOGICAL\033[0m,%s>\n", yytext); operator_count++; char_count+=1; return LOGICAL;}
{ASSIGN}    { printf("<\033[1;32mASSIGN\033[0m,%s>\n", yytext); assign_op++; char_count+=1; return ASSIGN;}
{OCTAL_CONST}   { printf("<\033[1;32mOCTAL_CONST\033[0m,%s>\n", yytext); int_const_count++; char_count+=1; return OCTAL_CONST;}
{ILLEGAL_OCTAL}     { report_error("Illegal octal constant", line); error_count++; char_count+=1; return ILLEGAL_OCTAL;}
{HEXADECIMAL_CONST}     { printf("<\033[1;32mHEXADECIMAL_CONST\033[0m,%s>\n", yytext); int_const_count++; char_count+=1; return HEXADECIMAL_CONST;}
{ILLEGAL_HEXADECIMAL}     { report_error("Illegal hexadecimal constant", line); error_count++; char_count+=1; return ILLEGAL_HEXADECIMAL;}
{FLOAT_DEC_CONST}   { printf("<\033[1;32mFLOAT_DEC_CONST\033[0m,%s>\n", yytext); float_const_count++; char_count+=1; return FLOAT_DEC_CONST;}
{FLOAT_HEXADECIMAL_CONST}   { printf("<\033[1;32mFLOAT_HEXADECIMAL_CONST\033[0m,%s>\n", yytext); float_const_count++; char_count+=1; return FLOAT_HEXADECIMAL_CONST;}
{ILLEGAL_FLOAT}    { report_error("Illegal float constant", line); error_count++; char_count+=1; return ILLEGAL_FLOAT;}
{ILLEGAL_FLOAT_HEXADECIMAL}    { report_error("Illegal hexadecimal float constant", line); error_count++; char_count+=1; return ILLEGAL_FLOAT_HEXADECIMAL;}
{DELIMITER}     { printf("<\033[1;32mDELIMITER\033[0m,%s>\n", yytext); delimiter_count++; char_count+=1; return DELIMITER;}
{IDENTIFIER}    { printf("<\033[1;32mIDENTIFIER\033[0m,%s>\n", yytext); identifier_count++; char_count+=1; return IDENTIFIER;}
{DEC_CONST}     { printf("<\033[1;32mDEC_CONST\033[0m,%s>\n", yytext); int_const_count++; char_count+=1; return DEC_CONST;}
{ILLEGAL_IDENTIFIER}   { report_error("Illegal identifier", line); error_count++; char_count+=1; return ILLEGAL_IDENTIFIER;}

[ \t]+   {}
\n      {line++;}
.       {error_count++; return NONE;}

%%

// 格式化输出错误的信息及所在的位置（使用红色突出）
void report_error(const char* msg, int lineno){
    fprintf(stderr, "\033[1;31mError at line %d: %s \'%s\'\033[0m\n", lineno, msg, yytext);
}

int main(int argc, char** argv){
    int token_type;
    clock_t start = clock();
    // 如果提供了输入文件名，则打开该文件，否则使用标准输入
    if (argc > 1){
        yyin = fopen(argv[1], "r");
        if (!yyin){
            perror("Failed to open the file");
            return 1;
        }
    }

    // 循环调用词法分析器，直到文件结束，实现类似“错误恢复”的功能
    while(token_type = yylex()){
        if(token_type == NONE){
            report_error("Invalid character", line);
        }
    }

    // 输出统计结果
    printf("\n%d行\n", line);
    printf("%d个词语\n", char_count);
    printf("%d关键字\n", keyword_count);
    printf("%d标识符\n", identifier_count);
    printf("%d常数（整数）\n", int_const_count);
    printf("%d常数（浮点数）\n", float_const_count);
    printf("%d赋值\n", assign_op)
    printf("%d运算符\n", operator_count);
    printf("%d比较符\n", comparator_count);
    printf("%d分隔符\n", delimiter_count);
    if(error_count > 0){
        fprintf(stderr, "\033[1;31mCompilation failed with %d errors.\033[0m\n", error_count);
    }

    if(yyin != stdin) fclose(yyin);
    // 统计检查词法错误所用时间
    clock_t end = clock();
    double time_spent = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Time spent: %.8f seconds\n", time_spent);
    return 0;
}

int yywrap(){
    return 1;
}