# WeTTY - Duke customization

## Finding Duke code
Please surround Duke custom code with the following comments for findability:

    Begin Duke customization
    End Duke customization

## Running locally on development machine
You'll need to have Docker installed and running.  And AWS credentials setup on your machine.
1) Copy down `s3://de-iot-hmb-wetty-certs/wetty_term_key` to root of the project workspace
2) Run 

       $(aws ecr get-login --region us-east-1 --no-include-email --registry-ids 886993334988)
       
3) Build, run, and follow logs:


       docker container kill $(docker ps -q --filter ancestor=dev/wetty) && \
       docker build -t dev/wetty . && \
       wetty_container=$(docker run -d -p 3000:3000 dev/wetty) && \
       echo $wetty_container && \
       docker exec -t $wetty_container service ssh start && \
       docker logs -f $wetty_container

4) URL should look something like this:

    http://localhost:3000/wetty/ssh/term?pass=term&vars={%22id%22:%22P20101234%22,%22ipAddress%22:%2222.23.17.34%22,%22hub%22:%22gw-default-prov%22}