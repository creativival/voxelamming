const { BuildBox } = require('voxelamming-node');

(async () => {
  const roomName = '1000';
  const buildBox = new BuildBox(roomName);

  buildBox.setCommand('japaneseCastle');

  await buildBox.sendData('mainCastleCommandSample');
  console.log('send data done')
})().catch(error => {
  console.error(error);
});
