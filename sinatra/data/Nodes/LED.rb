#this is LED Node

def GPIO_digital_mode1(node_id,input)
    if input == 1
        digitalWrite(Nodes_Hash[node_id][:targetPort].to_i,Nodes_Hash[node_id][:targetPort_mode].to_i)
    end
end

def GPIO_digital_mode2(node_id,input)
    if input == 0
        digitalWrite(Nodes_Hash[node_id][:targetPort].to_i,0)
    elsif input == 1
        digitalWrite(Nodes_Hash[node_id][:targetPort].to_i,1)
    end
end
    
def Node_LED(node_id)
    input_array = Dataprocessing(node_id,:get)
    Dataprocessing(node_id,:delete)  
    if input_array == []
      return 0
    end
      
    input_array.each do |input|
    
        if ((Nodes_Hash)[node_id][:targetPort_mode] == "0" || (Nodes_Hash)[node_id][:targetPort_mode] == "1") && Nodes_Hash[node_id][:LEDtype] == "GPIO"
            GPIO_digital_mode1(node_id,input)
        end
        if Nodes_Hash[node_id][:targetPort_mode] == "2" && Nodes_Hash[node_id][:LEDtype] == "GPIO"
            GPIO_digital_mode2(node_id,input)
        end

    end
end
