# Docker File Issues

1) Node Tag was latest, which is unPredictable , can break. I used stable version 20 with apline for lightweight. Include "As Build " for multistaging purpose.
2) Copy Statement used without proper dependency installed and removing node module ( This is will still work but image size would be bigger).
    Added " COPY package.json package-lock.json* ./ " -  for layering purpsoe, when we rebuild docker we dont have rebuild this later until any changes.
   
           " run npm ci && npm cache clean --force " - {Took Ai help} , This install depedency and remoce nodes modules ( reducing image Size).

           Now use Copy . .

3) Changed Npm install --> npm build ( install is slower , for complie purpose we user cli + build
4) Removed sceret key and DB password which are exposed in imaged. use them in run time.

# Using multi stage build to reduce image szied and remove unwanted build files.

    form node:20-alpine
    
    RUN npm ci --omit=dev --> this only install depedency required for production {Took ai help}
    
    COPY --from=builder /app/dist ./dist  ( copy only build output)  {Took ai help}

5) i have used node-apline , change from apt--> apk. we dont want "vim,wget" removed it , kept curl.

6) Added user node for non root user

7) Removed exposed 22 (ssh port) imaged should not exposed it


# Github Action Issues

1) Screted are exposed as env, remvoed it . And stored them in github builtin scerets.

2) checkout@v3 has security issues, not stable. Used @v4 stable verision and imporved performance.

3) we are using dockerhub as repo, so whlie build it we need to add docker repo name as tag , why because to avoid naming conflict and reuquired repo name to push.

# Adding Trivy after building Image.

4) for vulnerability scaning we are using trivy . we use built image as refference to scan the image. But defualt if we run it prodcue all the CVE , we check for only severity: 'CRITICAL' , mentioned exit code 1. if we found it return as 1, job fails. if not output saved as file.

5) After creating it we are uploading them. you can find the ouput at goto action> open workflow run > Scroll to Artifact.

6) while pushing docker iamge same issues as building tag name should be added properly.

7) In deploying part " StrictHostKeyChecking=no " this does not verify server identiy (risk of man in middle attack) . we can scan first and add the host them ssh into it.   { Ai figured out}

8) Added docker stop and rm to avoid port/ naming conflict.

9) Removed " --privileged" , it gives container host full access. Major security Risk.


# Decision Question

Q1) Situation we cant fix within 24hrs, so split the team into two give 1 team to fix the actual issues and other one to reduce the risk expose and run the app.
    Team 2 can: 
             - ADD on extra protection like  seccomp,app aromour , linux capabilited , running as non root user . Even app runs minimal Effect taken.
             - Adding wirefall, proxy.
             - Using CDN , even it attacker attacks they wont go to main server.
             - change exit code: 0 , accecpt vulnerabilty, fix later.
             - Last approach would be ingore the vulnerability , added .trivyignore.
    Team 1 can :
             - Manullay fix openssl issues , can ask help to backend developer to fix them.
             - Try to run the image in distroles and check for attack surface.
             - Notiy team about temporaliy accepting risk.

Q2) privileged  give full acces to root . which mean he can use kernal , modify network , mount files all linux capabilites he can use it. This not the meaning of container and security best pratice. This even casue attacker to steal credentials , if the container is attached to main server , whole server can be taken down within minutes.

Q3) It is not true , even if we rotate secret , we have already comprosied and exposed in git commit history, attacker usually scan for histroy too. Better to re-write the history to clean the comporsied histroy part. Add pre commit hook to prevent futher commit of sceret. if needed rotate sceret again.

Q4) pin sha for security . use bot to update sha. keep version in comment.


