# 使用官方 Nginx 镜像作为基础镜像
FROM nginx:alpine

# 删除默认的 Nginx 配置文件
RUN rm -rf /usr/share/nginx/html/*

# 将 Vue 生产版本静态文件复制到 Nginx 容器的静态文件目录
COPY dist/ /usr/share/nginx/html/

# 替换 Nginx 配置文件
COPY nginx.conf /etc/nginx/conf.d/default.conf

# 暴露 Nginx 默认的 HTTP 端口
EXPOSE 80

# 启动 Nginx 服务
CMD ["nginx", "-g", "daemon off;"]
