Nodes_Hash={:N21c71=>{:type=>"inject", :repeat=>"1", :wires=>[[:N2fbbe]], :inputNodeid=>[], :last_time=>0.0, :flow_controll=>1},
 :N2fbbe=>{:type=>"GPIO", :ReadType=>"ADC", :GPIOType=>"read", :targetPort_digital=>"", :targetPort_ADC=>"7", :wires=>[[:N14560]], :inputNodeid=>[:N21c71]},
 :N14560=>{:type=>"function", :wires=>[[]], :inputNodeid=>[:N2fbbe], :flow_endFlg=>0},
 :N03903=>{:type=>"inject", :repeat=>"", :wires=>[[:Nbd3e4]], :inputNodeid=>[], :last_time=>0.0, :flow_controll=>1},
 :Nbd3e4=>{:type=>"I2C", :ad=>98, :rules=>[{:t=>"W", :v=>0, :c=>0, :de=>"0.1"}, {:t=>"W", :v=>8, :c=>255, :de=>"0.1"}, {:t=>"W", :v=>1, :c=>32, :de=>"0.1"}, {:t=>"W", :v=>4, :c=>255, :de=>"0.1"}, {:t=>"W", :v=>3, :c=>255, :de=>"0.1"}, {:t=>"W", :v=>2, :c=>255, :de=>"0.1"}], :wires=>[[:Nf081d]], :inputNodeid=>[:N03903]},
 :Nf081d=>{:type=>"function", :wires=>[[]], :inputNodeid=>[:Nbd3e4], :flow_endFlg=>0},
 :N24807=>{:type=>"inject", :repeat=>"1", :wires=>[[:N21530]], :inputNodeid=>[], :last_time=>0.0, :flow_controll=>1},
 :N64633=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"0", :targetPort_mode=>"1", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N614bf]},
 :N398c2=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"5", :targetPort_mode=>"1", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N614bf]},
 :N614bf=>{:type=>"switch", :rules=>[{:t=>"lt", :v=>"1", :vt=>"str"}, {:t=>"gte", :v=>"1", :vt=>"str"}], :repair=>false, :outputs=>2, :wires=>[[:N64633, :N938d8], [:N398c2, :Nfd244]], :inputNodeid=>[:N21530]},
 :N21530=>{:type=>"function", :wires=>[[:N614bf]], :inputNodeid=>[:N24807]},
 :N938d8=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"5", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N614bf]},
 :Nfd244=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"0", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N614bf]},
 :N6693c=>{:type=>"inject", :repeat=>"", :wires=>[[:Nd2c29, :Nacf3e, :Nc35c0, :N60971]], :inputNodeid=>[], :last_time=>0.0, :flow_controll=>1},
 :Nd2c29=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"0", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N6693c]},
 :Nacf3e=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"1", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N6693c]},
 :Nc35c0=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"5", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N6693c]},
 :N60971=>{:type=>"LED", :LEDtype=>"GPIO", :targetPort=>"6", :targetPort_mode=>"0", :onBoardLED=>"", :wires=>[], :inputNodeid=>[:N6693c]}}
DatasBuffer = []

def Dataprocessing(node_id, mode, output = "")
    /get:データの取り出し deleet:自分宛のデータの削除 create:次ノード宛のデータの作成/
    get_datas = []
    if mode == :get
        DatasBuffer.each do |data|
            if node_id == data[1]
                get_datas << data[2]
            end
        end
        if Nodes_Hash[node_id][:inputNodeid].length > get_datas.length
            get_datas = []
        end
    end
    index = 0
    if mode == :delete
        DatasBuffer.each do |data|
            if node_id == data[1]
                DatasBuffer.delete_at(index)
            end
            index += 1
        end
    end
    if mode == :create
        if Nodes_Hash[node_id].has_key?(:flow_endFlg)
            return 0
        end
        output_index = 0
        Nodes_Hash[node_id][:wires].each do |wires|
            wires.each do |wire|
                index = 0
                DatasBuffer.each do |data|
                    if [node_id ,wire] == [data[0], data[1]] 
                        DatasBuffer.delete_at(index)
                        break
                    end
                    index += 1
                end
                DatasBuffer << [node_id ,wire, output[output_index]]
            end
            output_index += 1
        end
    end
    return get_datas
end
def Node_inject(node_id)
    if Nodes_Hash[node_id][:repeat] != ""
        if GetTime(node_id) == 1
            if Nodes_Hash[node_id][:flow_controll] == 1
                Nodes_Hash[node_id][:flow_controll] = 0
            elsif Nodes_Hash[node_id][:flow_controll] == 0
                Nodes_Hash[node_id][:flow_controll] = 1
            end
            Dataprocessing(node_id,:create,[Nodes_Hash[node_id][:flow_controll]])
        end
        return 0
    else
        Dataprocessing(node_id,:create,[1])
        return 0
    end
end

def GetTime(node_id)

    if Nodes_Hash[node_id][:type] == "inject"
        repeat_time = Nodes_Hash[node_id][:repeat].to_f
    end

    if Nodes_Hash[node_id][:type] == "delay"
        repeat_time = Nodes_Hash[node_id][:timeout].to_f
    end

    run_time = VM.tick()/1000.0
    last_time = Nodes_Hash[node_id][:last_time]
    last_time = run_time - last_time

    if last_time >= repeat_time
        Nodes_Hash[node_id][:last_time] = run_time
        return 1
    else
        return 0
    end
end

