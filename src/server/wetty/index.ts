/**
 * Create WeTTY server
 * @module WeTTy
 */
import server from '../socketServer';
import getCommand from '../command';
import { login, spawn } from './term';
import { loadSSL, logger } from '../utils';
import { SSH, SSL, SSLBuffer, Server } from '../interfaces';

/**
 * Starts WeTTy Server
 * @name startWeTTy
 */
export default function startWeTTy(
  ssh: SSH = { user: '', host: 'localhost', auth: 'password', port: 22 },
  serverConf: Server = {
    base: '/wetty/',
    port: 3000,
    host: '0.0.0.0',
    title: 'WeTTy',
    bypasshelmet: false,
  },
  command = '',
  forcessh = false,
  ssl?: SSL
): Promise<void> {
  return loadSSL(ssl).then((sslBuffer: SSLBuffer) => {
    if (ssh.key) {
      logger.warn(`!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Password-less auth enabled using private key from ${ssh.key}.
! This is dangerous, anything that reaches the wetty server
! will be able to run remote operations without authentication.
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!`);
    }

    const io = server(serverConf, sslBuffer);
    /**
     * Wetty server connected too
     * @fires WeTTy#connnection
     */
    io.on('connection', (socket: SocketIO.Socket) => {
      /**
       * @event wetty#connection
       * @name connection
       */
      logger.info('Connection accepted.');
      const { args, user: sshUser } = getCommand(socket, ssh, command, forcessh);
      logger.debug('Command Generated', {
        user: sshUser,
        cmd: args.join(' '),
      });

      /* Begin Duke customization */
      // Forward variables from URL to ssh shell (i.e. device ip address)
      const referer = socket.request['headers'].referer;
      logger.info(`parsing 'vars' from referer: ${referer}`);
      const varsQueryParam: any = new URLSearchParams(referer.split('?')[1]).get('vars');
      
      let vars: any;
      if (varsQueryParam !== null) {
        try {
          logger.info('vars query parameter string: ' + varsQueryParam);
          vars = JSON.parse(decodeURIComponent(varsQueryParam));
          logger.info(`parsed 'vars' query parameter: ${JSON.stringify(vars)}`);
          args.push('echo ip address: '+vars.ipAddress+' hub '+vars.hub+' && export IP_ADDR='+vars.ipAddress+' && export HUB='+vars.hub+'&& $SHELL');
        }
        catch(err) {
          logger.error("Error parsing vars " + varsQueryParam);
          logger.error(err);          
        }
      }
      else {
        logger.info(`no 'vars' query parameter`);
      }
      /* End Duke customization */

      if (sshUser) {
        spawn(socket, args);
      } else {
        login(socket)
          .then((username: string) => {
            args[1] = `${username.trim()}@${args[1]}`;
            logger.debug('Spawning term', {
              username: username.trim(),
              cmd: args.join(' ').trim(),
            });
            return spawn(socket, args);
          })
          .catch(() => {
            logger.info('Disconnect signal sent');
          });
      }
    });
  });
}
