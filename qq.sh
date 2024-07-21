#!/bin/bash

clear

json_file="package.json"
file_path="config/config/bot.yaml"
config_content="https://hlhs-nb.cn/signed/?key=114514"
target_config="sign_api_addr"
rm_config="ver"
new_config_file_path="config/config/qq.yaml"
new_config_key="platform"
new_config_value="2"
target_dir="/root/QSignServer"
file="config/ICQQ.yaml"
sign_api_addr="  sign_api_addr: $config_content"

current_time=$(date +"%Y-%m-%d %H:%M:%S")
echo "$current_time"

echo -e "\e[1;36m少女祈祷中...\e[0m"

if [ ! -f "$json_file" ]; then
  echo "JSON 文件不存在：$json_file"
  exit 1
fi

names=$(grep -oP '"name":\s*"\K[^"]+' "$json_file")

case "$names" in
  "miao-yunzai")
    echo -e "\e[1;32mMiao-Yunzai\e[0m"

    if [ ! -f "$file_path" ]; then
      echo "$file_path"
      echo -e "\e[1;31m配置文件不存在\e[0m"
      exit 1
    fi

    if [ -d "$target_dir" ]; then
      echo -e "\e[1;31m删除目录 $target_dir\e[0m"
      rm -rfv "$target_dir"
      echo -e "\e[1;32m已删除 $target_dir\e[0m"
    fi

    if grep -q "^$target_config:" "$file_path"; then
      echo -e "\e[1;33m修改签名地址\e[0m"
      sed -i "s|^$target_config:.*|$target_config: \"$config_content\"|" "$file_path"
    else
      echo -e "\e[1;33m添加签名地址\e[0m"
      echo "$target_config: $config_content" >> "$file_path"
    fi
    echo -e "\e[1;32m[√]\e[0m"

    echo -e "\e[1;33m删除 ver\e[0m"
    sed -i "/^$rm_config:/d" "$file_path"
    echo -e "\e[1;32m[√]\e[0m"

    if grep -q "^$new_config_key:" "$new_config_file_path"; then
      echo -e "\e[1;33m修改 aPad\e[0m"
      sed -i "/^$target_config:/d" "$file_path"
      echo "$target_config: \"$config_content\"" >> "$file_path"
    else
      echo -e "\e[1;33m添加 aPad\e[0m"
      echo "$new_config_key: $new_config_value" >> "$new_config_file_path"
    fi
    echo -e "\e[1;32m[√]\e[0m"

    echo -e "\e[1;33m修改完成\e[0m"
    ;;
  "trss-yunzai")
    echo -e "\e[1;32mTRSS-Yunzai\e[0m"

    if [ ! -f "$file" ]; then
      echo "$file"
      echo -e "\e[1;31m配置文件不存在\e[0m"
      exit 1
    fi

    if [ -d "$target_dir" ]; then
      echo -e "\e[1;31m删除目录 $target_dir\e[0m"
      rm -rfv "$target_dir"
      echo -e "\e[1;32m已删除 $target_dir\e[0m"
    fi

    echo -e "\e[1;33m修改签名地址\e[0m"

    sed -i '/^\s*sign_api_addr: /d' "$file"

    sed -i '/^bot: {}/c\bot:\n'"$sign_api_addr" "$file"

    if grep -q '^bot:$' "$file"; then
      sed -i '/^bot:$/a\'"$sign_api_addr" "$file"
    fi

    echo -e "\e[1;32m[√]\e[0m"
    ;;
  "yunzai")
    echo -e "\e[1;31mYunzai-Bot\e[0m"
    echo -e "\e[1;33m建议更换\e[0m \e[1;32mMiao-Yunzai\e[0m"
    sleep 5
    ;;
  *)
    echo -e "\e[1;31m无法判断当前项目\e[0m"
    echo -e "\e[1;33m请自行手动修改\e[0m"
    exit 1
    ;;
esac

curl -sSL QSign.icu/ver | bash
exit