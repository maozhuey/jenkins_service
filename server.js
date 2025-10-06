/**
 * TBK Production Server
 * Express 服务器，用于生产环境部署
 */

const express = require('express');
const cors = require('cors');
const path = require('path');

// 服务器配置
const PORT = process.env.PORT || 3000;
const HOST = '0.0.0.0';

/**
 * 创建 Express 应用
 */
const app = express();

/**
 * 中间件配置
 */
// CORS 配置
app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));

// JSON 解析
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// 静态文件服务
app.use(express.static(path.join(__dirname)));

/**
 * 请求日志中间件
 */
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path} - ${req.ip}`);
    next();
});

/**
 * API 路由
 */

// 根路径 - 服务器信息
app.get('/', (req, res) => {
    res.json({
        message: 'TBK Production Server is running',
        timestamp: new Date().toISOString(),
        version: '1.0.0',
        environment: process.env.NODE_ENV || 'production',
        server: 'Express.js'
    });
});

// 健康检查端点
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        pid: process.pid,
        environment: process.env.NODE_ENV || 'production'
    });
});

// 服务器状态端点
app.get('/status', (req, res) => {
    res.json({
        server: 'TBK Production',
        status: 'running',
        port: PORT,
        host: HOST,
        nodeVersion: process.version,
        platform: process.platform,
        arch: process.arch,
        timestamp: new Date().toISOString()
    });
});

// API 基础路由
app.get('/api', (req, res) => {
    res.json({
        message: 'TBK API is running',
        version: '1.0.0',
        endpoints: [
            'GET /',
            'GET /health',
            'GET /status',
            'GET /api'
        ],
        timestamp: new Date().toISOString()
    });
});

// 桃百科主页面
app.get('/tbk.html', (req, res) => {
    res.sendFile(path.join(__dirname, 'tbk.html'));
});

/**
 * 错误处理中间件
 */
app.use((err, req, res, next) => {
    console.error('Server error:', err);
    res.status(500).json({
        error: 'Internal Server Error',
        message: err.message,
        timestamp: new Date().toISOString()
    });
});

// 404 处理
app.use((req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Path ${req.path} not found`,
        method: req.method,
        timestamp: new Date().toISOString()
    });
});

/**
 * 优雅关闭处理
 */
const gracefulShutdown = (signal) => {
    console.log(`Received ${signal}, shutting down gracefully...`);
    server.close(() => {
        console.log('Server closed');
        process.exit(0);
    });
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));

/**
 * 启动服务器
 */
const server = app.listen(PORT, HOST, () => {
    console.log(`🚀 TBK Production Server started successfully!`);
    console.log(`📍 Server running at http://${HOST}:${PORT}`);
    console.log(`🌍 Environment: ${process.env.NODE_ENV || 'production'}`);
    console.log(`⏰ Started at: ${new Date().toISOString()}`);
    console.log(`🔧 Process ID: ${process.pid}`);
    console.log(`📊 Node.js version: ${process.version}`);
    
    // 健康检查端点提示
    console.log('\n📋 Available endpoints:');
    console.log(`   GET  /              - Server info`);
    console.log(`   GET  /health        - Health check`);
    console.log(`   GET  /status        - Server status`);
    console.log(`   GET  /api           - API info`);
    console.log(`   GET  /tbk.html      - TBK main page`);
    console.log(`   Static files served from: ${__dirname}`);
});

// 未捕获异常处理
process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
    process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
    process.exit(1);
});