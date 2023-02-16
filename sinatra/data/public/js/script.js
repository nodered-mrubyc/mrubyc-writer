////////////////////////////
//     web serial api     //
////////////////////////////

const encoder = new TextEncoder();
const sleep = waitTime => new Promise( resolve => setTimeout(resolve, waitTime) );
const disConnect = document.getElementById('disConnectButton');

// onConect-関数化- //
let reader, port, checkStr = "", str = "";
async function onConnectButtonClick() {
    // シリアルポートへ接続
    try {
        port = await navigator.serial.requestPort();
        await port.open({
            baudRate: 19200,        // ボーレートを19200にする（RBoard用）
            dataBits: 8,            // 1文字あたりのデータビット数を8にする
            stopBits: 1,            // ストップビットを1ビットに設定する
            parity: 'none',         // /パリティビットは送信しない設定にする
            flowControl: 'hardware' // ハードウェアフロー制御を行う
        }).catch(err => console.log(err));
        console.log("Connected serial port.");
        while (port.readable) {
            reader = port.readable.getReader();
            await serialPortReceive();    // シリアルポートからの返答を受け取る
        }
    } catch (error) {
        addSerial("Error: Open" + error + "\n");
        console.log("Serial port open error.");
        console.log(error);
    }
}
// シリアルポートからの返答を受け取る
async function serialPortReceive() {
    try {
        let isWHile = true;
        while (isWHile) {
            const { value, done } = await reader.read();    // シリアルポートからデータを受信する
            if (done) {
                addSerial("Canceled\n");
                console.log("Canceled");
                isWHile = !isWHile;
            }
            // strとcheckStrが一致していれば、whileを抜ける
            // if(str != "" && str.includes(checkStr)) {
            //     isWHile = !isWHile;
            // }
            const inputValue = new TextDecoder().decode(value);
            addSerial(inputValue);                  // シリアルポートから受信したデータをテキストエリアに表示する
            console.log("receive:" + inputValue);   // シリアルポートから受信したデータをコンソールに表示する
            // str += inputValue;
            // console.log(checkStr);
            // console.log(str);
        }
    } catch (error) {
        addSerial("Error: Read" + error + "\n");
        console.log("Serial port read error.");
        console.log(error);
    } finally {
        reader.releaseLock();
        await port.close();
        reader = null;
    }
    return {
        str,
    };
}


// disConnectボタン //
async function disConnectButtonClick() {
    try {
        if (port.readable) {
            await reader.cancel();
            reader = null;
            return;
        } else {
            return;
        }
    } catch (error) {
        addSerial("Error: Close" + error + "\n");
        console.log("Error");
        console.log(error);
    }
}

// ファイルを選択ボタン //
// ファイルのアップロード
const fileInput = document.getElementById("file");
let fileReader = new FileReader();   //FileReaderのインスタンスを作成する
let ary, file, file_size = 0;

// ファイルの読み込み
$(function(){
    // 添付ファイルチェンジイベント
    $('.fileinput').on('change', function(){
      let file = $(this).prop('files')[0];
      $('.filelabel').text(file.name);
    });
});
async function file_save() {
    // (1) XMLHttpRequestオブジェクトを作成
    const xhr = new XMLHttpRequest();
    // (2) 取得するファイルの設定
	xhr.open('get', './createdRuby/mrubyc_program.mrb');
    xhr.responseType = "arraybuffer";
    // (3) リクエスト（要求）を送信
	xhr.send();
    // レスポンスデータを受け取っている間は定期的に発生するイベント
    xhr.addEventListener('progress', (e) => {
        // p要素に進捗状況を表示
        if( e.lengthComputable ) {
            // ファイルのアップロード状況を表示
            // text_loading.textContent = Math.floor((e.loaded / e.total) * 100) + "%";
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
            writeButtonClick();
        }
    }
}

// writeボタン //
let writer;
async function writeButtonClick() {
    writer = port.writable.getWriter();
    let ary = new Uint8Array(file);

    // シリアルポートに\r\nを送信する
    await writer.write(encoder.encode("\r\n"));
    await sleep(800);
    // シリアルポートにファイルを書き込む準備
    await writer.write(encoder.encode("write " + file_size + "\r\n"));
    await sleep(800);
    // RBoardに.mrbファイルを転送
    await writer.write(ary);
    await writer.write(encoder.encode("\r\n"));
    await sleep(800);
    // .mrbを実行する
    await writer.write(encoder.encode("execute\r\n"));
    await sleep(500);
    
    writer.releaseLock();
}

// シリアルポートへの書き込みを行う関数
// function serialPortWriter (command, check) {
//     return new Promise (async (resolve, reject) => {
//         await writer.write(encoder.encode(command));
//         checkStr = check;
//         console.log(checkStr);
//         while (!str.includes(checkStr)) {
//             console.log(str);
//         }
//         checkStr = "";
//         resolve();
//     })
// }

// RBoardからのレスポンス
function addSerial(msg) {
    var textarea = document.getElementById('outputArea');
    textarea.value += msg;
    textarea.scrollTop = textarea.scrollHeight;
}

//////////////////////////////
//     ruby code editor     //
//////////////////////////////

function save() {
    // テキストエリア内の文字列を取得する
    const code = document.getElementById("input_code").value 

    // 文字列をblob化
    let blob = new Blob([code], { type: "text/plain" }) 

    // BlobをURLに変換
    let url = URL.createObjectURL(blob) 

    // ダウンロード用のaタグ生成
    const link = document.createElement("a") 
    link.href = url 
    link.download = "main.rb" 
    // 要素の追加
    document.body.appendChild(link) 
    // linkをclickすることでダウンロードが完了
    link.click() 

    // 「link」は不要な要素になるので、link要素を削除
    link.parentNode.removeChild(link)
} 