def Node_tempLCD(node_id)
    /データ有無の確認/
    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)
    if input_array == []
        return 0
    end
    input_array.each do |input_data|
        if input_data == 0
            return 0
        end
    end

    sraveAd = Nodes_Hash[node_id][:ad].to_i
    output = []
    
    # clear LCD
    I2C.write(sraveAd, 0x80.to_s.to_i, 0x01.to_s.to_i)
    sleep_ms("5".to_i)

    # LCDにtempを表示する
    $temp.to_s.each_byte do |data|
        I2C.write(sraveAd, 0x40.to_s.to_i, data.to_s.to_i)
        sleep_ms("1".to_i)
    end
    
    Dataprocessing(node_id,:create,[output])
end