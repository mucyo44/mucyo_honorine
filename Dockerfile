# Use official Node.js 22 image
FROM node:22

# Set working directory
WORKDIR /usr/src/app

# Copy package.json and install dependencies
COPY package.json ./
RUN npm install

# Copy application code
COPY app.js ./

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["npm", "start"]