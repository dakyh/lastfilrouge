# Use the latest LTS version of Node.js
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependancies
RUN npm install 

# Copy the rest of your application files
COPY . .

RUN npm run build

# Production Stage
FROM nginx:stable-alpine AS production

COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80


# Definz the command to run your app
CMD ["nginx","-g","daemon off;"]