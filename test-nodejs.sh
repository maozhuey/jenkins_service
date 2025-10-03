#!/bin/bash

echo "=== Node.js环境测试 ==="
echo "测试时间: $(date)"
echo ""

echo "1. 检查Node.js版本:"
docker exec jenkins node --version

echo ""
echo "2. 检查npm版本:"
docker exec jenkins npm --version

echo ""
echo "3. 测试简单的Node.js代码执行:"
docker exec jenkins node -e "console.log('Hello from Node.js in Jenkins!')"

echo ""
echo "4. 测试npm命令:"
docker exec jenkins npm --help | head -5

echo ""
echo "=== 测试完成 ==="