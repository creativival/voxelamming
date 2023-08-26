import WebSocket from 'ws';
import {
  getRotationMatrix,
  matrixMultiply,
  transformPointByRotationMatrix,
  addVectors,
  transpose3x3
} from './matrixUtil.mjs'


class BuildBox {
  constructor(roomName) {
    this.roomName = roomName;
    this.isAllowedMatrix = 0;
    this.savedMatrices = [];
    this.translation = [0, 0, 0, 0, 0, 0];
    this.globalAnimation = [0, 0, 0, 0, 0, 0, 1, 0]
    this.animation = [0, 0, 0, 0, 0, 0, 1, 0]
    this.boxes = [];
    this.sentence = []
    this.lights = [];
    this.commands = []
    this.size = 1.0;
    this.shape = 'box'
    this.isMetallic = 0
    this.roughness = 0.5
    this.isAllowedFloat = 0
    this.buildInterval = 0.01;
  }

  pushMatrix() {
    this.isAllowedMatrix++;
    this.savedMatrices.push(this.translation);
  }

  popMatrix() {
    this.isAllowedMatrix--;
    this.translation = this.savedMatrices.pop();
  }

  translate(x, y, z, pitch = 0, yaw = 0, roll = 0) {
    if (this.isAllowedMatrix) {
      const matrix = this.savedMatrices[this.savedMatrices.length - 1];
      const basePosition = matrix.slice(0, 3);

      let baseRotationMatrix;
      if (matrix.length === 6) {
        baseRotationMatrix = getRotationMatrix(...matrix.slice(3));
      } else {
        baseRotationMatrix = [
          matrix.slice(3, 6),
          matrix.slice(6, 9),
          matrix.slice(9, 12)
        ];
      }

      const [addX, addY, addZ] = transformPointByRotationMatrix([x, y, z], transpose3x3(baseRotationMatrix));

      [x, y, z] = addVectors(basePosition, [addX, addY, addZ]);
      [x, y, z] = this.roundNumbers([x, y, z]);

      const translateRotationMatrix = getRotationMatrix(-pitch, -yaw, -roll);
      const rotateMatrix = matrixMultiply(translateRotationMatrix, baseRotationMatrix);

      this.translation = [x, y, z, ...rotateMatrix[0], ...rotateMatrix[1], ...rotateMatrix[2]];
    } else {
      [x, y, z] = this.roundNumbers([x, y, z]);
      this.translation = [x, y, z, pitch, yaw, roll];
    }
  }

  animateGlobal(x, y, z, pitch = 0, yaw = 0, roll = 0, scale = 1, interval = 10) {
    [x, y, z] = this.roundNumbers([x, y, z]);
    this.globalAnimation = [x, y, z, pitch, yaw, roll, scale, interval];
  }

  animate(x, y, z, pitch=0, yaw=0, roll=0, scale=1, interval=10) {
    [x, y, z] = this.roundNumbers([x, y, z]);
    this.animation = [x, y, z, pitch, yaw, roll, scale, interval]
  }

  createBox(x, y, z, r=1, g=1, b=1, alpha=1) {
    [x, y, z] = this.roundNumbers([x, y, z]);
    // 重ねて置くことを防止するために、同じ座標の箱があれば削除する
    this.removeBox(x, y, z);
    this.boxes.push([x, y, z, r, g, b, alpha]);
  }

  removeBox(x, y, z) {
    [x, y, z] = this.roundNumbers([x, y, z]);
    for (let i = 0; i < this.boxes.length; i++) {
      let box = this.boxes[i];
      if (box[0] === x && box[1] === y && box[2] === z) {
        this.boxes.splice(i, 1);
        break;
      }
    }
  }

  setBoxSize(boxSize) {
    this.size = boxSize;
  }

  setBuildInterval(interval) {
    this.buildInterval = interval;
  }

  clearData() {
    this.translation = [0, 0, 0, 0, 0, 0];
    this.globalAnimation = [0, 0, 0, 0, 0, 0, 1, 0]
    this.animation = [0, 0, 0, 0, 0, 0, 1, 0]
    this.boxes = [];
    this.sentence = []
    this.lights = [];
    this.commands = []
    this.size = 1.0;
    this.shape = 'box'
    this.isMetallic = 0
    this.roughness = 0.5
    this.isAllowedFloat = 0
    this.buildInterval = 0.01;
  }

  writeSentence(sentence, x, y, z, r=1, g=1, b=1, alpha=1) {
    [x, y, z] = this.roundNumbers([x, y, z]);
    [x, y, z] = [x, y, z].map(val => String(val))
    r = String(r);
    g = String(g);
    b = String(b);
    alpha = String(alpha);
    this.sentence = [sentence, x, y, z, r, g, b, alpha];
  }

