#####
# Build stage: install NPM packages
#####

FROM node:18-alpine AS build

# Specify the directory within the container to place our files
WORKDIR /app

# Copy our local package.json to the specified /app/ directory, and install packages
COPY package*.json/ ./
RUN npm install

# Copy the rest of our local codebase and copy it to the /app/directory,
#  then build the app using Vite to generate a /dist directory
COPY . . 
RUN npm run build

#####
# Serve stage: host on nginx webserver
#####

FROM nginx:1.28.0-alpine-slim

# remove the default index.html before replacing it with our own
RUN rm -rf /usr/share/nginx/html/*

# Copy the results of `npm run build` (in the newly-generated `dist/` folder)
#  from within the node container (the `/app/` directory we specified above).
COPY --from=build /app/dist/ /usr/share/nginx/html

# expose default port
EXPOSE 80