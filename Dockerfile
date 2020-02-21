# Pull Ubuntu base docker image from HMB ECR and update.
FROM 886993334988.dkr.ecr.us-east-1.amazonaws.com/ubuntu-base:master
RUN apt-get update -y

# Install npm, sshpass, openssh-server
RUN apt-get install -y npm sshpass openssh-server

# Install node v12
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

WORKDIR /wetty
COPY . /wetty

RUN npm install
RUN npm run build

EXPOSE 3000

# Add a user
RUN useradd -d /home/term -m -s /bin/bash term
RUN echo 'term:term' | chpasswd

#CMD service ssh start && node . --bypasshelmet --forcessh
CMD tail -f /dev/null
