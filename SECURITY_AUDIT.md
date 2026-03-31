#Docker File Issues

1) Node Tag was latest, which is unPredictable , can break. I used stable version 20 with apline for lightweight. Include "As Build " for multistaging purpose.
2) Copy Statement used without proper dependency installed and removing node module ( This is will still work but image size would be bigger).
    Added " COPY package.json package-lock.json* ./ " -  for layering purpsoe, when we rebuild docker we dont have rebuild this later until any changes.
   
           " run npm ci && npm cache clean --force " - {Took Ai help} , This install depedency and remoce nodes modules ( reducing image Size).

           Now use Copy . .

3) Changed Npm install --> npm build ( install is slower , for complie purpose we user cli + build
4) Removed sceret key and DB password which are exposed in imaged. use them in run time.

#Using multi stage build to reduce image szied and remove unwanted build files.
form node:20-alpine

RUN npm ci --omit=dev --> this only install depedency required for production {Took ai help}

COPY --from=builder /app/dist ./dist  ( copy only build output)  {Took ai help}

5) i have used node-apline , change from apt--> apk. we dont want "vim,wget" removed it , kept curl.

6) Added user node for non root user

7) Removed exposed 22 (ssh port) imaged should not exposed it

