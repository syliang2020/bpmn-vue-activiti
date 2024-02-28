# 使用Node.js作为基础镜像
FROM node:16-alpine as build-stage

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json 文件到工作目录
COPY package*.json ./

# 安装项目依赖
RUN npm install

# 复制项目文件到工作目录
COPY . .

# 构建生产环境的静态文件
RUN npm run build

# 使用Nginx作为基础镜像
FROM nginx:1.21-alpine

# 将Vue项目的构建结果复制到Nginx的默认静态文件目录
COPY --from=build-stage /app/dist /usr/share/nginx/html

# 复制自定义的Nginx配置文件（如果有）
COPY nginx.conf /etc/nginx/nginx.conf

# 暴露容器的端口（如果需要）
EXPOSE 80

# 启动Nginx服务
CMD ["nginx", "-g", "daemon off;"]

#1.build
#docker build -t bpmn-activiti .
#2.run
#docker run --name bpmn-activiti -p 18080:80 -d --rm  bpmn-activiti
