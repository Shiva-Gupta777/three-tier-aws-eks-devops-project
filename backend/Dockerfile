# Base Image
FROM node:22-alpine

# Working Directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy application source  code
COPY . .

# Expose backend port
EXPOSE 8000

# Start application
CMD ["npm", "run", "dev"]