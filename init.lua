wifi.setmode(wifi.STATION)
wifi.sta.config("Istana_Bahru","DaveAndSalamiah")
print(wifi.sta.getip())
gpio2 = 4
gpio.mode(gpio2, gpio.OUTPUT)
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        if (string.find(request,"favicon") ~= nil) then
            return
        end
        print("request received")
        print(request)
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%w+)&*") do
                _GET[k] = v
            end
        end
        local redchecked,greenchecked,bluechecked = "","",""
        red,green,blue = 0,0,0
        if(_GET.red == "red")then
              --gpio.write(led1, gpio.HIGH);
              red = 255
              redchecked = " checked "
        end
        if(_GET.green == "green")then
              green = 255
              greenchecked = " checked "
        end
        if(_GET.blue == "blue")then
              -- gpio.write(led2, gpio.LOW);
              blue = 255
              bluechecked = " checked "
        end
        buf = buf.."<h1> ESP8266 Web Server</h1><form>";
        buf = buf.."<p>RED <input type=checkbox name=red value=red "
        buf = buf..redchecked
        buf = buf.."></p>";
        buf = buf.."<p>GREEN <input type=checkbox name=green value=green "
        buf = buf..greenchecked
        buf = buf.."></p>";
        buf = buf.."<p>BLUE <input type=checkbox name=blue value=blue "
        buf = buf..bluechecked
        buf = buf.."></p>"
        buf = buf.."<p><input type=submit></p></form>"
        --red = 255
        --green = 0
        --blue = 0
        ws2812.writergb(gpio2,string.char(red,green, blue))
        tmr.delay(1000000)
        client:send(buf);
        client:close();
        collectgarbage();
    end)
end)