  setLight(x, y, z, r=1, g=1, b=1, alpha=1, intensity=1000, interval=1, lightType='point') {
    [x, y, z] = this.roundNumbers([x, y, z]);

    if (lightType === 'point') {
      lightType = 1;
    } else if (lightType === 'spot') {
      lightType = 2;
    } else if (lightType === 'directional') {
      lightType = 3;
    } else {
      lightType = 1;
    }
    this.lights.push([x, y, z, r, g, b, alpha, intensity, interval, lightType]);
  }

  setCommand(command) {
    this.commands.push(command);

    if (command === 'float') {
      this.isAllowedFloat = 1;
    }
  }

  drawLine(x1, y1, z1, x2, y2, z2, r = 1, g = 1, b = 1, alpha = 1) {
    [x1, y1, z1, x2, y2, z2] = this.roundNumbers([x1, y1, z1, x2, y2, z2])
    const diff_x = x2 - x1;
    const diff_y = y2 - y1;
    const diff_z = z2 - z1;
    const maxLength = Math.max(Math.abs(diff_x), Math.abs(diff_y), Math.abs(diff_z));

    if (diff_x === 0 && diff_y === 0 && diff_z === 0) {
      return false;
    }

    if (Math.abs(diff_x) === maxLength) {
      if (x2 > x1) {
        for (let x = x1; x <= x2; x++) {
          const y = y1 + (x - x1) * diff_y / diff_x;
          const z = z1 + (x - x1) * diff_z / diff_x;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      } else{
        for (let x = x1; x >= x2; x--) {
          const y = y1 + (x - x1) * diff_y / diff_x;
          const z = z1 + (x - x1) * diff_z / diff_x;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      }
    } else if (Math.abs(diff_y) === maxLength) {
      if (y2 > y1) {
        for (let y = y1; y <= y2; y++) {
          const x = x1 + (y - y1) * diff_x / diff_y;
          const z = z1 + (y - y1) * diff_z / diff_y;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      } else {
        for (let y = y1; y >= y2; y--) {
          const x = x1 + (y - y1) * diff_x / diff_y;
          const z = z1 + (y - y1) * diff_z / diff_y;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      }
    } else if (Math.abs(diff_z) === maxLength) {
      if (z2 > z1) {
        for (let z = z1; z <= z2; z++) {
          const x = x1 + (z - z1) * diff_x / diff_z;
          const y = y1 + (z - z1) * diff_y / diff_z;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      } else {
        for (let z = z1; z >= z2; z--) {
          const x = x1 + (z - z1) * diff_x / diff_z;
          const y = y1 + (z - z1) * diff_y / diff_z;
          this.createBox(x, y, z, r, g, b, alpha);
        }
      }
    }
  }

  changeShape(shape) {
    this.shape = shape;
  }

  changeMaterial(isMetallic, roughness) {
    this.isMetallic = isMetallic ? 1 : 0;
    this.roughness = roughness;
  }

  async sendData() {
    console.log('Sending data...');
    const ws = new WebSocket('wss://websocket.voxelamming.com');
    const date = new Date();
    const dataToSend = {
      translation: this.translation,
      globalAnimation: this.globalAnimation,
      animation: this.animation,
      boxes: this.boxes,
      sentence: this.sentence,
      lights: this.lights,
      commands: this.commands,
      size: this.size,
      shape: this.shape,
      isMetallic: this.isMetallic,
      roughness: this.roughness,
      interval: this.buildInterval,
      isAllowedFloat: this.isAllowedFloat,
      date: date.toISOString()
    };

    try {
      await new Promise((resolve, reject) => {  ws.onopen = () => {
          ws.send(this.roomName);
          console.log(`Joined room: ${this.roomName}`);
          ws.send(JSON.stringify(dataToSend));
          console.log(dataToSend)
          console.log('Sent data to server');
          setTimeout(() => {
            ws.close();
            resolve();
          }, 1000); // 適切な時間を指定して自動的に接続を閉じる
        };

        ws.onerror = error => {
          console.error(`WebSocket error: ${error}`);
          reject(error);
        };
      });
    } catch (error) {
      console.error(`WebSocket connection failed: ${error}`);
    }
  }

  async sleepSecond(s) {
    await new Promise(resolve => setTimeout(resolve, s * 1000));
  }

  roundNumbers(num_list) {
    if (this.isAllowedFloat) {
      return num_list.map(val => parseFloat(val.toFixed(2)));
    } else {
      return num_list.map(val => Math.floor(parseFloat(val.toFixed(1))));
    }
  }
}

export default BuildBox;
