FROM nodered/node-red:latest


COPY node-red-contrib-mrubyc-rboard ./node-red-contrib-mrubyc-rboard

RUN npm install ./node-red-contrib-mrubyc-rboard

COPY node-red-contrib-original ./node-red-contrib-original

RUN npm install ./node-red-contrib-original
