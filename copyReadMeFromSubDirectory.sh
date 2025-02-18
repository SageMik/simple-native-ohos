# 保留父 README.md 头部内容
sed -n '1,/<!-- HEADER -->/p' README.md > HEADER.md
echo >> HEADER.md

# 处理子 README.md
process_sub_readme() {
    local dir="$1"
    local file="$2"
    cp "${dir}/README.md" $2
    sed -i '/```/,/```/!s/^\(#\+\)/\1#/g' $2 # 标题增加一级
    sed -i 's/\.\.\//.\//g' $2 # 修正相对路径
}

process_sub_readme sqlite3_simple TEMP1.md
echo >> TEMP1.md
process_sub_readme simple_native_ohos TEMP2.md

# 合并处理
cat HEADER.md TEMP1.md TEMP2.md > README.md
rm HEADER.md TEMP1.md TEMP2.md