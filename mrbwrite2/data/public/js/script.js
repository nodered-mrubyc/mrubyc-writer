/*
   web serial api for RBoard and ESP32 (with mruby/c)   

   参考：
    https://developer.chrome.com/ja/articles/serial/
    https://lang-ship.com/blog/work/web-serial-api-esp32-01-console/
*/

// 共通変数 初期化 //
const sleep = waitTime => new Promise( resolve => setTimeout(resolve, waitTime) );
let port, reader, keepReading, textarea ;


// 接続ボタン //
async function onConnectButtonClick() {
    // シリアルポートへ接続
    try {
        const baudRate = Number(document.getElementById('baudRate').value);
	
        textarea = document.getElementById('outputArea');
        port = await navigator.serial.requestPort();

        keepReading = true;

        await port.open({
            baudRate: baudRate,     // ボーレートの設定 
            dataBits: 8,            // 1文字あたりのデータビット数を8にする
            stopBits: 1,            // ストップビットを1ビットに設定する
            parity: 'none',         // /パリティビットは送信しない設定にする
            flowControl: 'none'     // ハードウェアフロー制御を行わない
        }).catch(err => console.log(err));

        textarea.value = "Connected serial port. \n" + baudRate + "\n";
        textarea.scrollTop = textarea.scrollHeight;

        console.log("Connected serial port.");
        await readUntilClosed() ;
        
    } catch (error) {
        textarea.value += "Error: Open " + error + "\n";
        textarea.scrollTop = textarea.scrollHeight;

        console.log("Serial port open error.");
        console.log(error);
    }
}

// シリアルポートから読み取り //
async function readUntilClosed() {
    while (port.readable && keepReading) {
        reader = port.readable.getReader();
        try {
            while (true) {
                const { value, done } = await reader.read();    // シリアルポートからデータを受信する
                if (done) {
                    textarea.value += "Canceled\n";
                    textarea.scrollTop = textarea.scrollHeight;
                    console.log("Canceled");
                    break;
                }
                if (value){
                    const inputValue = new TextDecoder().decode(value);
                    textarea.value += inputValue;                  // シリアルポートから受信したデータをテキストエリアに表示する
                    textarea.scrollTop = textarea.scrollHeight;
                    console.log("receive:" + inputValue);   // シリアルポートから受信したデータをコンソールに表示する
                }
            }
        } catch (error) {
            textarea.value += "Error: Read " + error + "\n";
            textarea.scrollTop = textarea.scrollHeight;
            console.log("Serial port read error.");
            console.log(error);
        } finally {
            reader.releaseLock();   
        }
    }
    await port.close()
    textarea.value += "port closed\n";
    textarea.scrollTop = textarea.scrollHeight;
    console.log("port closed");
}

// 切断ボタン //
async function disConnectButtonClick() {
    keepReading = false;
    reader.cancel();
}

// 書き込みボタン //
async function writeButtonClick( filename ) {
    // (1) XMLHttpRequestオブジェクトを作成
    const xhr = new XMLHttpRequest();
    // (2) 取得するファイルの設定
	xhr.open('get', filename);
    xhr.responseType = "arraybuffer";
    // (3) リクエスト（要求）を送信
	xhr.send();
    // レスポンスデータを受け取っている間は定期的に発生するイベント
    xhr.addEventListener('progress', (e) => {
        // p要素に進捗状況を表示
        if( e.lengthComputable ) {
            file_size = e.total;    // 読み込んだファイルのサイズを取得する(.mrb)
        } else {
            text_loading.textContent = "読み込み中";
        }
    });
    xhr.onreadystatechange = function() {
        // (4) 通信が正常に完了したか確認
        if( xhr.readyState === 4 && xhr.status === 200) {
            file = this.response;
            console.log(file);
            writeSendCommand(); //コマンド送信
        }
    }
}

// コマンド送信 //
async function writeSendCommand() {
    const encoder = new TextEncoder();
    const writer = port.writable.getWriter();
    let ary = new Uint8Array(file);

    const waitTime = Number(document.getElementById('waitTime').value);
 
    // シリアルポートに\r\nを送信する
    console.log("send \r\n");
    await writer.write(encoder.encode('\r\n'));
    await writer.write(encoder.encode('\r\n'));
    await sleep(waitTime);

    // ファイルのクリア
    console.log("send clear");
    await writer.write(encoder.encode("clear \r\n"));
    await sleep(waitTime);

    // シリアルポートにファイルを書き込む準備
    console.log("send write");
    await writer.write(encoder.encode("write " + file_size + "\r\n"));
    await sleep(waitTime);

    // RBoardに.mrbファイルを転送
    console.log("send binary file \r\n");
    await writer.write(ary);
    await writer.write(encoder.encode("\r\n"));
    await sleep(waitTime);

    // .mrbを実行する
    console.log("execute \r\n");
    await writer.write(encoder.encode("execute\r\n"));
    await sleep(waitTime);
    
    writer.releaseLock();
}
