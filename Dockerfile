# 使用阿里云官方镜像源的 Node.js 18 Alpine 镜像作为基础镜像
FROM registry.cn-hangzhou.aliyuncs.com/library/node:18-alpine

# 设置工作目录
WORKDIR /app

# 设置环境变量
ENV NODE_ENV=production
ENV PORT=3000

# 安装系统依赖
RUN apk add --no-cache \
    dumb-init \
    curl \
    && rm -rf /var/cache/apk/*

# 复制 package.json 和 package-lock.json（如果存在）
COPY package*.json ./

# 配置npm镜像源和安装项目依赖（带重试机制）
RUN npm config set registry https://registry.npmmirror.com/ && \
    npm config set disturl https://npmmirror.com/dist && \
    npm config set sass_binary_site https://npmmirror.com/mirrors/node-sass && \
    npm config set electron_mirror https://npmmirror.com/mirrors/electron/ && \
    npm config set puppeteer_download_host https://npmmirror.com/mirrors && \
    npm config set chromedriver_cdnurl https://npmmirror.com/mirrors/chromedriver && \
    npm config set operadriver_cdnurl https://npmmirror.com/mirrors/operadriver && \
    npm config set phantomjs_cdnurl https://npmmirror.com/mirrors/phantomjs && \
    npm config set selenium_cdnurl https://npmmirror.com/mirrors/selenium && \
    npm config set node_inspector_cdnurl https://npmmirror.com/mirrors/node-inspector && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-factor 2 && \
    npm config set fetch-retry-mintimeout 10000 && \
    npm config set fetch-retry-maxtimeout 60000 && \
    (npm ci --omit=dev || npm ci --omit=dev || npm ci --omit=dev) && \
    npm cache clean --force

# 复制应用程序代码
COPY . .

# 创建非 root 用户
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# 更改文件所有权
RUN chown -R nextjs:nodejs /app
USER nextjs

# 暴露端口
EXPOSE 3000

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node healthcheck.js

# 使用 dumb-init 作为 PID 1 进程
ENTRYPOINT ["dumb-init", "--"]

# 启动应用程序
CMD ["node", "server.js"]