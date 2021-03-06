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

COPY sauron.sh /home/term
CMD chmod +x /home/term/sauron.sh
CMD mkdir /home/term/.ssh
COPY wetty_term_key /home/term/.ssh/id_rsa
COPY wetty.sh /home/wetty/wetty.sh
CMD chmod +x /home/wetty/wetty.sh


CMD ["/bin/bash","/home/wetty/wetty.sh"] 
#CMD service ssh start && node . --bypasshelmet --forcessh
#CMD tail -f /dev/null