def Node_GPIO(node_id)

    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)  
    if input_array == []
      return 0
    end

    input = 0

    input_array.each do |input_data|
        if input_data == 0
            return 0
        end
        
    end
    
    if "read" == Nodes_Hash[node_id][:GPIOType]
        if "digital_read" == Nodes_Hash[node_id][:ReadType]
            input = digitalRead(Nodes_Hash[node_id][:targetPort_digital].to_i)
        end

        if "ADC" == Nodes_Hash[node_id][:ReadType]
            adc = ADC.new()
            adc.ch(Nodes_Hash[node_id][:targetPort_ADC].to_i)
            adc.start
            sleep(0.001)
            input = adc.read_v
            adc.stop
        end
        Dataprocessing(node_id,:create,[input])
        return 0
    end

    #後日実装!!
    if "write" == Nodes_Hash[node_id][:GPIOType]

        input_array.each do |input_data|
            if "digital_write" == Nodes_Hash[node_id][:WriteType]
                targetPort = Nodes_Hash[node_id][:targetPort_digital].to_i
                targetPort_mode = Nodes_Hash[node_id][:targetPort_mode].to_i

                if targetPort_mode == 2
                    if input_data != 1
                        digitalWrite(targetPort,0)
                        output = 0
                    else
                        digitalWrite(targetPort,1)
                        output = 1
                    end
                else
                    if input_data != 1
                        next
                    else
                        digitalWrite(targetPort,targetPort_mode)
                        output = 1
                    end
                end
            end

            if "PWM" == Nodes_Hash[node_id][:WriteType]
                PWM.new()
                PWM.pin(Nodes_Hash[node_id][:targetPort_PWM].to_i)
                PWM.start(Nodes_Hash[node_id][:PWM_num].to_i)
                PWM.cycle(Nodes_Hash[node_id][:time].to_i,Nodes_Hash[node_id][:double].to_i)
                PWM.rate(Nodes_Hash[node_id][:rate].to_i,Nodes_Hash[node_id][:PWM_num].to_i)
            end

        end
        return 0
    end
end

#this is function Node
def FunctionNode_N14560(msg)
data = msg 

    data = (3.3 / data)-1
    temp = 1.0/(Math.log(data)/4275+1/298.15)-273.15
    sleep(1)
    $ondo = temp.to_s
    
return $ondo
end
def FunctionNode_Nf081d(msg)
data = $ondo 
    
    puts("temp : " + $ondo)

return msg
end
def FunctionNode_N21530(msg)
data = $ondo
    
    if $ondo > 30 then
        puts ("high")
        return msg
    end
    if $ondo <= 30
        puts ("low")
        return 0
    end
end

def Node_function(node_id)
    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)
    if input_array == []
        return 0
    end
    output = 0

    input_array.each do |input_data|
 
    
        if node_id == :N14560
            output = FunctionNode_N14560(input_data)
        end
        
        if node_id == :Nf081d
            output = FunctionNode_Nf081d(input_data)
        end
        
        if node_id == :N21530
            output = FunctionNode_N21530(input_data)
        end
        
    end
    Dataprocessing(node_id,:create,[output])
end
    

def Node_I2C(node_id)
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
    Nodes_Hash[node_id][:rules].each do |rule|
        if rule[:t] == "W"
            I2C.write(sraveAd, rule[:v].to_i, rule[:c].to_i)
        else
            output = I2C.read(sraveAd, rule[:v].to_i, rule[:b].to_i)
        end

        if rule[:de] != ""
            sleep_ms(rule[:de].to_i)
        end
    end
    Dataprocessing(node_id,:create,[output])
end

#this is LED Node

def GPIO_digital_mode1(node_id,input)
    if input == 1
        digitalWrite(Nodes_Hash[node_id][:targetPort].to_i,targetPort_mode,Nodes_Hash[node_id][:targetPort_mode].to_i)
    end
end
    
def Node_LED(node_id)
    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)  
    if input_array == []
      return 0
    end
      
    input_array.each do |input|
    
            if (Nodes_Hash)[node_id][:targetPort_mode] == "0" || Nodes_Hash[node_id][:targetPort_mode] == "1" && Nodes_Hash[node_id][:LEDtype] == "GPIO"
                GPIO_digital_mode1(node_id,input)
            end

    end
end


#this is switch Node

def Node_switch(node_id)
    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)
    if input_array == []
      return 0
    end

    input_array.each do |input_data|
        if input_data == "" 
          return 0
        end
    end

    output_flg = []
    #各入力データに対し、各出力点に対する条件と比較を行う。
    input_array.each do |input_data|
        count = 0
        Nodes_Hash[node_id][:rules].each do |rules_element|
    
            if rules_element[:t] == "lt"
                if input_data < rules_element[:v].to_f
                    output_flg << 1
                else
                    output_flg << 0
                end
            end
         
            if rules_element[:t] == "gte"
                if input_data >= rules_element[:v].to_f
                    output_flg << 1
                else
                    output_flg << 0
                end
            end
            
            count += 1
        end
    end
    Dataprocessing(node_id,:create,output_flg)
end

while true
Node_inject(:N21c71)
Node_GPIO(:N2fbbe)
Node_function(:N14560)
Node_inject(:N03903)
Node_I2C(:Nbd3e4)
Node_function(:Nf081d)
Node_inject(:N24807)
Node_LED(:N64633)
Node_LED(:N398c2)
Node_switch(:N614bf)
Node_function(:N21530)
Node_LED(:N938d8)
Node_LED(:Nfd244)
Node_inject(:N6693c)
Node_LED(:Nd2c29)
Node_LED(:Nacf3e)
Node_LED(:Nc35c0)
Node_LED(:N60971)
sleep(0.01)
end